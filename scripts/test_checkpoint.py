"""Run: .venv/Scripts/python.exe -m unittest discover -s scripts -p test_checkpoint.py"""

import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest import mock
import zipfile

import checkpoint


class CheckpointTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.write("research/queue.json", {"schema_version": 1, "tasks": []})
        self.write("research/claims.json", {"schema_version": 1, "claims": []})
        self.write("README.md", "Project source\n")
        self.write("lean/Main.lean", "example : True := by trivial\n")
        self.write("lean/lean-toolchain", "leanprover/lean4:v4.29.0\n")
        self.write("scripts/work.py", "print('source')\n")

    def write(self, name, value):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        if isinstance(value, (dict, list)):
            value = json.dumps(value)
        path.write_text(value, encoding="utf-8")
        return path

    def create(self, reason="test checkpoint"):
        result = checkpoint.create_checkpoint(self.root, reason)
        directory = self.root / result["checkpoint"]
        manifest = json.loads((directory / "manifest.json").read_text(encoding="utf-8"))
        return result, directory, manifest

    def test_roundtrip_and_independent_workspace_changes(self):
        created, directory, manifest = self.create()
        verified = checkpoint.verify_latest(self.root)
        self.assertTrue(verified["archive_valid"], verified)
        self.assertFalse(verified["workspace"]["changed"])
        self.assertFalse(created["state"]["source_compilation_checked"])
        self.assertEqual("SNAPSHOT", created["state"]["label"])
        self.assertEqual("test checkpoint", manifest["reason"])
        with zipfile.ZipFile(directory / "source.zip") as archive:
            for entry in manifest["files"]:
                self.assertEqual(entry["sha256"], hashlib.sha256(archive.read(entry["path"])).hexdigest())
        self.write("README.md", "Later source\n")
        self.write("research/later.md", "New source\n")
        (self.root / "scripts/work.py").unlink()
        verified = checkpoint.verify_latest(self.root)
        self.assertTrue(verified["archive_valid"], verified)
        self.assertEqual(["README.md"], verified["workspace"]["modified"])
        self.assertEqual(["research/later.md"], verified["workspace"]["added"])
        self.assertEqual(["scripts/work.py"], verified["workspace"]["missing"])

    def test_caches_and_existing_checkpoints_excluded(self):
        for directory in [".venv", ".uv-cache", ".mathlib-cache", ".git", ".lake", "tmp", "output", "lean/.lake", "lean/.git", "scripts/__pycache__", "research/checkpoints/old"]:
            self.write(f"{directory}/should_not_capture.json", "{}")
        self.write("paper/paper.pdf", "binary placeholder")
        _, first_dir, first_manifest = self.create()
        original = (first_dir / "source.zip").read_bytes()
        _, second_dir, second_manifest = self.create("second")
        self.assertNotEqual(first_dir, second_dir)
        self.assertEqual(original, (first_dir / "source.zip").read_bytes())
        names = {entry["path"] for entry in second_manifest["files"]}
        self.assertFalse(any("should_not_capture" in name for name in names))
        self.assertNotIn("paper/paper.pdf", names)
        self.assertIn("lean/lean-toolchain", names)
        self.assertEqual(first_manifest["files"], second_manifest["files"])

    def test_tampered_archive_is_invalid(self):
        _, directory, _ = self.create()
        # A valid ZIP with an extra entry still fails, even though its CRCs work.
        with zipfile.ZipFile(directory / "source.zip", "a") as archive:
            archive.writestr("intruder.txt", b"tampered")
        result = checkpoint.verify_latest(self.root)
        self.assertFalse(result["archive_valid"])
        self.assertIn("archive SHA-256 mismatch", result["errors"])
        self.assertIsNone(result["workspace"])

    def test_manifest_tamper_is_invalid(self):
        _, directory, _ = self.create()
        with (directory / "manifest.json").open("ab") as stream:
            stream.write(b"\n")
        self.assertFalse(checkpoint.verify_latest(self.root)["archive_valid"])

    def test_corrupt_compressed_payload_is_reported(self):
        _, directory, _ = self.create()
        path = directory / "source.zip"
        with zipfile.ZipFile(path) as archive:
            info = archive.getinfo("README.md")
        start = info.header_offset + 30 + len(info.filename.encode("utf-8")) + len(info.extra)
        with path.open("r+b") as stream:
            stream.seek(start)
            stream.write(b"\xff" * min(info.compress_size, 10))
        result = checkpoint.verify_latest(self.root)
        self.assertFalse(result["archive_valid"])
        self.assertTrue(result["errors"])

    def test_duplicate_id_traversal_and_conflicts(self):
        queue = {"root_owned_paths": ["README.md"], "tasks": [
            {"id": "R1", "status": "running", "owned_paths": ["scripts/a.py", "../escape.py"]},
            {"id": "R1", "status": "ready", "owned_paths": ["scripts/A.py", "README.md", "C:\\escape.py"]},
            {"id": "R3", "status": "invalid", "owned_paths": ["/absolute.py"]},
        ]}
        errors = checkpoint.check_queue(queue)
        self.assertTrue(any("duplicate task ID" in error for error in errors))
        self.assertEqual(3, sum("unsafe relative path" in error for error in errors))
        self.assertEqual(2, sum("path conflict" in error for error in errors))
        self.assertTrue(any("invalid status" in error for error in errors))
        self.assertEqual([], checkpoint.check_queue({"tasks": [
            {"id": "old", "status": "done", "owned_paths": ["same.py"]},
            {"id": "new", "status": "running", "owned_paths": ["same.py"]},
        ]}))

    def test_running_and_review_are_explicitly_wip(self):
        self.write("research/queue.json", {"tasks": [
            {"id": "R1", "status": "running", "owned_paths": ["a.py"]},
            {"id": "R2", "status": "review", "owned_paths": ["b.py"]},
        ]})
        result, _, manifest = self.create()
        self.assertTrue(result["state"]["is_wip"])
        self.assertEqual("WIP", result["state"]["label"])
        self.assertEqual(["R1", "R2"], manifest["queue"]["running_or_review_task_ids"])
        self.assertFalse(result["state"]["source_compilation_checked"])

    def test_missing_self_and_cyclic_dependencies(self):
        errors = checkpoint.check_queue({"tasks": [
            {"id": "A", "status": "ready", "depends_on": ["B", "missing"]},
            {"id": "B", "status": "ready", "depends_on": ["A"]},
            {"id": "C", "status": "ready", "depends_on": ["C"]},
        ]})
        self.assertTrue(any("unknown dependency missing" in error for error in errors))
        self.assertTrue(any("depends on itself" in error for error in errors))
        self.assertTrue(any("dependency cycle" in error for error in errors))

    def test_unrecognized_metadata_is_wip(self):
        self.write("research/queue.json", {"tasks": None})
        self.write("research/claims.json", {"unrecognized": []})
        result, _, manifest = self.create()
        self.assertTrue(result["state"]["is_wip"])
        self.assertTrue(manifest["queue"]["validation_errors"])
        self.assertFalse(manifest["claims_assessment"]["all_accepted_evidence_matches"])

    def test_evidence_hashes_are_captured_and_mismatch_is_wip(self):
        evidence = self.write("results/build.txt", "reported build output\n")
        self.write("research/claims.json", {"claims": [
            {"id": "C1", "status": "formal_verified", "verification": {"command": "lake build", "log": "results/build.txt"},
             "evidence": [{"path": "results/build.txt", "sha256": checkpoint.file_digest(evidence)}]},
            {"id": "C2", "status": "unresolved", "statement": "not established"},
        ]})
        _, _, manifest = self.create()
        assessment = manifest["claims_assessment"]
        self.assertTrue(assessment["all_accepted_evidence_matches"])
        self.assertEqual(1, assessment["ignored_claim_count"])
        self.assertEqual("archived_bytes", assessment["accepted"][0]["evidence"][0]["hash_source"])
        self.assertFalse(assessment["accepted"][0]["verification_executed_by_checkpoint"])
        self.write("results/build.txt", "changed output\n")
        result, _, manifest = self.create()
        self.assertTrue(result["state"]["is_wip"])
        self.assertEqual("mismatch", manifest["claims_assessment"]["accepted"][0]["evidence"][0]["status"])

    def test_missing_claims_does_not_fabricate_validation(self):
        (self.root / "research/claims.json").unlink()
        result, _, manifest = self.create()
        self.assertTrue(result["state"]["is_wip"])
        self.assertFalse(manifest["claims_assessment"]["all_accepted_evidence_matches"])

    def test_optional_external_artifact_is_checked_but_not_archived(self):
        evidence = self.write("output/frozen.pdf", "frozen artifact bytes")
        self.write("research/claims.json", {"claims": [
            {"id": "C4", "status": "artifact_checked", "evidence": [
                {"path": "output/frozen.pdf", "sha256": checkpoint.file_digest(evidence),
                 "archive_required": False}
            ]}
        ]})
        result, directory, manifest = self.create()
        claim = manifest["claims_assessment"]["accepted"][0]
        self.assertFalse(result["state"]["is_wip"])
        self.assertTrue(claim["matches"])
        self.assertFalse(claim["all_evidence_archived"])
        self.assertTrue(claim["all_required_evidence_archived"])
        self.assertEqual("workspace_at_assessment", claim["evidence"][0]["hash_source"])
        self.assertEqual("output/frozen.pdf", manifest["claims_assessment"]["unarchived_references"][0]["path"])
        with zipfile.ZipFile(directory / "source.zip") as archive:
            self.assertNotIn("output/frozen.pdf", archive.namelist())
        self.write("output/frozen.pdf", "changed artifact bytes")
        result, _, manifest = self.create()
        self.assertTrue(result["state"]["is_wip"])
        self.assertEqual("mismatch", manifest["claims_assessment"]["accepted"][0]["evidence"][0]["status"])
        evidence.unlink()
        result, _, manifest = self.create()
        self.assertTrue(result["state"]["is_wip"])
        self.assertEqual("unavailable", manifest["claims_assessment"]["accepted"][0]["evidence"][0]["status"])

    def test_external_artifact_requires_archiving_by_default(self):
        evidence = self.write("output/frozen.pdf", "frozen artifact bytes")
        self.write("research/claims.json", {"claims": [
            {"id": "C4", "status": "artifact_checked", "evidence": [
                {"path": "output/frozen.pdf", "sha256": checkpoint.file_digest(evidence)}
            ]}
        ]})
        result, _, manifest = self.create()
        self.assertTrue(result["state"]["is_wip"])
        claim = manifest["claims_assessment"]["accepted"][0]
        self.assertTrue(claim["matches"])
        self.assertFalse(claim["all_required_evidence_archived"])

    def test_latest_not_replaced_when_archive_creation_fails(self):
        self.create()
        pointer = self.root / "research/checkpoints/LATEST.json"
        before = pointer.read_bytes()
        with mock.patch.object(checkpoint.zipfile.ZipFile, "writestr", side_effect=OSError("simulated write failure")):
            with self.assertRaises(OSError):
                self.create("failing write")
        self.assertEqual(before, pointer.read_bytes())
        self.assertTrue(checkpoint.verify_latest(self.root)["archive_valid"])

    def test_latest_pointer_cannot_escape_checkpoint_directory(self):
        self.create()
        pointer = self.root / "research/checkpoints/LATEST.json"
        value = json.loads(pointer.read_bytes())
        value["path"] = "../outside"
        pointer.write_bytes(checkpoint.json_bytes(value))
        result = checkpoint.verify_latest(self.root)
        self.assertFalse(result["archive_valid"])
        self.assertTrue(any("pointer" in error for error in result["errors"]))


if __name__ == "__main__":
    unittest.main()
