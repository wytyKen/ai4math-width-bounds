"""Freeze or verify the v0.3 research delivery. Uses only the standard library.

This validates recorded bytes, not mathematical proofs or author identity.
Creation requires a stable latest checkpoint and refuses to replace a release.
Verification reads the ZIP alone; the outer receipt anchors its whole-file hash.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import sys
import uuid
import zipfile

import checkpoint

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = "output/DELIVERY_MANIFEST.json"
TARGET = ROOT / "output/ai4math_research_delivery_v0_3.zip"
RECEIPT = TARGET.with_suffix(".receipt.json")
SCOPE = "Byte integrity and recorded evidence only; does not run Lean, certify proofs, establish novelty, or authenticate an author."
HASH = re.compile(r"[0-9a-f]{64}\Z")


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def encoded(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


def check_claims(read) -> int:
    claims = json.loads(read("research/claims.json"))["claims"]
    references = 0
    for claim in claims:
        for item in claim.get("evidence", []):
            name = checkpoint.safe_path(item["path"])
            if sha(read(name)) != item["sha256"]:
                raise ValueError(f"claim {claim['id']} evidence mismatch: {name}")
            references += 1
    return references


def verify(path: Path) -> dict:
    with zipfile.ZipFile(path) as packet:
        names = packet.namelist()
        safe_names = [checkpoint.safe_path(n) for n in names]
        if (names != safe_names or len(names) != len({n.casefold() for n in names})
                or MANIFEST not in names):
            raise ValueError("noncanonical/duplicate archive paths or missing manifest")
        manifest = json.loads(packet.read(MANIFEST))
        if manifest.get("schema_version") != 1 or manifest.get("version") != "0.3":
            raise ValueError("unsupported delivery manifest")
        entries = manifest["files"]
        expected = []
        for item in entries:
            name = checkpoint.safe_path(item["path"])
            if name == MANIFEST or type(item["size"]) is not int or item["size"] < 0:
                raise ValueError(f"invalid manifest entry: {name}")
            if not isinstance(item["sha256"], str) or not HASH.fullmatch(item["sha256"]):
                raise ValueError(f"invalid hash: {name}")
            expected.append(name)
        if len(expected) != len(set(expected)) or set(names) != set(expected) | {MANIFEST}:
            raise ValueError("archive members differ from manifest")
        for item in entries:
            data = packet.read(item["path"])
            if len(data) != item["size"] or sha(data) != item["sha256"]:
                raise ValueError(f"archive hash/size mismatch: {item['path']}")
        queue = json.loads(packet.read("research/queue.json"))
        errors = checkpoint.check_queue(queue)
        if errors or any(t["status"] in {"ready", "running", "review"} for t in queue["tasks"]):
            raise ValueError(f"delivery queue is invalid or active: {errors}")
        references = check_claims(packet.read)
        pointer = json.loads(packet.read("research/checkpoints/LATEST.json"))
        if pointer["checkpoint_id"] != manifest["checkpoint_id"]:
            raise ValueError("checkpoint pointer differs from delivery manifest")
        base = checkpoint.safe_path(pointer["path"])
        for name, key in (("manifest.json", "manifest_sha256"), ("source.zip", "archive_sha256")):
            if sha(packet.read(f"{base}/{name}")) != pointer[key]:
                raise ValueError(f"checkpoint {name} digest mismatch")
        cp_manifest = json.loads(packet.read(f"{base}/manifest.json"))
        if cp_manifest["state"]["is_wip"]:
            raise ValueError("delivery contains a WIP checkpoint")
    return dict(archive_valid=True, payload_files=len(entries), claim_references=references,
                checkpoint_id=manifest["checkpoint_id"], sha256=checkpoint.file_digest(path),
                validation_scope=SCOPE)


def create() -> dict:
    if TARGET.exists() or RECEIPT.exists():
        raise ValueError("refusing to overwrite frozen v0.3 delivery or receipt")
    checked = checkpoint.verify_latest(ROOT)
    if (not checked["archive_valid"] or checked["workspace"]["changed"]
            or checked["state"]["is_wip"]):
        raise ValueError("create a stable, unchanged latest checkpoint first")
    queue = json.loads((ROOT / "research/queue.json").read_bytes())
    if any(t["status"] in {"ready", "running", "review"} for t in queue["tasks"]):
        raise ValueError("close all active tasks before release")
    check_claims(lambda name: checkpoint.contained_file(ROOT, name).read_bytes())
    paths = checkpoint.source_paths(ROOT)
    paths += ["output/pdf/width_bounds.pdf", "output/pdf/width_bounds_v0_2.pdf",
              "output/pdf/width_bounds_v0_3.pdf", "output/width_bounds_review_v0_1.zip",
              "output/width_bounds_review_v0_2.zip", "research/checkpoints/LATEST.json"]
    pointer = json.loads((ROOT / "research/checkpoints/LATEST.json").read_bytes())
    paths += [f"{pointer['path']}/{n}" for n in ("manifest.json", "source.zip")]
    paths = sorted(set(paths))
    payload = {p: checkpoint.contained_file(ROOT, p).read_bytes() for p in paths}
    # Checkpoint verifies the same bytes; do not race a live writer when freezing.
    after = checkpoint.verify_latest(ROOT)
    if not after["archive_valid"] or after["workspace"]["changed"]:
        raise ValueError("workspace changed while capturing release")
    manifest = dict(schema_version=1, version="0.3", created_utc=datetime.now(timezone.utc).isoformat(),
                    status="Research-delivery phase closed; not an end-to-end semigroup formalization.",
                    validation_scope=SCOPE, checkpoint_id=pointer["checkpoint_id"],
                    files=[dict(path=p, size=len(b), sha256=sha(b)) for p, b in payload.items()])
    TARGET.parent.mkdir(parents=True, exist_ok=True)
    temporary = TARGET.with_name(f".{TARGET.name}.{uuid.uuid4().hex}.tmp")
    try:
        with zipfile.ZipFile(temporary, "x", zipfile.ZIP_DEFLATED) as packet:
            for name, data in payload.items():
                packet.writestr(name, data)
            packet.writestr(MANIFEST, encoded(manifest))
        report = verify(temporary)
        # Windows rename refuses an existing target, preserving release immutability.
        if TARGET.exists():
            raise ValueError("target appeared during capture")
        temporary.rename(TARGET)
        receipt = dict(version="0.3", archive=TARGET.relative_to(ROOT).as_posix(),
                       manifest_sha256=sha(encoded(manifest)), bytes=TARGET.stat().st_size, **report)
        with RECEIPT.open("xb") as stream:
            stream.write(encoded(receipt))
    finally:
        if temporary.exists():
            temporary.unlink()
    return receipt


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verify", type=Path, metavar="ZIP", help="read-only, archive-only verification")
    args = parser.parse_args()
    try:
        checkpoint.require_project_venv()
        result = verify(args.verify.resolve(strict=True)) if args.verify else create()
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    except (OSError, ValueError, KeyError, TypeError, zipfile.BadZipFile) as error:
        print(json.dumps({"archive_valid": False, "error": str(error)}, ensure_ascii=False))
        return 1


if __name__ == "__main__":
    sys.exit(main())
