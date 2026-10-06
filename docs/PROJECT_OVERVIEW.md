# Project overview: mathematics, history, and evidence

The project studies width bounds for Betti numbers of four-generator numerical semigroup rings, through a three-variable lex-ideal model. Its strongest machine-checked result is now about **actual finite-colength lex quotients and their standard Tor objects in every degree**. It also proves that the largest xy-section dimension in the specified lex budget class has growth $\Theta(w\log w)$. The full route from a numerical semigroup to that lex model remains a traditional mathematical argument, rather than an end-to-end Lean proof.

This English overview describes the completed R058/v0.4 mathematics and the later contribution review, proof narrative, public-repository work, and privacy audit through 2026-10-07. It is intended to be readable without the Chinese historical records. It synthesizes the [original project report](../research/PROJECT_REPORT.md) and [v0.4 retrospective](../research/PROJECT_RETROSPECTIVE_v0_4.md), which remain optional Chinese archives. It adds no theorem, experiment, compilation result, novelty certification, or authorship confirmation.

For the mathematics itself, read the [proof narrative](PROOF_NARRATIVE.md). Use the [statement map](STATEMENT_MAP.md) to inspect exact hypotheses and Lean declarations, [contributions](CONTRIBUTIONS.md) for the literature comparison, [reproducibility guide](REPRODUCIBILITY.md) for execution and evidence, and [publication status](PUBLICATION_STATUS.md) for release and responsibility boundaries. The [future-work guide](FUTURE_WORK.md) separates possible extensions from authorized work.

## 1. Starting problem and present result

Let $\Gamma=\langle g_0,g_1,g_2,g_3\rangle$ be a numerical semigroup with exactly these four minimal generators, ordered $0<g_0<g_1<g_2<g_3$. Its multiplicity is $m=g_0$ and width is $w=g_3-g_0$. Over an arbitrary field $K$, consider

$$
R=K[[ t^\Gamma]],\qquad
P=K[[ X_0,X_1,X_2,X_3]],
\qquad X_i\longmapsto t^{g_i}.
$$

The starting target is the width inequality for Betti numbers over the minimal regular presentation:

$$
b_i^P(R)=\dim_K\mathrm{Tor}_i^P(R,K)
\le i\binom{w+1}{i+1}\qquad(i\ge1).
$$

These are not the dimensions of $\mathrm{Tor}^R(K,K)$. Degree zero is excluded because $b_0=1$. Four distinct minimal generators force $w\ge3$. The ring is one-dimensional Cohen–Macaulay of codimension three, so classical algebra gives vanishing in degrees at least four; the substantive inequalities concern the first three positive degrees.

The starting literature is Caviglia–Moscariello–Sammartano (CMS), *Bounds for syzygies of monomial curves*, arXiv:2307.05770v2 / PAMS 152 (2024), 3665–3678. The inspected version proves the four-generator width bounds for $w\ge40$ and discusses the smaller range in Remark 5.2. Its lex reduction and cumulative-budget problem are prior work. The project's current positioning is a **candidate analytic strengthening in the three-variable case**, supported by a concrete formalization. Originality is unresolved; see the exact comparisons and unexcluded sources in [CONTRIBUTIONS](CONTRIBUTIONS.md).

The completed output has three distinct layers:

| Layer | What is established | Boundary |
|---|---|---|
| Traditional semigroup proof | The all-width inequality after cited algebraic reductions; the first bound is strict for $w\ge4$ | Internally checked with AI assistance; no external human peer review and no complete Lean semigroup bridge |
| Formal lex result | Actual quotient spaces, minimal generator numbers, a finite free resolution, standard Tor and actual K-dimensions, the strict first bound, and all positive-degree width inequalities | Exact hypotheses of the lex model remain necessary |
| Formal extremal result | A maximum section dimension is attained for $w\ge4$ and is standard $\Theta(w\log w)$ | An extremum over the lex budget class, not a matching semigroup lower bound |

## 2. The exact finite-colength lex model

Fix an arbitrary field $K$ and $A=K[x,y,z]$, represented in Lean by `MvPolynomial (Fin 3) K`. Let $S\subseteq\mathbb N^3$ be upward closed under coordinatewise order and lexicographic in each degree, with variable order $x>y>z$. The ideal

$$
I=\mathrm{monomialIdeal}(S)
=\langle x^iy^jz^k:(i,j,k)\in S\rangle
$$

