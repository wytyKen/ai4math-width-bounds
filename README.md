# ai4math: width bounds, lex ideals, and standard Tor

**An ongoing human–AI mathematical research project.** This repository studies width bounds for four-generated numerical semigroups and formalizes a related three-variable lex-ideal model in Lean. It contains proofs, source code, a research manuscript, and a versioned record of the work.

**Status — 7 October 2026:** the latest mathematical baseline is **R058 / v0.4**. Contribution analysis and proof exposition are complete through R091–R092. The full numerical-semigroup reduction is not formalized end to end, novelty remains unresolved, and there has been no external human peer review. The current release is a research snapshot.

**English is the primary project language.** [Chinese overview / 中文说明](README.zh-CN.md) is available. Historical Chinese research records remain as archival evidence; the complete primary reading path below is in English.

## Read the project

| Purpose | English entry point |
|---|---|
| Understand the project, its history, and its limits | [Project overview](docs/PROJECT_OVERVIEW.md) |
| Read the mathematical argument | [Proof narrative, N0–N9](docs/PROOF_NARRATIVE.md) |
| Trace statements to exact Lean declarations | [Statement map](docs/STATEMENT_MAP.md) |
| Distinguish known results from candidate contributions | [Contributions and unresolved literature questions](docs/CONTRIBUTIONS.md) |
| Read the frozen manuscript | [v0.4 PDF](output/pdf/width_bounds_v0_4.pdf) / [TeX](paper/width_bounds_v0_4.tex), a 10-page research report |
| Build and check the project | [Reproducibility guide](docs/REPRODUCIBILITY.md) |
| Understand publication status, AI use, and responsibilities | [Publication and responsibility note](docs/PUBLICATION_STATUS.md) |
| Understand the next decisions and possible extensions | [Future work](docs/FUTURE_WORK.md) |

The [documentation index](docs/README.md) covers the English documentation. [Current state](research/STATE.md), [handoff](research/HANDOFF.md), and [contribution guidelines](CONTRIBUTING.md) describe ongoing maintenance. The [research archive guide](research/README.md) explains the older records and their languages.

## What has been established

| Layer | Existing evidence | Boundary |
|---|---|---|
| Combinatorics and extremal growth | Harmonic and logarithmic bounds, strict binomial control, explicit feasible ideals, and an attained extremum of order Θ(w log w) | The matching lower bound concerns the actual lex budget class; it is not a matching lower bound for numerical semigroups |
| Lean formalization | An actual finite free resolution, standard higher Tor, genuine finite-dimensional K-vector spaces, vanishing, and width bounds | The model has the explicit hypotheses below; the complete semigroup-to-model bridge is still missing |
| Classical mathematical exposition | Published reductions and comparisons connect the model to the original semigroup application | Classical arguments, cited results, direct mathematical corollaries, and compiled Lean declarations are distinguished |
| Novelty | R091 compares related theorems, algorithms, and formalization work | Questions U1–U5 remain open; the repository makes no certified first-proof or first-formalization claim |
| Reproducibility | Pinned dependencies, source and log hashes, and frozen reports | R095 independent clean-environment reproduction has not been completed |

### Precise formalized model

Let K be any field, A = K[x,y,z], and m = (x,y,z). Let I be a finite-colength lex monomial ideal, assume x is not in I, and take an integer w ≥ 4. For every integer d ≥ 0, require the actual cumulative Hilbert-dimension budget

```text
Σ_{t=0}^d dim_K Q_t(I) ≤ 1 + d·w
```

where Q_t(I) is the image of the degree-t homogeneous polynomials in A/I. Finite colength is a separate assumption. Let a be the first exponent for which xᵃ belongs to I, and let ℓ be the actual K-dimension of the full xy quotient subspace.

