# Contributions and literature comparison

This is the full English counterpart of the [original Chinese R091 comparison](../research/publication/CONTRIBUTION_MAP.md), whose literature-check date is **2026-10-03**. Two bounded rounds of checking were completed. This document identifies contributions and literature coverage; it does not certify originality, add mathematics, or rewrite frozen manuscripts. The English edition was prepared on 2026-10-07 without a new literature search.

**Reading the dates:** R091 originally stopped before R092. R092's proof narrative and statement mapping have since been completed; see the English [proof narrative](PROOF_NARRATIVE.md) and [statement map](STATEMENT_MAP.md). R093's factual human-contribution and responsibility record remains pending. Statements below about what “this review” did refer to R091, not to a new search or verification during translation.

## Main assessment

**The best-supported current description is “a candidate analytic strengthening of the CMS three-variable cumulative-budget problem, with a formal implementation of standard Tor for actual lex quotients.” This review neither certified originality nor found a theorem in the material read that eliminates every candidate increment.** A mathematical manuscript remains a reasonable candidate, provided known formulas, standard library tools, and immediate corollaries are separated from any claim of priority.

| Candidate | Locally accepted content | Closest baseline and current assessment |
|---|---|---|
| M1: strict bounds for all widths | Three lex bounds and standard Tor for $w\ge4$; the original semigroup application remains at the traditional proof layer | CMS covers non-strict bounds for $w\ge40$. A uniform analytic strict strengthening remains a candidate contribution, not confirmed priority. |
| M2: harmonic upper bound | An explicit harmonic bound for $\ell$, combined with the three formulas to give three $O(w\log w)$ bounds | The correct baseline includes CMS's $O(w^{3/2})$ estimate. The semigroup version is a traditional corollary, not an independent discovery. |
| M3: growth of an actual extremum | Existence of a maximum section dimension in the same lex budget class, an actual lower-bound family, and standard Theta | The candidate content is the uniform analytic order and a feasible lower construction. Divisor counting and taking a maximum of a bounded subset of natural numbers are not new methods. |
| F1: formalization design | A concrete boundary resolution, full-kernel and injectivity proofs, standard Tor, and actual K-dimension calculations | The formulas are classically known and many interfaces reuse mathlib. The integrated implementation has value, but “first formalization” has not been established. |

Two limitations must remain visible. White's highly relevant 2021 dissertation was not obtained in full. White's 2020 algorithm, together with truncation, already supplies a route to optimization at fixed $w$; it is incorrect to say that existing algorithms are wholly inapplicable or that this project first made the extremum computable. The comparison across proof assistants is also incomplete, so an unsuccessful keyword search cannot support a worldwide priority claim.

R091 recommended that an authorized R092 organize an internal proof narrative using “the bounds/implementation proved here,” rather than “the first,” “for the first time,” or “a complete solution of the general problem.” The human-responsibility record in R093 is a separate task requiring its own factual inputs. R091 itself stopped after this comparison.

## The comparison contract

Let $K$ be any field, $A=K[x,y,z]$, and $\mathfrak m=(x,y,z)$. The common class $\mathcal C(K,w)$ consists of actual finite-colength lex monomial ideals $I$ with $x\notin I$, $w\ge4$, and, for every $d\in\mathbb N$,

$$
\sum_{t=0}^{d}\dim_K Q_t(I)\le1+dw.
$$

Here $Q_t(I)$ is the image of homogeneous polynomials of degree $t$ in the actual quotient $A/I$. For a lex monomial ideal, $x$ being standard is equivalent to the absence of degree-one monomials, agreeing with the traditional assumption $I\subseteq\mathfrak m^2$. Finite colength cannot be deduced from the budget. For this abstract class, $w$ is a budget parameter; it need not be the difference between extremal minimal generators of a numerical semigroup.

Write $a=\min\{r:x^r\in I\}\ge2$ and $\ell=\dim_K\mathrm{xySubspace}(I)$. Under the traditional monomial-basis identification, $\ell$ is also the K-dimension of $K[x,y]/(I\cap K[x,y])$ or $A/(I+(z))$. The Lean endpoint is the actual `xySubspace` inside the quotient. This review does not claim a newly constructed two-variable quotient-ring isomorphism. Set

