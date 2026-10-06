import WidthBounds.MinimalGenerators
import WidthBounds.FiniteColength
import WidthBounds.GeneratorMinimality
import WidthBounds.BoundaryGenerators

/-!
# Exact finite monomial generators

The exponent-to-polynomial map below is injective over a nontrivial coefficient
semiring. Further results in this module connect divisibility-minimal exponents
with an actual polynomial generating set; no Betti-number identification is used.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Finset LexCounting Columns

variable {R : Type*} [CommSemiring R]

/-- The coefficient-one polynomials attached to a finite exponent set. -/
def exponentMonomials (E : Finset (Fin 3 →₀ ℕ)) :
    Finset (MvPolynomial (Fin 3) R) := by
  classical
  exact E.image (fun e => monomial e (1 : R))

theorem coe_exponentMonomials (E : Finset (Fin 3 →₀ ℕ)) :
    (exponentMonomials (R := R) E : Set (MvPolynomial (Fin 3) R)) =
      (fun e => monomial e (1 : R)) '' (E : Set (Fin 3 →₀ ℕ)) := by
  classical
  simp only [exponentMonomials, coe_image]

variable [Nontrivial R]

/-- Counting exponents counts the actual coefficient-one polynomials exactly. -/
theorem card_exponentMonomials (E : Finset (Fin 3 →₀ ℕ)) :
    (exponentMonomials (R := R) E).card = E.card := by
  classical
  exact card_image_of_injective E (monomial_left_injective one_ne_zero)

theorem monomial_mem_exponentMonomials_iff
    (E : Finset (Fin 3 →₀ ℕ)) (e : Fin 3 →₀ ℕ) :
    monomial e (1 : R) ∈ exponentMonomials (R := R) E ↔ e ∈ E := by
  classical
  constructor
  · intro h
    obtain ⟨f, hf, heq⟩ := mem_image.mp h
    have hfe : f = e := monomial_left_injective one_ne_zero heq
    simpa only [hfe] using hf
  · intro he
    exact mem_image.mpr ⟨e, he, rfl⟩

/-- Genuine ideal membership in a finite monomial span is divisibility by
one of its listed exponents; no upper-closure hypothesis on the list is needed. -/
theorem monomial_mem_span_exponentMonomials_iff
    (E : Finset (Fin 3 →₀ ℕ)) (e : Fin 3 →₀ ℕ) :
    monomial e (1 : R) ∈ Ideal.span
      (exponentMonomials (R := R) E : Set (MvPolynomial (Fin 3) R)) ↔
      ∃ f ∈ E, f ≤ e := by
  classical
  rw [coe_exponentMonomials, mem_ideal_span_monomial_image]
  simp only [support_monomial, one_ne_zero, ↓reduceIte, mem_singleton,
    forall_eq, mem_coe]

/-- An exponent with no distinct divisor in the list cannot be removed from
the corresponding actual polynomial generating set. -/
theorem monomial_not_mem_span_erase
    (E : Finset (Fin 3 →₀ ℕ)) (e : Fin 3 →₀ ℕ)
    (hMinimal : ∀ f ∈ E, f ≤ e → f = e) :
    monomial e (1 : R) ∉ Ideal.span
      (exponentMonomials (R := R) (E.erase e) : Set (MvPolynomial (Fin 3) R)) := by
  classical
  rw [monomial_mem_span_exponentMonomials_iff]
  rintro ⟨f, hf, hle⟩
  exact (mem_erase.mp hf).1 (hMinimal f (mem_erase.mp hf).2 hle)

omit [Nontrivial R] in
/-- A covering finite list of minimal exponents is the full minimal-exponent
set. This uses actual ideal membership in both hypotheses. -/
theorem mem_finset_iff_isMinimalExponent
    (I : Ideal (MvPolynomial (Fin 3) R)) (E : Finset (Fin 3 →₀ ℕ))
    (hMinimal : ∀ e ∈ E, IsMinimalExponent I e)
    (hCover : ∀ e, monomial e (1 : R) ∈ I → ∃ f ∈ E, f ≤ e)
    (e : Fin 3 →₀ ℕ) : e ∈ E ↔ IsMinimalExponent I e := by
  constructor
  · exact hMinimal e
  · intro he
    obtain ⟨f, hf, hle⟩ := hCover e he.1
    have hfe : f = e := he.2 f hle (hMinimal f hf).1
    simpa only [hfe] using hf

