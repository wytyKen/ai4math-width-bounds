# Core proof narrative

English translation prepared on 2026-10-07 of the accepted R092 document, drafted on 2026-10-04 and reviewed on 2026-10-05. This is a complete reading version of the existing internal mathematical account for a future candidate manuscript. It does not change frozen v0.4, add proofs, Lean code, builds or experiments, or certify novelty. The [statement map](STATEMENT_MAP.md) gives exact declarations and complete hypotheses; the [contribution map](CONTRIBUTIONS.md) retains the contribution classifications and unresolved literature risks. The [Chinese original](../research/publication/PROOF_NARRATIVE.md) is preserved.

The argument proceeds from actual quotient dimensions and standard monomials, through pointwise and harmonic estimates under a cumulative budget, to the strict binomial bound from a terminal column budget, actual lower-bound ideals and matching growth at all sufficiently large widths, and finally standard Tor and the traditional semigroup application. N0–N9 are shared location labels for this narrative and the statement map; they do not denote new scientific tasks.

## N0. Objects, hypotheses, and conclusions

Let K be any field, A = K[x,y,z], with variable order x > y > z, and m = (x,y,z). Let I be a homogeneous lex monomial ideal: if a monomial belongs to I, every lexicographically larger monomial of the same degree also belongs to I. Assume that:

- A/I is finite-dimensional over K;
- x ∉ I;
- w is an integer with w ≥ 4 and, for every integer d ≥ 0,

```text
HS(A/I,d) := Σ_(t=0)^d dim_K Q_t(I) ≤ 1 + dw.                 (0.1)
```

Here Q_t(I) is the image in the actual quotient A/I of the homogeneous polynomials of degree exactly t. The parameter w is a budget parameter here; it need not be the width of a semigroup. The condition x ∉ I, together with lex, excludes every degree-one monomial, so I ⊆ m². Finite colength is a separate assumption and does not follow from (0.1).

A monomial is *standard* if it does not belong to I. Write

```text
H_d = #{x^i y^j z^k ∉ I : i+j+k=d},
h_d = #{x^i y^(d−i) ∉ I : 0≤i≤d}.
```

Since I is a monomial ideal, its monomials span it as a K-vector space. Uniqueness of monomial expansion shows that the remaining monomial classes form a basis of A/I. Thus H_d = dim_K Q_d(I), and

```text
ell := dim_K span{[x^i y^j] : i,j≥0} = Σ_(d≥0) h_d.
```

This is the dimension of the complete xy subspace in the actual quotient. It is not a truncated count renamed as a dimension. Under the usual monomial-basis identification, it also equals the dimension of K[x,y]/(I ∩ K[x,y]).

Finite colength ensures that some pure power of x belongs to I; otherwise all classes [x^r] would be linearly independent. Set a = min{r : x^r ∈ I}, so a ≥ 2. For 0 ≤ i < a, set

```text
n_i = #{j≥0 : x^i y^j ∉ I} > 0.
```

The ideal property makes the standard y exponents in each column the initial interval 0,…,n_i−1. Columns with i ≥ a are empty, so ell = Σ_(i<a) n_i.

The conclusions proved or precisely connected here are

```text
ell ≤ 3w + (2w−1) H_harm(2w−1) ≤ 10w log w,                 (0.2)

a+1+ell < binom(w+1,2),
a+2ell ≤ 2 binom(w+1,3),
ell ≤ 3 binom(w+1,4).                                      (0.3)
```

We use H_harm(n) = Σ_(r=1)^n 1/r for the harmonic number, to distinguish it from the three-variable Hilbert number H_d. In the same class of actual lex ideals satisfying the budget, the maximum of ell is attained and lies between w log w / 16 and 10w log w for w ≥ 64. The four standard Tor dimensions are 1, a+1+ell, a+2ell, ell, and higher Tor vanishes. Only after these statements do we connect the numbers to the original semigroup problem.

## N1. Section shape, prefixes, and truncation

### N1a. Why the two-variable profile is monotone

