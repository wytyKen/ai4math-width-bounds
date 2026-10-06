"""Create a small local review packet, excluding runtimes and dependency caches."""

import argparse
import hashlib
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", choices=("0.1", "0.2"), default="0.2")
    version = parser.parse_args().version
    suffix = version.replace(".", "_")
    target = ROOT / f"output/width_bounds_review_v{suffix}.zip"
    if target.exists():
        raise SystemExit(f"Refusing to overwrite frozen review packet: {target}")
    paths = [
        "README.md", "pyproject.toml", "uv.lock",
        "paper/README.md", "paper/width_bounds.tex", "paper/certificate_table.tex",
        "output/pdf/width_bounds.pdf",
        "scripts/audit_bounds.py", "scripts/envelope_certificate.py",
        "scripts/prepare_paper.py", "scripts/build_paper.ps1", "scripts/package_review.py",
        "lean/lakefile.toml", "lean/lake-manifest.json", "lean/lean-toolchain", "lean/WidthBounds.lean",
        "research/combinatorial_proof.md", "research/algebra_bridge_audit.md",
        "research/literature_review.md", "research/adversarial_review.md",
        "research/first_pass.md", "research/review_plan.md",
        "results/envelope_certificate.json", "results/lean_combinatorial_build.txt",
        "results/dp_audit.json", "results/lean_check.txt",
        "results/pdf_qa.md",
    ]
    paths += [p.relative_to(ROOT).as_posix() for p in sorted((ROOT / "lean/WidthBounds").glob("*.lean"))
              if p.name != "Basic.lean"]
    if version == "0.2":
        paths += [
            "paper/README_v0_2.md", "paper/width_bounds_v0_2.tex",
            "output/pdf/width_bounds_v0_2.pdf", "research/analytic_formalization.md",
            "research/tasks/R006_analytic.md", "research/tasks/R010_analytic_review.md",
            "research/tasks/R011_analytic_arithmetic.md", "research/tasks/R012_all_widths.md",
            "research/tasks/R015_novelty.md", "research/tasks/R016_columns.md",
            "results/lean_columns_build.txt", "results/lean_all_widths_build.txt",
            "results/pdf_qa_v0_2.md",
        ]
    entries = []
    for rel in paths:
        path = ROOT / rel
        data = path.read_bytes()
        entries.append({"path": rel, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()})
    manifest = {
        "version": version, "date": "2026-09-23",
        "status": "Research draft for independent review; novelty not established.",
        "formal_scope": "Standard-monomial combinatorics; v0.2 includes all widths >=4 without finite enumeration. Algebraic transfer is conventional.",
        "files": entries,
    }
    manifest_path = ROOT / ("results/review_packet_manifest.json" if version == "0.1"
                            else f"results/review_packet_manifest_v{suffix}.json")
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    target.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(target, "w", ZIP_DEFLATED) as packet:
        for rel in paths:
            packet.write(ROOT / rel, rel)
        packet.write(manifest_path, manifest_path.relative_to(ROOT).as_posix())
    with ZipFile(target) as packet:
        assert packet.testzip() is None
        assert len(packet.namelist()) == len(paths) + 1
        assert not any(".lake/" in p or ".venv/" in p or ".mathlib-cache/" in p for p in packet.namelist())
    print(f"Created {target.name}: {len(paths)+1} files, {target.stat().st_size} bytes.")


if __name__ == "__main__":
    main()
