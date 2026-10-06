import WidthBounds.GeneratorNumberBounds
import WidthBounds.GeneratorQuotient
import WidthBounds.IdealSubquotient
import Mathlib.LinearAlgebra.StdBasis

/-!
# The actual generator quotient and its dimension

This module identifies the quotient of the actual ideal by the product of
the variable ideal with it. The denominator is the actual ideal product,
independent of the coefficient map. No Tor or Betti identification is made here.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Module Finset

variable {K : Type*} [Field K]

/-- Minimal coefficient coordinates send each listed coefficient-one
monomial to the corresponding standard coordinate vector. -/
theorem minimalCoefficientMap_monomial_one
    (E : Finset (Fin 3 →₀ ℕ)) (e : ↥E) :
    minimalCoefficientMap (K := K) E (monomial e.val (1 : K)) =
      Pi.basisFun K ↥E e := by
  classical
  ext f
  simp only [minimalCoefficientMap_apply, coeff_monomial, Pi.basisFun_apply,
    Pi.single_apply, Subtype.val_inj]
  simp only [eq_comm]

/-- The actual vector-space quotient `I / (x,y,z)I`. Its denominator is
defined by the ideal product, not by a coefficient kernel. -/
abbrev GeneratorQuotient (I : Ideal (MvPolynomial (Fin 3) K)) :=
  IdealSubquotient I (variableIdeal (K := K) * I)

/-- Within `I`, vanishing of every minimal coefficient is exactly membership
in the genuine product of the variable ideal with `I`. -/
theorem minimalCoefficientMap_zero_iff_mem_product
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (p : MvPolynomial (Fin 3) K) (hp : p ∈ monomialIdeal S) :
    minimalCoefficientMap E p = 0 ↔
      p ∈ variableIdeal (K := K) * monomialIdeal (R := K) S := by
  constructor
  · intro hZero
    exact (mem_variableIdeal_mul_monomialIdeal_iff S hUp E hMin hSpan p).mpr ⟨hp, hZero⟩
  · intro hProd
    exact ((mem_variableIdeal_mul_monomialIdeal_iff S hUp E hMin hSpan p).mp hProd).2

/-- The kernel equality for the coefficient map restricted to the actual
ideal, with the product already defined independently. -/
theorem ker_generatorCoefficientMap
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    LinearMap.ker (restrictedIdealMap (monomialIdeal (R := K) S)
      (minimalCoefficientMap (K := K) E)) =
      idealSubmodule (monomialIdeal (R := K) S) (variableIdeal * monomialIdeal S) :=
  ker_restrictedIdealMap _ _ _ (minimalCoefficientMap_zero_iff_mem_product S hUp E hMin hSpan)

/-- Actual quotient classes correspond to their minimal monomial coordinates. -/
def generatorQuotientEquiv
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    GeneratorQuotient (monomialIdeal (R := K) S) ≃ₗ[K] (↥E → K) :=
  idealSubquotientEquiv _ _ (minimalCoefficientMap E)
    (minimalCoefficientMap_zero_iff_mem_product S hUp E hMin hSpan)
    (minimalCoefficientMap_exists_preimage _ E hMin)

@[simp] theorem generatorQuotientEquiv_mk
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (p : (monomialIdeal (R := K) S).restrictScalars K) :
    generatorQuotientEquiv S hUp E hMin hSpan (Submodule.Quotient.mk p) =
      minimalCoefficientMap E p.1 := by
  rfl

/-- A genuine basis of the actual quotient, indexed by the minimal exponents. -/
def generatorQuotientBasis
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    Basis ↥E K (GeneratorQuotient (monomialIdeal (R := K) S)) :=
  (Pi.basisFun K ↥E).map (generatorQuotientEquiv S hUp E hMin hSpan).symm

