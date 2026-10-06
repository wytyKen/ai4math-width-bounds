# ai4math: width bounds, lex ideals, and standard Tor

An ongoing human–AI mathematical research project on width bounds for four-generated numerical semigroups and a related Lean formalization of three-variable lex ideals.

**Research snapshot:** the mathematical baseline is **R058 / v0.4**; contribution analysis and proof exposition are complete through R091–R092. The full semigroup reduction is not formalized end to end, novelty remains unresolved, and there has been no external human peer review. See [current status](research/STATE.md) for later documentation and repository work.

English is the primary project language. [中文说明](README.zh-CN.md) and original-language historical records are available.

## Start here

| Your purpose | Read |
|---|---|
| Understand the result and how the project developed | [Project overview](docs/PROJECT_OVERVIEW.md) |
| Follow the argument and inspect the formal statements | [Proof narrative](docs/PROOF_NARRATIVE.md) → [Statement map](docs/STATEMENT_MAP.md) |
| Assess novelty and related work | [Contributions](docs/CONTRIBUTIONS.md) |
| Build or verify an artifact | [Reproducibility](docs/REPRODUCIBILITY.md) |
| Understand release status and responsibilities | [Publication note](docs/PUBLICATION_STATUS.md) |

The [documentation guide](docs/README.md) gives the full reading routes and explains which document owns each topic. The [v0.4 manuscript](output/pdf/width_bounds_v0_4.pdf) is a frozen 10-page English report; its [TeX source](paper/width_bounds_v0_4.tex) and [version index](paper/README.md) are available.

## Main formalized result

Let K be any field, A = K[x,y,z], and m = (x,y,z). Let I be a finite-colength lex monomial ideal with x ∉ I. For an integer w ≥ 4, assume

```text
Σ_{t=0}^d dim_K Q_t(I) ≤ 1 + d·w    for every integer d ≥ 0,
```

where Q_t(I) is the degree-t homogeneous image in A/I. Finite colength is a separate assumption. Let a be the first exponent with xᵃ ∈ I, and ℓ the actual dimension of the full xy quotient subspace.

- An actual finite free resolution has ranks **1, a+1+ℓ, a+2ℓ, ℓ** and zero terms from degree 4. Its differentials vanish after left tensoring with A/m.
- For standard `Tor_i^A(A/m, A/I)`, with the second factor derived and K-action restricted along K→A, all degrees are K-finite. Degrees 0–3 have the four dimensions above; degrees i ≥ 4 are actual zero objects (`IsZero`).
- Writing `b_i = dim_K Tor_i^A(A/m, A/I)`, every i ≥ 1 satisfies `b_i ≤ i·C(w+1, i+1)`; the first bound is strict: `b_1 < w·(w+1)/2`. Here C(n,k) is the binomial coefficient, zero when k > n.
- The maximum xy dimension M_K(w) over this actual lex budget class is attained for w ≥ 4. For w ≥ 64, `w·log(w)/16 ≤ M_K(w) ≤ 10w·log(w)`, using natural logarithms; standard mathlib `Asymptotics.IsTheta` is also proved.

The [proof narrative](docs/PROOF_NARRATIVE.md) gives the full assumptions and argument. The extremal lower bound concerns the lex class, not a matching semigroup lower bound. General Tor balance and a full graded Betti-table interface remain unfinished.

## Evidence, use, and next steps

Lean/mathlib are pinned to **4.22.0**; Python tools use the root uv environment and Python 3.13. The [reproducibility guide](docs/REPRODUCIBILITY.md) owns setup commands and explains the accepted incremental build, pending clean reproduction, and differences between a public checkout and the complete local archive.

AI assistants substantially participated in exploration, implementation, writing, and internal review. Internal AI review is not human peer review. The human contribution/responsibility record (R093) and independent clean reproduction (R095) remain pending. See [future work](docs/FUTURE_WORK.md) for the finite next decisions.

For changes or corrections, read [CONTRIBUTING](CONTRIBUTING.md). Historical Chinese reports and frozen evidence remain accessible through the [archive guide](research/README.md); their original bytes and dated scope are preserved.

No project-wide license, final paper author list, or DOI has been selected. Public availability does not itself grant an open-source reuse license. When citing this work, identify the exact repository revision and its research-snapshot status; see the [publication note](docs/PUBLICATION_STATUS.md) for rights, attribution, and responsibility.