/-- Deleting any minimal exponent destroys the generation of its monomial,
even when the remaining generators are combined with arbitrary polynomials. -/
theorem exponentMonomials_irredundant_of_minimal
    (I : Ideal (MvPolynomial (Fin 3) R)) (E : Finset (Fin 3 →₀ ℕ))
    (hMinimal : ∀ e ∈ E, IsMinimalExponent I e) {e : Fin 3 →₀ ℕ} (he : e ∈ E) :
    monomial e (1 : R) ∉ Ideal.span
      (exponentMonomials (R := R) (E.erase e) : Set (MvPolynomial (Fin 3) R)) := by
  apply monomial_not_mem_span_erase
  intro f hf hle
  exact (hMinimal e he).2 f hle (hMinimal f hf).1

omit [Nontrivial R] in
/-- All three kinds of boundary exponents are divisibility minimal when `a`
is the first forbidden pure x exponent and the ideal is lex. -/
theorem boundaryExponents_isMinimal
    (I : Ideal (MvPolynomial (Fin 3) R)) (hLex : IsLex I)
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    {e : Fin 3 →₀ ℕ} (he : e ∈ boundaryExponents I hZ a n) :
    IsMinimalExponent I e := by
  rcases (mem_boundaryExponents_iff I hZ a n e).mp he with
    rfl | ⟨i, hi, rfl⟩ | ⟨i, j, hi, hj, rfl⟩
  · exact isMinimalExponent_pure_x I hx hInitial
  · exact isMinimalExponent_xy_boundary I hLex n hn hInitial hi
  · exact isMinimalExponent_zThreshold I hLex hZ ((hn i j).mpr hj)

omit [Nontrivial R] in
/-- The list contains every minimal monomial, not just a collection of
minimal candidates. The converse follows from divisibility coverage. -/
theorem mem_boundaryExponents_iff_isMinimal
    (I : Ideal (MvPolynomial (Fin 3) R)) (hLex : IsLex I)
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) (e : Fin 3 →₀ ℕ) :
    e ∈ boundaryExponents I hZ a n ↔ IsMinimalExponent I e := by
  apply mem_finset_iff_isMinimalExponent
  · intro f hf
    exact boundaryExponents_isMinimal I hLex hZ a n hx hn hInitial hf
  · intro f hf
    exact exists_boundaryExponent_le I hZ a n hf

omit [Nontrivial R] in
/-- For a genuine monomial ideal, the explicit boundary polynomials generate
the original ideal. No arbitrary polynomial ideal is assumed to be monomial. -/
theorem span_boundary_exponentMonomials
    (S : Set (Fin 3 →₀ ℕ))
    (hZ : ∃ b, monomial3 0 0 b ∈ monomialIdeal (R := R) S)
    (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ monomialIdeal (R := R) S)
    (hn : ∀ i j, standard (monomialIdeal (R := R) S) i j 0 ↔ j < n i) :
    Ideal.span (exponentMonomials (R := R)
      (boundaryExponents (monomialIdeal (R := R) S) hZ a n) :
        Set (MvPolynomial (Fin 3) R)) = monomialIdeal S := by
  rw [coe_exponentMonomials]
  exact span_boundaryExponents S hZ a n hx hn

