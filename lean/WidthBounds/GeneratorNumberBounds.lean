import WidthBounds.GeneratorExact
import WidthBounds.Growth
import WidthBounds.PolynomialGeneratorNumber
import WidthBounds.GeneratingFamilyDimension

/-!
# Least cardinality of arbitrary polynomial generating sets

The set of cardinalities is defined using genuine ideal spans of arbitrary
finite polynomial sets. No homogeneity or monomial restriction is built into
this definition, and no identification with Tor or Betti numbers is made.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Finset LexCounting

variable {R : Type*} [CommSemiring R]

/-- Cardinalities attained by arbitrary finite polynomial generating sets. -/
def generatorCardinalities (I : Ideal (MvPolynomial (Fin 3) R)) : Set ℕ :=
  {n | ∃ P : Finset (MvPolynomial (Fin 3) R),
    Ideal.span (P : Set (MvPolynomial (Fin 3) R)) = I ∧ P.card = n}

/-- An attained lower bound is the actual least generating cardinality. -/
theorem isLeast_generatorCardinalities_of_bound
    (I : Ideal (MvPolynomial (Fin 3) R)) (G : Finset (MvPolynomial (Fin 3) R))
    (hG : Ideal.span (G : Set (MvPolynomial (Fin 3) R)) = I)
    (hLower : ∀ P : Finset (MvPolynomial (Fin 3) R),
      Ideal.span (P : Set (MvPolynomial (Fin 3) R)) = I → G.card ≤ P.card) :
    IsLeast (generatorCardinalities I) G.card := by
  refine ⟨⟨G, hG, rfl⟩, ?_⟩
  rintro n ⟨P, hP, rfl⟩
  exact hLower P hP

/-- The already proved prefix budget bounds the genuine initial degree. -/
theorem initial_degree_le_width_sub_two_of_budget
    {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A) {w a : ℕ}
    (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ d, d < a → A d 0 0)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    a ≤ w - 2 := by
  apply alpha_le_width_sub_two hw ha
  have hPrefix := sum_hilbert3_initial hA hInitial
  have hBudget := hHS (a - 1)
  have hPred : a - 1 + 1 = a := by omega
  rwa [hPred, hPrefix] at hBudget

/-- An exact rational harmonic bound for the generator-count expression.
The real logarithmic or asymptotic notation is not formalized here. -/
theorem generator_expression_le_harmonic
    {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A) {w a : ℕ}
    (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ d, d < a → A d 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    ((a + 1 + sectionLength A w : ℕ) : ℚ) ≤ 4 * (w : ℚ) - 1 +
      ((2 * w - 1 : ℕ) : ℚ) * Growth.harmonicQ (2 * w - 1) := by
  have hAlpha := initial_degree_le_width_sub_two_of_budget hA hw ha hInitial hHS
  have hNat : a + 2 ≤ w := by omega
  have hRat : (a : ℚ) + 2 ≤ (w : ℚ) := by exact_mod_cast hNat
  have hLength := Growth.sectionLength_le_harmonic hA hw ha hInitial hx hHS
  push_cast
  linarith

/-- Any finite collection of divisibility-minimal monomials gives a lower
bound on the size of every polynomial generating set. The latter is arbitrary:
its elements need not be monomials, homogeneous, or linearly independent. -/
theorem minimal_exponents_card_le_generators
    {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (P : Finset (MvPolynomial (Fin 3) K))
    (hSpan : Ideal.span (P : Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    E.card ≤ P.card := by
  classical
  have hDim := finrank_le_card_of_ideal_generators (monomialIdeal (R := K) S)
    (minimalCoefficientMap (K := K) E)
    (fun q p hp => minimalCoefficientMap_mul S hUp E hMin hp q)
    (minimalCoefficientMap_exists_preimage (monomialIdeal (R := K) S) E hMin) P hSpan
  simpa only [Module.finrank_fintype_fun_eq_card, Fintype.card_coe] using hDim

/-- A monomial generating set consisting of minimal exponents attains the
least cardinality among all finite polynomial generating sets. -/
theorem isLeast_generatorCardinalities_of_minimal_exponents
    {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    IsLeast (generatorCardinalities (monomialIdeal (R := K) S)) E.card := by
  have hLeast := isLeast_generatorCardinalities_of_bound (monomialIdeal (R := K) S)
    (exponentMonomials (R := K) E) hSpan (fun P hP => by
      rw [card_exponentMonomials]
      exact minimal_exponents_card_le_generators S hUp E hMin P hP)
  simpa only [card_exponentMonomials] using hLeast

/-- For the original finite-colength lex model, the least number of arbitrary
polynomial generators is exactly `a+1+dim(xySubspace)`. This same least number
satisfies both the strict binomial bound and an exact rational harmonic bound.
Neither upper bound applies to deliberately enlarged redundant generating sets. -/
theorem finiteColength_generator_number_bounds
    {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ a : ℕ, 2 ≤ a ∧
      monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      IsLeast (generatorCardinalities (monomialIdeal (R := K) S))
        (a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S))) ∧
      a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) <
        (w + 1).choose 2 ∧
      ((a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) : ℕ) : ℚ) ≤
        4 * (w : ℚ) - 1 +
          ((2 * w - 1 : ℕ) : ℚ) * Growth.harmonicQ (2 * w - 1) := by
  obtain ⟨a, E, ha, hx, hInitial, hClassify, hSpan, hCard, hStrict, _⟩ :=
    finiteColength_exists_exact_minimal_generators S hUp hLex hOne hw hBudget
  have hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e :=
    fun e he => (hClassify e).mp he
  have hLeast := isLeast_generatorCardinalities_of_minimal_exponents S hUp E hMin hSpan
  have hCardE : E.card =
      a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) := by
    simpa only [card_exponentMonomials] using hCard
  refine ⟨a, ha, hx, hInitial, ?_, ?_, ?_⟩
  · rwa [hCardE] at hLeast
  · rwa [hCard] at hStrict
  · rw [finrank_xySubspace S hUp hLex hw hBudget]
    exact generator_expression_le_harmonic (monomialIdeal_standardLex S hUp hLex)
      hw ha hInitial (not_not.mpr hx) (hilbertBudget_of_finrankBudget S hUp w hBudget)

#print axioms minimal_exponents_card_le_generators
#print axioms isLeast_generatorCardinalities_of_minimal_exponents
#print axioms finiteColength_generator_number_bounds

end

end WidthBounds.MonomialInterface