At fixed degree d, the x exponents of standard xy monomials form the initial interval i = 0,…,h_d−1. If x^i y^(d−i) is standard, reducing i lowers lex order and leaves it standard. For d < a, x^d is standard and is the largest monomial of that degree, so every monomial of degree d is standard. Hence

```text
h_d = d+1,     H_d = binom(d+2,2)     (d<a).                 (1.1)
```

For d ≥ a, a standard xy monomial has x exponent i < a, so its y exponent d−i is positive. Division by y preserves standardness and gives an injection into the preceding degree. Thus h_d ≤ h_(d−1): the sequence is nonincreasing from degree a−1 onward. In particular h_d ≤ a for d ≥ a. This does not assume that an arbitrary abstract Hilbert sequence is realizable.

### N1b. The prefix budget controls the initial degree

Apply (0.1) at d = a−1 and sum the triangular values in (1.1):

```text
P_a := Σ_(t=0)^(a−1) H_t = binom(a+2,3) ≤ 1+(a−1)w.        (1.2)
```

The identity

```text
6 (binom(a+2,3)−1) = (a−1)(a²+4a+6)
```

and a−1 > 0 give a²+4a+6 ≤ 6w. Consequently,

```text
binom(a+1,2) ≤ 3w.                                         (1.3)
```

Also a ≤ w−2. Otherwise a ≥ w−1, and the previous inequality implies w²+2w+3 ≤ 6w, or (w−1)(w−3) ≤ 0, contrary to w ≥ 4. This uses the full natural-number range, not enumeration of finitely many widths.

### N1c. The two-variable support is genuinely finite

If h_d > 0, then y^d is standard. For every t ≤ d, y^t is standard; downward lex closure then forces all t+1 degree-t monomials in y,z to be standard. Therefore

```text
(d+1)(d+2)/2 ≤ Σ_(t=0)^d H_t ≤ 1+dw.
```

For d ≥ 1, compare the endpoints and cancel the positive factor d to obtain d+3 ≤ 2w. Thus

```text
h_d = 0     (d≥2w−2),
ell = Σ_(d=0)^(2w) h_d.                                   (1.4)
```

The division step does not use d = 0. In the cutoff application, d ≥ 2w−2 ≥ 6 ensures positivity. Summing through 2w retains three final degrees already known to be zero; this redundant truncation matches the existing finite-sum interface. It controls the xy section, not the entire tail in the z direction or the total length of A/I.

## N2. From the all-degree budget to the harmonic upper bound

### N2a. How many three-variable monomials a section forces

If the number of standard xy monomials of degree t is at least h, then x^i y^(t−i) is standard for every 0 ≤ i < h. Reducing the y exponent and adding z gives t−i+1 standard monomials. The columns for different i are disjoint, so

```text
H_t ≥ Σ_(i=0)^(h−1) (t−i+1)
    = h(t+1) − h(h−1)/2.                                  (2.1)
```

Here h ≤ t+1, and all counts are nonnegative integers. For a general I this is a lower bound; it does not assert that these columns contain every standard monomial.

### N2b. The pointwise product bound

Fix d ≥ a and set r = d−a+1 ≥ 1 and h = h_d. By N1a, h_t ≥ h for a ≤ t ≤ d, and h ≤ a. Sum (2.1), retaining the prefix P_a, to obtain

```text
2P_a + rh(a+d+3−h) ≤ 2+2dw.                               (2.2)
```

If rh ≥ 2w, then a+d+3−h ≥ d+3 makes the left side at least 2w(d+3), exceeding the right side by 6w−2 > 0. This is a contradiction. Therefore

```text
(d−a+1)h_d < 2w,
h_d ≤ floor((2w−1)/(d−a+1)).                              (2.3)
```

There is no division by h, so h = 0 is included. The numerator 2w−1 comes from a strict integer inequality. The denominator r is positive; this is not an arbitrary real-number rounding assertion.

### N2c. Finite summation

Let N = 2w−a+1. N1b gives a ≤ w−2, so N ≥ 0; a ≥ 2 also gives N ≤ 2w−1. Combine the prefix from N1a, the cutoff from N1c, and (2.3):

