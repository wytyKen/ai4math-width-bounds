import WidthBounds.FiniteMonomialPresentation

/-!
# Residue tensor and rank of a finite monomial presentation

This module integrates the actual finite free presentation with residue
tensoring and the existing lex generator count. It does not construct a
second differential or a finite projective resolution.
-/

namespace WidthBounds.MonomialPresentation

noncomputable section

open CategoryTheory CategoryTheory.Limits MvPolynomial Module Finset MonomialInterface
open scoped TensorProduct

variable {K : Type*} [Field K]

/-- The genuine left residue tensor of the first differential, over A. -/
def tensorDifferential (E : Finset (Fin 3 →₀ ℕ)) :
    ((Ring K ⧸ variableIdeal (K := K)) ⊗[Ring K] FreeModule K E) →ₗ[Ring K]
      ((Ring K ⧸ variableIdeal (K := K)) ⊗[Ring K] Ring K) :=
  (differential (K := K) E).lTensor (Ring K ⧸ variableIdeal (K := K))

@[simp]
theorem tensorDifferential_tmul (E : Finset (Fin 3 →₀ ℕ))
    (q : Ring K ⧸ variableIdeal (K := K)) (c : FreeModule K E) :
    tensorDifferential (K := K) E (q ⊗ₜ[Ring K] c) = q ⊗ₜ[Ring K] differential (K := K) E c :=
  LinearMap.lTensor_tmul (Ring K ⧸ variableIdeal (K := K))
    (differential (K := K) E) q c

@[simp]
theorem tensorDifferential_tmul_freeBasis (E : Finset (Fin 3 →₀ ℕ))
    (q : Ring K ⧸ variableIdeal (K := K)) (e : E) :
    tensorDifferential (K := K) E (q ⊗ₜ[Ring K] freeBasis (K := K) E e) =
      q ⊗ₜ[Ring K] MvPolynomial.monomial e.val (1 : K) := by
  rw [tensorDifferential_tmul, differential_freeBasis]

/-- The categorical residue tensor sends d1 to zero under the actual ideal
containment. No assertion about the syzygy inclusion is made. -/
theorem residueTensorFunctor_map_differential_eq_zero
    (E : Finset (Fin 3 →₀ ℕ)) (I : Ideal (Ring K))
    (hSpan : Ideal.span (exponentMonomials (R := K) E : Set (Ring K)) = I)
    (hI : I ≤ variableIdeal (K := K)) :
    (residueTensorFunctor (K := K)).map (differentialMap (K := K) E) = 0 := by
  rw [← mapToIdeal_comp_inclusion E I hSpan, Functor.map_comp,
    residueTensorFunctor_map_inclusion_eq_zero I hI, comp_zero]

theorem tensorDifferential_eq_zero
    (E : Finset (Fin 3 →₀ ℕ)) (I : Ideal (Ring K))
    (hSpan : Ideal.span (exponentMonomials (R := K) E : Set (Ring K)) = I)
    (hI : I ≤ variableIdeal (K := K)) : tensorDifferential (K := K) E = 0 := by
  exact congrArg (fun f => f.hom)
    (residueTensorFunctor_map_differential_eq_zero E I hSpan hI)

/-- Restriction uses the existing coefficient-field scalar tower. -/
def tensorDifferentialK (E : Finset (Fin 3 →₀ ℕ)) :
    ((Ring K ⧸ variableIdeal (K := K)) ⊗[Ring K] FreeModule K E) →ₗ[K]
      ((Ring K ⧸ variableIdeal (K := K)) ⊗[Ring K] Ring K) :=
  (tensorDifferential (K := K) E).restrictScalars K

@[simp]
theorem tensorDifferentialK_tmul (E : Finset (Fin 3 →₀ ℕ))
    (q : Ring K ⧸ variableIdeal (K := K)) (c : FreeModule K E) :
    tensorDifferentialK (K := K) E (q ⊗ₜ[Ring K] c) = q ⊗ₜ[Ring K] differential (K := K) E c :=
  tensorDifferential_tmul E q c

theorem tensorDifferentialK_eq_zero
    (E : Finset (Fin 3 →₀ ℕ)) (I : Ideal (Ring K))
    (hSpan : Ideal.span (exponentMonomials (R := K) E : Set (Ring K)) = I)
    (hI : I ≤ variableIdeal (K := K)) : tensorDifferentialK (K := K) E = 0 := by
  simp only [tensorDifferentialK, tensorDifferential_eq_zero E I hSpan hI]
  rfl

/-- The finite free term has the expected rank over the polynomial ring.
This is not a claim that it is finite dimensional over the coefficient field. -/
theorem generatorFree_finrank (E : Finset (Fin 3 →₀ ℕ)) :
    Module.finrank (MvPolynomial (Fin 3) K) (E → MvPolynomial (Fin 3) K) = E.card := by
  simp

/-- A complete minimal monomial index set gives the actual free-term rank
in the finite-colength lex model. The rank is over the polynomial ring. -/
theorem finiteColength_generatorFree_rank
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
      Module.finrank (MvPolynomial (Fin 3) K) (E → MvPolynomial (Fin 3) K) =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank (MvPolynomial (Fin 3) K) (E → MvPolynomial (Fin 3) K) <
        (w + 1).choose 2 := by
  obtain ⟨a, E, ha, hx, hInitial, hClassify, hSpan, hCard, hStrict, _⟩ :=
    finiteColength_exists_exact_minimal_generators S hUp hLex hOne hw hBudget
  refine ⟨a, E, ha, hx, hInitial, hClassify, hSpan, ?_, ?_⟩
  · simpa only [generatorFree_finrank, card_exponentMonomials] using hCard
  · simpa only [generatorFree_finrank, card_exponentMonomials] using hStrict

/-- The original actual lex model admits a finite free presentation with
the counted rank and a zero residue-tensored first differential. This does
not assert a basis or freeness for the first syzygy module. -/
theorem finiteColength_presentation_bounds
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ (a : ℕ) (E : Finset (Fin 3 →₀ ℕ))
      (hSpan : Ideal.span (exponentMonomials (R := K) E : Set (Ring K)) = monomialIdeal S),
      2 ≤ a ∧ monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      (∀ e, e ∈ E ↔ IsMinimalExponent (monomialIdeal (R := K) S) e) ∧
      (presentation E (monomialIdeal S) hSpan).Exact ∧
      Function.Surjective (differentialIntoIdeal E (monomialIdeal S) hSpan) ∧
      Module.finrank (Ring K) (FreeModule K E) =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank (Ring K) (FreeModule K E) < (w + 1).choose 2 ∧
      tensorDifferentialK (K := K) E = 0 := by
  obtain ⟨a, E, ha, hx, hInitial, hClassify, hSpan, hRank, hStrict⟩ :=
    finiteColength_generatorFree_rank S hUp hLex hOne hw hBudget
  refine ⟨a, E, hSpan, ha, hx, hInitial, hClassify,
    presentation_exact E _ hSpan, differentialIntoIdeal_surjective E _ hSpan,
    hRank, hStrict, ?_⟩
  exact tensorDifferentialK_eq_zero E _ hSpan
    (monomialIdeal_le_variableIdeal_of_x_standard S hUp hOne)

#print axioms generatorFree_finrank
#print axioms finiteColength_generatorFree_rank
#print axioms tensorDifferential_tmul
#print axioms tensorDifferential_tmul_freeBasis
#print axioms residueTensorFunctor_map_differential_eq_zero
#print axioms tensorDifferentialK_eq_zero
#print axioms finiteColength_presentation_bounds

end

end WidthBounds.MonomialPresentation