$$
b_i(I)=\dim_K\mathrm{Tor}_i^A(A/\mathfrak m,A/I),
$$

with the K-action obtained by restriction along the original `algebraMap`. If a source writes $\beta_j(I)$ for the ideal as a module, its corresponding quotient invariant here is $b_{j+1}$. The index shift must be retained.

The semigroup objects are separately denoted $R=K[[ t^\Gamma]]$ and $P=K[[ X_0,X_1,X_2,X_3]]$. The numerical semigroup $\Gamma$ has exactly four minimal generators $g_0<g_1<g_2<g_3$, and width $w=g_3-g_0$. A reviewed traditional comparison bounds $\beta_i^P(R)$ by $b_i$ for a suitable ideal in $\mathcal C(K,w)$ when $w\ge4$. The consecutive-generator branch $w=3$ is treated separately by traditional results. This is not the current end-to-end Lean theorem, and a lex lower bound cannot be transported backward to a semigroup lower bound.

## Precise statements and local evidence

### M1: strict binomial bounds for all widths

For every $I\in\mathcal C(K,w)$,

$$
b_1(I)<\binom{w+1}{2},\qquad
b_2(I)\le2\binom{w+1}{3},\qquad
b_3(I)\le3\binom{w+1}{4}.
$$

Standard Tor is an actual zero object in every degree $i\ge4$. Consequently, $b_i(I)\le i\binom{w+1}{i+1}$ for every $i\ge1$. Since dimensions are natural numbers, the first strict bound means at most $\binom{w+1}{2}-1$. The current Lean entry points are `finiteColength_higherTor_width_bounds` and `finiteColength_tor_all_positive_bounds` in [HigherTorBounds](../lean/WidthBounds/HigherTorBounds.lean). C031 has accepted build and semantic evidence; R091 did not rebuild it.

The all-width result for the original semigroup is an application after traditional transfer. That application does not remove the abstract lex model's $w\ge4$ assumption. M1 must be compared with CMS's exact range and strictness, rather than with its title alone.

### M2: harmonic upper bounds and the semigroup corollary

The existing section bound is $\ell\le3w+(2w-1)H_{2w-1}$, and $a\le w-2$. The standard three formulas give the componentwise corollaries

$$
\begin{aligned}
b_1&\le4w-1+(2w-1)H_{2w-1},\\
b_2&\le7w-2+2(2w-1)H_{2w-1},\\
b_3&\le3w+(2w-1)H_{2w-1}.
\end{aligned}
$$

Thus each of the three fixed positive degrees is $O(w\log w)$. The traditional comparison also makes these upper bounds for $\beta_i^P(R)$ of a four-generator semigroup. These three displayed inequalities organize immediate consequences of existing results; they are not all claimed as separately registered, newly compiled Lean endpoints. The section harmonic bound and the $b_1$ interface are formalized, as are the actual higher-dimensional formulas. The traditional semigroup $O(w\log w)$ corollary was mathematically available as soon as the harmonic bound and traditional formulas were available; v0.4 was not the first point at which that corollary became true.

Local entry points are [Growth](../lean/WidthBounds/Growth.lean), [GeneratorNumberBounds](../lean/WidthBounds/GeneratorNumberBounds.lean), [LogGrowth](../lean/WidthBounds/LogGrowth.lean), and [HigherTorBounds](../lean/WidthBounds/HigherTorBounds.lean). The relevant comparison includes the existing $O(w^{3/2})$ route. For small $w$, the harmonic formula need not be numerically tighter; M1 and M2 can be used together.

### M3: Theta growth in the actual lex budget class

Let $M_K(w)$ be the largest value of $\ell$ in the same class $\mathcal C(K,w)$. Existing formal proofs establish that for $w\ge4$ the class is nonempty, its natural-number values are bounded, and its maximum is attained. For $w\ge64$,

$$
\frac{w\log w}{16}\le M_K(w)\le10w\log w,
$$

and this is connected to standard `Asymptotics.IsTheta`. Existence of an ideal attaining the maximum does not identify an explicit maximizing ideal. The lower bound uses an explicit family, which is not claimed to be an exact maximizer for every $w$.