is an actual `Ideal.span`, not a name attached to a counting function. Standard monomials are closed under divisibility and downward in same-degree lex order.

Let $Q_d(I)$ be the image of the degree-$d$ homogeneous polynomial subspace under the actual quotient map $A\to A/I$, and write $H_d=\dim_K Q_d(I)$. Let

$$
V_{xy}(I)=\mathrm{span}_K\{[x^iy^j]:i,j\in\mathbb N\}\subseteq A/I,
\qquad \ell=\dim_K V_{xy}(I).
$$

The definition of this subspace ranges over all natural-number exponents. Finite spanning and equality with the combinatorial `sectionLength` are proved later; the definition does not impose the desired truncation. Its traditional identification with $K[x,y]/(I\cap K[x,y])$ does not mean a separate quotient-ring isomorphism was added to the Lean library.

The final width and extremal theorems retain all of the following:

| Assumption | Meaning |
|---|---|
| Any field $K$ | Positive characteristic is allowed; real logarithms estimate dimensions and impose no characteristic-zero assumption on $K$. |
| Actual upward-closed lex monomial ideal | Monomial generation is part of the input, not inferred merely from a property of monomials contained in an arbitrary ideal. |
| Finite colength | An actual `Module.Finite K (A/I)` condition; a bare numerical `finrank` does not establish finite-dimensionality. |
| $x\notin I$ | In this lex setting there are no degree-one terms; it gives the first pure-$x$ forbidden exponent $a\ge2$ and yields $I\subseteq\mathfrak m$. |
| $w\ge4$ | The precise range of the abstract lex theorem. The original semigroup's $w=3$ branch is separate. |
| Every-degree cumulative budget | For **every** natural $d$, $\sum_{t=0}^{d}H_t\le1+dw$. A sampled range or a presumed column budget cannot replace this hypothesis. |

Here $a=\min\{r:x^r\in I\}$ and $\mathfrak m=(x,y,z)$. Some auxiliary results need less: the pure combinatorial bound does not require the entire three-variable quotient to be finite-dimensional; certain xy-section bounds require a nonzero ideal instead. The table describes the final finite-colength contract, not an assertion that every helper theorem has all of its hypotheses.

The class is not finite as a set of ideals. What becomes finite and bounded is the relevant set of natural-number section dimensions. This distinction matters both for extrema and for algorithm comparisons.

## 3. What the mathematics proves

### 3.1 Uniform strict and harmonic bounds

For the model above, let $n_i$ be the number of standard xy monomials in column $i$, for $0\le i<a$. Then $\ell=\sum_{i<a}n_i$. Lex order forces $i+n_i\le n_0$ and forces the three-variable triangle $j+k<n_i$ in that column to be standard. All these disjoint triangles lie within the budget through degree $n_0-1$, giving

$$
\sum_{i<a}\frac{n_i(n_i+1)}2\le1+(n_0-1)w.
$$

Complete standardness below the first forbidden degree also gives

$$
\binom{a+2}{3}\le1+(a-1)w,\qquad
a^2+4a+6\le6w,\qquad a\le w-2.
$$

Completing squares with the signed vector $v_0=2n_0+1-2w$, $v_i=2n_i+1$ for $i>0$, and applying Cauchy's inequality proves

$$
a+1+\ell<\binom{w+1}{2},\qquad
a+2\ell\le2\binom{w+1}{3},\qquad
\ell\le3\binom{w+1}{4}.
$$

The first coordinate may be negative; the proof does not add a false nonnegativity assumption. Column geometry, the terminal budget, the signed arithmetic, and the final combination are all formalized. The final theorem does not assume these intermediate conclusions.

A different use of the cumulative envelope gives, for the two-variable degree count $h_d$ and every $d\ge a$,

$$
(d-a+1)h_d<2w,\qquad
h_d\le\left\lfloor\frac{2w-1}{d-a+1}\right\rfloor.
$$

Proved truncation makes the ensuing sum finite. With $H_n=\sum_{r=1}^{n}1/r$,

$$
\ell\le3w+(2w-1)H_{2w-1}
\le3w+(2w-1)(1+\log(2w-1))
\le10w\log w\quad(w\ge4).
$$

The exact harmonic estimate and its comparison with the library's real logarithm are formalized. The constant 10 is sufficient, not proved optimal. The harmonic bound need not beat the strict binomial bound numerically at every small width. Its role is the stronger growth order, whose correct literature baseline includes CMS's $O(w^{3/2})$ estimate.

