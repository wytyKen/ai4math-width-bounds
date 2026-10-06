import WidthBounds.GeneratorTensorFiber
import WidthBounds.VariableResidue

/-!
# Bases and width bounds for the actual residue tensor fiber

All tensors are over the polynomial ring, and all dimensions are over the
coefficient field. The first factor is the actual quotient by the variable
ideal. This module does not identify the fiber with a Tor group.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Module Finset
open scoped TensorProduct

variable {K : Type*} [Field K]

/-- If `x` is standard, the actual monomial ideal lies in the variable ideal.
This proves a containment needed by a future low-degree Tor interface, without
asserting any derived-functor identification. No lex or budget condition is needed. -/
theorem monomialIdeal_le_variableIdeal_of_x_standard
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S)
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0) :
    monomialIdeal (R := K) S ≤ variableIdeal := by
  intro p hp
  apply (mem_variableIdeal_iff_constantCoeff_eq_zero p).mpr
  by_contra hCoeff
  have hSupport : (0 : Fin 3 →₀ ℕ) ∈ p.support :=
    mem_support_iff.mpr hCoeff
  have hZeroS := (mem_monomialIdeal_iff_support S hUp p).mp hp 0 hSupport
  have hZero : monomial3 0 0 0 ∈ monomialIdeal (R := K) S := by
    have hz := (monomial_mem_monomialIdeal_iff (R := K) S hUp 0).mpr hZeroS
    simpa only [monomial3, exponent, Finsupp.single_zero, add_zero] using hz
  exact hOne (monomial3_mem_of_le _ (by omega) le_rfl le_rfl hZero)

/-- Minimal exponent coordinates on the actual tensor fiber. -/
def generatorTensorCoordinates
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    GeneratorTensorFiber (monomialIdeal (R := K) S) ≃ₗ[K] (↥E → K) :=
  (generatorTensorEquiv (monomialIdeal (R := K) S)).trans
    (generatorQuotientEquiv S hUp E hMin hSpan)

/-- On a pure tensor, minimal coordinates are scaled by the constant term
of the residue representative. The tensor remains over the polynomial ring. -/
theorem generatorTensorCoordinates_mk_tmul
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (q : MvPolynomial (Fin 3) K) (p : monomialIdeal (R := K) S) :
    generatorTensorCoordinates S hUp E hMin hSpan
      (Ideal.Quotient.mk (variableIdeal (K := K)) q ⊗ₜ[MvPolynomial (Fin 3) K] p) =
      constantCoeff q • minimalCoefficientMap E p.val := by
  simp only [generatorTensorCoordinates, LinearEquiv.trans_apply,
    generatorTensorEquiv_mk_tmul]
  exact minimalCoefficientMap_mul S hUp E hMin p.property q

/-- The same formula on an arbitrary residue class, using the proved
coefficient-field algebra identification of the actual residue ring. -/
theorem generatorTensorCoordinates_tmul
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (q : MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K))
    (p : monomialIdeal (R := K) S) :
    generatorTensorCoordinates S hUp E hMin hSpan
      (q ⊗ₜ[MvPolynomial (Fin 3) K] p) =
      variableResidueEquiv q • minimalCoefficientMap E p.val := by
  obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective q
  simpa only [variableResidueEquiv_mk] using
    generatorTensorCoordinates_mk_tmul S hUp E hMin hSpan r p

/-- A basis of the actual tensor product, transported through its proved
linear equivalence with the actual generator quotient. -/
def generatorTensorBasis
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    Basis ↥E K (GeneratorTensorFiber (monomialIdeal (R := K) S)) :=
  (generatorQuotientBasis S hUp E hMin hSpan).map
    (generatorTensorEquiv (monomialIdeal (R := K) S)).symm

