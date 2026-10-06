"""Constructive v0.4 integrity tests using real temporary checkpoints and ZIPs."""

import io
import json
from pathlib import Path
import stat
import tempfile
import unittest
from unittest.mock import patch
import warnings
import zipfile

import package_delivery_v0_4 as delivery


class DeliveryV04Tests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "project"
        self.prepare(self.root)
        self.receipt = delivery.create(self.root)
        self.archive = self.root / delivery.TARGET
        with zipfile.ZipFile(self.archive) as packet:
            self.files = {name: packet.read(name) for name in packet.namelist()
                          if name != delivery.MANIFEST}
            self.manifest = json.loads(packet.read(delivery.MANIFEST))
        self.base = json.loads(self.files[delivery.LATEST])["path"]

    def prepare(self, root):
        files = {
            "research/queue.json": delivery.encoded({"tasks": [], "root_owned_paths": []}),
            "research/claims.json": delivery.encoded({"claims": [
                {"id": "C001", "status": "formal_verified", "evidence": [
                    {"path": "proof.txt", "sha256": delivery.sha(b"proof bytes")}]},
                {"id": "C002", "status": "artifact_checked", "evidence": [
                    {"path": "output/legacy_v0_3.zip", "sha256": delivery.sha(b"legacy ZIP"),
                     "archive_required": False}]},
            ]}),
            "proof.txt": b"proof bytes",
            "README.md": b"fixture, not a mathematical proof",
            "output/legacy_v0_3.zip": b"legacy ZIP",
            **{name: f"fixture artifact {name}".encode() for name in delivery.REQUIRED_ARTIFACTS},
        }
        for name, data in files.items():
            path = root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        result = delivery.checkpoint.create_checkpoint(root, "stable test fixture")
        self.assertFalse(result["state"]["is_wip"])

    def write(self, change_manifest=None, mutate_after_manifest=None, extra=None):
        manifest = dict(self.manifest)
        manifest["files"] = [dict(path=name, size=len(data), sha256=delivery.sha(data))
                             for name, data in self.files.items()]
        if change_manifest:
            change_manifest(manifest)
        payload = dict(self.files)
        if mutate_after_manifest:
            mutate_after_manifest(payload)
        with zipfile.ZipFile(self.archive, "w", zipfile.ZIP_DEFLATED) as packet:
            for name, data in payload.items():
                packet.writestr(name, data)
            packet.writestr(delivery.MANIFEST, delivery.encoded(manifest))
            if extra:
                with warnings.catch_warnings():
                    warnings.simplefilter("ignore", UserWarning)
                    packet.writestr(*extra)

    def checkpoint_change(self, change_manifest=None, change_source=None, source_extra=None):
        name = f"{self.base}/manifest.json"
        cp = json.loads(self.files[name])
        if change_source or source_extra:
            with zipfile.ZipFile(io.BytesIO(self.files[f"{self.base}/source.zip"])) as packet:
                source = {p: packet.read(p) for p in packet.namelist()}
            if change_source:
                change_source(source)
            memory = io.BytesIO()
            with zipfile.ZipFile(memory, "w", zipfile.ZIP_DEFLATED) as packet:
                for path, data in source.items():
                    packet.writestr(path, data)
                if source_extra:
                    with warnings.catch_warnings():
                        warnings.simplefilter("ignore", UserWarning)
                        packet.writestr(*source_extra)
            data = memory.getvalue()
            self.files[f"{self.base}/source.zip"] = data
            cp["archive"].update(sha256=delivery.sha(data), size=len(data))
        if change_manifest:
            change_manifest(cp)
        self.files[name] = delivery.encoded(cp)
        pointer = json.loads(self.files[delivery.LATEST])
        pointer.update(manifest_sha256=delivery.sha(self.files[name]),
                       archive_sha256=delivery.sha(self.files[f"{self.base}/source.zip"]))
        self.files[delivery.LATEST] = delivery.encoded(pointer)

    def rejected(self, message):
        with self.assertRaisesRegex((ValueError, KeyError, zipfile.BadZipFile), message):
            delivery.verify(self.archive)

    def test_constructive_create_and_verify_matches_receipt(self):
        report = delivery.verify(self.archive)
        self.assertTrue(report["archive_valid"])
        self.assertEqual(report["version"], "0.4")
        self.assertEqual(report["claim_references"], 2)
        self.assertEqual(report["checkpoint_source_files"], 4)
        self.assertEqual(report["sha256"], self.receipt["sha256"])
        self.assertEqual(report["bytes"], self.archive.stat().st_size)
        self.assertEqual(json.loads((self.root / delivery.RECEIPT).read_bytes()), self.receipt)
        self.assertIn("output/legacy_v0_3.zip", self.files)
        self.assertNotIn(delivery.TARGET, self.files)
        self.assertNotIn(delivery.RECEIPT, self.files)

    def test_verify_is_read_only_and_needs_no_workspace(self):
        standalone = Path(self.temp.name) / "standalone.zip"
        data = self.archive.read_bytes()
        standalone.write_bytes(data)
        with patch.object(delivery.checkpoint, "contained_file", side_effect=AssertionError("workspace read")), \
                patch.object(delivery.checkpoint, "verify_latest", side_effect=AssertionError("workspace read")):
            self.assertTrue(delivery.verify(standalone)["archive_valid"])
        self.assertEqual(standalone.read_bytes(), data)
        self.assertEqual(set(standalone.parent.iterdir()), {self.root, standalone})

    def test_wrong_version_rejected(self):
        self.write(change_manifest=lambda m: m.update(version="0.3"))
        self.rejected("version")

    def test_tampered_payload_rejected(self):
        self.write(mutate_after_manifest=lambda p: p.update({"proof.txt": b"altered"}))
        self.rejected("hash/size mismatch")

    def test_missing_member_rejected(self):
        self.write(mutate_after_manifest=lambda p: p.pop("proof.txt"))
        self.rejected("members differ")

    def test_unlisted_member_rejected(self):
        self.write(extra=("unlisted.txt", b"extra"))
        self.rejected("members differ")

    def test_required_artifact_missing_even_with_updated_manifest(self):
        self.files.pop("output/pdf/width_bounds_v0_4.pdf")
        self.write()
        self.rejected("payload differs")

    def test_unexpected_listed_artifact_rejected(self):
        self.files["output/unexpected.bin"] = b"extra"
        self.write()
        self.rejected("payload differs")

    def test_duplicate_and_case_collision_members_rejected(self):
        for name in ("proof.txt", "PROOF.TXT"):
            with self.subTest(name=name):
                self.write(extra=(name, b"duplicate"))
                self.rejected("duplicate")

    def test_unsafe_member_paths_rejected(self):
        for name in ("../escape.txt", "/absolute", "C:/drive", "a\\b.txt", "a/./b",
                     "a//b", "CON.txt", "a/trailing.", "a/name ", "a/stream:other", "a/?.txt"):
            with self.subTest(name=name):
                info = zipfile.ZipInfo(name)
                # Keep intentionally malformed raw spelling; ZipInfo normally
                # normalizes backslashes when this test runs on Windows.
                info.filename = name
                info.orig_filename = name
                self.write(extra=(info, b"unsafe"))
                self.rejected("unsafe|noncanonical")

    def test_file_directory_collision_rejected(self):
        self.write(extra=("proof.txt/child", b"collision"))
        self.rejected("path collision")

    def test_symlink_member_rejected(self):
        info = zipfile.ZipInfo("output/link.bin")
        info.create_system = 3
        info.external_attr = (stat.S_IFLNK | 0o777) << 16
        self.files[info.filename] = b"target"
        self.write(mutate_after_manifest=lambda p: p.pop(info.filename), extra=(info, b"target"))
        self.rejected("nonregular")

    def test_invalid_manifest_sizes_hashes_and_duplicate_paths(self):
        changes = (
            (lambda m: m["files"][0].update(size=True), "size"),
            (lambda m: m["files"][0].update(sha256="bad"), "hash"),
            (lambda m: m["files"].append(m["files"][0]), "duplicate"),
            (lambda m: m["files"][0].update(path="a\\b"), "noncanonical"),
        )
        for change, message in changes:
            with self.subTest(message=message):
                self.write(change_manifest=change)
                self.rejected(message)

    def test_stale_claim_rejected_despite_updated_manifest(self):
        self.files["proof.txt"] = b"new bytes but old evidence"
        self.write()
        self.rejected("evidence mismatch")

    def test_nonaccepted_claim_evidence_also_checked(self):
        claims = json.loads(self.files["research/claims.json"])
        claims["claims"][0]["status"] = "conjecture"
        self.files["research/claims.json"] = delivery.encoded(claims)
        self.files["proof.txt"] = b"new bytes but old evidence"
        self.write()
        self.rejected("evidence mismatch")

    def test_missing_claim_evidence_rejected(self):
        self.files.pop("output/legacy_v0_3.zip")
        self.write()
        self.rejected("legacy_v0_3")

    def test_required_accepted_evidence_must_be_in_checkpoint(self):
        claims = json.loads(self.files["research/claims.json"])
        claims["claims"][1]["evidence"][0]["archive_required"] = True
        self.files["research/claims.json"] = delivery.encoded(claims)
        self.write()
        self.rejected("required accepted evidence absent from checkpoint")

    def test_active_queue_rejected_for_all_active_statuses(self):
        for status in sorted(delivery.ACTIVE):
            with self.subTest(status=status):
                queue = {"tasks": [{"id": "R001", "status": status, "owned_paths": []}],
                         "root_owned_paths": []}
                self.files["research/queue.json"] = delivery.encoded(queue)
                self.write()
                self.rejected("queue is invalid or active")

    def test_invalid_queue_rejected(self):
        self.files["research/queue.json"] = delivery.encoded({"tasks": [{"id": "bad", "status": "wrong"}]})
        self.write()
        self.rejected("queue is invalid or active")

    def test_wip_checkpoint_rejected(self):
        self.checkpoint_change(lambda cp: cp["state"].update(is_wip=True))
        self.write()
        self.rejected("WIP checkpoint")

    def test_false_stability_label_rejected(self):
        self.checkpoint_change(lambda cp: cp["state"].update(label="WIP"))
        self.write()
        self.rejected("WIP checkpoint")

    def test_false_checkpoint_claim_assessment_rejected(self):
        self.checkpoint_change(lambda cp: cp["claims_assessment"].update(all_accepted_evidence_matches=False))
        self.write()
        self.rejected("claims assessment")

    def test_checkpoint_queue_must_match(self):
        self.checkpoint_change(lambda cp: cp["queue"].update(snapshot={"tasks": []}))
        self.write()
        self.rejected("checkpoint queue")

    def test_checkpoint_id_mismatch_rejected(self):
        self.write(change_manifest=lambda m: m.update(checkpoint_id="wrong"))
        self.rejected("checkpoint ID")

    def test_checkpoint_manifest_digest_rejected(self):
        self.files[f"{self.base}/manifest.json"] += b" "
        self.write()
        self.rejected("manifest digest")

    def test_nested_checkpoint_tamper_rejected_after_outer_rehash(self):
        self.checkpoint_change(change_source=lambda source: source.update({"proof.txt": b"changed"}))
        self.write()
        self.rejected("hash/size mismatch")

    def test_checkpoint_archive_digest_and_size_rejected(self):
        original = dict(self.files)
        for field, value in (("sha256", "0" * 64), ("size", 1)):
            with self.subTest(field=field):
                self.files = dict(original)
                self.checkpoint_change(lambda cp: cp["archive"].update({field: value}))
                self.write()
                self.rejected("source.zip digest/size")

    def test_nested_duplicate_and_unsafe_members_rejected(self):
        original = dict(self.files)
        for name, message in (("proof.txt", "duplicate"), ("../escape", "unsafe")):
            with self.subTest(name=name):
                self.files = dict(original)
                self.checkpoint_change(source_extra=(name, b"bad nested member"))
                self.write()
                self.rejected(message)

    def test_nested_member_missing_rejected(self):
        self.checkpoint_change(change_source=lambda source: source.pop("README.md"))
        self.write()
        self.rejected("members differ")

    def test_current_source_must_equal_nested_checkpoint(self):
        self.files["README.md"] = b"different, correctly rehashed outer source"
        self.write()
        self.rejected("current delivery source differs")

    def test_current_source_selection_must_equal_checkpoint(self):
        self.files["extra_source.py"] = b"pass"
        self.write()
        self.rejected("source members differ")

    def test_current_delivery_self_references_rejected(self):
        original = dict(self.files)
        for name in (delivery.TARGET, delivery.RECEIPT, delivery.MANIFEST):
            with self.subTest(name=name):
                self.files = dict(original)
                claims = json.loads(self.files["research/claims.json"])
                claims["claims"][0]["evidence"][0]["path"] = name
                self.files["research/claims.json"] = delivery.encoded(claims)
                self.write()
                self.rejected("circular current-delivery")

    def test_existing_target_and_receipt_are_not_overwritten(self):
        target_bytes = self.archive.read_bytes()
        receipt_path = self.root / delivery.RECEIPT
        receipt_bytes = receipt_path.read_bytes()
        with self.assertRaisesRegex(ValueError, "refusing to overwrite"):
            delivery.create(self.root)
        self.assertEqual(self.archive.read_bytes(), target_bytes)
        self.assertEqual(receipt_path.read_bytes(), receipt_bytes)
        self.archive.unlink()
        with self.assertRaisesRegex(ValueError, "refusing to overwrite"):
            delivery.create(self.root)
        self.assertFalse(self.archive.exists())
        self.assertEqual(receipt_path.read_bytes(), receipt_bytes)

    def test_creation_rejects_changed_workspace(self):
        fresh = Path(self.temp.name) / "changed"
        self.prepare(fresh)
        (fresh / "README.md").write_bytes(b"changed after checkpoint")
        with self.assertRaisesRegex(ValueError, "stable, unchanged"):
            delivery.create(fresh)
        self.assertFalse((fresh / delivery.TARGET).exists())

    def test_creation_rejects_ready_queue_despite_nonwip_checkpoint(self):
        fresh = Path(self.temp.name) / "ready"
        self.prepare(fresh)
        queue = {"tasks": [{"id": "R001", "status": "ready", "owned_paths": []}]}
        (fresh / "research/queue.json").write_bytes(delivery.encoded(queue))
        result = delivery.checkpoint.create_checkpoint(fresh, "ready is not running")
        self.assertFalse(result["state"]["is_wip"])
        with self.assertRaisesRegex(ValueError, "queue is invalid or active"):
            delivery.create(fresh)

    def test_creation_rejects_changed_optional_binary_evidence(self):
        fresh = Path(self.temp.name) / "binary"
        self.prepare(fresh)
        (fresh / "output/legacy_v0_3.zip").write_bytes(b"changed binary")
        with self.assertRaisesRegex(ValueError, "evidence mismatch"):
            delivery.create(fresh)

    def test_capture_rechecks_binary_artifacts(self):
        fresh = Path(self.temp.name) / "capture"
        self.prepare(fresh)
        original = delivery.stable_workspace
        calls = []

        def racing_check(root):
            original(root)
            calls.append(root)
            if len(calls) == 2:
                (root / "output/pdf/width_bounds_v0_4.pdf").write_bytes(b"changed during capture")

        with patch.object(delivery, "stable_workspace", side_effect=racing_check):
            with self.assertRaisesRegex(ValueError, "changed while capturing"):
                delivery.create(fresh)
        self.assertFalse((fresh / delivery.TARGET).exists())

    def test_target_or_receipt_appearing_during_capture_is_preserved(self):
        for relative in (delivery.TARGET, delivery.RECEIPT):
            with self.subTest(relative=relative):
                fresh = Path(self.temp.name) / Path(relative).name
                self.prepare(fresh)
                original = delivery.verify

                def racing_verify(path):
                    result = original(path)
                    (fresh / relative).write_bytes(b"concurrent owner bytes")
                    return result

                with patch.object(delivery, "verify", side_effect=racing_verify):
                    with self.assertRaisesRegex(ValueError, "appeared during capture"):
                        delivery.create(fresh)
                self.assertEqual((fresh / relative).read_bytes(), b"concurrent owner bytes")
                other = delivery.RECEIPT if relative == delivery.TARGET else delivery.TARGET
                self.assertFalse((fresh / other).exists())
                self.assertFalse(list((fresh / "output").glob("*.tmp")))


if __name__ == "__main__":
    delivery.checkpoint.require_project_venv()
    unittest.main(verbosity=2)