The family is

$$
I_s=(x^iy^jz^k:(i+1)(i+j+k+1)>s^2),\qquad s\ge2.
$$

The actual upper-set and lex properties, finite colength, standardness of $x$, and budget in every degree are proved. If $s^2\le w$, the ideal belongs to the same budget class. Its section dimension is

$$
\ell_s=\sum_{i<s}\left(\left\lfloor\frac{s^2}{i+1}\right\rfloor-i\right).
$$

Choosing $s=\lfloor\sqrt w\rfloor$ covers all sufficiently large widths. Traditional divisor counting gives $\ell_s=(D(s^2)+s)/2$, where $D(n)=\sum_{r=1}^{n}\lfloor n/r\rfloor$ is the divisor summatory function. This is an application of known arithmetic; neither the divisor sum nor its classical asymptotic is presented as original.

Local entry points are [LowerConstructionBounds](../lean/WidthBounds/LowerConstructionBounds.lean), [LogLower](../lean/WidthBounds/LogLower.lean), and [LexGrowthTheta](../lean/WidthBounds/LexGrowthTheta.lean), corresponding to C022/C023. The standard `IsTheta` endpoint concerns the maximum section dimension. It is not a newly defined collection of all Betti-extremum functions, a semigroup lower bound, or a result for arbitrary numbers of variables.

### F1: a concrete resolution connected to standard Tor

The project constructs actual modules $F_1,F_2,F_3$, proves $\mathrm{range}(d_2)=\ker(d_1)$ and $\mathrm{range}(d_3)=\ker(d_2)$, and proves $d_3$ injective. The augmentation to the original quotient is a quasi-isomorphism. All terms are finite free, and terms from degree four onward are zero. All differentials vanish modulo $\mathfrak m$. Standard derived comparison from mathlib, homology of a zero-differential complex, and actual tensor-basis coordinates then give standard Tor, its K-dimensions, and higher-degree `IsZero`.

The precise increment is the formalization of this concrete instance and the combination of its interfaces. It is not the invention of lex Betti formulas, projective resolutions, Tor, or change of scalars. R098 itemizes candidate reuse value and the traditional/library sources. R091 does not certify a worldwide first formalization or a new general homological framework.

## Direct mathematical baselines

### CMS supplies the problem and key existing tools