### 3.2 From generators to actual Tor

The minimal monomial boundary has three disjoint parts: $x^a$; the xy column ends $x^iy^{n_i}$; and the first forbidden z-lift $x^iy^jz^{t_{ij}}$ of each standard xy monomial. Finite colength supplies the pure-z threshold. The project proves that these are all minimal monomial generators and that there are exactly $a+1+\ell$ of them.

An irredundant monomial list alone would not prove minimality among arbitrary polynomial generating sets. The next step uses coefficients at all minimal exponents: multiplication by an arbitrary polynomial acts on those coefficients through its constant term. A surjection from the actual ideal to the finite coordinate space then forces any finite polynomial generating set to have at least that cardinality. The Lean result is an actual `IsLeast (generatorCardinalities I) (a+1+ell)` statement.

The coefficient map's kernel is proved to be the actual ideal product $\mathfrak m I$ inside $I$, yielding $I/\mathfrak m I\simeq_K K^E$ for the full minimal-exponent set $E$. Actual tensor and residue-field identifications then give

$$
(A/\mathfrak m)\otimes_A I\simeq_K I/\mathfrak m I,
\qquad A/\mathfrak m\simeq_K K.
$$

The tensor base ring remains $A$. The general Tor-one bridge explicitly assumes $I\subseteq\mathfrak m$ and connects the standard mathlib object to this tensor using an actual short exact sequence and projective resolution. It does not define “Tor” to be the desired dimension and does not assume $I$ projective.

The v0.4 extension constructs the actual exact augmented complex

$$
0\longrightarrow A^\ell\xrightarrow{d_3}A^{a+2\ell}
\xrightarrow{d_2}A^{a+1+\ell}\xrightarrow{d_1}A
\longrightarrow A/I\longrightarrow0.
$$

For $d_2$, common-degree monomial relations and canonical boundary-neighbor relations generate the **whole** kernel, including nonhomogeneous polynomial vectors. For $d_3$, lower-height corrections to triangular relation columns give kernel membership; top-row elimination proves both the entire kernel equality and injectivity. Merely checking consecutive composites vanish would not establish these facts.

The complex is packaged as mathlib's standard `ProjectiveResolution`, with the original quotient augmentation and actual zero terms in degrees at least four. All residue differentials are zero. Standard derived comparison identifies Tor with the homology of the residue-tensor complex, then with its terms. Tensor-basis coordinates and the actual residue-field identification prove K-finiteness before computing dimensions.

For

$$
T_i(I)=\mathrm{Tor}_i^A(A/\mathfrak m,A/I),
$$

the implementation **fixes the first factor $A/\mathfrak m$ and derives the second factor $A/I$**. Its K-action is restriction along $K\to A$, not a newly chosen action. Every $T_i$ is K-finite, and

$$
(\dim_K T_0,\dim_K T_1,\dim_K T_2,\dim_K T_3)
=(1,a+1+\ell,a+2\ell,\ell).
$$

Every $T_i$ with $i\ge4$ is an actual zero object. Combining these identities with the combinatorial results proves all positive-degree width inequalities and the strict first one. The project has not additionally formalized general Tor factor interchange or a full graded-shifts API.

The same formulas immediately give

$$
\begin{aligned}
\dim_K T_1&\le4w-1+(2w-1)H_{2w-1},\\
\dim_K T_2&\le7w-2+2(2w-1)H_{2w-1},\\
\dim_K T_3&\le3w+(2w-1)H_{2w-1}.
\end{aligned}
$$

These are direct mathematical compositions of accepted results. In particular, the second and third harmonic formulas are not advertised as newly compiled independent endpoints. Traditional comparison transfers them to the semigroup upper bounds; that corollary was available mathematically before v0.4 completed the lex-side Tor formalization.

### 3.3 Actual lower examples and an attained extremum

For each integer $s\ge2$, the explicit ideal

$$
I_s=(x^iy^jz^k:(i+1)(i+j+k+1)>s^2)
$$

is proved upward closed, lex, finite-colength, and standard in degree one, with initial exponent $a=s$. Its two-variable degree profile is

$$
h_d=\min\left(d+1,\left\lfloor\frac{s^2}{d+1}\right\rfloor\right).
$$