- The actual standard finite free resolution of A/I has A-ranks **1, a+1+ℓ, a+2ℓ, ℓ** in degrees 0–3 and zero terms from degree 4 onward. Tensoring on the left with A/m makes every differential zero.
- The standard object is **Tor_i^A(A/m, A/I)**: the first factor is fixed and the second is derived. Its K-action is restricted along the actual map K → A. Every degree is proved K-finite, its dimensions in degrees 0–3 are the four values above, and degrees i ≥ 4 are actual zero objects (`IsZero`).
- Write `b_i = dim_K Tor_i^A(A/m, A/I)`. For all i ≥ 1, `b_i ≤ i·C(w+1, i+1)`, where C(n,k) denotes the binomial coefficient and is zero for k > n. The first inequality is strict: `b_1 < C(w+1, 2) = w·(w+1)/2`.
- Let M_K(w) be the maximum xy dimension over this actual lex budget class. The maximum is attained for w ≥ 4. For w ≥ 64, `w·log(w)/16 ≤ M_K(w) ≤ 10w·log(w)`, where log is the natural logarithm. The development also proves the corresponding standard mathlib `Asymptotics.IsTheta` statement.

The complete semigroup reduction, a general Tor factor-exchange/balance interface, and a full graded-shifts/Betti-table API remain unfinished. Explicit harmonic formulas for b₂ and b₃ in the exposition are direct mathematical consequences of existing declarations, not newly compiled standalone endpoints. Finite experiments were used for exploration and error detection; they do not replace the general proofs.

## AI participation and human responsibility

AI assistants participated substantially in mathematical exploration, Lean implementation, literature checks, documentation, and internal review. The human participant set goals, adjusted scope, and made continuation decisions. The detailed human contribution, understanding, and verification record is still pending under R093; it must not be inferred from permission to run tools or publish a repository.

“Independent review” in historical task reports usually means another AI agent's internal check. It does not mean external human peer review or statistically independent evidence of reliability. Git commit identities record repository activity and do not establish the author list of a future paper.

The project prohibits `sorry`, `admit`, custom axioms, and `native_decide`. Recorded axiom checks use standard logical axioms, with research assumptions explicit. A successful Lean build applies to the actual declarations and dependencies, not automatically to every informal interpretation or originality claim. The project does not establish autonomous AI discovery or a measured efficiency advantage of human–AI collaboration.

## Build and verification

Lean and mathlib are pinned to **4.22.0**, with mathlib commit `79e94a093aff4a60fb1b1f92d9681e407124c2ca`. Keep [lean-toolchain](lean/lean-toolchain) and [lake-manifest.json](lean/lake-manifest.json); do not use `lake update` to change the accepted dependency baseline.

With elan / Lake installed, run this from the repository root in PowerShell:

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

These are reproduction instructions, not a claim that this documentation update performed a clean build. The accepted [R058 validation record](results/r058_validation.json) and [Lean build log](results/lean_higher_tor_build.txt) record a successful integrated incremental build, including cache replay.

Python tools use the root uv `.venv` and Python 3.13. Installation and verification distinctions are explained in the [reproducibility guide](docs/REPRODUCIBILITY.md). Public Git clones intentionally omit caches, local checkpoints, downloaded third-party full texts, old ZIPs, and receipts. Some historical [claim evidence](research/claims.json) therefore belongs to the complete local archive rather than the public checkout. Missing archive files are not proof-compilation failures. [.gitattributes](.gitattributes) preserves exact bytes for recorded hashes.

## Contributing, corrections, and next steps

Use English for new primary documentation, code comments, and issue reports; optional translations are welcome. Preserve historical evidence and frozen artifacts. For a suspected error, identify the statement, assumptions, file and commit, and the counterexample or failing command. See [CONTRIBUTING](CONTRIBUTING.md).

The next planned research-preparation task is **R093: an honest contribution and responsibility record**. Manuscript route selection and independent reproduction follow separate decisions. R060–R067 are an optional branch for full semigroup formalization, not an automatic continuation. Frozen v0.1–v0.4 artifacts remain unchanged.

## License and citation status

No project-wide license, final paper author list, or DOI has been selected. Public availability is not a grant of an open-source reuse license; third-party materials retain their own terms. See [GitHub's licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository).

When referring to this snapshot, identify the repository, the exact commit, and its work-in-progress status. A Git timestamp is provenance evidence, not certification of mathematical novelty or priority. The [publication note](docs/PUBLICATION_STATUS.md) explains the current boundaries and the work needed before a formal submission.