/-- The basis elements are exactly `1 tensor g`, for the original minimal
coefficient-one monomial generators `g`. -/
theorem generatorTensorBasis_apply
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) (e : ↥E) :
    generatorTensorBasis S hUp E hMin hSpan e =
      (1 : MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)) ⊗ₜ[MvPolynomial (Fin 3) K]
        (⟨monomial e.val (1 : K), (hMin e.val e.property).1⟩ : monomialIdeal (R := K) S) := by
  apply (generatorTensorEquiv (monomialIdeal (R := K) S)).injective
  simp only [generatorTensorBasis, Basis.map_apply, LinearEquiv.apply_symm_apply,
    generatorTensorEquiv_one_tmul]
  exact generatorQuotientBasis_apply S hUp E hMin hSpan e

theorem finrank_generatorTensor_eq_quotient
    (I : Ideal (MvPolynomial (Fin 3) K)) :
    Module.finrank K (GeneratorTensorFiber I) = Module.finrank K (GeneratorQuotient I) :=
  (generatorTensorEquiv I).finrank_eq

theorem generatorTensor_finite
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    Module.Finite K (GeneratorTensorFiber (monomialIdeal (R := K) S)) :=
  Module.Finite.equiv (generatorTensorCoordinates S hUp E hMin hSpan).symm

theorem finrank_generatorTensor
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    Module.finrank K (GeneratorTensorFiber (monomialIdeal (R := K) S)) = E.card := by
  rw [finrank_generatorTensor_eq_quotient]
  exact finrank_generatorQuotient S hUp E hMin hSpan

theorem generatorTensor_finrank_isLeast
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S) :
    IsLeast (generatorCardinalities (monomialIdeal (R := K) S))
      (Module.finrank K (GeneratorTensorFiber (monomialIdeal (R := K) S))) := by
  rw [finrank_generatorTensor_eq_quotient]
  exact generatorQuotient_finrank_isLeast S hUp E hMin hSpan

/-- The actual tensor fiber is finite-dimensional and its dimension is the
least polynomial generator number, with the established width bounds. -/
theorem finiteColength_generatorTensor_bounds
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ a : ℕ, 2 ≤ a ∧
      monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      Module.Finite K (GeneratorTensorFiber (monomialIdeal (R := K) S)) ∧
      Module.finrank K (GeneratorTensorFiber (monomialIdeal (R := K) S)) =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      IsLeast (generatorCardinalities (monomialIdeal (R := K) S))
        (Module.finrank K (GeneratorTensorFiber (monomialIdeal (R := K) S))) ∧
      Module.finrank K (GeneratorTensorFiber (monomialIdeal (R := K) S)) <
        (w + 1).choose 2 ∧
      (Module.finrank K (GeneratorTensorFiber (monomialIdeal (R := K) S)) : ℚ) ≤
        4 * (w : ℚ) - 1 + ((2 * w - 1 : ℕ) : ℚ) * Growth.harmonicQ (2 * w - 1) := by
  obtain ⟨a, ha, hx, hInitial, hFinite, hDim, hLeast, hStrict, hHarm⟩ :=
    finiteColength_generatorQuotient_bounds S hUp hLex hOne hw hBudget
  letI := hFinite
  have hTensorFinite : Module.Finite K (GeneratorTensorFiber (monomialIdeal (R := K) S)) :=
    Module.Finite.equiv (generatorTensorEquiv (monomialIdeal (R := K) S)).symm
  refine ⟨a, ha, hx, hInitial, hTensorFinite, ?_, ?_, ?_, ?_⟩
  · rwa [finrank_generatorTensor_eq_quotient]
  · rwa [finrank_generatorTensor_eq_quotient]
  · rwa [finrank_generatorTensor_eq_quotient]
  · rwa [finrank_generatorTensor_eq_quotient]

#print axioms generatorTensorBasis_apply
#print axioms generatorTensorCoordinates_tmul
#print axioms monomialIdeal_le_variableIdeal_of_x_standard
#print axioms finrank_generatorTensor
#print axioms finiteColength_generatorTensor_bounds

end

end WidthBounds.MonomialInterface
