import WidthBounds.MonomialFirstSyzygies

/-! Total degrees and residue coefficients of the actual boundary relations. -/

noncomputable section

namespace WidthBounds.MonomialPresentation

open MvPolynomial Finset MonomialInterface
open scoped TensorProduct

universe u

variable {K : Type u} [Field K]

def coordinateTotal (e : Fin 3 →₀ ℕ) : ℕ := e 0 + e 1 + e 2

@[simp] theorem coordinateTotal_exponent (i j k : ℕ) :
    coordinateTotal (exponent i j k) = i + j + k := by
  simp [coordinateTotal]

theorem coordinateTotal_mono {e f : Fin 3 →₀ ℕ} (h : e ≤ f) :
    coordinateTotal e ≤ coordinateTotal f :=
  Nat.add_le_add (Nat.add_le_add (h 0) (h 1)) (h 2)

@[simp] theorem coordinateTotal_add (e f : Fin 3 →₀ ℕ) :
    coordinateTotal (e + f) = coordinateTotal e + coordinateTotal f := by
  simp only [coordinateTotal, Finsupp.add_apply]
  omega

theorem boundaryRelationDegree_total (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (s : BoundaryRelationIndex a n) :
    coordinateTotal (boundaryRelationDegree I hZ a n s) =
      coordinateTotal (boundaryRelationSource I hZ a n s).val + 1 := by
  rcases s with i | ⟨⟨i, j⟩, q⟩
  · simp [boundaryRelationDegree, boundaryRelationSource]
    omega
  · dsimp [boundaryRelationDegree, boundaryRelationSource]
    split_ifs <;> simp only [coordinateTotal_exponent] <;> omega

theorem canonicalBoundaryExponent_congr_xy (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    {d e : Fin 3 →₀ ℕ} (h0 : d 0 = e 0) (h1 : d 1 = e 1) :
    canonicalBoundaryExponent I hZ a n d = canonicalBoundaryExponent I hZ a n e := by
  simp only [canonicalBoundaryExponent, h0, h1]

/-- Lex closure replaces one positive z exponent by x or y. The canonical
boundary of either adjacent multidegree therefore has no larger total degree. -/
theorem boundaryRelationTarget_total_le (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (s : BoundaryRelationIndex a n) :
    coordinateTotal (boundaryRelationTarget I hZ a n s).val ≤
      coordinateTotal (boundaryRelationSource I hZ a n s).val := by
  rcases s with i | ⟨⟨i, j⟩, q⟩
  · have hp := column_pos_of_initial I n hn hInitial i.isLt
    change coordinateTotal (canonicalBoundaryExponent I hZ a n
      (exponent (i.val + 1) (n i) 0)) ≤ coordinateTotal (exponent i (n i) 0)
    simp only [canonicalBoundaryExponent, exponent_zero, exponent_one]
    split_ifs with hi hj
    · simp only [coordinateTotal_exponent]
      omega
    · have hc := column_strictAnti_of_initial I hLex n hn hInitial
        (show i.val < i.val + 1 by omega) (show i.val + 1 < a by omega)
      simp only [coordinateTotal_exponent]
      omega
    · have hc := column_strictAnti_of_initial I hLex n hn hInitial
        (show i.val < i.val + 1 by omega) (show i.val + 1 < a by omega)
      omega
  · have hp := zThreshold_pos_of_standard I hZ ((hn i j).mpr j.isLt)
    have hm := zThreshold_mem I hZ i j
    change coordinateTotal (canonicalBoundaryExponent I hZ a n
      (boundaryRelationDegree I hZ a n (Sum.inr ⟨⟨i, j⟩, q⟩))) ≤
      coordinateTotal (exponent i j (zThreshold I hZ i j))
    by_cases hq : q = 0
    · have hmove : monomial3 (i.val + 1) j (zThreshold I hZ i j - 1) ∈ I :=
        hLex (by omega) (Or.inl (by omega)) hm
      have hle := canonicalBoundaryExponent_le I hZ a n _ hmove
      have heq := canonicalBoundaryExponent_congr_xy I hZ a n
        (d := exponent (i.val + 1) j (zThreshold I hZ i j))
        (e := exponent (i.val + 1) j (zThreshold I hZ i j - 1))
        (by simp) (by simp)
      simp only [boundaryRelationDegree, hq, ↓reduceIte, heq]
      have := coordinateTotal_mono hle
      simp only [coordinateTotal_exponent] at this ⊢
      omega
    · have hmove : monomial3 i (j.val + 1) (zThreshold I hZ i j - 1) ∈ I :=
        hLex (by omega) (Or.inr ⟨rfl, by omega⟩) hm
      have hle := canonicalBoundaryExponent_le I hZ a n _ hmove
      have heq := canonicalBoundaryExponent_congr_xy I hZ a n
        (d := exponent i (j.val + 1) (zThreshold I hZ i j))
        (e := exponent i (j.val + 1) (zThreshold I hZ i j - 1))
        (by simp) (by simp)
      simp only [boundaryRelationDegree, hq, ↓reduceIte, heq]
      have := coordinateTotal_mono hle
      simp only [coordinateTotal_exponent] at this ⊢
      omega

theorem monomial_sub_mem_variableIdeal_of_total_lt {d e : Fin 3 →₀ ℕ}
    (hlt : coordinateTotal e < coordinateTotal d) :
    monomial (d - e) (1 : K) ∈ variableIdeal := by
  apply monomial_mem_variableIdeal_of_ne_zero
  intro hz
  have hle : d ≤ e := tsub_eq_zero_iff_le.mp hz
  have := coordinateTotal_mono hle
  omega

/-- Every entry of every actual second differential column lies in the
variable ideal. The strictness comes from the proved lex degree control. -/
theorem boundaryRelation_apply_mem_variableIdeal (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (s : BoundaryRelationIndex a n) (u : boundaryExponents I hZ a n) :
    boundaryRelation I hZ a n s u ∈ variableIdeal := by
  classical
  have hdeg := boundaryRelationDegree_total I hZ a n s
  have ht := boundaryRelationTarget_total_le I hZ a n hLex hn hInitial s
  have hsMem : monomial (boundaryRelationDegree I hZ a n s -
      (boundaryRelationSource I hZ a n s).val) (1 : K) ∈ variableIdeal :=
    monomial_sub_mem_variableIdeal_of_total_lt (by omega)
  have htMem : monomial (boundaryRelationDegree I hZ a n s -
      (boundaryRelationTarget I hZ a n s).val) (1 : K) ∈ variableIdeal :=
    monomial_sub_mem_variableIdeal_of_total_lt (by omega)
  dsimp only [boundaryRelation, commonRelation, Pi.sub_apply]
  apply (variableIdeal (K := K)).sub_mem
  · by_cases hu : u = boundaryRelationSource I hZ a n s
    · rw [hu, Pi.single_eq_same]
      exact hsMem
    · simp only [Pi.single_eq_of_ne hu, Submodule.zero_mem]
  · by_cases hu : u = boundaryRelationTarget I hZ a n s
    · rw [hu, Pi.single_eq_same]
      exact htMem
    · simp only [Pi.single_eq_of_ne hu, Submodule.zero_mem]

theorem secondDifferential_apply_mem_variableIdeal (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (c : BoundaryRelationIndex a n → Ring K) (u : boundaryExponents I hZ a n) :
    secondDifferential I hZ a n c u ∈ variableIdeal := by
  classical
  change (∑ s, c s • boundaryRelation I hZ a n s) u ∈ variableIdeal
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  apply (variableIdeal (K := K)).sum_mem
  intro s _
  exact (variableIdeal (K := K)).mul_mem_left (c s)
    (boundaryRelation_apply_mem_variableIdeal I hZ a n hLex hn hInitial s u)

theorem residue_smul_eq_zero_of_mem_variableIdeal
    (q : Ring K ⧸ variableIdeal (K := K)) {p : Ring K} (hp : p ∈ variableIdeal) :
    p • q = 0 := by
  obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective q
  change Ideal.Quotient.mk (variableIdeal (K := K)) (p * r) = 0
  exact Ideal.Quotient.eq_zero_iff_mem.mpr
    ((variableIdeal (K := K)).mul_mem_right r hp)

theorem residue_tmul_eq_zero_of_coordinates_mem_variableIdeal
    {ι : Type*} [Fintype ι]
    (q : Ring K ⧸ variableIdeal (K := K)) (v : ι → Ring K)
    (hv : ∀ i, v i ∈ variableIdeal) :
    q ⊗ₜ[Ring K] v = 0 := by
  classical
  have heq : v = ∑ i : ι, v i • Pi.single i (1 : Ring K) := by
    ext i
    simp [Pi.single_apply, smul_eq_mul]
  rw [heq, TensorProduct.tmul_sum]
  apply Finset.sum_eq_zero
  intro i _
  rw [← TensorProduct.smul_tmul,
    residue_smul_eq_zero_of_mem_variableIdeal q (hv i), TensorProduct.zero_tmul]

/-- A map to an actual finite free module whose entries lie in the variable
ideal becomes the zero linear map after tensoring by the residue ring. -/
theorem lTensor_eq_zero_of_coordinates_mem_variableIdeal
    {M : Type*} [AddCommGroup M] [Module (Ring K) M]
    {ι : Type*} [Fintype ι] (f : M →ₗ[Ring K] (ι → Ring K))
    (hf : ∀ m i, f m i ∈ variableIdeal) :
    f.lTensor (Ring K ⧸ variableIdeal (K := K)) = 0 := by
  apply TensorProduct.ext'
  intro q m
  exact residue_tmul_eq_zero_of_coordinates_mem_variableIdeal q (f m) (hf m)

theorem residueTensorFunctor_map_eq_zero_of_coordinates_mem_variableIdeal
    {M : Type u} [AddCommGroup M] [Module (Ring K) M]
    {ι : Type} [Fintype ι] (f : M →ₗ[Ring K] (ι → Ring K))
    (hf : ∀ m i, f m i ∈ variableIdeal) :
    (residueTensorFunctor (K := K)).map
      (ModuleCat.ofHom f : ModuleCat.of (Ring K) M ⟶
        ModuleCat.of (Ring K) (ι → Ring K)) = 0 := by
  apply ModuleCat.hom_ext
  exact lTensor_eq_zero_of_coordinates_mem_variableIdeal f hf

theorem secondDifferential_lTensor_eq_zero (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    (secondDifferential I hZ a n).lTensor (Ring K ⧸ variableIdeal (K := K)) = 0 :=
  lTensor_eq_zero_of_coordinates_mem_variableIdeal _
    (secondDifferential_apply_mem_variableIdeal I hZ a n hLex hn hInitial)

theorem residueTensorFunctor_map_secondDifferential_eq_zero (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    (residueTensorFunctor (K := K)).map (secondDifferentialMap I hZ a n) = 0 := by
  apply ModuleCat.hom_ext
  exact secondDifferential_lTensor_eq_zero I hZ a n hLex hn hInitial

#print axioms boundaryRelationDegree_total
#print axioms boundaryRelationTarget_total_le
#print axioms boundaryRelation_apply_mem_variableIdeal
#print axioms residue_tmul_eq_zero_of_coordinates_mem_variableIdeal
#print axioms lTensor_eq_zero_of_coordinates_mem_variableIdeal
#print axioms residueTensorFunctor_map_secondDifferential_eq_zero

end WidthBounds.MonomialPresentation
