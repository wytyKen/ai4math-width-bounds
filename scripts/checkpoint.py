"""Immutable source checkpoints; this tool does not compile or prove anything.

Run with the repository's .venv interpreter. All dependencies are in the standard
library. A changed workspace is reported separately from a corrupt checkpoint.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath, PureWindowsPath
import re
import sys
import uuid
import zipfile
import zlib


SCHEMA_VERSION = 1
STATUSES = {"ready", "running", "review", "done", "parked", "rejected"}
OWNING_STATUSES = {"ready", "running", "review"}
ACCEPTED_STATUSES = {"formal_verified", "traditional_reviewed", "artifact_checked"}
EXCLUDED_DIRS = {
    ".venv", ".uv-cache", ".mathlib-cache", ".git", ".lake", "tmp", "output",
    "__pycache__", ".pytest_cache", ".mypy_cache", ".ruff_cache", "node_modules",
}
SOURCE_SUFFIXES = {
    ".py", ".ps1", ".sh", ".bash", ".bat", ".cmd", ".lean", ".toml",
    ".lock", ".yaml", ".yml", ".json", ".md", ".txt", ".tex", ".bib",
    ".sty", ".cls", ".c", ".h", ".cpp", ".hpp", ".cc", ".js", ".mjs",
    ".cjs", ".ts", ".tsx", ".jsx", ".css", ".html", ".svg", ".ipynb",
    ".csv", ".tsv", ".rs", ".go", ".r", ".jl", ".ini", ".cfg", ".conf",
    ".sql", ".sln", ".csproj",
}
SOURCE_NAMES = {
    ".gitignore", ".gitattributes", ".gitmodules", "lean-toolchain", "Makefile",
    "Dockerfile", "CMakeLists.txt",
}
CHECKPOINT_ID = re.compile(r"\d{8}T\d{12}Z-[0-9a-f]{8}\Z")
HASH = re.compile(r"[0-9a-f]{64}\Z")
VALIDATION_SCOPE = (
    "Byte integrity and recorded evidence hashes only. This tool does not run "
    "Lean, compile source, reproduce verification commands, or certify proofs. "
    "A snapshot is captured file by file, not as a transactional workspace freeze."
)


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_digest(path: Path) -> str:
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def json_bytes(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


def safe_path(value: object) -> str:
    """Return a normalized relative path, rejecting Windows and POSIX escapes."""
    if not isinstance(value, str) or not value or "\x00" in value:
        raise ValueError("path must be a nonempty string")
    normalized = value.replace("\\", "/")
    parts = normalized.split("/")
    if (PurePosixPath(normalized).is_absolute() or PureWindowsPath(value).drive
            or any(part in {"", ".", ".."} or ":" in part for part in parts)):
        raise ValueError(f"unsafe relative path: {value!r}")
    return normalized


def contained_file(root: Path, name: str) -> Path:
    path = root / safe_path(name)
    # Do not follow file or directory symlinks into another tree.
    relative = path.relative_to(root)
    cursor = root
    for part in relative.parts:
        cursor = cursor / part
        if cursor.is_symlink():
            raise ValueError(f"symlink is not a checkpoint file: {name}")
    path.resolve().relative_to(root.resolve())
    return path


def source_paths(root: Path) -> list[str]:
    paths = []
    for directory, dirs, files in os.walk(root, followlinks=False):
        current = Path(directory)
        dirs[:] = sorted(
            name for name in dirs
            if name not in EXCLUDED_DIRS
            and not (current / name).is_symlink()
            and (current / name).relative_to(root).as_posix() != "research/checkpoints"
        )
        for name in sorted(files):
            path = current / name
            if (not path.is_symlink()
                    and (path.suffix.lower() in SOURCE_SUFFIXES or name in SOURCE_NAMES)):
                paths.append(path.relative_to(root).as_posix())
    return sorted(paths)


def parse_json(data: bytes | None, label: str) -> tuple[object | None, str | None]:
    if data is None:
        return None, f"{label} is missing"
    try:
        return json.loads(data.decode("utf-8-sig")), None
    except (ValueError, UnicodeError) as exc:
        return None, f"{label}: {exc}"


def check_queue(queue: object) -> list[str]:
    errors: list[str] = []
    if not isinstance(queue, dict) or not isinstance(queue.get("tasks"), list):
        return ["queue must be an object with a tasks list"]
    seen: set[str] = set()
    dependencies: dict[str, list[str]] = {}
    occupied: list[tuple[str, str]] = []

    def check_paths(values: object, owner: str, occupies: bool) -> None:
        if not isinstance(values, list):
            errors.append(f"{owner}: owned paths must be a list")
            return
        for value in values:
            try:
                name = safe_path(value)
            except ValueError as exc:
                errors.append(f"{owner}: {exc}")
                continue
            if occupies:
                key = name.casefold()  # This project runs on Windows.
                for prior, prior_owner in occupied:
                    if key == prior or key.startswith(prior + "/") or prior.startswith(key + "/"):
                        errors.append(f"path conflict: {owner} {name!r} overlaps {prior_owner} {prior!r}")
                occupied.append((key, owner))

    check_paths(queue.get("root_owned_paths", []), "root", True)
    for index, task in enumerate(queue["tasks"]):
        if not isinstance(task, dict):
            errors.append(f"task[{index}] must be an object")
            continue
        task_id = task.get("id")
        if not isinstance(task_id, str) or not task_id.strip():
            errors.append(f"task[{index}] has an invalid ID")
        elif task_id in seen:
            errors.append(f"duplicate task ID: {task_id}")
        else:
            seen.add(task_id)
        status = task.get("status")
        if not isinstance(status, str) or status not in STATUSES:
            errors.append(f"{task_id}: invalid status {status!r}")
        check_paths(task.get("owned_paths", []), str(task_id),
                    isinstance(status, str) and status in OWNING_STATUSES)
        depends_on = task.get("depends_on", [])
        if not isinstance(depends_on, list) or any(not isinstance(dep, str) or not dep for dep in depends_on):
            errors.append(f"{task_id}: depends_on must be a list of nonempty task IDs")
        elif isinstance(task_id, str):
            dependencies[task_id] = depends_on
    for task_id, deps in dependencies.items():
        for dependency in deps:
            if dependency == task_id:
                errors.append(f"{task_id}: task depends on itself")
            elif dependency not in seen:
                errors.append(f"{task_id}: unknown dependency {dependency}")
    visited: set[str] = set()
    visiting: set[str] = set()

    def visit(task_id: str) -> None:
        if task_id in visiting:
            errors.append(f"dependency cycle includes {task_id}")
            return
        if task_id in visited:
            return
        visiting.add(task_id)
        for dependency in dependencies.get(task_id, []):
            if dependency in dependencies and dependency != task_id:
                visit(dependency)
        visiting.remove(task_id)
        visited.add(task_id)

    for task_id in dependencies:
        visit(task_id)
    return errors


def assess_claims(root: Path, claims: object, files: dict[str, dict], parse_error: str | None) -> dict:
    assessment: dict = {
        "accepted_statuses": sorted(ACCEPTED_STATUSES),
        "scope": "Recorded evidence hash comparison; no verification commands executed.",
        "accepted": [], "ignored_claim_count": 0, "issues": [],
        "unarchived_references": [],
    }
    if parse_error:
        assessment["issues"].append(parse_error)
    if not isinstance(claims, dict) or not isinstance(claims.get("claims"), list):
        assessment["issues"].append("claims schema is unavailable or unrecognized")
        assessment["all_accepted_evidence_matches"] = False
        return assessment
    for claim in claims["claims"]:
        if not isinstance(claim, dict):
            assessment["issues"].append("non-object claim cannot be assessed")
            continue
        if not isinstance(claim.get("status"), str):
            assessment["issues"].append(f"claim {claim.get('id')!r} has no recognizable status")
            continue
        if claim["status"] not in ACCEPTED_STATUSES:
            assessment["ignored_claim_count"] += 1
            continue
        result: dict = {"id": claim.get("id"), "status": claim["status"], "evidence": []}
        evidence = claim.get("evidence")
        if not isinstance(evidence, list) or not evidence:
            result["issue"] = "accepted claim has no usable evidence list"
            result["matches"] = False
        else:
            for item in evidence:
                entry: dict = {"path": item.get("path") if isinstance(item, dict) else None}
                expected = item.get("sha256") if isinstance(item, dict) else None
                entry["expected_sha256"] = expected
                required = item.get("archive_required", True) if isinstance(item, dict) else True
                # Only the explicit boolean false makes archiving optional.
                entry["archive_required"] = required is not False
                try:
                    name = safe_path(entry["path"])
                    entry["path"] = name
                    entry["included_in_snapshot"] = name in files
                    # For included evidence compare the actual bytes captured in the ZIP.
                    actual = files[name]["sha256"] if name in files else file_digest(contained_file(root, name))
                    entry["actual_sha256"] = actual
                    entry["hash_source"] = "archived_bytes" if name in files else "workspace_at_assessment"
                    entry["status"] = (
                        "invalid_archive_required" if not isinstance(required, bool)
                        else "invalid_expected_hash" if not isinstance(expected, str) or not HASH.fullmatch(expected)
                        else "match" if expected == actual else "mismatch"
                    )
                except (OSError, ValueError) as exc:
                    entry["status"] = "unavailable"
                    entry["error"] = str(exc)
                result["evidence"].append(entry)
                if not entry.get("included_in_snapshot", False):
                    assessment["unarchived_references"].append({
                        "claim_id": result["id"], "path": entry["path"],
                        "archive_required": entry["archive_required"], "status": entry["status"],
                    })
            result["matches"] = all(entry["status"] == "match" for entry in result["evidence"])
        result["all_evidence_archived"] = bool(result["evidence"]) and all(
            entry.get("included_in_snapshot", False) for entry in result["evidence"]
        )
        result["all_required_evidence_archived"] = bool(result["evidence"]) and all(
            not entry["archive_required"] or entry.get("included_in_snapshot", False)
            for entry in result["evidence"]
        )
        verification = claim.get("verification")
        result["recorded_verification"] = verification if isinstance(verification, dict) else None
        result["verification_executed_by_checkpoint"] = False
        assessment["accepted"].append(result)
    assessment["all_accepted_evidence_matches"] = not assessment["issues"] and all(
        claim["matches"] for claim in assessment["accepted"]
    )
    return assessment


def create_checkpoint(root: Path, reason: str) -> dict:
    root = root.resolve(strict=True)
    if not reason.strip():
        raise ValueError("reason must not be blank")
    created = datetime.now(timezone.utc)
    checkpoint_id = created.strftime("%Y%m%dT%H%M%S%fZ") + "-" + uuid.uuid4().hex[:8]
    base = root / "research" / "checkpoints"
    # Also reject a symlinked checkpoint parent before writing outside the project.
    contained_file(root, "research/checkpoints/LATEST.json")
    base.mkdir(parents=True, exist_ok=True)
    checkpoint = base / checkpoint_id
    checkpoint.mkdir(exist_ok=False)
    captured: dict[str, bytes] = {}
    entries: dict[str, dict] = {}
    archive_path = checkpoint / "source.zip"
    with archive_path.open("xb") as stream:
        with zipfile.ZipFile(stream, mode="w", compression=zipfile.ZIP_DEFLATED) as archive:
            for name in source_paths(root):
                data = contained_file(root, name).read_bytes()
                entries[name] = {"path": name, "size": len(data), "sha256": digest(data)}
                archive.writestr(name, data)
                if name in {"research/queue.json", "research/claims.json"}:
                    captured[name] = data
        stream.flush()
        os.fsync(stream.fileno())
    queue, queue_error = parse_json(captured.get("research/queue.json"), "research/queue.json")
    queue_errors = [queue_error] if queue_error else check_queue(queue)
    tasks = queue.get("tasks", []) if isinstance(queue, dict) else []
    if not isinstance(tasks, list):
        tasks = []
    active = [task.get("id") for task in tasks if isinstance(task, dict)
              and isinstance(task.get("status"), str) and task["status"] in {"running", "review"}]
    claims, claims_error = parse_json(captured.get("research/claims.json"), "research/claims.json")
    evidence = assess_claims(root, claims, entries, claims_error)
    wip_reasons = []
    if active:
        wip_reasons.append("running or review tasks remain")
    if queue_errors:
        wip_reasons.append("queue validation failed or queue unavailable")
    if not evidence["all_accepted_evidence_matches"]:
        wip_reasons.append("accepted-claim evidence could not be fully matched")
    if any(not claim["all_required_evidence_archived"] for claim in evidence["accepted"]):
        wip_reasons.append("some required accepted-claim evidence is absent from the archive")
    archive_hash = file_digest(archive_path)
    manifest = {
        "schema_version": SCHEMA_VERSION, "checkpoint_id": checkpoint_id,
        "created_utc": created.isoformat().replace("+00:00", "Z"), "reason": reason,
        "archive": {"file": "source.zip", "sha256": archive_hash, "size": archive_path.stat().st_size},
        "files": list(entries.values()),
        "selection": {"excluded_directory_names": sorted(EXCLUDED_DIRS),
                      "scope": "source-only; optional external artifact references are not backups",
                      "excluded_paths": ["research/checkpoints"],
                      "included_suffixes": sorted(SOURCE_SUFFIXES),
                      "included_names": sorted(SOURCE_NAMES), "symlinks": "excluded"},
        "queue": {"snapshot": queue, "validation_errors": queue_errors,
                  "has_running_or_review_tasks": bool(active), "running_or_review_task_ids": active},
        "claims_assessment": evidence,
        "state": {"label": "WIP" if wip_reasons else "SNAPSHOT",
                  "is_wip": bool(wip_reasons), "wip_reasons": wip_reasons,
                  "source_compilation_checked": False, "validation_scope": VALIDATION_SCOPE},
    }
    manifest_data = json_bytes(manifest)
    with (checkpoint / "manifest.json").open("xb") as stream:
        stream.write(manifest_data)
        stream.flush()
        os.fsync(stream.fileno())
    pointer = {
        "schema_version": SCHEMA_VERSION, "checkpoint_id": checkpoint_id,
        "path": f"research/checkpoints/{checkpoint_id}",
        "created_utc": manifest["created_utc"], "manifest_sha256": digest(manifest_data),
        "archive_sha256": archive_hash,
    }
    temporary = base / (".LATEST-" + uuid.uuid4().hex + ".tmp")
    try:
        with temporary.open("xb") as stream:
            stream.write(json_bytes(pointer))
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, base / "LATEST.json")
    finally:
        if temporary.exists():
            temporary.unlink()
    return {"created": True, "checkpoint": pointer["path"], "file_count": len(entries),
            "state": manifest["state"], "queue_errors": queue_errors,
            "claims_assessment": evidence}


def compare_workspace(root: Path, files: list[dict]) -> dict:
    expected = {entry["path"]: entry for entry in files}
    current = set(source_paths(root))
    changed, missing, unavailable = [], [], []
    for name, entry in expected.items():
        if name not in current:
            missing.append(name)
            continue
        try:
            if file_digest(contained_file(root, name)) != entry["sha256"]:
                changed.append(name)
        except (OSError, ValueError) as exc:
            unavailable.append({"path": name, "error": str(exc)})
    added = sorted(current - set(expected))
    return {"changed": bool(changed or missing or added or unavailable),
            "modified": changed, "missing": missing, "added": added, "unavailable": unavailable}


def verify_latest(root: Path) -> dict:
    root = root.resolve(strict=True)
    result: dict = {"archive_valid": False, "errors": [], "workspace": None,
                    "validation_scope": VALIDATION_SCOPE}
    errors = result["errors"]
    try:
        pointer = json.loads(contained_file(root, "research/checkpoints/LATEST.json").read_bytes())
        checkpoint_id = pointer.get("checkpoint_id")
        if (pointer.get("schema_version") != SCHEMA_VERSION or not isinstance(checkpoint_id, str)
                or not CHECKPOINT_ID.fullmatch(checkpoint_id)
                or pointer.get("path") != f"research/checkpoints/{checkpoint_id}"):
            raise ValueError("invalid LATEST pointer schema or checkpoint path")
        result["checkpoint"] = pointer["path"]
        manifest_data = contained_file(root, pointer["path"] + "/manifest.json").read_bytes()
        if digest(manifest_data) != pointer.get("manifest_sha256"):
            raise ValueError("manifest SHA-256 differs from LATEST pointer")
        manifest = json.loads(manifest_data)
        if manifest.get("schema_version") != SCHEMA_VERSION or manifest.get("checkpoint_id") != checkpoint_id:
            raise ValueError("manifest schema or checkpoint ID mismatch")
        if manifest.get("archive", {}).get("file") != "source.zip":
            raise ValueError("invalid archive filename")
        archive_path = contained_file(root, pointer["path"] + "/source.zip")
        actual = file_digest(archive_path)
        if actual != manifest["archive"].get("sha256") or actual != pointer.get("archive_sha256"):
            errors.append("archive SHA-256 mismatch")
        if archive_path.stat().st_size != manifest["archive"].get("size"):
            errors.append("archive size mismatch")
        files = manifest.get("files")
        if not isinstance(files, list):
            raise ValueError("manifest files must be a list")
        names = []
        for entry in files:
            if not isinstance(entry, dict):
                raise ValueError("invalid manifest file entry")
            name = safe_path(entry.get("path"))
            if name != entry["path"] or name in names:
                raise ValueError("duplicate or noncanonical manifest path")
            if not isinstance(entry.get("sha256"), str) or not HASH.fullmatch(entry["sha256"]):
                raise ValueError(f"invalid manifest hash for {name}")
            if type(entry.get("size")) is not int or entry["size"] < 0:
                raise ValueError(f"invalid manifest size for {name}")
            names.append(name)
        with zipfile.ZipFile(archive_path) as archive:
            actual_names = archive.namelist()
            if len(actual_names) != len(set(actual_names)) or set(actual_names) != set(names):
                errors.append("archive entries differ from manifest, or contain duplicates")
            bad = archive.testzip()
            if bad is not None:
                errors.append(f"archive CRC failed: {bad}")
            for entry in files:
                if entry["path"] in actual_names:
                    data = archive.read(entry["path"])
                    if len(data) != entry["size"] or digest(data) != entry["sha256"]:
                        errors.append(f"archived file hash or size mismatch: {entry['path']}")
        result["archive_valid"] = not errors
        result["state"] = manifest.get("state")
        # Only compare against a manifest whose pointer and archive both validated.
        if result["archive_valid"]:
            result["workspace"] = compare_workspace(root, files)
    except (OSError, ValueError, KeyError, TypeError, AttributeError, RuntimeError,
            EOFError, zipfile.BadZipFile, zlib.error) as exc:
        errors.append(str(exc))
    return result


def require_project_venv() -> None:
    expected = Path(__file__).resolve().parents[1] / ".venv"
    if Path(sys.prefix).resolve() != expected.resolve():
        raise ValueError(f"use this project's .venv Python interpreter: {expected}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    operation = parser.add_mutually_exclusive_group(required=True)
    operation.add_argument("--reason", help="create a checkpoint, recording this reason")
    operation.add_argument("--verify-latest", action="store_true", help="verify archive; separately report workspace changes")
    operation.add_argument("--check", action="store_true", help="only validate queue IDs, statuses, ownership, and dependencies")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args(argv)
    try:
        require_project_venv()
        root = args.root.resolve(strict=True)
        if args.check:
            queue, error = parse_json(contained_file(root, "research/queue.json").read_bytes(), "research/queue.json")
            errors = [error] if error else check_queue(queue)
            result = {"queue_valid": not errors, "errors": errors}
            code = 0 if not errors else 1
        elif args.verify_latest:
            result = verify_latest(root)
            code = 0 if result["archive_valid"] else 1
        else:
            result = create_checkpoint(root, args.reason)
            code = 0
    except (OSError, ValueError) as exc:
        result = {"error": str(exc)}
        code = 2
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return code


if __name__ == "__main__":
    raise SystemExit(main())
