import WidthBounds.BoundaryResolutionDegree
import WidthBounds.TriangularSecondSyzygies

/-!
# Concrete third columns from bounded boundary normalization

The normalizing coefficients constructed here have strictly controlled
support and vanish in the variable residue. They are used to build actual
third relations, rather than assuming the needed second-kernel elements.
-/

noncomputable section

namespace WidthBounds.MonomialPresentation

open MvPolynomial Finset MonomialInterface CategoryTheory CategoryTheory.Limits
open scoped TensorProduct

variable {K : Type*} [Field K]

theorem normalization_gap_mem_variableIdeal (d δ : Fin 3 →₀ ℕ)
    (h : coordinateTotal d < coordinateTotal δ) :
    monomial (δ - d) (1 : K) ∈ variableIdeal (K := K) := by
  apply monomial_mem_variableIdeal_of_ne_zero
  intro hz
  have hle : δ ≤ d := tsub_eq_zero_iff_le.mp hz
  have := coordinateTotal_mono hle
  omega

/-- Normalization at a sufficiently high multidegree has coefficients in
the variable ideal and uses only sources of no greater boundary height. -/
theorem exists_normalizingCoefficients (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (δ : Fin 3 →₀ ℕ) (B : ℕ) (hδ : B + 1 < coordinateTotal δ)
    (u : boundaryExponents I hZ a n) (hu : u.val ≤ δ)
    (hub : coordinateTotal u.val ≤ B) :
    ∃ c : BoundaryRelationIndex a n → Ring K,
      secondDifferential I hZ a n c =
        commonRelation (K := K) (boundaryExponents I hZ a n) δ u
          (canonicalBoundary I hZ a n δ) ∧
      (∀ r, boundaryHeight a n u.val <
        boundaryHeight a n (boundaryRelationSource I hZ a n r).val → c r = 0) ∧
      ∀ r, c r ∈ variableIdeal (K := K) := by
  classical
  let P : ℕ → Prop := fun m => ∀ u : boundaryExponents I hZ a n,
    boundaryHeight a n u.val = m → u.val ≤ δ → coordinateTotal u.val ≤ B →
      ∃ c : BoundaryRelationIndex a n → Ring K,
        secondDifferential I hZ a n c =
          commonRelation (K := K) (boundaryExponents I hZ a n) δ u
            (canonicalBoundary I hZ a n δ) ∧
        (∀ r, m < boundaryHeight a n (boundaryRelationSource I hZ a n r).val → c r = 0) ∧
        ∀ r, c r ∈ variableIdeal (K := K)
  have hP : ∀ m, P m := by
    intro m
    induction m using Nat.strong_induction_on with
    | h m ih =>
      intro u hm hud hub
      by_cases hc : u = canonicalBoundary I hZ a n δ
      · refine ⟨0, ?_, ?_, ?_⟩
        · simp [hc, commonRelation]
        · simp
        · simp
      · obtain ⟨s, hs, hsd⟩ := exists_boundary_step I hZ a n δ u hud hc
        have ht := boundaryRelationTarget_le_degree I hZ a n hx hn s
        have hlt : boundaryHeight a n (boundaryRelationTarget I hZ a n s).val < m := by
          simpa only [hs, hm] using
            boundaryRelationTarget_height_lt I hZ a n hLex hn hInitial s
        have htb : coordinateTotal (boundaryRelationTarget I hZ a n s).val ≤ B := by
          have hg := boundaryRelationTarget_total_le I hZ a n hLex hn hInitial s
          rw [hs] at hg
          exact hg.trans hub
        obtain ⟨c, hcmap, hcsupport, hcmem⟩ :=
          ih _ hlt (boundaryRelationTarget I hZ a n s) rfl (ht.trans hsd) htb
        let q : Ring K := monomial (δ - boundaryRelationDegree I hZ a n s) 1
        have hq : q ∈ variableIdeal (K := K) := by
          apply normalization_gap_mem_variableIdeal
          rw [boundaryRelationDegree_total, hs]
          omega
        refine ⟨Pi.single s q + c, ?_, ?_, ?_⟩
        · rw [map_add, secondDifferential_single, hcmap]
          dsimp only [q, boundaryRelation]
          rw [commonRelation_smul _ _ _ _ _
            (boundaryRelationSource_le_degree I hZ a n s) ht hsd, hs]
          simp only [commonRelation, sub_add_sub_cancel]
        · intro r hr
          have hrs : r ≠ s := by
            intro he
            subst r
            rw [hs, hm] at hr
            omega
          have hz := hcsupport r (hlt.trans hr)
          simp [hrs, hz]
        · intro r
          apply (variableIdeal (K := K)).add_mem
          · by_cases hrs : r = s
            · subst r
              simpa using hq
            · simp [hrs]
          · exact hcmem r
  exact hP _ u rfl hu hub

def faceDegree (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (p : BoundaryFaceIndex a n) : Fin 3 →₀ ℕ :=
  exponent (p.1.val + 1) (p.2.val + 1) (zThreshold I hZ p.1 p.2)

theorem faceDegree_x_le (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (p : BoundaryFaceIndex a n) :
    boundaryRelationDegree I hZ a n (faceX p) ≤ faceDegree I hZ a n p := by
  change exponent (p.1.val + 1) p.2.val _ ≤ exponent (p.1.val + 1) (p.2.val + 1) _
  exact exponent_le_iff.mpr ⟨le_rfl, by omega, le_rfl⟩

theorem faceDegree_y_le (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (p : BoundaryFaceIndex a n) :
    boundaryRelationDegree I hZ a n (faceY p) ≤ faceDegree I hZ a n p := by
  change exponent p.1.val (p.2.val + 1) _ ≤ exponent (p.1.val + 1) (p.2.val + 1) _
  exact exponent_le_iff.mpr ⟨by omega, le_rfl, le_rfl⟩

theorem faceDegree_gap_x (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (p : BoundaryFaceIndex a n) :
    monomial (faceDegree I hZ a n p - boundaryRelationDegree I hZ a n (faceX p))
      (1 : K) = X (1 : Fin 3) := by
  have he : faceDegree I hZ a n p - boundaryRelationDegree I hZ a n (faceX p) =
      Finsupp.single (1 : Fin 3) 1 := by
    ext i
    fin_cases i <;> simp [faceDegree, boundaryRelationDegree, faceX, exponent]
  rw [he]
  rfl

theorem faceDegree_gap_y (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (p : BoundaryFaceIndex a n) :
    monomial (faceDegree I hZ a n p - boundaryRelationDegree I hZ a n (faceY p))
      (1 : K) = X (0 : Fin 3) := by
  have he : faceDegree I hZ a n p - boundaryRelationDegree I hZ a n (faceY p) =
      Finsupp.single (0 : Fin 3) 1 := by
    ext i
    fin_cases i <;> simp [faceDegree, boundaryRelationDegree, faceY, exponent]
  rw [he]
  rfl

/-- The concrete third column exists with its actual kernel identity,
triangular leading entries and variable-ideal coefficients. -/
theorem exists_lexThirdColumn (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (p : BoundaryFaceIndex a n) :
    ∃ f : BoundaryRelationIndex a n → Ring K,
      secondDifferential I hZ a n f = 0 ∧
      (∀ r, faceHeight I hZ a n p ≤ relationHeight I hZ a n r →
        f r = if r = faceX p then X 1 else if r = faceY p then -X 0 else 0) ∧
      ∀ r, f r ∈ variableIdeal (K := K) := by
  classical
  let u := boundaryRelationSource I hZ a n (faceX p)
  let δ := faceDegree I hZ a n p
  let B := coordinateTotal u.val
  have hδ : B + 1 < coordinateTotal δ := by
    dsimp [B, u, δ, faceDegree, faceX, boundaryRelationSource]
    simp only [coordinateTotal_exponent]
    omega
  have hxD := faceDegree_x_le I hZ a n p
  have hyD := faceDegree_y_le I hZ a n p
  have htx := boundaryRelationTarget_le_degree I hZ a n hx hn (faceX p)
  have hty := boundaryRelationTarget_le_degree I hZ a n hx hn (faceY p)
  have htxB : coordinateTotal (boundaryRelationTarget I hZ a n (faceX p)).val ≤ B :=
    boundaryRelationTarget_total_le I hZ a n hLex hn hInitial (faceX p)
  have htyB : coordinateTotal (boundaryRelationTarget I hZ a n (faceY p)).val ≤ B :=
    boundaryRelationTarget_total_le I hZ a n hLex hn hInitial (faceY p)
  obtain ⟨cx, hcx, hxSupport, hxMem⟩ := exists_normalizingCoefficients
    I hZ a n hx hLex hn hInitial δ B hδ
    (boundaryRelationTarget I hZ a n (faceX p)) (htx.trans hxD) htxB
  obtain ⟨cy, hcy, hySupport, hyMem⟩ := exists_normalizingCoefficients
    I hZ a n hx hLex hn hInitial δ B hδ
    (boundaryRelationTarget I hZ a n (faceY p)) (hty.trans hyD) htyB
  have hxLow : boundaryHeight a n (boundaryRelationTarget I hZ a n (faceX p)).val <
      faceHeight I hZ a n p :=
    boundaryRelationTarget_height_lt I hZ a n hLex hn hInitial (faceX p)
  have hyLow : boundaryHeight a n (boundaryRelationTarget I hZ a n (faceY p)).val <
      faceHeight I hZ a n p :=
    boundaryRelationTarget_height_lt I hZ a n hLex hn hInitial (faceY p)
  have hxScale : (X (1 : Fin 3) : Ring K) • boundaryRelation I hZ a n (faceX p) =
      commonRelation (K := K) (boundaryExponents I hZ a n) δ u
        (boundaryRelationTarget I hZ a n (faceX p)) := by
    rw [← faceDegree_gap_x I hZ a n p]
    exact commonRelation_smul _ _ _ _ _
      (boundaryRelationSource_le_degree I hZ a n (faceX p)) htx hxD
  have hyScale : (X (0 : Fin 3) : Ring K) • boundaryRelation I hZ a n (faceY p) =
      commonRelation (K := K) (boundaryExponents I hZ a n) δ u
        (boundaryRelationTarget I hZ a n (faceY p)) := by
    rw [← faceDegree_gap_y I hZ a n p]
    exact commonRelation_smul _ _ _ _ _
      (boundaryRelationSource_le_degree I hZ a n (faceY p)) hty hyD
  let f : BoundaryRelationIndex a n → Ring K :=
    Pi.single (faceX p) (X 1) - Pi.single (faceY p) (X 0) - (cy - cx)
  refine ⟨f, ?_, ?_, ?_⟩
  · dsimp only [f]
    rw [map_sub, map_sub, map_sub, secondDifferential_single, secondDifferential_single,
      hcy, hcx, hxScale, hyScale]
    unfold commonRelation
    abel
  · intro r hr
    have hxr := hxSupport r (hxLow.trans_le hr)
    have hyr := hySupport r (hyLow.trans_le hr)
    dsimp only [f, Pi.sub_apply]
    rw [hxr, hyr]
    by_cases hrx : r = faceX p
    · subst r
      simp [faceX, faceY]
    · by_cases hry : r = faceY p
      · subst r
        simp [hrx]
      · simp [hrx, hry]
  · intro r
    apply (variableIdeal (K := K)).sub_mem
    · apply (variableIdeal (K := K)).sub_mem
      · by_cases hr : r = faceX p
        · subst r
          simp only [Pi.single_eq_same]
          apply (mem_variableIdeal_iff_constantCoeff_eq_zero _).mpr
          simp
        · simp [hr]
      · by_cases hr : r = faceY p
        · subst r
          simp only [Pi.single_eq_same]
          apply (mem_variableIdeal_iff_constantCoeff_eq_zero _).mpr
          simp
        · simp [hr]
    · exact (variableIdeal (K := K)).sub_mem (hyMem r) (hxMem r)

def lexThirdColumn (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (p : BoundaryFaceIndex a n) : BoundaryRelationIndex a n → Ring K :=
  Classical.choose (exists_lexThirdColumn I hZ a n hx hLex hn hInitial p)

theorem lexThirdColumn_spec (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (p : BoundaryFaceIndex a n) :
    secondDifferential I hZ a n (lexThirdColumn I hZ a n hx hLex hn hInitial p) = 0 ∧
      (∀ r, faceHeight I hZ a n p ≤ relationHeight I hZ a n r →
        lexThirdColumn I hZ a n hx hLex hn hInitial p r =
          if r = faceX p then X 1 else if r = faceY p then -X 0 else 0) ∧
      ∀ r, lexThirdColumn I hZ a n hx hLex hn hInitial p r ∈ variableIdeal (K := K) :=
  Classical.choose_spec (exists_lexThirdColumn I hZ a n hx hLex hn hInitial p)

theorem lexThirdColumn_triangular (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    TriangularFaces I hZ a n (lexThirdColumn I hZ a n hx hLex hn hInitial) :=
  fun p => (lexThirdColumn_spec I hZ a n hx hLex hn hInitial p).2.1

def lexThirdDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    (BoundaryFaceIndex a n → Ring K) →ₗ[Ring K] (BoundaryRelationIndex a n → Ring K) :=
  thirdDifferential (lexThirdColumn I hZ a n hx hLex hn hInitial)

theorem range_lexThirdDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    LinearMap.range (lexThirdDifferential I hZ a n hx hLex hn hInitial) =
      LinearMap.ker (secondDifferential I hZ a n) :=
  range_thirdDifferential I hZ a n hLex hn hInitial _
    (fun p => (lexThirdColumn_spec I hZ a n hx hLex hn hInitial p).1)
    (lexThirdColumn_triangular I hZ a n hx hLex hn hInitial)

theorem lexThirdDifferential_injective (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    Function.Injective (lexThirdDifferential I hZ a n hx hLex hn hInitial) :=
  thirdDifferential_injective I hZ a n _
    (lexThirdColumn_triangular I hZ a n hx hLex hn hInitial)

theorem secondDifferential_comp_lexThirdDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    (secondDifferential I hZ a n).comp
      (lexThirdDifferential I hZ a n hx hLex hn hInitial) = 0 := by
  apply LinearMap.ext
  intro b
  exact secondDifferential_thirdDifferential I hZ a n _
    (fun p => (lexThirdColumn_spec I hZ a n hx hLex hn hInitial p).1) b

def lexThirdDifferentialMap (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    ModuleCat.of (Ring K) (BoundaryFaceIndex a n → Ring K) ⟶
      ModuleCat.of (Ring K) (BoundaryRelationIndex a n → Ring K) :=
  ModuleCat.ofHom (lexThirdDifferential I hZ a n hx hLex hn hInitial)

instance lexThirdDifferentialMap_mono (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    Mono (lexThirdDifferentialMap I hZ a n hx hLex hn hInitial) :=
  (ModuleCat.mono_iff_injective _).mpr
    (lexThirdDifferential_injective I hZ a n hx hLex hn hInitial)

theorem lexThirdDifferentialMap_comp (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    lexThirdDifferentialMap I hZ a n hx hLex hn hInitial ≫
      secondDifferentialMap I hZ a n = 0 := by
  apply ModuleCat.hom_ext
  exact secondDifferential_comp_lexThirdDifferential I hZ a n hx hLex hn hInitial

theorem lexThird_exact (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    (ShortComplex.mk (lexThirdDifferentialMap I hZ a n hx hLex hn hInitial)
      (secondDifferentialMap I hZ a n)
      (lexThirdDifferentialMap_comp I hZ a n hx hLex hn hInitial)).Exact := by
  apply (ShortComplex.moduleCat_exact_iff_range_eq_ker _).mpr
  exact range_lexThirdDifferential I hZ a n hx hLex hn hInitial

theorem lexThirdDifferential_apply_mem_variableIdeal (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (c : BoundaryFaceIndex a n → Ring K) (r : BoundaryRelationIndex a n) :
    lexThirdDifferential I hZ a n hx hLex hn hInitial c r ∈ variableIdeal := by
  classical
  change (∑ p, c p • lexThirdColumn I hZ a n hx hLex hn hInitial p) r ∈ variableIdeal
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  apply (variableIdeal (K := K)).sum_mem
  intro p _
  exact (variableIdeal (K := K)).mul_mem_left (c p)
    ((lexThirdColumn_spec I hZ a n hx hLex hn hInitial p).2.2 r)

theorem residueTensorFunctor_map_lexThirdDifferential_eq_zero (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    (residueTensorFunctor (K := K)).map
      (lexThirdDifferentialMap I hZ a n hx hLex hn hInitial) = 0 :=
  residueTensorFunctor_map_eq_zero_of_coordinates_mem_variableIdeal _
    (lexThirdDifferential_apply_mem_variableIdeal I hZ a n hx hLex hn hInitial)

theorem boundary_thirdFree_finrank (a : ℕ) (n : ℕ → ℕ) :
    Module.finrank (Ring K) (BoundaryFaceIndex a n → Ring K) =
      ∑ i ∈ range a, n i := by
  rw [Module.finrank_fintype_fun_eq_card]
  simp only [BoundaryFaceIndex, Fintype.card_sigma, Fintype.card_fin]
  rw [Fin.sum_univ_eq_sum_range]

#print axioms exists_normalizingCoefficients
#print axioms exists_lexThirdColumn
#print axioms lexThirdColumn_triangular
#print axioms range_lexThirdDifferential
#print axioms lexThirdDifferential_injective
#print axioms lexThird_exact
#print axioms residueTensorFunctor_map_lexThirdDifferential_eq_zero
#print axioms boundary_thirdFree_finrank

end WidthBounds.MonomialPresentation