[CMS v2](https://arxiv.org/html/2307.05770v2), dated 2024-07-20, uses the same all-degree budget in Problem 4.1, with a general number of variables. This project handles three variables with no degree-one terms. Equation (7) in the proof of Lemma 4.2 already gives the section formulas for Betti numbers of lex ideals; quotient-ring indices must be shifted by one. Theorem 5.1 gives the non-strict bounds for $w\ge40$, and Remark 5.2 discusses $4\le w\le39$. The estimate in Section 5, equation (19), already belongs to an $O(w^{3/2})$ route. The problem setting, lex comparison, three formulas, and direction of using more degrees of the budget are therefore not original contributions of this project.

This comparison supports a substantive difference between M1/M2 and the text inspected. It does not prove that no other literature or further consequence of an old method covers them. In particular, strictness for larger widths may follow from further use of existing estimates. The comparable candidate contribution is the uniform analytic argument and its full range, rather than a claim that every strict inequality at every width was previously unknown.

R091 read the relevant definitions, Section 4 formulas, and Section 5 argument. It also checked [survey v3](https://arxiv.org/html/2406.00790v3), dated 2026-09-28: Theorem 9 still states the embedding-dimension-four result for $w\ge40$. This is a comparison point, not evidence that anything omitted from the survey does not exist.

### Fixed-colength extrema do not automatically preserve the cumulative budget

[Caviglia–Sammartano v3](https://arxiv.org/html/1903.08770v3), dated 2023-01-06, Theorem 3.7 gives a Betti extremum $C(d)$ for a fixed number of points $d$ in a fixed Clements–Lindström ring. [Moscariello–Sammartano v1](https://arxiv.org/html/2405.19810v1), Theorem 2.2, restates Valla's bound at fixed colength, while Proposition 2.5 compares sections. These are relevant tools and should not be omitted merely because the parameters differ. Their maximizing objects, however, do not automatically satisfy the present budget in every degree.

A simple applicability check illustrates the issue. At $w=4$, the ideal $I_{18}=(x^2,xy,xz,y^2,yz,z^{18})$ has length 20 and satisfies the budget. The compressed ideal $\mathfrak m^4$ of the same length has cumulative dimension 10 at $d=2$, exceeding $1+2w=9$. It is therefore invalid to replace an ideal by a fixed-length maximizer and assert that the budget is preserved. This is an elementary comparison of applicability conditions, not a new Lean result or experiment.

Versions must be distinguished. Caviglia–Sammartano [v1](https://arxiv.org/html/1903.08770v1), dated 2019-03-20, uses `Exp(p)` for a general Hilbert polynomial in Theorem 4.3. The corresponding point-count result in the final v3 is Theorem 3.7/$C(d)$; the title did not change. Terminology and numbering from the early version must not be attached to the final version, and the reason for the change is not inferred. R091 also followed the introductory theorems and relevant proof locations of the [original Caviglia–Murai journal paper](https://msp.org/ant/2013/7-5/ant-v7-n5-p01-p.pdf). It concerns saturated extrema at fixed Hilbert polynomial, rather than a uniform harmonic conclusion in the present parameter $w$.

## White's algorithm: overlap cannot simply be excluded

Definition 1.3 of [White 2020 v1](https://arxiv.org/html/2011.03401v1) permits constraints on a Hilbert function $h$ and its difference $\Delta h$, requiring the tail bounds to agree, $G=F$. The relevant procedure is Algorithm 3.2 (**Complete**), which retains the upper bounds. It can fix one homological degree $q$ and maximize the total Betti number in that degree. Optimizing each coordinate separately, finding all maximal vectors, and maximizing the sum of Betti numbers are different problems and must not be conflated; the software also provides corresponding variants. R091 did not run the software or audit its implementation.

### An applicability observation

The following is a short comparison argument made in R091 about existing results. It is not a width theorem already stated by White, and it is not a newly compiled conclusion.

Adjoin a free variable: $B=A[t]$ and $J=IB$. Then $J$ is saturated and $\mathrm{HF}(B/J,d)=\mathrm{HS}(A/I,d)$. Adjoining the variable preserves Betti numbers. Slices with fixed eventual length can therefore be expressed through constraints on $h$ and $\Delta h$. Dismissing the work because it studies saturated ideals is incorrect.

The length of the original ideal really can be unbounded at fixed $w$: for $N\ge2$,

$$
I_N=(x^2,xy,xz,y^2,yz,z^N)
$$

has length $N+2$ and satisfies the budget for $w\ge3$. However, CMS already bounds the least forbidden pure-$y$ exponent by $\beta\le2w+1$. Take $D=2w+1$ and $L'=L+\mathfrak m^D$. The xy section was already zero in all total degrees at least $D$, so $L'$ and $L$ have the same xy section, $a$, and $\ell$. Both remain lex, the Hilbert–Samuel function only decreases, and the known three formulas give the same total Betti numbers. All degrees at least $D$ of $A/L'$ vanish; hence

$$
\mathrm{length}(A/L')
=\mathrm{HS}(A/L',D-1)
\le1+w(D-1)=1+2w^2.
$$

This provides a finite-length/tail optimization route at fixed $w$, correcting the inference that unbounded original length necessarily rules out the old algorithm. In this three-variable quotient model, White's ideal-Betti objective at fixed $q=2$ corresponds to $b_3=\ell$, while $q=0$ corresponds to $b_1$. It remains necessary to encode $G,F,g,f$, the no-degree-one condition, and the tail data precisely; establish the correspondence between legal functions and the target class; translate the coordinate objectives and reference constants; and actually reproduce the algorithm. **R091 confirmed only this connection. It did not execute the optimization, output an extremum at any fixed $w$, or produce a new finite certificate.**

Computability at finite parameters is not the same as an existing analytic proof for all $w$ or an asymptotic analysis. The remaining M2/M3 candidates are the explicit harmonic estimate, an actual lower-bound family satisfying every budget, and the matching growth order. Existence or computability of a maximum should not be packaged as the main new contribution. Further exclusion must concern existing analytic estimates for the old framework or its objective function, rather than merely whether a paper's title includes “log.”

### A highly relevant full text remains unavailable

White's 2021 dissertation is recorded in the [university's original repository](https://uknowledge.uky.edu/math_etds/81/), DOI 10.13023/etd.2021.187, as *Maximums of Total Betti Numbers in Hilbert Families*. Its abstract describes more general families of Hilbert functions, algorithms, and some situations guaranteeing a common maximum. The [author's institutional record](https://digitalcollections.dordt.edu/faculty_work/1439/) ultimately links to the same full text. Download attempts returned 403; only metadata and the abstract were read.

This is an explicit unresolved source. It cannot be assumed to be merely a reprint of the 2020 paper, and the absence of “log” from an abstract cannot exclude coverage. The bounded R091 task can be complete while publication-level “first” language remains unjustified until this source and other necessary leads are obtained and compared. R091 did not contact the author or bypass access restrictions.

## Scope of recent semigroup sources

R091 checked the family definition and Corollary 4.8 in [2507.11738v3](https://arxiv.org/html/2507.11738v3). The objects are specific Sally-type families $S^e(m,n)$, and the conclusion concerns the minimal number of generators of the defining ideal / the first-Betti width bound. It also checked the abstract, introduction, resolution construction, and relevant theorem/conjecture locations in Sections 3 and 6 of [2609.26752v1](https://arxiv.org/html/2609.26752v1), dated 2026-09-22. That work gives explicit Betti calculations for two Sally-type families and related questions. These deserve inclusion as neighboring work, but the statements read are not the all-width harmonic conclusion for arbitrary four-generator semigroups. R091 did not exclude every potential consequence page by page.

The [author's research directory](https://sites.google.com/site/alessiosammartano/research) served as navigation, not as a substitute for a complete citation network. Public arXiv version information, a theorem's actual scope, and an unsuccessful search are three different kinds of evidence.

## Actual boundaries of the formal contribution

[CMS equation (7)](https://arxiv.org/html/2307.05770v2#S4) and classical stable-ideal theory already explain the four ranks. The original Eliahou–Kervaire paper, *Minimal resolutions of some monomial ideals* (1990, [DOI](https://doi.org/10.1016/0021-8693(90)90237-I)), was not obtained in full during this review. R098 read other primary papers using the EK generator formula, which supports the classification as known mathematics, but did not compare each local $d_3$ entry with the EK matrices. This project therefore claims neither new Betti formulas, a completed formalization of the general EK theorem, nor a chain isomorphism between the two constructions.

| Implementation component | Relation to existing tools | Appropriate contribution description |
|---|---|---|
| Standard Tor and derived comparison using $P$ | Direct reuse of mathlib `CategoryTheory.Tor` and `P.isoLeftDerivedObj` | An instantiation of existing standard objects, not an invention of Tor theory |
| Zero-differential homology and restriction to K-scalars | `HomologyData.ofZeros` and `restrictScalars.mapIso` already exist | An auditable composition of isomorphisms with scalar compatibility |
| Actual K-dimension of the residue tensor | Tensor-basis coordinates and Finsupp equivalences already exist; the project supplies the actual $\mathfrak m$-residue-field identification and specialized interfaces | Integration of actual objects, still specialized to $K[x,y,z]$, not a theorem for every local ring |
| Packaging a standard length-three resolution | Works over an arbitrary commutative ring, given exactness of the three specified arrows and injectivity at the top, with actual target $A/I$ | A useful finite packager; it does not prove arbitrary matrices exact or provide an arbitrary-length framework |
| Concrete third-relation columns for lex boundaries | Actual proofs of lower support, coefficients in $\mathfrak m$, kernel membership, the full kernel, and injectivity | A candidate contribution in proof organization; it uses proved existence and `Classical.choose`, not a claimed canonical executable matrix algorithm |

Pinned library sources are the [Tor definition](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/CategoryTheory/Monoidal/Tor.lean), [derived comparison](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/CategoryTheory/Abelian/LeftDerived.lean), and [tensor-basis coordinates](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/LinearAlgebra/TensorProduct/Basis.lean). Exact local endpoints, pinned library line references, and limits on generality are in the optional Chinese audit [R098](../research/tasks/R098_formal_contribution_audit.md). Innovation is not assessed by counting wrapper files.

### Neighboring formalizations must remain in view

The [Isabelle AFP Gröbner Bases entry](https://isa-afp.org/entries/Groebner_Bases.html), specifically its [Syzygy source](https://isa-afp.org/browser_info/current/AFP/Groebner_Bases/Syzygy.html), already has endpoints for actual syzygy modules and extracting their Gröbner bases, permitting iterated relation calculations. This rules out claiming a first formalization of syzygies. The inspected endpoints did not directly supply the present lex ranks or standard Tor/K-dimensions, but not all downstream material was audited to exclude coverage by combination.

AxiomMath's [original Fel project](https://github.com/AxiomMath/fel-polynomial) is relevant existing Lean work. The root agent additionally read definitions and final theorems in its [problem](https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/problem.lean) and [solution](https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/solution.lean) files. The inspected endpoints concern numerical-semigroup gaps, Hilbert numerators, and formal-power-series coefficient identities; a title containing “syzygies” does not identify them with this project's actual standard Tor chain. The problem file is a problem template, so placeholders there cannot be used to discredit the solution. R091 did not compile that project locally, pin its commit, or audit all accompanying material. Toolchain displays differed across cached/versioned pages, so version numbers cannot be used to exclude overlap.

Another author's project website described a Tor-one example based on supplied resolution/bridge data, but its source repository was not audited. It remains an unverified lead, documented in R098. A bounded cross-library search supports only “no project with an individually verified matching contract was found,” not “world first” or an assertion that other libraries lack comparable capabilities.

## Unresolved items and future wording

| Item | Still needed | Consequence for the assessment |
|---|---|---|
| U1: White's dissertation | Relevant full-text theorems and their relation to the 2020 algorithm and this class | Mathematical priority remains unsettled; access failure is not exclusion. |
| U2: old algorithms and analytic optimization | Precise encoding, legal-object correspondence, coordinate-objective translation, software verification, or existing analytic results | No claim of first computability; a possible algorithmic route has not been represented as an already proved all-width bound. |
| U3: variants of existing extremal/lower constructions | Isomorphic constructions under other terminology, related citations, and finer combinations of fixed-length tools | The explicit harmonic/Theta results remain candidates, not the product of a field-wide novelty certification. |
| U4: identity with traditional resolution methods | Exact comparison of EK/cellular/Schreyer methods with the local triangular columns | No claim of a new resolution algorithm or general EK formalization. |
| U5: formalizations in other libraries | Unindexed projects, AFP downstream work, and complete source/version/build checks of inspected public projects | F1 claims no priority; design insight still needs further examples or comparison. |

The recommended positioning is to organize M1–M3 as one candidate mathematical story: uniform analytic strict bounds, explicit harmonic control, and matching growth order in an actual lex budget class. Present the semigroup $O(w\log w)$ statement as a traditional application, and F1 as completed formal support plus a candidate independent design contribution. If later source comparison shows that the mathematics is covered, change the positioning instead of adding small variations to sustain a novelty claim.

An appropriate statement is: “We give an analytic proof under the stated explicit assumptions and formalize the chain from actual lex quotients to standard Tor.” Current evidence does not justify “first solution of the general CMS problem,” “first construction of lex resolutions,” “first computation of this extremum,” or “certified original.” Existence of maxima, traditional counting, standard derived comparison, and existing library methods should each retain their proper attribution.

R091 supplied R092 with the object contract, exact M1–M3 statements, known/corollary/candidate labels, and U1–U5 list. A self-contained proof and statement map can organize these without silently removing unresolved items. R093 can separately gather the factual responsibility record when authorized. R091 itself did not create those later deliverables or make an external submission.

## Record of the bounded review

The scope and two rounds of queries are recorded in the optional Chinese [R091 search log](../research/publication/R091_SEARCH_LOG.md). Scientific evidence remained the existing accepted C031/C023 and related claims. At R091's conclusion R092 and R093 had not started, and no external contact or publication occurred. The dated reading note at the top explains the later completion of R092; this translation does not alter the historical record.
