import WidthBounds.FiniteMonomialPresentation
import WidthBounds.FinitePresentationBounds
import WidthBounds.MonomialRelationSpan
import WidthBounds.BoundarySyzygies

/-!
# A second differential from actual monomial relations

The source is a finite free module on explicitly specified relations. Its
range is identified with the actual first differential's kernel only after
the relation-generating theorem has been proved.
-/

namespace WidthBounds.MonomialPresentation

noncomputable section

open CategoryTheory CategoryTheory.Limits MvPolynomial Finset MonomialInterface
open scoped TensorProduct

variable {K : Type*} [Field K]

/-- The actual linear combination of a finite relation family. -/
def relationDifferential {J : Type} [Fintype J]
    (E : Finset (Fin 3 →₀ ℕ)) (r : J → FreeModule K E) :
    (J → Ring K) →ₗ[Ring K] FreeModule K E :=
  Fintype.linearCombination (Ring K) r

@[simp]
theorem relationDifferential_single {J : Type} [Fintype J] [DecidableEq J]
    (E : Finset (Fin 3 →₀ ℕ)) (r : J → FreeModule K E) (j : J) (c : Ring K) :
    relationDifferential (K := K) E r (Pi.single j c) = c • r j := by
  classical
  exact Fintype.linearCombination_apply_single _ _ _ _

theorem range_relationDifferential {J : Type} [Fintype J]
    (E : Finset (Fin 3 →₀ ℕ)) (r : J → FreeModule K E) :
    LinearMap.range (relationDifferential (K := K) E r) =
      Submodule.span (Ring K) (Set.range r) :=
  Fintype.range_linearCombination (Ring K) r

theorem differential_comp_relationDifferential {J : Type} [Fintype J]
    (E : Finset (Fin 3 →₀ ℕ)) (r : J → FreeModule K E)
    (hr : ∀ j, differential (K := K) E (r j) = 0) :
    (differential (K := K) E).comp (relationDifferential (K := K) E r) = 0 := by
  ext c
  simp [relationDifferential, Fintype.linearCombination_apply, map_sum, hr]

/-- The relation map as an actual morphism in the same module category. -/
def relationDifferentialMap {J : Type} [Fintype J]
    (E : Finset (Fin 3 →₀ ℕ)) (r : J → FreeModule K E) :
    ModuleCat.of (Ring K) (J → Ring K) ⟶ ModuleCat.of (Ring K) (FreeModule K E) :=
  ModuleCat.ofHom (relationDifferential (K := K) E r)

theorem relationDifferentialMap_comp {J : Type} [Fintype J]
    (E : Finset (Fin 3 →₀ ℕ)) (r : J → FreeModule K E)
    (hr : ∀ j, differential (K := K) E (r j) = 0) :
    relationDifferentialMap (K := K) E r ≫ differentialMap (K := K) E = 0 := by
  apply ModuleCat.hom_ext
  exact differential_comp_relationDifferential E r hr

theorem relationFree_finrank (J : Type) [Fintype J] :
    Module.finrank (Ring K) (J → Ring K) = Fintype.card J := by
  simp

