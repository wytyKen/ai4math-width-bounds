# Project overview: mathematics, history, and evidence

This project studies width bounds for Betti numbers of four-generator numerical semigroup rings through a three-variable lex-ideal model. Its completed Lean development reaches actual finite-colength quotients, a finite free resolution, and standard Tor in every degree. It also establishes sharp growth order for the largest xy-section dimension in the specified lex budget class. The complete numerical-semigroup reduction remains a traditional mathematical argument.

This overview explains what the project achieved, how its scope changed, and what its evidence supports. For the argument, continue to the [proof narrative](PROOF_NARRATIVE.md); for exact hypotheses and declarations, use the [statement map](STATEMENT_MAP.md). The [contribution analysis](CONTRIBUTIONS.md), [reproducibility guide](REPRODUCIBILITY.md), [publication note](PUBLICATION_STATUS.md), and [future-work guide](FUTURE_WORK.md) own the corresponding details.

## The problem and completed result

For a numerical semigroup with exactly four minimal generators $g_0<g_1<g_2<g_3$, let $w=g_3-g_0$ and $m=g_0$. Over any field K, the original target concerns $R=K[[t^\Gamma]]$ over its minimal regular presentation $P=K[[X_0,X_1,X_2,X_3]]$:

```text
b_i^P(R) = dim_K Tor_i^P(R,K) ≤ i binom(w+1,i+1),    i ≥ 1.
```

These are presentation Betti numbers; they are not dimensions of Tor over R. Degree zero is excluded because its dimension is one. Four minimal generators force $w\ge3$, and the classical codimension-three Cohen–Macaulay argument gives vanishing from degree four.

Caviglia–Moscariello–Sammartano (CMS), *Bounds for syzygies of monomial curves*, supplies the lex reduction and cumulative-budget problem. The inspected version proves the four-generator width bound for $w\ge40$. The project's analytic strengthening in three variables remains a **candidate contribution**: the [literature comparison](CONTRIBUTIONS.md) preserves the known ingredients, M1–M3/F1 labels, and unresolved U1–U5, including inaccessible thesis material and algorithmic overlap. Neither originality nor a first formalization has been certified.

The formal result has a narrower, explicit input. Let $A=K[x,y,z]$, with $x>y>z$, and let I be an actual lex monomial ideal. Assume **finite colength, x standard, $w\ge4$, and the cumulative Hilbert budget in every degree**:

```text
Σ_(t=0)^d dim_K Q_t(I) ≤ 1 + dw,    for every natural d.
```