```text
ell = Σ_(d<a) h_d + Σ_(d=a)^(2w) h_d
    ≤ binom(a+1,2) + Σ_(r=1)^N floor((2w−1)/r)
    ≤ 3w + (2w−1) Σ_(r=1)^(2w−1) 1/r.                    (2.4)
```

The final step first removes the floor and then extends a nonnegative sum. We sum bounds satisfied by each actual h_d; we do not claim that one ideal simultaneously attains all the degreewise upper bounds. The three actual tail values h_d vanish, but their replacement floor bounds need not vanish. Keeping those bounds merely weakens the estimate. This proves the uniform harmonic bound.

## N3. An explicit real-logarithmic upper bound

Integral comparison for the decreasing function 1/x gives H_harm(n) ≤ 1+log n for n ≥ 1. Also log 2 ≤ 1 and log w ≥ log 4 ≥ 1. Put T = 2w−1, so 0 < T ≤ 2w and

```text
log T ≤ log(2w) ≤ 1+log w.
```

Equation (2.4) now yields

```text
ell ≤ 3w + T(1+log T)
    ≤ 7w + 2w log w
    ≤ 10w log w.                                          (3.1)
```

The last step uses w ≤ w log w and retains the accepted coarse constant 10; no optimality is claimed. The estimate log 4 ≥ 1 follows from log 2 = ∫_1^2 dx/x ≥ 1/2. Logarithms only compare integer dimensions and place no characteristic-zero restriction on K.

## N4. The terminal column budget and strict binomial bound

The harmonic bound describes growth order. The exact strict binomial bound for all widths comes from another readable organization of the same budget.

### N4a. A single terminal budget

The final standard monomial x^i y^(n_i−1) forces y^(i+n_i−1) of the same degree to be standard. Thus

```text
i+n_i ≤ n_0     (0≤i<a).                                  (4.1)
```

For fixed i, every x^i y^j z^k with j+k < n_i is standard: first use divisibility to obtain standard x^i y^(j+k), then downward lex closure. These monomials have total degree at most i+n_i−1 ≤ n_0−1, and number n_i(n_i+1)/2. Different i give disjoint sets. Applying the budget at this one terminal degree gives

```text
Σ_(i=0)^(a−1) n_i(n_i+1)/2 ≤ 1+(n_0−1)w.                 (4.2)
```

The degree is valid because n_0 ≥ 1. We have not independently optimized the budget of each column and assumed simultaneous attainment.

### N4b. A sum of squares with signs

Set

```text
v_0 = 2n_0+1−2w,
v_i = 2n_i+1     (1≤i<a).
```

The value v_0 may be negative. Direct expansion and (4.2) give

```text
Σ_i v_i = 2ell+a−2w,
Σ_i v_i² ≤ 4(w−1)(w−2)+a.
```

Cauchy's inequality applies to these signed values, hence

```text
(2ell+a−2w)² ≤ a(4(w−1)(w−2)+a).                          (4.3)
```

Alternatively use the identity aΣv_i²−(Σv_i)² = Σ_(i<j)(v_i−v_j)² directly. No nonnegativity hypothesis is missing.

### N4c. The strict comparison

Put T = w²−w−a−2. Since a ≤ w−2, we have T ≥ w(w−2) > 0, and

```text
T² − a(4(w−1)(w−2)+a)
  = (w−2)((w−2)(w+1)² − 2a(3w−1))
  ≥ (w−2)²(w−1)(w−3) > 0.
```

Together with (4.3), this implies 2ell+a−2w < T, which rearranges to a+1+ell < w(w+1)/2. The left side is integral, so, with C = binom(w+1,2), we have ell ≤ C−a−2. Consequently,

```text
a+2ell ≤ 2C−a−4 ≤ 2C,     ell ≤ C.
```

