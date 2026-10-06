"""Create or verify the immutable v0.4 delivery using only the standard library.

Create only after all reports and claims are final and LATEST is stable/unchanged.
--verify reads the ZIP alone, including its nested checkpoint, without extraction.
Hashes validate recorded bytes; they do not rerun Lean or authenticate a signer.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import io
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import sys
import uuid
import zipfile
import zlib

import checkpoint

ROOT = Path(__file__).resolve().parents[1]
VERSION = "0.4"
MANIFEST = "output/DELIVERY_MANIFEST_v0_4.json"
TARGET = "output/ai4math_research_delivery_v0_4.zip"
RECEIPT = "output/ai4math_research_delivery_v0_4.receipt.json"
LATEST = "research/checkpoints/LATEST.json"
REQUIRED_ARTIFACTS = (
    "output/pdf/width_bounds.pdf", "output/pdf/width_bounds_v0_2.pdf",
    "output/pdf/width_bounds_v0_3.pdf", "output/pdf/width_bounds_v0_4.pdf",
    "output/width_bounds_review_v0_1.zip", "output/width_bounds_review_v0_2.zip",
)
SCOPE = ("Byte integrity and recorded evidence only; does not run Lean, certify "
         "proofs, establish novelty, or authenticate an author.")
HASH = re.compile(r"[0-9a-f]{64}\Z")
DEVICE = re.compile(r"(?:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\..*)?\Z", re.I)
ACTIVE = {"ready", "running", "review"}


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def encoded(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


def canonical_path(value: object) -> str:
    name = checkpoint.safe_path(value)
    if name != value:
        raise ValueError(f"noncanonical archive path: {value!r}")
    for part in name.split("/"):
        if (part.endswith((".", " ")) or DEVICE.fullmatch(part)
                or any(ord(c) < 32 or c in '<>"|?*' for c in part)):
            raise ValueError(f"unsafe Windows archive path: {value!r}")
    return name


def check_names(names: list[str]) -> None:
    folded: set[str] = set()
    for name in names:
        canonical_path(name)
        key = name.casefold()
        if key in folded:
            raise ValueError(f"duplicate archive/manifest path: {name}")
        folded.add(key)
    for name in folded:
        if any(str(parent) in folded for parent in PurePosixPath(name).parents
               if str(parent) != "."):
            raise ValueError(f"file/directory path collision: {name}")


def manifest_entries(value: object) -> dict[str, dict]:
    if not isinstance(value, list):
        raise ValueError("manifest files must be a list")
    names = []
    for item in value:
        if not isinstance(item, dict):
            raise ValueError("invalid manifest entry")
        name = canonical_path(item.get("path"))
        if type(item.get("size")) is not int or item["size"] < 0:
            raise ValueError(f"invalid manifest size: {name}")
        if not isinstance(item.get("sha256"), str) or not HASH.fullmatch(item["sha256"]):
            raise ValueError(f"invalid manifest hash: {name}")
        names.append(name)
    check_names(names)
    return {item["path"]: item for item in value}


def check_zip(packet: zipfile.ZipFile, entries: dict[str, dict], extra: set[str]) -> None:
    # On Windows ZipInfo normalizes backslashes; orig_filename retains the raw
    # archive spelling (also before NUL truncation), so check both representations.
    check_names([info.orig_filename for info in packet.infolist()])
    names = packet.namelist()
    check_names(names)
    if set(names) != set(entries) | extra or set(entries) & extra:
        raise ValueError("archive members differ from manifest")
    for info in packet.infolist():
        mode = stat.S_IFMT(info.external_attr >> 16)
        if info.is_dir() or mode not in {0, stat.S_IFREG} or info.flag_bits & 1:
            raise ValueError(f"nonregular/encrypted archive member: {info.filename}")
    for name, item in entries.items():
        data = packet.read(name)
        if len(data) != item["size"] or sha(data) != item["sha256"]:
            raise ValueError(f"archive hash/size mismatch: {name}")


def read_json(read, name: str) -> dict:
    def unique(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError(f"duplicate JSON key in {name}: {key}")
            result[key] = value
        return result
    value = json.loads(read(name), object_pairs_hook=unique)
    if not isinstance(value, dict):
        raise ValueError(f"JSON object required: {name}")
    return value


def closed_queue(queue: dict) -> None:
    errors = checkpoint.check_queue(queue)
    if errors or any(task["status"] in ACTIVE for task in queue["tasks"]):
        raise ValueError(f"delivery queue is invalid or active: {errors}")


def evidence_items(claims: dict):
    if not isinstance(claims.get("claims"), list):
        raise ValueError("claims must contain a claims list")
    ids = set()
    for claim in claims["claims"]:
        if (not isinstance(claim, dict) or not isinstance(claim.get("id"), str)
                or not claim["id"] or claim["id"] in ids):
            raise ValueError("invalid or duplicate claim ID")
        ids.add(claim["id"])
        evidence = claim.get("evidence", [])
        if not isinstance(evidence, list):
            raise ValueError(f"invalid evidence list: {claim['id']}")
        if claim.get("status") in checkpoint.ACCEPTED_STATUSES and not evidence:
            raise ValueError(f"accepted claim has no evidence: {claim['id']}")
        for item in evidence:
            if not isinstance(item, dict):
                raise ValueError(f"invalid evidence: {claim['id']}")
            name = canonical_path(item.get("path"))
            if name.casefold() in {TARGET.casefold(), RECEIPT.casefold(), MANIFEST.casefold()}:
                raise ValueError(f"circular current-delivery evidence reference: {name}")
            if (not isinstance(item.get("sha256"), str) or not HASH.fullmatch(item["sha256"])
                    or type(item.get("archive_required", True)) is not bool):
                raise ValueError(f"invalid evidence hash/required flag: {name}")
            yield claim, item


def check_claims(read) -> tuple[dict, list]:
    claims = read_json(read, "research/claims.json")
    references = list(evidence_items(claims))
    for claim, item in references:
        if sha(read(item["path"])) != item["sha256"]:
            raise ValueError(f"claim {claim['id']} evidence mismatch: {item['path']}")
    return claims, references


def source_name(name: str) -> bool:
    """The path selection policy of checkpoint.source_paths, applied to ZIP names."""
    path = PurePosixPath(name)
    return (not set(path.parts[:-1]) & checkpoint.EXCLUDED_DIRS
            and not name.startswith("research/checkpoints/")
            and (path.suffix.lower() in checkpoint.SOURCE_SUFFIXES
                 or path.name in checkpoint.SOURCE_NAMES))


def check_checkpoint(read, outer_entries: dict, delivery_manifest: dict,
                     queue: dict, references: list) -> int:
    pointer = read_json(read, LATEST)
    ident = pointer.get("checkpoint_id")
    if (pointer.get("schema_version") != checkpoint.SCHEMA_VERSION
            or not isinstance(ident, str) or not checkpoint.CHECKPOINT_ID.fullmatch(ident)
            or pointer.get("path") != f"research/checkpoints/{ident}"
            or ident != delivery_manifest.get("checkpoint_id")):
        raise ValueError("invalid checkpoint pointer or checkpoint ID mismatch")
    base = pointer["path"]
    manifest_data = read(f"{base}/manifest.json")
    source_data = read(f"{base}/source.zip")
    if sha(manifest_data) != pointer.get("manifest_sha256"):
        raise ValueError("checkpoint manifest digest mismatch")
    cp = read_json(read, f"{base}/manifest.json")
    if cp.get("schema_version") != checkpoint.SCHEMA_VERSION or cp.get("checkpoint_id") != ident:
        raise ValueError("checkpoint manifest schema/ID mismatch")
    archive = cp.get("archive", {})
    if (archive.get("file") != "source.zip" or type(archive.get("size")) is not int
            or archive["size"] != len(source_data) or sha(source_data) != archive.get("sha256")
            or sha(source_data) != pointer.get("archive_sha256")):
        raise ValueError("checkpoint source.zip digest/size mismatch")
    state = cp.get("state", {})
    if (state.get("is_wip") is not False or state.get("label") != "SNAPSHOT"
            or state.get("wip_reasons") != []):
        raise ValueError("delivery contains a WIP checkpoint or invalid stable state")
    recorded_queue = cp.get("queue", {})
    if (recorded_queue.get("snapshot") != queue or recorded_queue.get("validation_errors") != []
            or recorded_queue.get("has_running_or_review_tasks") is not False
            or recorded_queue.get("running_or_review_task_ids") != []):
        raise ValueError("checkpoint queue differs from closed delivery queue")
    assessment = cp.get("claims_assessment", {})
    if (assessment.get("all_accepted_evidence_matches") is not True
            or assessment.get("issues") != []):
        raise ValueError("checkpoint claims assessment is not stable")
    entries = manifest_entries(cp.get("files"))
    if set(entries) != {name for name in outer_entries if source_name(name)}:
        raise ValueError("checkpoint source members differ from current delivery sources")
    for claim, item in references:
        if (claim.get("status") in checkpoint.ACCEPTED_STATUSES
                and item.get("archive_required", True) and item["path"] not in entries):
            raise ValueError(f"required accepted evidence absent from checkpoint: {item['path']}")
    with zipfile.ZipFile(io.BytesIO(source_data)) as nested:
        check_zip(nested, entries, set())
        for name in entries:
            if nested.read(name) != read(name):
                raise ValueError(f"current delivery source differs from checkpoint: {name}")
    expected = (set(entries) | set(REQUIRED_ARTIFACTS) | {item["path"] for _, item in references}
                | {LATEST, f"{base}/manifest.json", f"{base}/source.zip"})
    if set(outer_entries) != expected:
        raise ValueError("delivery payload differs from source/artifact/evidence selection")
    return len(entries)


def verify(path: Path) -> dict:
    """Read-only and independent of workspace payloads; never extracts or executes."""
    # The same open file is used for member checks and whole-archive hashing.
    with path.open("rb") as stream:
        with zipfile.ZipFile(stream) as packet:
            check_names([info.orig_filename for info in packet.infolist()])
            check_names(packet.namelist())
            manifest = read_json(packet.read, MANIFEST)
            if type(manifest.get("schema_version")) is not int or manifest["schema_version"] != 1:
                raise ValueError("unsupported delivery manifest schema")
            if manifest.get("version") != VERSION:
                raise ValueError("unsupported delivery manifest version")
            entries = manifest_entries(manifest.get("files"))
            check_zip(packet, entries, {MANIFEST})
            queue = read_json(packet.read, "research/queue.json")
            closed_queue(queue)
            _, references = check_claims(packet.read)
            count = check_checkpoint(packet.read, entries, manifest, queue, references)
            manifest_hash = sha(packet.read(MANIFEST))
        stream.seek(0)
        archive_hash = hashlib.file_digest(stream, "sha256").hexdigest()
        size = stream.tell()
    return dict(archive_valid=True, version=VERSION, payload_files=len(entries),
                claim_references=len(references), checkpoint_source_files=count,
                checkpoint_id=manifest["checkpoint_id"], sha256=archive_hash,
                bytes=size, manifest_sha256=manifest_hash, validation_scope=SCOPE)


def stable_workspace(root: Path) -> None:
    result = checkpoint.verify_latest(root)
    if (not result["archive_valid"] or not result.get("workspace")
            or result["workspace"]["changed"] or result.get("state", {}).get("is_wip") is not False):
        raise ValueError("create a stable, unchanged latest checkpoint first")


def create(root: Path = ROOT) -> dict:
    """The root argument exists for isolated fixtures; CLI creation uses ROOT only."""
    root = root.resolve(strict=True)
    target = checkpoint.contained_file(root, TARGET)
    receipt_path = checkpoint.contained_file(root, RECEIPT)
    if target.exists() or receipt_path.exists():
        raise ValueError("refusing to overwrite frozen v0.4 delivery or receipt")
    stable_workspace(root)
    read = lambda name: checkpoint.contained_file(root, canonical_path(name)).read_bytes()
    closed_queue(read_json(read, "research/queue.json"))
    _, references = check_claims(read)
    pointer_data = read(LATEST)
    pointer = json.loads(pointer_data)
    paths = (set(checkpoint.source_paths(root)) | set(REQUIRED_ARTIFACTS)
             | {item["path"] for _, item in references}
             | {LATEST, f"{pointer['path']}/manifest.json", f"{pointer['path']}/source.zip"})
    check_names(sorted(paths))
    payload = {name: read(name) for name in sorted(paths)}
    check_claims(payload.__getitem__)
    stable_workspace(root)
    if read(LATEST) != pointer_data or any(read(name) != data for name, data in payload.items()):
        raise ValueError("workspace/artifact changed while capturing release")
    manifest = dict(schema_version=1, version=VERSION,
                    created_utc=datetime.now(timezone.utc).isoformat(),
                    status="R059 lex higher-Tor release; not an end-to-end semigroup formalization.",
                    validation_scope=SCOPE, checkpoint_id=pointer["checkpoint_id"],
                    files=[dict(path=name, size=len(data), sha256=sha(data))
                           for name, data in payload.items()])
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = target.with_name(f".{target.name}.{uuid.uuid4().hex}.tmp")
    try:
        with zipfile.ZipFile(temporary, "x", zipfile.ZIP_DEFLATED) as packet:
            for name, data in payload.items():
                packet.writestr(name, data)
            packet.writestr(MANIFEST, encoded(manifest))
        report = verify(temporary)
        if target.exists() or receipt_path.exists():
            raise ValueError("target or receipt appeared during capture; refusing to overwrite")
        # An exclusive hard link publishes atomically without replacement on Windows
        # and POSIX. The temporary file is on the same volume as its destination.
        os.link(temporary, target)
        receipt = dict(archive=TARGET, manifest=MANIFEST, **report)
        with receipt_path.open("xb") as stream:
            stream.write(encoded(receipt))
            stream.flush()
            os.fsync(stream.fileno())
    finally:
        if temporary.exists():
            temporary.unlink()
    return receipt


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verify", type=Path, metavar="ZIP", help="read-only archive-only verification")
    args = parser.parse_args()
    try:
        checkpoint.require_project_venv()
        report = verify(args.verify.resolve(strict=True)) if args.verify else create()
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0
    except (OSError, ValueError, KeyError, TypeError, AttributeError, RuntimeError,
            EOFError, zipfile.BadZipFile, zlib.error) as error:
        print(json.dumps({"archive_valid": False, "error": str(error)}, ensure_ascii=False))
        return 1


if __name__ == "__main__":
    sys.exit(main())