Here $Q_t(I)$ is the image of the degree-t homogeneous subspace in the actual quotient A/I. Finite colength is an actual finiteness assumption, not a conclusion from the budget or a bare `finrank`. The budget parameter w need not come from a semigroup. The complete definitions, including monomial generation, are in [N0](PROOF_NARRATIVE.md#n0-objects-hypotheses-and-conclusions) and the statement map's [contracts](STATEMENT_MAP.md#contracts-complete-conditions-represented-by-the-abbreviations); helper declarations may have weaker hypotheses.

Write $\mathfrak m=(x,y,z)$, let a be the first forbidden pure-x exponent, and let ell be the dimension of the **full** xy subspace in A/I. The formal chain proves a true minimum of $a+1+\mathrm{ell}$ over all finite polynomial generating sets, then constructs the exact augmented resolution

```text
0 → A^ell → A^(a+2ell) → A^(a+1+ell) → A → A/I → 0.
```

For standard $T_i=\mathrm{Tor}_i^A(A/\mathfrak m,A/I)$, the implementation fixes the first factor $A/\mathfrak m$ and derives the second factor A/I. Its K-action follows the actual map K→A. K-finiteness is proved before dimensions are calculated:

```text
(dim_K T_0, dim_K T_1, dim_K T_2, dim_K T_3)
    = (1, a+1+ell, a+2ell, ell).
```

Every higher T_i is an actual zero object. The all-positive-degree width bound holds, with the first inequality strict. There is also a harmonic estimate

```text
ell ≤ 3w + (2w−1) H_harm(2w−1) ≤ 10w log w,
```

where $H_{\mathrm{harm}}(n)=\sum_{r=1}^n1/r$. Combining it with the dimension formulas gives three $O(w\log w)$ upper bounds. The second and third harmonic expressions are direct mathematical compositions, not new standalone compiled endpoints. Their correct literature baseline includes CMS's $O(w^{3/2})$ estimate; the harmonic bound need not improve the strict binomial bound numerically at every small width.

The maximum $M_K(w)$ of ell over actual ideals in this budget class is attained for $w\ge4$. For $w\ge64$,

```text
w log w / 16 ≤ M_K(w) ≤ 10w log w.
```

The development connects this to standard `Asymptotics.IsTheta`. Explicit lower ideals cover nonsquare as well as square widths. The class of ideals need not be finite; its bounded natural-number section dimensions suffice for attainment. No exact maximizing ideal, optimal constants, separate cross-field equality theorem, or matching semigroup lower bound is claimed.

The [classical semigroup application in N9](PROOF_NARRATIVE.md#n9-the-traditional-comparison-layer-for-the-original-semigroup-application) handles three cases: CMS's budget range $w\le m-2$, the complementary branch using length m and a separate degree-zero check, and width three using arithmetic-sequence results. Regular-parameter reduction preserves ranks, while the later initial/lex steps give upper comparisons. No equality for an arbitrary tangent cone, infinite-field hypothesis, or Cohen–Macaulay tangent-cone assumption is inserted. This complete route, general Tor factor interchange, and a full graded-shifts interface have not been formalized end to end.

## How the project reached this point

The scientific baseline is **R058/C031**, frozen in the v0.4 delivery. Task numbers identify work contracts, not equal units of progress or strict completion order. The following groups the significant changes; the [original report](../research/PROJECT_REPORT.md) and [v0.4 retrospective](../research/PROJECT_RETROSPECTIVE_v0_4.md) preserve the detailed Chinese history.

| Milestone | Change and significance |
|---|---|
| 23 September 2026, R001–R004 / v0.1 | Fixed Lean/mathlib 4.22.0 and the Python environment. Python and independent integer checks produced 267 finite-parameter envelope certificates; Lean checked small-width combinatorics. The report combined these with classical reduction and the published large-width result. |
| R005/R013 | Added immutable snapshots, hashes, an atomic latest pointer, WIP marking, and queue validation. A worker without chat history recovered its task from files. This tested recovery, not mathematical discovery. |
| R006–R016 / v0.2 | Replaced finite enumeration with a terminal triangular-column budget and signed Cauchy argument for every $w\ge4$. Actual monomial-ideal interfaces followed; the new declarations exclude the old finite certificates from their dependencies. |
| R017–R023 | Connected counts to actual quotient bases and homogeneous images, established the harmonic bound, and developed the lower family. A separate experiment checked 1,807 actual semigroups through the Apéry/Hilbert/lex path; it did not prove the universal transfer. |
| R025–R039, through 25 September | Classified all minimal monomials, proved minimality against arbitrary polynomial generators, and built the actual residue fiber, tensor, and coefficient-field identification. Tensor identities were not presented as Tor before the derived bridge existed. |
| 26–29 September, R040–R048 / v0.3 | Corrected an assumed library API and built standard Tor-one. The lower family, every-degree budget, attained maximum, and logarithmic Theta chain were completed. R049–R051 checked the frozen delivery; higher Tor was still unfinished then. |
| 30 September–1 October, R054–R058 | Chose to resolve A/I directly. R055 built the augmentation; R056 proved whole first-kernel generation; R057 proved the next kernel equality and top injectivity. R058 connected the concrete resolution to standard Tor, actual K-dimensions, and all positive-degree bounds. |
| R059 / v0.4 | An independent AI-agent whole-chain semantic review preceded the English manuscript/PDF and a new archive with an external receipt. Byte verification did not count as another proof build or external human review. |
| R086–R102 | The retrospective changed the priority from more semigroup infrastructure to contribution positioning and exposition. R091 retained unresolved literature questions; R092 completed the N0–N9 proof narrative and declaration map, without new mathematics or builds. |
| R103–R115, through 7 October | Prepared and published the repository, fixed README rendering, audited the public payload, and added an English primary reading path. R109–R111 found no actionable private content within their inspected history/PDF scope. Documentation and release work did not advance the scientific baseline. |

Earlier artifacts retain their dated meanings: a v0.3 statement that higher Tor was pending is historical, not the present lex result. The Python package version `0.1.0` is separate metadata. Frozen v0.1–v0.4 sources, PDFs, archives, and acceptance records are not silently updated as the documentation evolves.

## Counterexamples and unsuccessful shortcuts

The project learned several scope boundaries from concrete examples. These are historical mathematical and semantic checks; their presence here does not assert new compiled special-case theorems.

- **The budget does not imply finite colength.** The lex ideal $(x^2,xy,xz,y^2)$ has Hilbert counts $1,3,2,2,\ldots$ and satisfies the $w=4$ cumulative budget. Every pure z power remains standard, so the quotient is infinite-dimensional.
- **The abstract width-three statement is false.** The ideal $(x^2,xy,xz)+(y,z)^3$ has columns $(3,1)$ and satisfies that budget, yet $a+1+\mathrm{ell}=7>6$. At width four, $(x^2,xy,xz)+(y,z)^5$ reaches $\binom52-1$, ruling out a uniform improvement by two.
- **A fixed budget does not bound total length.** The ideals $(x^2,xy,xz,y^2,yz,z^N)$ have length $N+2$. This does not make existing fixed-parameter algorithms irrelevant: R091 found that truncation at degree $2w+1$ preserves the relevant section and Betti values while bounding length by $1+2w^2$. White's fixed-parameter algorithm remains a meaningful comparison.
- **A residue fiber need not give a global generator minimum.** For $I=(x-1,y)$, the dimension of $I/\mathfrak mI$ is one but two generators are required. The project's minimum formula retains its monomial hypotheses.
- **The Tor-one bridge needs $I\subseteq\mathfrak m$.** At $I=A$, the residue tensor is one-dimensional while the quotient and its Tor-one are zero.
- **An upper comparison cannot transfer a lower bound backward.** Large lex Betti numbers do not force large semigroup Betti numbers, even if a semigroup realizes the same Hilbert function. That needs separate homological evidence or an equality mechanism.

Other obstacles concerned implementation: natural/integer casts in a signed argument, excessive scalar-instance simplification, an incorrect expectation about `ProjectiveResolution.of`, a section hypothesis needing explicit `include`, and transport of zero objects through restriction of scalars. Missing `.olean` files and console encoding failures were distinguished from proof failures. Final claims cite successful evidence rather than development diagnostics.

## What the evidence supports

The project distinguishes conjecture, finite experimental support, internally reviewed classical proof, compiled Lean statements, literature-known results, and unresolved novelty. These statuses cannot substitute for one another.

| Evidence | Supported conclusion and limit |
|---|---|
| Named declarations and a successful Lean build | Kernel checking of the actual formal propositions. This does not check every informal interpretation or the unformalized semigroup bridge. |
| Dependency and axiom audits | The inspected declarations' dependencies and foundational assumptions. Project policy prohibits `sorry`, `admit`, custom axioms, and `native_decide`; the R058 reports use only `propext`, `Classical.choice`, and `Quot.sound`. |
| Internal mathematical/semantic review | Another examination of hypotheses, object identity, and proof scope. AI reviewers can share errors; their reports are not external human peer review. |
| Finite experiments | Evidence about the tested cases and implementation. They cannot establish an infinite theorem or exhaustive literature exclusion. |
| Hashes, checkpoints, and receipts | Byte correspondence and recoverability. They do not perform a fresh compilation, authenticate authorship, or establish independent reproduction. |
| Public Git repository | Availability of a revision's payload. Hosting does not establish journal acceptance, licensing, or a successful clean build. |

R058 records a successful unified **incremental build with cached dependency replay** under Lean/mathlib 4.22.0. The [reproducibility guide](REPRODUCIBILITY.md) owns the exact commands, pinned commit, log/hash references, audit counts, archive checkpoints, and public-clone versus local-delivery instructions. Its evidence remains tied to the recorded source bytes; editing a proof would require new validation. **R095 independent clean-environment reproduction is pending.** Public clones intentionally omit local checkpoints, caches, downloaded full texts, and some delivery binaries; those omissions do not imply corruption.

## Human–AI workflow and its limits

The recorded human role includes selecting the problem and scope, authorizing continuation or stopping, choosing freezes, and setting collaboration constraints. Agents did substantial literature retrieval, mathematical exploration, proof implementation, documentation, and internal review. The records do not establish who originated every idea, which steps a human independently re-proved, or who can currently take responsibility for the complete argument.

Persistence made this work inspectable. STATE, HANDOFF, and the queue retain status and file ownership; task reports retain results; claims connect conclusions to source/log hashes; checkpoints preserve resumable bytes. The root integrates work from at most two concurrent child agents, including reviewers, with bounded contracts and exclusive files. Recovery starts from saved reports and source rather than chat memory or blindly restarting interrupted work.

The demonstrated value lies in concrete semantic connections: finite arithmetic to a uniform argument; counts to actual quotient dimensions; monomial irredundancy to a minimum over arbitrary polynomial generators; residue fibers to standard Tor; free A-ranks to finite K-dimensions; and numerical envelopes to actual lower examples. Each step closed a gap that a plausible explanation could otherwise conceal.

This is an auditable case study, not a controlled demonstration of AI efficiency or autonomous novelty. There was no randomized or matched control, complete resource ledger, or exclusion of related arguments from training data. Shared models, prompts, and training material can correlate reviewer errors; multiple approvals cannot be converted into statistical confidence. Claims about speedup, two-agent superiority, or general research effectiveness would need prospective records of task versions, tools, interventions, costs, failures, reuse, and semantic outcomes.

**R093, the factual human-contribution and responsibility record, remains pending.** It must distinguish log-supported facts, personal confirmation, and unknowns. Scholarly responsibility requires being able to explain the hypotheses, proof, Tor order and base rings, formalization boundary, and closest literature; it does not require personally writing every helper lemma. An upload command or a plausible contribution statement cannot supply that confirmation. Public evidence should use authorized artifacts, not private conversations or sensitive data.

The retrospective also exposed a management risk: completing the next numbered task can hide a changed research bottleneck. After v0.4, contribution positioning, readable proofs, responsibility, and independent reproduction mattered more than automatically extending infrastructure. The [publication note](PUBLICATION_STATUS.md) handles release and authorship responsibilities; the [future-work guide](FUTURE_WORK.md) keeps planned tasks separate from authorization.

## Reusable interfaces

The source is organized around actual objects. These groups allow a future authorized extension to reuse completed work without rebuilding the chain. File names below are under `lean/WidthBounds/`; exact endpoints and namespaces are in the [statement map](STATEMENT_MAP.md).

| Interface | Main modules and contract |
|---|---|
| Counts and quotient dimensions | `MonomialBasis`, `IdealBounds`, `Growth`, `LogGrowth`: actual bases, homogeneous images, full xy subspace, strict/harmonic/log bounds. No complete graded-quotient API is claimed. |
| Generators and fibers | `GeneratorExact`, `GeneratorNumberBounds`, `GeneratorQuotientBounds`, `GeneratorTensorFiber`, `VariableResidue`, `GeneratorTensorBounds`: minimal exponents, arbitrary-polynomial minimum, actual residue quotient and tensor. Monomial hypotheses remain essential. |
| Standard Tor-one | `DerivedKernel`, `TorOneBridge`, `TorOneBounds`: derived comparison, with ideal containment and factor order explicit. |
| Presentation and first relations | `FiniteMonomialPresentation`, `FinitePresentationBounds`, `MonomialRelationSpan`, `BoundarySyzygies`, `MonomialFirstSyzygies`: augmentation, neighbor relations, and whole-kernel generation, including nonhomogeneous polynomial vectors. |
| Third differential | `PolynomialPairRelation`, `BoundaryResolutionDegree`, `TriangularSecondSyzygies`, `BoundaryThirdDifferential`: divisibility, height corrections, entire kernel equality, and top injectivity. The lex instance supplies the helper assumptions. |
| Resolution and higher Tor | `FiniteThreeResolution`, `LexQuotientResolution`, `ResidueFreeDimension`, `MinimalResolutionTor`, `HigherTorBounds`: a general packager requiring exactness/injectivity and a concrete instance proving them. Residue tensor coordinates establish K-finiteness; finite free A-modules alone do not. |
| Extremal growth | `LowerConstruction`, `LowerProfile`, `LowerConstructionBounds`, `LogLower`, `LexGrowthTheta`: actual admissible ideals, an attained maximum, and standard Theta, without exact extremizers or semigroup lower bounds. |

The optional full-semigroup branch would need actual semigroup objects, regular-parameter and initial/lex comparisons, the correct budget cases, and reconciled Tor conventions. The [future-work guide](FUTURE_WORK.md) owns that sequence and other possible scopes. None begins automatically from this interface list. An honest, readable research artifact is a valid endpoint at the chosen boundary.
