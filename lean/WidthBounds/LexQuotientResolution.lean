import WidthBounds.FiniteThreeResolution
import WidthBounds.BoundaryThirdDifferential

/-! Actual finite lex quotient resolutions. Concrete d3 data are supplied
by BoundaryThirdDifferential, not by unproved exactness assumptions. -/

noncomputable section

namespace WidthBounds.MonomialPresentation

open CategoryTheory CategoryTheory.Limits MvPolynomial Finset MonomialInterface
open scoped ZeroObject

variable {K : Type*} [Field K]
variable (I : Ideal (Ring K)) (hZ : ∃ b, monomial3 0 0 b ∈ I)
    (a : ℕ) (n : ℕ → ℕ) (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (hSpan : Ideal.span (exponentMonomials (R := K)
      (boundaryExponents I hZ a n) : Set (Ring K)) = I)

/-- A standard projective resolution of the actual quotient. Every
exactness and monomorphism input is supplied by the concrete boundary maps. -/
def lexQuotientResolution : ProjectiveResolution (ModuleCat.of (Ring K) (Ring K ⧸ I)) :=
  FiniteThreeResolution.resolution
    (ModuleCat.of (Ring K) (FreeModule K (boundaryExponents I hZ a n)))
    (ModuleCat.of (Ring K) (BoundaryRelationIndex a n → Ring K))
    (ModuleCat.of (Ring K) (BoundaryFaceIndex a n → Ring K))
    (differentialMap (K := K) (boundaryExponents I hZ a n))
    (secondDifferentialMap I hZ a n)
    (lexThirdDifferentialMap I hZ a n hx hLex hn hInitial)
    (secondDifferentialMap_comp I hZ a n hx hn)
    (lexThirdDifferentialMap_comp I hZ a n hx hLex hn hInitial)
    (secondPresentation_exact I hZ a n hx hLex hn hInitial)
    (lexThird_exact I hZ a n hx hLex hn hInitial)
    I (differentialMap_comp_quotient _ I hSpan) (presentation_exact _ I hSpan)

instance lexQuotientResolution_free (j : ℕ) :
    Module.Free (Ring K) ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.X j) := by
  unfold lexQuotientResolution
  infer_instance

instance lexQuotientResolution_finite (j : ℕ) :
    Module.Finite (Ring K) ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.X j) := by
  unfold lexQuotientResolution
  infer_instance

theorem lexQuotientResolution_augmentation :
    (lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).π.f 0 = idealQuotientMap I := by
  apply FiniteThreeResolution.resolution_π_f_zero

theorem lexQuotientResolution_zero_tail (j : ℕ) :
    IsZero ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.X (j + 4)) := by
  apply FiniteThreeResolution.resolution_X_isZero_tail

theorem lexQuotientResolution_rank_zero :
    Module.finrank (Ring K)
      ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.X 0) = 1 := by
  change Module.finrank (Ring K) (Ring K) = 1
  simp

theorem lexQuotientResolution_rank_one :
    Module.finrank (Ring K)
      ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.X 1) =
        a + 1 + ∑ i ∈ range a, n i := by
  change Module.finrank (Ring K) (FreeModule K (boundaryExponents I hZ a n)) = _
  rw [generatorFree_finrank, card_boundaryExponents I hZ a n hn]

theorem lexQuotientResolution_rank_two :
    Module.finrank (Ring K)
      ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.X 2) =
        a + 2 * ∑ i ∈ range a, n i := by
  change Module.finrank (Ring K) (BoundaryRelationIndex a n → Ring K) = _
  exact boundary_secondFree_finrank a n

theorem lexQuotientResolution_rank_three :
    Module.finrank (Ring K)
      ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.X 3) =
        ∑ i ∈ range a, n i := by
  change Module.finrank (Ring K) (BoundaryFaceIndex a n → Ring K) = _
  exact boundary_thirdFree_finrank a n