For w ≥ 4, binom(w+1,3)/C = (w−1)/3 ≥ 1 and 3 binom(w+1,4)/C = (w−1)(w−2)/4 ≥ 1. This proves (0.3). The positivity of T is essential. The eventual Betti statement applies only to i ≥ 1: one cannot insert b_0 = 1 into an i = 0 target whose right side is zero.

## N5. An actual ideal realizes the lower-bound profile

### N5a. The ideal and its initial degree

Take an integer s ≥ 2, put q = s², and define

```text
I_s = (x^i y^j z^k : (i+1)(i+j+k+1)>q) ⊆ K[x,y,z].        (5.1)
```

The forbidden exponent set is upward closed under coordinatewise increase because both positive factors are nondecreasing. A monomial therefore belongs to the ideal spanned by this set exactly when its exponent satisfies the displayed inequality. At fixed total degree, moving upward in lex order increases the x exponent or leaves it unchanged, so the forbidden set is lex upper. Every monomial of total degree d ≥ q belongs to I_s, making the actual quotient finite-dimensional.

A pure power x^r is standard exactly when (r+1)² ≤ s². Thus the first forbidden pure-x degree is a = s, and x is standard. We have constructed an ideal, rather than merely specifying a Hilbert sequence and assuming realization; the initial degree is s, not s−1.

### N5b. The budget in every degree

At degree d, the standardness condition is (i+1)(d+1) ≤ q. Hence

```text
h_d^(s) = min(d+1, floor(q/(d+1))),
H_d^(s) = h_d^(s)(d+1) − h_d^(s)(h_d^(s)−1)/2.             (5.2)
```

Equality holds because this family's standard set consists exactly of the first h_d^(s) complete x columns, unlike the general lower bound in N2. There is also a uniform budget proof: map a standard triple (i,j,d−i−j) to i(d+1)+j. Since 0 ≤ j ≤ d−i < d+1, this positional representation is injective, and

```text
0 ≤ i(d+1)+j < (i+1)(d+1) ≤ q.
```

Thus H_d^(s) ≤ q in every degree and H_0^(s) = 1. For all d ≥ 0,

```text
HS(A/I_s,d) ≤ 1+dq.                                       (5.3)
```

This includes the zero tail at degrees ≥ q; it is not a finite experimental check. If q ≤ w, the same ideal satisfies the budget 1+dw.

### N5c. Exact column lengths and the harmonic lower bound

For 0 ≤ i < s, standardness in the xy section is equivalent to

```text
0 ≤ j < floor(s²/(i+1))−i.
```

The upper endpoint is at least s−i > 0, so the subtraction gives an actual nonnegative column length. Columns with i ≥ s are empty. Therefore

```text
ell_s = Σ_(r=1)^s floor(s²/r) − s(s−1)/2.                 (5.4)
```

Use floor(u) ≥ u−1 term by term:

```text
ell_s ≥ s² H_harm(s) − (s²+s)/2
      ≥ s²(log(s+1) − 1/2 − 1/(2s)).                       (5.5)
```

The second inequality follows from H_harm(s) ≥ ∫_1^(s+1) dx/x. This already proves a lower bound for square parameters without delicate divisor-problem asymptotics. The divisor-sum interpretation is known arithmetic; the point here is realization by a three-variable ideal satisfying every budget.

## N6. Nonsquare widths, attained maxima, and standard Theta

For every w ≥ 64, take s = floor(sqrt(w)). Then s ≥ 2 and s² ≤ w < (s+1)². Since s+1 ≤ 2s, we obtain s² ≥ w/4, while log(s+1) ≥ (log w)/2. Also log w ≥ log 64 = 6 log 2 ≥ 3.

Insert these estimates into (5.5), using 1/(2s) ≤ 1/4:

```text
ell_s ≥ s²((log w)/2 − 3/4)
      ≥ (s²/4) log w
      ≥ w log w / 16.                                     (6.1)
```

This I_s satisfies the budget with parameter w, so the result is not restricted to square widths. We use threshold 64 to agree with the existing Lean endpoint; a smaller threshold in a historical paper proof is not substituted for the compiled declaration.

