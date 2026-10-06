"""Integrity failure tests for the portable delivery verifier; no Lean invoked."""

import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import warnings
import zipfile

import package_delivery as delivery


class DeliveryIntegrityTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.archive = Path(self.temp.name) / "fixture.zip"
        self.cp = "research/checkpoints/fixture"
        self.files = {
            "research/queue.json": delivery.encoded({"tasks": [], "root_owned_paths": []}),
            "research/claims.json": delivery.encoded({"claims": [{"id": "fixture", "evidence": [
                {"path": "proof.txt", "sha256": delivery.sha(b"fixture proof bytes")}]}]}),
            "proof.txt": b"fixture proof bytes",
            f"{self.cp}/manifest.json": delivery.encoded({"state": {"is_wip": False}}),
            f"{self.cp}/source.zip": b"fixture checkpoint payload, not a proof",
        }
        self.files["research/checkpoints/LATEST.json"] = delivery.encoded({
            "path": self.cp, "checkpoint_id": "fixture",
            "manifest_sha256": delivery.sha(self.files[f"{self.cp}/manifest.json"]),
            "archive_sha256": delivery.sha(self.files[f"{self.cp}/source.zip"]),
        })

    def write(self, mutate=None, extra=None):
        manifest = dict(schema_version=1, version="0.3", checkpoint_id="fixture", files=[
            dict(path=p, size=len(b), sha256=delivery.sha(b)) for p, b in self.files.items()])
        payload = dict(self.files)
        if mutate:
            mutate(payload)
        with zipfile.ZipFile(self.archive, "w") as packet:
            for p, b in payload.items():
                packet.writestr(p, b)
            packet.writestr(delivery.MANIFEST, delivery.encoded(manifest))
            if extra:
                with warnings.catch_warnings():
                    warnings.simplefilter("ignore", UserWarning)
                    packet.writestr(*extra)

    def test_valid_archive_needs_no_workspace_payload(self):
        self.write()
        result = delivery.verify(self.archive)
        self.assertTrue(result["archive_valid"])
        self.assertEqual(result["claim_references"], 1)

    def test_corrupt_payload_rejected(self):
        self.write(lambda p: p.update({"proof.txt": b"altered"}))
        with self.assertRaisesRegex(ValueError, "hash/size mismatch"):
            delivery.verify(self.archive)

    def test_unlisted_entry_rejected(self):
        self.write(extra=("unlisted.txt", b"extra"))
        with self.assertRaisesRegex(ValueError, "members differ"):
            delivery.verify(self.archive)

    def test_duplicate_member_rejected(self):
        self.write(extra=("proof.txt", self.files["proof.txt"]))
        with self.assertRaisesRegex(ValueError, "duplicate"):
            delivery.verify(self.archive)

    def test_unsafe_path_rejected(self):
        self.write(extra=("../escape.txt", b"unsafe"))
        with self.assertRaisesRegex(ValueError, "unsafe"):
            delivery.verify(self.archive)

    def test_valid_manifest_with_stale_claim_rejected(self):
        self.files["proof.txt"] = b"new source but old evidence"
        self.write()
        with self.assertRaisesRegex(ValueError, "evidence mismatch"):
            delivery.verify(self.archive)

    def test_active_queue_rejected(self):
        self.files["research/queue.json"] = delivery.encoded({"root_owned_paths": [], "tasks": [
            {"id": "R001", "status": "running", "owner": "root", "depends_on": [], "owned_paths": []}]})
        self.write()
        with self.assertRaisesRegex(ValueError, "queue is invalid or active"):
            delivery.verify(self.archive)

    def test_wip_checkpoint_rejected(self):
        name = f"{self.cp}/manifest.json"
        self.files[name] = delivery.encoded({"state": {"is_wip": True}})
        pointer = json.loads(self.files["research/checkpoints/LATEST.json"])
        pointer["manifest_sha256"] = delivery.sha(self.files[name])
        self.files["research/checkpoints/LATEST.json"] = delivery.encoded(pointer)
        self.write()
        with self.assertRaisesRegex(ValueError, "WIP checkpoint"):
            delivery.verify(self.archive)

    def test_existing_release_never_overwritten(self):
        self.archive.write_bytes(b"preserved release")
        with patch.object(delivery, "TARGET", self.archive):
            with self.assertRaisesRegex(ValueError, "refusing to overwrite"):
                delivery.create()
        self.assertEqual(self.archive.read_bytes(), b"preserved release")


if __name__ == "__main__":
    delivery.checkpoint.require_project_venv()
    unittest.main()