/-- The actual adjacent relation column indexed by a horizontal boundary,
or by a lower variable at a vertical boundary. -/
def boundaryRelation (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (s : BoundaryRelationIndex a n) : FreeModule K (boundaryExponents I hZ a n) :=
  commonRelation (K := K) (boundaryExponents I hZ a n)
    (boundaryRelationDegree I hZ a n s)
    (boundaryRelationSource I hZ a n s) (boundaryRelationTarget I hZ a n s)

theorem boundaryRelation_mem_ker (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (s : BoundaryRelationIndex a n) :
    boundaryRelation I hZ a n s ∈
      LinearMap.ker (differential (K := K) (boundaryExponents I hZ a n)) :=
  commonRelation_mem_ker _ _ _ _
    (boundaryRelationSource_le_degree I hZ a n s)
    (boundaryRelationTarget_le_degree I hZ a n hx hn s)

/-- Adjacent relations normalize any boundary divisor to the chosen
boundary divisor of a common multidegree. The induction is on a proved
strictly decreasing natural height, not on a finite experimental cutoff. -/
theorem commonRelation_canonical_mem (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (N : Submodule (Ring K) (FreeModule K (boundaryExponents I hZ a n)))
    (hN : ∀ s, boundaryRelation I hZ a n s ∈ N)
    (d : Fin 3 →₀ ℕ) (u : boundaryExponents I hZ a n) (hu : u.val ≤ d) :
    commonRelation (K := K) (boundaryExponents I hZ a n) d u
      (canonicalBoundary I hZ a n d) ∈ N := by
  classical
  let P : ℕ → Prop := fun m => ∀ u : boundaryExponents I hZ a n,
    boundaryHeight a n u.val = m → u.val ≤ d →
      commonRelation (K := K) (boundaryExponents I hZ a n) d u
        (canonicalBoundary I hZ a n d) ∈ N
  have hP : ∀ m, P m := by
    intro m
    induction m using Nat.strong_induction_on with
    | h m ih =>
      intro u hm hud
      by_cases hc : u = canonicalBoundary I hZ a n d
      · simp [hc, commonRelation]
      · obtain ⟨s, hs, hsd⟩ := exists_boundary_step I hZ a n d u hud hc
        have ht := boundaryRelationTarget_le_degree I hZ a n hx hn s
        have hlt : boundaryHeight a n (boundaryRelationTarget I hZ a n s).val < m := by
          simpa only [hs, hm] using
            boundaryRelationTarget_height_lt I hZ a n hLex hn hInitial s
        have hnext := ih _ hlt (boundaryRelationTarget I hZ a n s) rfl (ht.trans hsd)
        have hedge := N.smul_mem
          (MvPolynomial.monomial (d - boundaryRelationDegree I hZ a n s) (1 : K)) (hN s)
        dsimp only [boundaryRelation] at hedge
        rw [commonRelation_smul _ _ _ _ _
          (boundaryRelationSource_le_degree I hZ a n s) ht hsd, hs] at hedge
        have hsum := N.add_mem hedge hnext
        simpa only [commonRelation, sub_add_sub_cancel] using hsum
  exact hP _ u rfl hu

def boundaryRelationSpan (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ) :
    Submodule (Ring K) (FreeModule K (boundaryExponents I hZ a n)) :=
  Submodule.span (Ring K) (Set.range (boundaryRelation I hZ a n))

/-- The finite adjacent family generates the complete actual relation
kernel, including relations with arbitrary polynomial coefficients. -/
theorem boundaryRelationSpan_eq_ker (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    boundaryRelationSpan I hZ a n =
      LinearMap.ker (differential (K := K) (boundaryExponents I hZ a n)) := by
  classical
  apply le_antisymm
  · apply Submodule.span_le.mpr
    rintro _ ⟨s, rfl⟩
    exact boundaryRelation_mem_ker I hZ a n hx hn s
  · apply ker_differential_le_of_commonRelation
    intro d u v hu hv
    let N := boundaryRelationSpan I hZ a n
    have hN : ∀ s, boundaryRelation I hZ a n s ∈ N :=
      fun s => Submodule.subset_span ⟨s, rfl⟩
    have hU := commonRelation_canonical_mem I hZ a n hx hLex hn hInitial N hN d u hu
    have hV := commonRelation_canonical_mem I hZ a n hx hLex hn hInitial N hN d v hv
    have heq : commonRelation (K := K) (boundaryExponents I hZ a n) d u v =
        commonRelation (K := K) (boundaryExponents I hZ a n) d u
          (canonicalBoundary I hZ a n d) -
        commonRelation (K := K) (boundaryExponents I hZ a n) d v
          (canonicalBoundary I hZ a n d) := by
      unfold commonRelation
      abel
    rw [heq]
    exact N.sub_mem hU hV

/-- The actual second differential on the explicitly counted boundary
relation indices. Its definition does not mention the target kernel. -/
def secondDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ) :
    (BoundaryRelationIndex a n → Ring K) →ₗ[Ring K]
      FreeModule K (boundaryExponents I hZ a n) :=
  relationDifferential (boundaryExponents I hZ a n) (boundaryRelation I hZ a n)

@[simp]
theorem secondDifferential_single (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (s : BoundaryRelationIndex a n) (c : Ring K) :
    secondDifferential I hZ a n (Pi.single s c) = c • boundaryRelation I hZ a n s :=
  relationDifferential_single _ _ s c

theorem differential_comp_secondDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i) :
    (differential (K := K) (boundaryExponents I hZ a n)).comp
      (secondDifferential I hZ a n) = 0 :=
  differential_comp_relationDifferential _ _
    (fun s => (LinearMap.mem_ker).mp (boundaryRelation_mem_ker I hZ a n hx hn s))

theorem range_secondDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    LinearMap.range (secondDifferential I hZ a n) =
      firstSyzygies (K := K) (boundaryExponents I hZ a n) := by
  rw [secondDifferential, range_relationDifferential]
  exact boundaryRelationSpan_eq_ker I hZ a n hx hLex hn hInitial

def secondDifferentialMap (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ) :
    ModuleCat.of (Ring K) (BoundaryRelationIndex a n → Ring K) ⟶
      ModuleCat.of (Ring K) (FreeModule K (boundaryExponents I hZ a n)) :=
  ModuleCat.ofHom (secondDifferential I hZ a n)

theorem secondDifferentialMap_comp (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i) :
    secondDifferentialMap I hZ a n ≫
      differentialMap (K := K) (boundaryExponents I hZ a n) = 0 := by
  apply ModuleCat.hom_ext
  exact differential_comp_secondDifferential I hZ a n hx hn

def secondPresentation (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i) : ShortComplex (ModuleCat (Ring K)) :=
  ShortComplex.mk (secondDifferentialMap I hZ a n)
    (differentialMap (K := K) (boundaryExponents I hZ a n))
    (secondDifferentialMap_comp I hZ a n hx hn)

theorem secondPresentation_exact (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    (secondPresentation I hZ a n hx hn).Exact := by
  apply (ShortComplex.moduleCat_exact_iff_range_eq_ker _).mpr
  exact range_secondDifferential I hZ a n hx hLex hn hInitial

def secondToFirstSyzygies (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i) :
    (BoundaryRelationIndex a n → Ring K) →ₗ[Ring K]
      firstSyzygies (K := K) (boundaryExponents I hZ a n) :=
  (secondDifferential I hZ a n).codRestrict _ (fun c =>
    (LinearMap.mem_ker).mpr
      (LinearMap.congr_fun (differential_comp_secondDifferential I hZ a n hx hn) c))

theorem secondToFirstSyzygies_surjective (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    Function.Surjective (secondToFirstSyzygies I hZ a n hx hn) := by
  intro z
  have hz : z.val ∈ LinearMap.range (secondDifferential I hZ a n) := by
    rw [range_secondDifferential I hZ a n hx hLex hn hInitial]
    exact z.property
  obtain ⟨c, hc⟩ := hz
  exact ⟨c, Subtype.ext hc⟩

theorem boundary_firstSyzygies_finite (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    Module.Finite (Ring K) (firstSyzygies (K := K) (boundaryExponents I hZ a n)) :=
  Module.Finite.of_surjective (secondToFirstSyzygies I hZ a n hx hn)
    (secondToFirstSyzygies_surjective I hZ a n hx hLex hn hInitial)

theorem boundary_secondFree_finrank (a : ℕ) (n : ℕ → ℕ) :
    Module.finrank (Ring K) (BoundaryRelationIndex a n → Ring K) =
      a + 2 * ∑ i ∈ range a, n i := by
  rw [relationFree_finrank, card_boundaryRelationIndex]

theorem boundary_secondFree_projective (a : ℕ) (n : ℕ → ℕ) :
    Projective (ModuleCat.of (Ring K) (BoundaryRelationIndex a n → Ring K)) := by
  infer_instance

/-- The actual finite-colength lex budget class has a second finite free
term of the stated rank, generating the complete actual relation kernel.
No statement about the kernel of this second differential is made. -/
theorem finiteColength_second_presentation_bounds
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (Ring K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ (a : ℕ) (n : ℕ → ℕ)
      (hZ : ∃ b, monomial3 0 0 b ∈ monomialIdeal (R := K) S)
      (hx : monomial3 a 0 0 ∈ monomialIdeal (R := K) S)
      (hn : ∀ i j, standard (monomialIdeal (R := K) S) i j 0 ↔ j < n i)
      (_hInitial : ∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0)
      (hSpan : Ideal.span (exponentMonomials (R := K)
        (boundaryExponents (monomialIdeal (R := K) S) hZ a n) : Set (Ring K)) =
          monomialIdeal S),
      2 ≤ a ∧
      (∀ e, e ∈ boundaryExponents (monomialIdeal (R := K) S) hZ a n ↔
        IsMinimalExponent (monomialIdeal (R := K) S) e) ∧
      (presentation (boundaryExponents (monomialIdeal (R := K) S) hZ a n)
        (monomialIdeal S) hSpan).Exact ∧
      (secondPresentation (monomialIdeal (R := K) S) hZ a n hx hn).Exact ∧
      LinearMap.range (secondDifferential (monomialIdeal (R := K) S) hZ a n) =
        firstSyzygies (K := K) (boundaryExponents (monomialIdeal (R := K) S) hZ a n) ∧
      Function.Surjective (secondToFirstSyzygies (monomialIdeal (R := K) S) hZ a n hx hn) ∧
      Module.finrank (Ring K)
        (FreeModule K (boundaryExponents (monomialIdeal (R := K) S) hZ a n)) =
          a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank (Ring K) (BoundaryRelationIndex a n → Ring K) =
        a + 2 * Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank (Ring K) (BoundaryRelationIndex a n → Ring K) ≤
        2 * (w + 1).choose 3 := by
  have hZ := exists_pure_z_mem_of_finite_quotient (K := K) S hUp
  have hNonzero : monomialIdeal (R := K) S ≠ ⊥ := by
    obtain ⟨b, hb⟩ := hZ
    apply (monomialIdeal_ne_bot_iff S).mpr
    exact ⟨exponent 0 0 b, (monomial_mem_monomialIdeal_iff S hUp _).mp hb⟩
  obtain ⟨a, ha, hxNot, hInitial, _, hSecond, _⟩ :=
    monomialIdeal_all_widths_dimension_bounds S hUp hLex hNonzero hOne hw hBudget
  have hx : monomial3 a 0 0 ∈ monomialIdeal (R := K) S := not_not.mp hxNot
  let I := monomialIdeal (R := K) S
  let n := Columns.columnLength (standard I) w
  have hLI : IsLex I := monomialIdeal_isLex S hUp hLex
  have hA := monomialIdeal_standardLex (R := K) S hUp hLex
  have hHS := hilbertBudget_of_finrankBudget S hUp w hBudget
  have hn : ∀ i j, standard I i j 0 ↔ j < n i :=
    fun _ _ => Columns.standard_iff_lt_columnLength hA hw hHS
  have hSum : (∑ i ∈ range a, n i) = Module.finrank K (xySubspace I) := by
    rw [finrank_xySubspace S hUp hLex hw hBudget]
    exact Columns.sum_columns_eq_sectionLength hA hw hxNot hHS
  have hSpan := span_boundary_exponentMonomials S hZ a n hx hn
  refine ⟨a, n, hZ, hx, hn, hInitial, hSpan, ha, ?_,
    presentation_exact _ _ hSpan, secondPresentation_exact I hZ a n hx hLI hn hInitial,
    range_secondDifferential I hZ a n hx hLI hn hInitial,
    secondToFirstSyzygies_surjective I hZ a n hx hLI hn hInitial, ?_, ?_, ?_⟩
  · exact mem_boundaryExponents_iff_isMinimal I hLI hZ a n hx hn hInitial
  · rw [generatorFree_finrank, card_boundaryExponents I hZ a n hn, hSum]
  · rw [boundary_secondFree_finrank, hSum]
  · simpa only [boundary_secondFree_finrank, hSum] using hSecond

#print axioms differential_comp_relationDifferential
#print axioms commonRelation_canonical_mem
#print axioms boundaryRelationSpan_eq_ker
#print axioms range_secondDifferential
#print axioms secondPresentation_exact
#print axioms secondToFirstSyzygies_surjective
#print axioms boundary_firstSyzygies_finite
#print axioms boundary_secondFree_finrank
#print axioms finiteColength_second_presentation_bounds

end

end WidthBounds.MonomialPresentation
