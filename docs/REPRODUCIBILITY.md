# Reproducing and checking the project

This guide is the English maintenance entry point. It distinguishes source builds, recorded historical build evidence, byte-integrity checks, and PDF reproduction. R095 independent clean-environment validation remains pending; the English documentation update does not complete it.

## Fixed environment

| Component | Accepted baseline |
|---|---|
| Lean | `leanprover/lean4:v4.22.0` in [lean-toolchain](../lean/lean-toolchain) |
| mathlib | v4.22.0, commit `79e94a093aff4a60fb1b1f92d9681e407124c2ca` |
| Lake dependencies | [lake-manifest.json](../lean/lake-manifest.json), with the pinned [lakefile](../lean/lakefile.toml) |
| Python | 3.13 series, root uv `.venv`, [pyproject.toml](../pyproject.toml) and [uv.lock](../uv.lock) |
| Cache locations | `.uv-cache/`, `.mathlib-cache/`, `lean/.lake/` inside the checkout |

Do not run `lake update` to make a dependency mismatch disappear. Keep the environment failure separate from a proof failure. Runtime caches are not distributed as part of the public source repository.

## Build Lean from a Git checkout

Prerequisite: a working elan / Lake installation capable of obtaining the pinned toolchain. From the repository root in PowerShell:

```powershell
$taskRoot = (Get-Location).Path
$env:MATHLIB_CACHE_DIR = Join-Path $taskRoot '.mathlib-cache'
Push-Location lean
try {
    lake exe cache get
    if ($LASTEXITCODE -ne 0) { throw 'mathlib cache download failed' }
    lake build
    if ($LASTEXITCODE -ne 0) { throw 'Lean build failed' }
} finally {
    Pop-Location
}
```

Dependency/toolchain and cache downloads may require network access. A failed cache download is not evidence that a theorem is false. Save the exit status and the relevant log if a build fails.

For a POSIX shell, the corresponding Lean commands are:

```bash
export MATHLIB_CACHE_DIR="$PWD/.mathlib-cache"
(cd lean && lake exe cache get && lake build)
```

These instructions have not been re-certified as a clean-environment run by this documentation task. The existing scientific evidence is the [R058 record](../results/r058_validation.json) and [integrated build log](../results/lean_higher_tor_build.txt), SHA-256 `29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4`. It records a successful incremental integrated build, including cache replay. The 64 Lean project files have remained byte-identical through the current documentation and release work.

R058 recorded 16 new named axiom checks and 17 additional dependency roots. These counts describe that validation step; they are not a claim that a short audit alone proves every informal statement or the complete semigroup application.

## Python and queue checks

Install the locked root environment with uv, then invoke project scripts using that interpreter:

```powershell
uv --cache-dir .uv-cache sync --frozen
.venv\Scripts\python.exe -B scripts/checkpoint.py --check
```

On POSIX systems, the interpreter path is `.venv/bin/python`. `--check` validates queue structure and ownership. It does not compile Lean, verify a PDF, or decide mathematical correctness.

Historical experiment scripts remain in [scripts](../scripts/). They are not prerequisites for every source build, and the finite experiments do not replace the general proofs. Run only the experiment or test relevant to the change being made.

## Public checkout versus complete local delivery

The public checkout includes the Lean/Python source, English primary documentation, historical research records, textual results, manuscript sources, and four project PDFs. It omits local checkpoints, runtimes/caches, downloaded third-party full texts, complete older ZIPs, and their receipts.

Some entries in [claims.json](../research/claims.json) refer to those excluded historical artifacts. Their absence from a plain clone is expected. Do not present a failed archive lookup as a Lean failure, and do not claim the Git checkout independently validates a ZIP that is not present.

If a complete local delivery includes `research/checkpoints/`, the corresponding command is:

```powershell
.venv\Scripts\python.exe -B scripts/checkpoint.py --verify-latest
```

It distinguishes a damaged archived snapshot from ordinary later workspace changes. It checks bytes and recorded evidence hashes, not proof compilation. On a plain clone without local checkpoints, skip this historical-archive command.

For a separately obtained complete frozen v0.4 delivery, use the existing archive verifier:

```powershell
.venv\Scripts\python.exe -B scripts/package_delivery_v0_4.py --verify output/ai4math_research_delivery_v0_4.zip
```

The original v0.4 ZIP has SHA-256 `ed74ee6c46ed160fd4b00f074de9c1e8c833f9a0b91a5bd96f29b36f1ede2285`. Its source checkpoint is `20261001T095721013368Z-b002439c`; the mathematical R058 baseline is `20261001T090243180713Z-07071c19`. Later documentation checkpoints are separate versions. Do not recreate or overwrite that frozen ZIP to include today's README.

The archive verifier checks safe paths, listed payloads, hashes, evidence references, and agreement between the inner source snapshot and outer payload. It does not execute the archived Lean files. Hashes establish byte correspondence, not a signature, novelty, or external peer review.

## Manuscript PDFs

The [manuscript index](../paper/README.md) lists all frozen versions. The v0.4 PDF was compiled using the existing local MiKTeX pipeline and received a recorded 10-page visual check; the native editor's failed compilation attempt was not treated as success. Evidence is in [PDF QA](../results/pdf_qa_v0_4.md) and the [compile log](../results/paper_compile_v0_4.txt).

For a deliberate manuscript-reproduction task, use a separate working copy/output and the existing `scripts/build_paper_v0_4.ps1`. The script refuses to overwrite the corresponding PDF when the frozen v0.4 ZIP is present. TeX installations, fonts, and metadata can change PDF bytes without changing the source argument; do not replace frozen acceptance evidence with the new PDF's hash.

The workflow under `lean/.github/` is a historical nested template, not a root repository CI configuration. This project does not claim that GitHub Actions or an independent clean machine has validated the current release.