An explicit injection bounds the three-variable degree count by $s^2$. Together with $H_0=1$, this proves the budget in **every** degree: $\sum_{t=0}^{d}H_t\le1+ds^2$. Hence the same actual ideal is admissible whenever $w\ge s^2$. The exact section dimension and a finite harmonic lower bound are

$$
\ell_s=\sum_{i=0}^{s-1}\left(\left\lfloor\frac{s^2}{i+1}\right\rfloor-i\right),
\qquad s^2H_s\le\ell_s+\frac{s^2+s}{2}.
$$

For each $w\ge4$, the set of section dimensions attained by actual admissible ideals is nonempty (use $I_2$) and bounded. Its natural-number supremum is therefore a member of the set. The resulting maximum $M_K(w)$ is attained; this does not assert that each separate degree envelope can be simultaneously attained or identify a closed-form maximizing ideal.

For every $w\ge64$, taking $s=\lfloor\sqrt w\rfloor$ gives $s^2\le w<(s+1)^2$ and $w\le4s^2$, so the actual lower family works at all sufficiently large widths, not just squares. The formal result is

$$
\frac1{16}w\log w\le\ell_s\le M_K(w)\le10w\log w,
$$

and standard `Asymptotics.IsTheta` at `Filter.atTop`. The maximum function has a total definition on natural numbers, but maximum attainment is proved from $w=4$ and these two-sided bounds from $w=64$. Neither constants nor exact extremizers are proved optimal. Cross-field equality of maximum values is not a separate completed theorem. The lower family does not establish a semigroup lower bound.

## 4. Where the traditional semigroup bridge remains

The classical reduction uses the regular parameter $t^m$ and the Artinian quotient $R/(t^m)$ of length $m$. Reduction along the corresponding regular parameter preserves minimal-resolution ranks. Passing to lowest-degree initial forms, a Gröbner initial ideal, and a same-Hilbert-function lex ideal then gives the upper comparison

$$
b_i^P(R)\le b_i^A(A/L).
$$

The exactness is at the regular-parameter step; the project does not assert equality of Betti numbers for an arbitrary local ring and its tangent cone. The comparison uses the arbitrary-characteristic lex theorem and does not require an infinite field or a Cohen–Macaulay tangent cone. The resulting $A/L$ has length $m$ and degree-one dimension three.

CMS's budget theorem applies in the branch $w\le m-2$. The complementary branch $w\ge m-1$ instead uses total length: for $d\ge1$, $\mathrm{HS}(A/L,d)\le m\le w+1\le1+dw$, while degree zero is one. The semigroup branch $w=3$ has consecutive generators $m,m+1,m+2,m+3$ and uses existing arithmetic-sequence results, with localization/completion and minimality conditions retained.

These are cited and internally reviewed traditional arguments. The original numerical semigroup, its affine/local/complete models, the regular-parameter comparison, associated-graded and initial-ideal comparisons, lex Betti domination, and the special $w=3$ branch have not been assembled into a single Lean theorem from the original input. The current standard Tor order must also be reconciled explicitly with the order used in the original target. The optional Chinese [algebra-bridge audit](../research/algebra_bridge_audit.md) preserves the earlier checks; N9 in the English [proof narrative](PROOF_NARRATIVE.md) gives the current account.

## 5. How the project reached the present stage

Task IDs identify work contracts, not equal units of research progress or strict completion order. Dates below follow the recorded milestones; a later task number can support an earlier main task.