/-- The complete set of minimal monomial exponents generates the actual
ideal and has exactly `a+1+sectionLength` elements. Deletion is tested using
actual ideal spans, so polynomial combinations of the remaining list are allowed. -/
theorem monomialIdeal_exists_exact_minimal_exponents
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    {w a : ℕ} (hw : 4 ≤ w)
    (hHS : ∀ d, (∑ t ∈ range (d + 1),
      hilbert3 (standard (monomialIdeal (R := R) S)) t) ≤ 1 + d * w)
    (hx : monomial3 a 0 0 ∈ monomialIdeal (R := R) S)
    (hInitial : ∀ d, d < a → standard (monomialIdeal (R := R) S) d 0 0)
    (hZ : ∃ b, monomial3 0 0 b ∈ monomialIdeal (R := R) S) :
    ∃ E : Finset (Fin 3 →₀ ℕ),
      (∀ e, e ∈ E ↔ IsMinimalExponent (monomialIdeal (R := R) S) e) ∧
      Ideal.span (exponentMonomials (R := R) E : Set (MvPolynomial (Fin 3) R)) =
        monomialIdeal S ∧
      E.card = a + 1 + sectionLength (standard (monomialIdeal (R := R) S)) w ∧
      ∀ e ∈ E, monomial e (1 : R) ∉ Ideal.span
        (exponentMonomials (R := R) (E.erase e) : Set (MvPolynomial (Fin 3) R)) := by
  let I := monomialIdeal (R := R) S
  let n := columnLength (standard I) w
  have hLI : IsLex I := monomialIdeal_isLex S hUp hLex
  have hA := monomialIdeal_standardLex (R := R) S hUp hLex
  have hn : ∀ i j, standard I i j 0 ↔ j < n i :=
    fun _ _ => standard_iff_lt_columnLength hA hw hHS
  let E := boundaryExponents I hZ a n
  have hMin : ∀ e ∈ E, IsMinimalExponent I e :=
    fun _ he => boundaryExponents_isMinimal I hLI hZ a n hx hn hInitial he
  refine ⟨E, ?_, ?_, ?_, ?_⟩
  · exact mem_boundaryExponents_iff_isMinimal I hLI hZ a n hx hn hInitial
  · exact span_boundary_exponentMonomials S hZ a n hx hn
  · change (boundaryExponents I hZ a n).card = _
    rw [card_boundaryExponents I hZ a n hn]
    congr 1
    exact sum_columns_eq_sectionLength hA hw (not_not.mpr hx) hHS
  · intro e he
    exact exponentMonomials_irredundant_of_minimal I E hMin he

/-- Exact minimal-monomial counting, real quotient dimensions and the strict
width bound in one theorem. This does not identify a Betti number or compare
with arbitrary nonmonomial generating families. -/
theorem finiteColength_exists_exact_minimal_generators
    {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ (a : ℕ) (E : Finset (Fin 3 →₀ ℕ)), 2 ≤ a ∧
      monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      (∀ e, e ∈ E ↔ IsMinimalExponent (monomialIdeal (R := K) S) e) ∧
      Ideal.span (exponentMonomials (R := K) E : Set (MvPolynomial (Fin 3) K)) =
        monomialIdeal S ∧
      (exponentMonomials (R := K) E).card =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      (exponentMonomials (R := K) E).card < (w + 1).choose 2 ∧
      ∀ e ∈ E, monomial e (1 : K) ∉ Ideal.span
        (exponentMonomials (R := K) (E.erase e) : Set (MvPolynomial (Fin 3) K)) := by
  have hZ := exists_pure_z_mem_of_finite_quotient (K := K) S hUp
  have hNonzero : monomialIdeal (R := K) S ≠ ⊥ := by
    obtain ⟨N, hN⟩ := hZ
    apply (monomialIdeal_ne_bot_iff S).mpr
    exact ⟨exponent 0 0 N, (monomial_mem_monomialIdeal_iff S hUp _).mp hN⟩
  obtain ⟨a, ha, hx, hInitial, hStrict, _⟩ :=
    monomialIdeal_all_widths_dimension_bounds S hUp hLex hNonzero hOne hw hBudget
  obtain ⟨E, hClassify, hSpan, hCard, hIrred⟩ :=
    monomialIdeal_exists_exact_minimal_exponents S hUp hLex hw
      (hilbertBudget_of_finrankBudget S hUp w hBudget) (not_not.mp hx) hInitial hZ
  have hCardDim : (exponentMonomials (R := K) E).card =
      a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) := by
    rw [card_exponentMonomials, finrank_xySubspace S hUp hLex hw hBudget]
    exact hCard
  refine ⟨a, E, ha, not_not.mp hx, hInitial, hClassify, hSpan, hCardDim, ?_, hIrred⟩
  rwa [hCardDim]

#print axioms monomialIdeal_exists_exact_minimal_exponents
#print axioms finiteColength_exists_exact_minimal_generators

end

end WidthBounds.MonomialInterface