/-- The abstractly transported basis vectors are exactly the quotient classes
of the original coefficient-one monomial generators. -/
theorem generatorQuotientBasis_apply
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) (e : ↥E) :
    generatorQuotientBasis S hUp E hMin hSpan e = Submodule.Quotient.mk
      (⟨monomial e.val (1 : K), (hMin e.val e.property).1⟩ :
        (monomialIdeal (R := K) S).restrictScalars K) := by
  apply (generatorQuotientEquiv S hUp E hMin hSpan).injective
  simp only [generatorQuotientBasis, Basis.map_apply, LinearEquiv.apply_symm_apply,
    generatorQuotientEquiv_mk]
  exact (minimalCoefficientMap_monomial_one E e).symm

theorem generatorQuotient_finite
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    Module.Finite K (GeneratorQuotient (monomialIdeal (R := K) S)) :=
  Module.Finite.equiv (generatorQuotientEquiv S hUp E hMin hSpan).symm

theorem finrank_generatorQuotient
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    Module.finrank K (GeneratorQuotient (monomialIdeal (R := K) S)) = E.card := by
  rw [(generatorQuotientEquiv S hUp E hMin hSpan).finrank_eq]
  simp only [Module.finrank_fintype_fun_eq_card, Fintype.card_coe]

/-- The dimension of the actual quotient equals the least size of an
arbitrary finite polynomial generating set, by the already proved lower bound. -/
theorem generatorQuotient_finrank_isLeast
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    IsLeast (generatorCardinalities (monomialIdeal (R := K) S))
      (Module.finrank K (GeneratorQuotient (monomialIdeal (R := K) S))) := by
  rw [finrank_generatorQuotient S hUp E hMin hSpan]
  exact isLeast_generatorCardinalities_of_minimal_exponents S hUp E hMin hSpan

/-- Actual quotient dimension, least generator number, and the strict and
harmonic width bounds under the original finite-colength lex hypotheses. -/
theorem finiteColength_generatorQuotient_bounds
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ a : ℕ, 2 ≤ a ∧
      monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      Module.Finite K (GeneratorQuotient (monomialIdeal (R := K) S)) ∧
      Module.finrank K (GeneratorQuotient (monomialIdeal (R := K) S)) =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      IsLeast (generatorCardinalities (monomialIdeal (R := K) S))
        (Module.finrank K (GeneratorQuotient (monomialIdeal (R := K) S))) ∧
      Module.finrank K (GeneratorQuotient (monomialIdeal (R := K) S)) <
        (w + 1).choose 2 ∧
      (Module.finrank K (GeneratorQuotient (monomialIdeal (R := K) S)) : ℚ) ≤
        4 * (w : ℚ) - 1 + ((2 * w - 1 : ℕ) : ℚ) * Growth.harmonicQ (2 * w - 1) := by
  obtain ⟨a, E, ha, hx, hInitial, hClassify, hSpan, hCard, hStrict, _⟩ :=
    finiteColength_exists_exact_minimal_generators S hUp hLex hOne hw hBudget
  have hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e :=
    fun e he => (hClassify e).mp he
  have hDim := finrank_generatorQuotient S hUp E hMin hSpan
  have hDimXY : Module.finrank K (GeneratorQuotient (monomialIdeal (R := K) S)) =
      a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) := by
    rw [hDim]
    simpa only [card_exponentMonomials] using hCard
  refine ⟨a, ha, hx, hInitial, generatorQuotient_finite S hUp E hMin hSpan,
    hDimXY, generatorQuotient_finrank_isLeast S hUp E hMin hSpan, ?_, ?_⟩
  · rw [hDimXY]
    rwa [hCard] at hStrict
  · rw [hDimXY, finrank_xySubspace S hUp hLex hw hBudget]
    exact generator_expression_le_harmonic (monomialIdeal_standardLex S hUp hLex)
      hw ha hInitial (not_not.mpr hx) (hilbertBudget_of_finrankBudget S hUp w hBudget)

#print axioms ker_generatorCoefficientMap
#print axioms generatorQuotientEquiv
#print axioms generatorQuotientBasis_apply
#print axioms finrank_generatorQuotient
#print axioms finiteColength_generatorQuotient_bounds

end

end WidthBounds.MonomialInterface