| Period / milestone | What changed | Accepted boundary |
|---|---|---|
| 2026-09-23, R001–R004 / v0.1 | Fixed the Python environment and Lean/mathlib 4.22.0. Python and independent integer checks produced 267 finite-parameter envelope certificates; Lean checked the small-width combinatorics. Classical reduction and the published large-width result produced the first report. | Finite certificates and traditional algebra were separate evidence. |
| R005 and R013 | Added immutable snapshots, per-file hashes, an atomic latest pointer, WIP marking, and queue validation; a worker without chat history successfully recovered the task from files. | Recoverability and auditability, not a theorem or guarantee of discovery. |
| R006–R016 / v0.2 | Replaced dependence on finite enumeration with the terminal triangular-column budget and signed Cauchy argument for every $w\ge4$. Built actual monomial-ideal interfaces and recorded bounded novelty checks. | The new declaration dependencies exclude the old finite certificate; novelty remained unresolved. |
| R017–R023 | Connected combinatorics to actual quotient bases and homogeneous images; established the harmonic upper bound; developed the lower family. A separate check examined 1,807 actual semigroups through the Apéry/Hilbert/lex path. | Finite experiments checked for errors; they did not prove the infinite transfer or all minimal relations. |
| R025–R033 | Constructed finite generators, proved the full minimal-monomial classification, and then proved minimality against arbitrary polynomial generating sets. | Exact cardinality is the true minimum, not just monomial irredundancy. |
| 2026-09-24–25, R034–R039 | Built the actual $I/\mathfrak m I$ quotient, residue tensor, and coefficient-field identification. Saved artifacts supported continuation after execution/review interruptions. | Tensor identifications were not described as Tor before the derived bridge existed. |
| 2026-09-26–29, R040–R043 | Corrected an assumed library API and constructed a usable projective resolution and standard Tor-one bridge. | Actual standard object, fixed factors and K-action; higher Tor was still pending then. |
| 2026-09-29, R024/R044–R048 / v0.3 | Completed the actual lower family, all-degree budget, logarithmic estimates, attained maximum, and standard Theta over all sufficiently large widths. R049–R051 organized and checked the frozen delivery. | Standard Tor-one plus the extremal chain; v0.3 did not yet contain the later high-degree formalization. |
| 2026-09-30, R054 | Audited the pinned library and chose to resolve the second factor $A/I$ directly. | The availability of a library comparison was not mistaken for possession of the required resolution. |
| R055 / C027 | Constructed $F_1\to A$, proved its image is $I$ and the quotient-map kernel, and identified the first rank. | No assertion that $F_1\to A$ is injective or its kernel free. |
| R056 / C028 | Constructed $d_2$ and proved it generates the whole first kernel; obtained rank $a+2\ell$. | Whole-kernel exactness, not merely $d_1d_2=0$. |
| R057 / C029 | Constructed corrected third-relation columns, proved full exactness and injectivity, and packaged the finite free residue-minimal resolution. | Residue minimality is proved; a full graded-shifts interface is not claimed. |
| 2026-10-01, R058 / C031 | Connected that resolution to standard Tor, actual K-finiteness, dimensions, higher zero objects, and all positive-degree width bounds. | Completed lex chain; no complete semigroup bridge or general factor interchange. |
| R059 / v0.4 | Performed an independent whole-chain semantic review, saved a new English manuscript/PDF, packaged a new archive, and verified it with an external receipt. | A frozen research delivery; no new proof build was claimed merely from rechecking bytes. |
| R086–R090, retrospective and planning | Reassessed the research value and chose contribution/proof/responsibility preparation ahead of automatically extending the semigroup infrastructure. | Plans and strategic judgments did not become new mathematics or automatic authorization. |
| R091 with R097–R099 | Completed two bounded literature/contribution rounds and an internal review; retained M1–M3/F1 candidate labels and U1–U5 unresolved items. | No originality certification, no algorithm execution, no access to White's full dissertation. |
| R092 with R100–R102 | Produced a self-contained N0–N9 proof narrative and precise statement map with internal reviews. | No new Lean build, mathematical expansion, or external peer review. |
| R103–R108 | Prepared public-repository wording and exclusions, initialized and checked a local Git payload, and fixed README formula rendering. The user set the remote and completed the initial push. | Public availability is a separate event from scholarly publication, licensing, or clean reproducibility. |
| R109–R111 | Audited the reachable text history and all four public project PDFs, and strengthened ignore rules. The review found no credentials or private material requiring removal in its inspected scope. | Normal Git identity was retained; no history rewrite or frozen PDF modification was required. |
| R112–R114, current documentation work | Added an English primary reading path while preserving Chinese historical sources and frozen mathematics. | Documentation improves accessibility; it does not count as mathematical progress or resolve authorship. |

The latest scientific baseline is R058/C031. v0.4 is the frozen research version; the Python package version `0.1.0` is a separate software metadata value. The older v0.1–v0.3 artifacts and their acceptance records retain their original meanings. Historical sentences such as “higher Tor is not yet formalized” describe their dates, not today's lex result.

## 6. Errors, counterexamples, and unsuccessful shortcuts

Several distinctions were established by concrete counterexamples or semantic checks, rather than by cosmetic changes to wording.