/-- All differentials of the actual constructed resolution vanish after
left tensoring over A with the actual variable-ideal residue ring. -/
theorem lexQuotientResolution_residue_d_zero (hI : I ≤ variableIdeal (K := K)) (i j : ℕ) :
    (residueTensorFunctor (K := K)).map
      ((lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan).complex.d i j) = 0 := by
  unfold lexQuotientResolution
  apply FiniteThreeResolution.map_resolution_d_eq_zero
  · exact residueTensorFunctor_map_differential_eq_zero _ I hSpan hI
  · exact residueTensorFunctor_map_secondDifferential_eq_zero I hZ a n hLex hn hInitial
  · exact residueTensorFunctor_map_lexThirdDifferential_eq_zero I hZ a n hx hLex hn hInitial

omit I hZ a n hx hLex hn hInitial hSpan in
/-- The actual lex budget model has a finite free standard resolution with
the stated ranks and zero residual differentials. This does not yet identify
standard higher Tor with those residual terms. -/
theorem finiteColength_exists_residue_minimal_resolution
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (Ring K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ (a : ℕ)
      (P : ProjectiveResolution (ModuleCat.of (Ring K) (Ring K ⧸ monomialIdeal (R := K) S))),
      2 ≤ a ∧
      monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      (∀ j, Module.Free (Ring K) (P.complex.X j)) ∧
      (∀ j, Module.Finite (Ring K) (P.complex.X j)) ∧
      Module.finrank (Ring K) (P.complex.X 0) = 1 ∧
      Module.finrank (Ring K) (P.complex.X 1) =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank (Ring K) (P.complex.X 2) =
        a + 2 * Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank (Ring K) (P.complex.X 3) =
        Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      (∀ j, IsZero (P.complex.X (j + 4))) ∧
      ∀ i j, (residueTensorFunctor (K := K)).map (P.complex.d i j) = 0 := by
  obtain ⟨a, n, hZ, hx, hn, hInitial, hSpan, ha, _, _, _, _, _, hRank₁, _, _⟩ :=
    finiteColength_second_presentation_bounds S hUp hLex hOne hw hBudget
  let I := monomialIdeal (R := K) S
  have hLI : IsLex I := monomialIdeal_isLex S hUp hLex
  have hI : I ≤ variableIdeal (K := K) := monomialIdeal_le_variableIdeal_of_x_standard S hUp hOne
  let P := lexQuotientResolution I hZ a n hx hLI hn hInitial hSpan
  have hSum : (∑ i ∈ range a, n i) = Module.finrank K (xySubspace I) := by
    have hr : Module.finrank (Ring K) (FreeModule K (boundaryExponents I hZ a n)) =
        a + 1 + ∑ i ∈ range a, n i := by
      rw [generatorFree_finrank, card_boundaryExponents I hZ a n hn]
    exact Nat.add_left_cancel (hr.symm.trans hRank₁)
  refine ⟨a, P, ha, hx, hInitial, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro j
    exact lexQuotientResolution_free I hZ a n hx hLI hn hInitial hSpan j
  · intro j
    exact lexQuotientResolution_finite I hZ a n hx hLI hn hInitial hSpan j
  · exact lexQuotientResolution_rank_zero I hZ a n hx hLI hn hInitial hSpan
  · simpa only [hSum] using lexQuotientResolution_rank_one I hZ a n hx hLI hn hInitial hSpan
  · simpa only [hSum] using lexQuotientResolution_rank_two I hZ a n hx hLI hn hInitial hSpan
  · simpa only [hSum] using lexQuotientResolution_rank_three I hZ a n hx hLI hn hInitial hSpan
  · intro j
    exact lexQuotientResolution_zero_tail I hZ a n hx hLI hn hInitial hSpan j
  · intro i j
    exact lexQuotientResolution_residue_d_zero I hZ a n hx hLI hn hInitial hSpan hI i j

#print axioms lexQuotientResolution
#print axioms lexQuotientResolution_augmentation
#print axioms lexQuotientResolution_free
#print axioms lexQuotientResolution_finite
#print axioms lexQuotientResolution_zero_tail
#print axioms lexQuotientResolution_residue_d_zero
#print axioms finiteColength_exists_residue_minimal_resolution

end WidthBounds.MonomialPresentation