Let C_(K,w) be the common class in N0 and M_K(w) the maximum of its actually attained ell values. For w ≥ 4, I_2 proves nonemptiness. N4 gives an integer upper bound on every ell, so this nonempty bounded set of natural numbers has a maximum, attained by an actual ideal by definition. Attainment does not imply that I_floor(sqrt(w)) is optimal at each w.

Apply (3.1) to a maximizing ideal and (6.1) to the feasible lower-bound example:

```text
w log w / 16 ≤ M_K(w) ≤ 10w log w     (w≥64).              (6.2)
```

The bounding functions are eventually nonnegative. This is the standard Theta(w log w) comparison on natural-number parameters after passing to real values. The existing Lean endpoint is `Asymptotics.IsTheta` for the section maximum. No separate extremal functions for all Betti numbers were constructed in R092. In particular, no lower-bound family has been proved to arise from four-generated semigroups; an upper comparison cannot be reversed to infer a semigroup lower bound.

## N7. From an actual resolution to standard Tor

We distinguish the known source of the algebraic formulas, the exactness content of the concrete implementation, and the dimension consequences. The three-variable lex formulas are traditionally known: [equation (7) in the proof of CMS Lemma 4.2](https://arxiv.org/html/2307.05770v2#S4.E7) gives them through section formulas for the ideal. Its ideal Betti indices must shift one position to the right to give positive quotient Betti numbers. The Lean implementation obtains the same conclusion through the actual resolution below; it does not define the numbers to equal the desired formulas.

### N7a. The concrete resolution and what its proof establishes

For i < a and j < n_i, let t_ij be the least t with x^i y^j z^t ∈ I. Finite colength gives existence, and xy standardness gives t_ij ≥ 1. The complete boundary generating set is

```text
x^a,
x^i y^(n_i)          (i<a),
x^i y^j z^(t_ij)     (i<a, j<n_i).
```

Set n_a = 0. Lex gives n_i > n_(i+1), making the xy boundary minimal. If a z-boundary monomial remained in I after division by x or y, lex would allow replacing a z by x or y, putting a lower z power at the same xy position into I and contradicting minimality of t_ij. Division by z gives the same contradiction directly. Generation follows by separating the cases where the pure-x or xy boundary has already been crossed, or otherwise the z threshold at that xy position has been reached. Thus this is the complete minimal generating family, of size a+1+ell. The map d1 sends its free basis to these actual monomials; its image is I, the kernel of A → A/I. The second basis consists of an x step for each xy boundary and x and y steps for each z boundary, totaling a+2ell terms. Each relation is a difference of two monomial multiples at a common monomial degree.

Why do these relations generate the entire kernel, beyond d1d2 = 0? Group an arbitrary vector of polynomial coefficients by the common monomial degree of its image. In each group the coefficients sum to zero, so the vector is a sum of pairwise differences to a canonical boundary. Canonical neighboring steps normalize these differences by descending through the finite boundary order. This works at each common degree; finite summation gives all of ker(d1) = image(d2). It covers arbitrary polynomial coefficients, not only monomial tests.

The third basis is indexed by the ell standard xy positions. The third column at a z boundary has the form

```text
f_p = y e_(r_x(p)) − x e_(r_y(p)) − (c_y−c_x).
```

The same normalization actually constructs c_x and c_y, supported strictly below the top position, with d2(c_y−c_x) = d2(y e_rx−x e_ry). Hence f_p belongs to ker(d2). At the highest uneliminated position of a second relation, an xy boundary has a single x coefficient, which must be zero by the domain property. At a z boundary, the two top coefficients f,g satisfy xf+yg = 0. Setting x = 0 shows that x divides g; write g = −xh and cancel x to obtain f = yh. Subtracting h f_p lowers the support. Finite elimination gives all of ker(d2) = image(d3). Similarly, at the highest nonzero third-column coefficient its top y multiple cannot vanish in a domain, proving that d3 is injective. No false assumption that (x,y) = A is used.

Lex ensures that a canonical neighboring target generator has no larger total degree. The common degree exceeds the source degree, so every second-column coefficient lies in m. The third-column corrections control both support and degree, placing all their coefficients in m as well; the d1 generators also lie in m. This gives the actual exact augmented sequence

```text
0 → A^ell --d3→ A^(a+2ell) --d2→ A^(a+1+ell) --d1→ A
  → A/I → 0,                                               (7.1)
```

with all residue differentials zero. This explanation follows the constructions in the [complete first-syzygy proof](../research/tasks/R056_first_syzygies.md) and [actual resolution proof](../research/tasks/R057_lex_resolution.md). The statement map supplies the full induction references and exact source entry points. This is not a fresh assumption of a resolution with expected ranks. The implementation chooses third columns after proving existence; it does not claim a new executable canonical matrix algorithm, a general Eliahou–Kervaire (EK) theorem, or a complete interface for graded shifts.

### N7b. Standard Tor and finiteness over K

Write

```text
T_i(I) = Tor_i^A(A/m, A/I),     b_i(I) = dim_K T_i(I),
```

with the K action obtained by restriction along the actual K → A. Package (7.1) as a standard projective resolution P and apply F = (A/m) ⊗_A −. Standard derived-functor comparison gives T_i(I) ≅ H_i(F(P)). Since all residue differentials vanish, this actual homology is isomorphic to F(P_i).

If P_i has a finite A-basis B_i, actual tensor-basis coordinates and A/m ≃_K K give a K-linear isomorphism

```text
(A/m) ⊗_A P_i ≃_K (A/m)^(B_i) ≃_K K^(B_i).
```

This first proves finiteness over K; dimension then equals the original term's A-free rank. It does not assert that P_i itself is K-finite, and it does not redefine the K action to obtain a target number. Therefore

```text
(b_0,b_1,b_2,b_3) = (1,a+1+ell,a+2ell,ell),
T_i(I) = 0     (i≥4).                                     (7.2)
```

In higher degrees, actual zero resolution terms and isomorphisms give zero objects. This is stronger than a bare `finrank = 0`, which can also hold for infinite-dimensional spaces. The degree-one object and K action agree definitionally with the earlier generator-fiber calculation. Here the second factor A/I is resolved; this work does not thereby supply a general Tor factor-exchange theorem in local Lean code.

## N8. Actual Betti bounds and direct corollaries

Substituting (7.2) into N4 gives the strict first binomial bound and the second and third bounds for every w ≥ 4 in the common class. Zero objects supply degrees i ≥ 4. Thus

```text
b_i(I) ≤ i binom(w+1,i+1)     (i≥1),
b_1(I) ≤ binom(w+1,2)−1.                                  (8.1)
```

This is an accepted endpoint of the existing `HigherTorBounds` implementation.

Next put H = H_harm(2w−1). Adding a ≤ w−2 and the N2 bounds gives

```text
b_1(I) ≤ 4w−1 + (2w−1)H,
b_2(I) ≤ 7w−2 + 2(2w−1)H,
b_3(I) ≤ 3w + (2w−1)H.                                   (8.2)
```

The first line uses a+1 ≤ w−1; the second uses a ≤ w−2 and twice the ell bound; the third is the ell bound itself. All three are written here as direct consequences of existing results. This does not claim that R092 added three Lean theorems. The b1 harmonic interface already exists; the statement map separately records the status of the composed b2 and b3 formulas.

Each of the three fixed positive degrees consequently has an O(w log w) upper bound. These need not improve the binomial formulas at every small width, and both sets of bounds may be used. A fair asymptotic literature comparison includes the existing CMS O(w^(3/2)) route, rather than comparing only against the coarser binomial orders. The current standard Theta theorem concerns only the lex section maximum in N6; it is not a matching lower bound for every I or for semigroups themselves.

## N9. The traditional comparison layer for the original semigroup application

This section accurately combines existing algebraic results; it is outside the current end-to-end Lean coverage. Let Γ have exactly four minimal generators g0 < g1 < g2 < g3, put m_Γ = g0 and w = g3−g0, and let R = K[[t^Γ]], with minimal regular presentation P = K[[X0,X1,X2,X3]]. The original target consists of the Betti numbers over P, not Tor^R(K,K).

[CMS Theorem 2.1 and equation (1) after Definition 3.1](https://arxiv.org/html/2307.05770v2) provide the traditional comparison: reduce by the regular parameter t^(m_Γ), then pass to the associated graded ring, a monomial initial ideal J, and the lex ideal L ⊂ K[x,y,z] with the same Hilbert function. The quotient has length m_Γ and no degree-one relations, and

```text
β_i^P(R) ≤ β_i^A(A/J) ≤ b_i(L)     (i≥1).                 (9.1)
```

The reduction and comparison themselves do not depend on a width branch. The extra condition w ≤ m_Γ−2 enters only when using the budget theorem below. Regular-parameter reduction gives equality, while the associated-graded, initial-ideal and lex steps give upper comparisons. One cannot identify the Betti numbers of a general tangent cone with those of the original ring. We use traditional Tor symmetry and standard Betti conventions to identify the numerical values; this is not represented as a general exchange interface already implemented locally.

For w ≥ 4 the two budget branches must remain separate. If w ≤ m_Γ−2, use [CMS Theorem 3.3](https://arxiv.org/html/2307.05770v2#S3.Thmthm3). If w ≥ m_Γ−1, then, for d ≥ 1,

```text
HS(A/L,d) ≤ m_Γ ≤ w+1 ≤ 1+dw;
```

at d = 0 the value is 1. Both branches therefore supply all N0 hypotheses. Equations (8.1) and (8.2), through (9.1), give the corresponding traditional semigroup upper bounds. This traditional O(w log w) consequence was already available once the harmonic bound and classical formulas were in place; v0.4 adds machine coverage at the lex homological end.

Four distinct minimal generators imply w ≥ 3. At w = 3 they must be four consecutive generators. [Herzog–Stamate v3 Proposition 2.7, printed page 9](https://arxiv.org/pdf/1308.4644v3#page=9) gives β_i(K[Γ]) ≤ i binom(r,i+1) for r minimal generators in arithmetic progression and 1 ≤ i ≤ r−1; take r = 4. Localizing a minimal weighted graded resolution at the homogeneous maximal ideal and then completing preserves Betti ranks: flatness preserves exactness, and matrix entries remain in the maximal ideal. For the original one-dimensional Cohen–Macaulay ring with a four-dimensional regular presentation, Auslander–Buchsbaum gives projective dimension 3, so degrees i ≥ 4 vanish. The w = 3 branch does not use the abstract strict lex bound proved only for w ≥ 4.

The [traditional reduction audit](../research/algebra_bridge_audit.md) records the full object and hypothesis checks for these citations. This layer is treated as cited mathematics, not newly formalized work; a successful build log is not evidence that Lean has verified it.

## Claim levels and the stopping point

N0–N6 give readable proofs of the central counting and actual extremal results. N7 explains the existing actual resolution and its connection to standard objects. N8 separates compiled binomial endpoints from direct harmonic corollaries. N9 cites traditional comparisons. The [statement map](STATEMENT_MAP.md) gives exact hypotheses, declarations, source lines, and missing bridges for each label. The core harmonic argument is not replaced by “the program accepted it,” and the writing task does not extend the large homological foundations library.

All R091 unresolved items U1–U5 remain: the full White doctoral thesis was unavailable; the scope of older algorithms and analytic optimization remains a risk; related earlier extremal or lower-bound constructions remain unexcluded; identification with traditional resolutions is incomplete; and cross-library formalization priority is unaudited. The link to White's finite optimization is not itself a published all-width analytic growth result. Known formulas, classical counting, and library tools are not claimed as inventions. This account describes the proof or implementation presented here without certifying originality or priority.

R092 completed the internal proof explanation and mapping only. This English translation preserves that scope: it changes no v0.4 artifact, starts no R093 authorship-responsibility record or submission, makes no claim of human author verification, and adds no mathematical build or experiment.