- **The budget does not imply finite colength.** The lex ideal $(x^2,xy,xz,y^2)$ has degree counts $1,3,2,2,\ldots$ and satisfies the $w=4$ cumulative bound, but every pure z power is standard and the quotient is infinite-dimensional.
- **The abstract $w=3$ theorem is false.** The ideal $(x^2,xy,xz)+(y,z)^3$ satisfies that budget and has column lengths $(3,1)$, yet $a+1+\ell=7>\binom42=6$. At $w=4$, $(x^2,xy,xz)+(y,z)^5$ attains $\binom52-1$, so a uniform improvement by two is impossible.
- **Fixed budget does not bound total quotient length.** The ideals $(x^2,xy,xz,y^2,yz,z^N)$ have length $N+2$. R091 later showed why this does not rule out existing fixed-parameter algorithms: truncation at degree $2w+1$ preserves the relevant section and Betti values while bounding length by $1+2w^2$.
- **A residue fiber need not equal the global minimum for arbitrary ideals.** For $I=(x-1,y)$, $\dim_K I/\mathfrak m I=1$ but the ideal needs two generators. The project's minimum formula keeps its monomial hypotheses.
- **The Tor-one bridge needs $I\subseteq\mathfrak m$.** At $I=A$, the residue tensor is one-dimensional while the quotient and its Tor-one are zero.
- **An upper comparison cannot carry a lower bound backward.** Large lex Betti numbers do not force large semigroup Betti numbers, even if the same Hilbert function is realized. A semigroup lower bound needs its own homological evidence or an equality mechanism.

These observations are recorded in the historical reports; their inclusion here does not claim new compiled special-case theorems. They also explain why formal verification alone is not enough: the chosen statement must represent the intended mathematical question.

Other difficulties were implementation issues, not refutations of mathematics. They included natural/integer casts in the signed argument, excessive simplification during scalar-instance search, an incorrect expectation about the pinned `ProjectiveResolution.of` API, a section assumption requiring explicit `include`, and transporting a zero object through restriction of scalars. Missing `.olean` files and console-encoding failures were separated from actual Lean proof failures. Development diagnostics were preserved, but final claims refer to completed successful logs rather than WIP output.

## 7. Evidence hierarchy and reproducibility

The project keeps six research statuses separate: conjecture or proposed route; finite experimental support; traditional proof reviewed internally; a specific compiled Lean theorem; literature-known mathematics; and unresolved novelty. Document checks, archive integrity, public availability, licensing, and author confirmation are further distinct statuses.

| Evidence | What it supports | What it does not establish |
|---|---|---|
| A successful Lean build of named declarations | Kernel checking of the stated formal propositions with their actual dependencies | The correctness of every informal interpretation, originality, human understanding, or the unformalized semigroup bridge |
| Declaration-level dependency and axiom audit | Which constants and foundational axioms the inspected results use | A proof of novelty or general reliability of all AI work |
| Internal mathematical/semantic review | A second examination of hypotheses, object identity, proof scope, and evidence | External human peer review; independent agents may have correlated errors |
| A finite experiment | The tested cases and specified implementation checks | A universal theorem or exhaustive literature exclusion |
| Source/log hashes and archive receipts | Byte correspondence and recoverable delivery | A new compilation, author identity authentication, or third-party reproduction |
| A public Git repository | Availability of the published payload | A selected license, journal acceptance, a verified root CI workflow, or a clean build |

The scientific build log is [lean_higher_tor_build.txt](../results/lean_higher_tor_build.txt), SHA-256:

```text
29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4
```

R058 records an actual `lake build` exit code of zero with no errors or warnings. Sixteen new named axiom reports contain only `propext`, `Classical.choice`, and `Quot.sound`; seventeen new declaration dependency roots exclude the old finite/small-width certificates and `sorryAx`. The fixed mathlib commit is `79e94a093aff4a60fb1b1f92d9681e407124c2ca`, with Lean/mathlib 4.22.0. Project policy prohibits `sorry`, `admit`, custom axioms, and `native_decide`. Text scans assist the audit; they do not replace the actual build and dependency reports.

This was a unified **incremental build with cached dependency replay**, not a clean rebuild. The source hashes and validation fields are in [r058_validation.json](../results/r058_validation.json); [claims.json](../research/claims.json) indexes the claims and their evidence. Rechecking their hashes does not rerun Lean. If a proof changes, the old log is no longer evidence for the modified source.

The frozen v0.4 ZIP hash is `ed74ee6c46ed160fd4b00f074de9c1e8c833f9a0b91a5bd96f29b36f1ede2285`. Its source checkpoint and scientific checkpoint are different records: `20261001T095721013368Z-b002439c` packages the delivery; `20261001T090243180713Z-07071c19` is the scientific baseline. The external receipt avoids circularly placing an archive's own hash inside its source payload. A public Git clone intentionally excludes local checkpoints, old ZIPs/receipts, caches, temporary files, and downloaded third-party full texts. Missing those local archives is not a mathematical failure.

R095's independent clean-environment reproduction remains pending. The existing package integrity checks and incremental build do not satisfy it. Follow the English [reproducibility guide](REPRODUCIBILITY.md), which distinguishes the public-clone path from local archival recovery.

## 8. Human–AI workflow, meaning, and limitations

The recorded human role includes selecting the problem and scope, authorizing continuation or stopping, choosing freezes, and setting collaboration constraints. Agents performed substantial literature retrieval, derivation organization, proof implementation, documentation, and internal review. The records do not yet determine who first originated every mathematical idea, which steps were independently re-proved by a human, or who can presently take responsibility for the full proof. Those facts must not be invented from a user's authorization to continue.

The practical workflow was deliberately persistent. `STATE.md`, `HANDOFF.md`, and `queue.json` preserve current status and exact ownership; task reports preserve detailed results; `claims.json` connects conclusions to source/log hashes; checkpoints preserve resumable bytes. The root agent integrates and checks results. At most two child agents, including reviewers, work concurrently, without further delegation. Workers receive bounded contracts and exclusive files. After interruptions, the project checks saved reports and source before continuing, instead of discarding an apparently abandoned task or trusting chat memory.

The strongest demonstrated value of this workflow is the sequence of semantic connections: finite arithmetic to a uniform proof; counts to actual quotient spaces; monomial irredundancy to a true minimum over all polynomial generators; a residue fiber to standard Tor; free A-ranks to actual finite K-dimensions; and upper envelopes to realizable lower examples. Those are concrete checks against plausible but incomplete explanations.

The project is also an auditable case study of AI-assisted mathematics. It is **not evidence of a proven AI efficiency advantage**, an autonomous discovery of new mathematics, a quantified speedup over mathematicians, superiority of two agents over one, or general effectiveness on arbitrary research problems. There was no randomized or matched control, complete resource ledger, or exclusion of related arguments from model training data. Internal reviewers may share models, training material, prompts, and failure modes; their acceptance reports cannot be multiplied into a statistical confidence level.

Future methodological claims would require prospective records: fixed task statements and versions, actual model/tool configuration, human interventions, time and resource use, failures, prior-solution reuse, and semantic outcomes. A successful historical path cannot be retroactively converted into a controlled experiment. Public evidence should be authorized task records and artifacts, not private conversations or sensitive data.

R093 is the planned factual contribution and responsibility record. It is still pending and must distinguish **supported by logs**, **confirmed by the person**, and **unknown**. A plausible contribution statement is not a substitute for actual confirmation. Someone intending to take scholarly responsibility should be able to explain the hypotheses, proof, Tor order and base rings, formalization boundary, and closest literature without having an assistant answer on their behalf. This does not require personally writing every Lean helper lemma.

The retrospective also identified a management risk: completing the next numbered task can conceal that the research bottleneck has changed. After v0.4, contribution positioning, readable proofs, human responsibility, and independent reproducibility were more pressing than automatically building the remaining semigroup infrastructure. More tasks or code do not automatically yield more mathematical knowledge or a publishable contribution.

## 9. Public availability and scholarly status

The user completed the initial push to the [research repository](https://github.com/wytyKen/ai4math-width-bounds) as part of the public-release work. R091 and R092 give readers a contribution comparison and a proof/code map. English documentation now provides a primary route through those results while retaining the Chinese records as optional archives. The translation did not inspect remote visibility or CI. Making the repository available does not certify novelty, determine authorship, or amount to a journal submission or acceptance.

The content-privacy audit covered three reachable commits' text and four public project PDFs, totaling 29 pages, at its recorded time. No credentials or private materials requiring removal were found in that scope. The ignore rules were strengthened; ordinary Git name/email information was intentionally retained. This is a bounded audit of the inspected payload, not a perpetual guarantee about future commits. Ignore rules do not retroactively remove tracked content or history.

The project has no confirmed human responsibility record from R093, no completed clean reproduction from R095, and no external human peer review. The user deferred external expert review; that choice does not prevent honest local documentation or technical delivery, and it must not be rewritten as a completed review. A license or authorship commitment has not been selected on the user's behalf. See [publication status](PUBLICATION_STATUS.md) for the current distinction between repository release, research report, preprint, journal/conference submission, and upstream software contribution.

The v0.4 PDF is a frozen stage-delivery report. It should not be treated as automatically ready for a chosen venue merely because its local mathematical chain is complete. A future mathematical paper would emphasize the precise candidate increment and self-contained proof; a formalization paper would need clear design insight, comparison, and reuse; a collaboration paper would need claims supported by suitable records or experiments. These are alternative purposes, not three automatically warranted publications.

## 10. Interfaces for a future extension

The formal source is organized around actual objects, allowing a future authorized extension to reuse completed work without repeating it.

| Interface group | Main files under `lean/WidthBounds/` | Contract and limit |
|---|---|---|
| Counts and actual quotient dimensions | `MonomialBasis`, `IdealBounds`, `Growth`, `LogGrowth` | Standard bases, homogeneous-image dimensions, the full xy subspace, and strict/harmonic/log bounds; no complete graded-quotient API is claimed. |
| Actual minimal generators and fibers | `GeneratorExact`, `GeneratorNumberBounds`, `GeneratorQuotientBounds`, `GeneratorTensorFiber`, `VariableResidue`, `GeneratorTensorBounds` | Exact minimal exponents, arbitrary-polynomial minimum, actual $I/\mathfrak mI$ and residue tensor; minimum formulas retain monomial hypotheses. |
| Standard Tor-one | `DerivedKernel`, `TorOneBridge`, `TorOneBounds` | Actual derived comparison with $I\subseteq\mathfrak m$ and fixed factor order. |
| Finite presentation and first relations | `FiniteMonomialPresentation`, `FinitePresentationBounds`, `MonomialRelationSpan`, `BoundarySyzygies`, `MonomialFirstSyzygies` | Actual span, augmentation kernel, neighbor relations, and full first-kernel generation. |
| Concrete third differential | `PolynomialPairRelation`, `BoundaryResolutionDegree`, `TriangularSecondSyzygies`, `BoundaryThirdDifferential` | Divisibility, height control, correction columns, whole-kernel equality, and top injectivity; the final lex construction supplies helper assumptions. |
| Resolution and all Tor degrees | `FiniteThreeResolution`, `LexQuotientResolution`, `ResidueFreeDimension`, `MinimalResolutionTor`, `HigherTorBounds` | The general packager needs exactness/injectivity input; the concrete lex instance proves it. Actual K-finiteness follows from residue tensor coordinates, not from free A-modules being K-finite. |
| Actual extremal growth | `LowerConstruction`, `LowerProfile`, `LowerConstructionBounds`, `LogLower`, `LexGrowthTheta` | Explicit admissible ideals, attained maximum, and standard Theta; no semigroup lower bound or exact maximizing family. |

The exact namespaces and endpoints are in [STATEMENT_MAP](STATEMENT_MAP.md). In particular, homological/scalar bridges use `WidthBounds.MonomialInterface`, the concrete resolution and higher bounds use `WidthBounds.MonomialPresentation`, and the finite packager uses `WidthBounds.FiniteThreeResolution`. A report abbreviation never licenses dropping a source declaration's hypotheses.

The remaining full-semigroup route is a separate scope: first agree on actual affine/local/complete objects and Tor conventions (R060); then Apéry bases and length (R061), all-degree filtration budgets (R062), regular-parameter and flat comparisons (R063), associated-graded/initial-ideal comparison (R064), and arbitrary-characteristic lex domination (R065); finally handle boundary branches and assemble the original-input theorem (R066–R067). The comparison infrastructure is a substantial cost uncertainty. A preliminary interface audit would be a finite decision task, not authorization to execute the whole sequence.

Other possible scopes include exact extrema or constants, cross-field independence, actual semigroup lower bounds, focused library extraction, or maintenance on a new toolchain. They remain options, not ready tasks. The current preparation path instead leaves R093 next, with R094–R096 and the old R060–R067 parked. New work requires a chosen scope; frozen v0.4 and earlier artifacts are preserved, and a future milestone receives its own version and evidence.

An adequate endpoint is an honest, readable, auditable research artifact. The project need not clear every possible extension to be complete at its chosen boundary, and a documentation translation does not reopen mathematical research.
