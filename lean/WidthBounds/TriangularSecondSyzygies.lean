import WidthBounds.MonomialFirstSyzygies
import WidthBounds.PolynomialPairRelation

/-! Triangular third relations, with top equations proved for the actual second differential. -/

noncomputable section
namespace WidthBounds.MonomialPresentation
open MvPolynomial Finset MonomialInterface
variable {K : Type*} [Field K]

abbrev BoundaryFaceIndex (a : ℕ) (n : ℕ → ℕ) := Σ i : Fin a, Fin (n i)

def faceX {a : ℕ} {n : ℕ → ℕ} (p : BoundaryFaceIndex a n) :
    BoundaryRelationIndex a n := Sum.inr (p, 0)

def faceY {a : ℕ} {n : ℕ → ℕ} (p : BoundaryFaceIndex a n) :
    BoundaryRelationIndex a n := Sum.inr (p, 1)

def relationHeight (I : Ideal (Ring K)) (hZ : ∃ b, monomial3 0 0 b ∈ I)
    (a : ℕ) (n : ℕ → ℕ) (r : BoundaryRelationIndex a n) : ℕ :=
  boundaryHeight a n (boundaryRelationSource I hZ a n r).val

def faceHeight (I : Ideal (Ring K)) (hZ : ∃ b, monomial3 0 0 b ∈ I)
    (a : ℕ) (n : ℕ → ℕ) (p : BoundaryFaceIndex a n) : ℕ :=
  relationHeight I hZ a n (faceX p)

@[simp] theorem relationHeight_faceY (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (p : BoundaryFaceIndex a n) :
    relationHeight I hZ a n (faceY p) = faceHeight I hZ a n p := rfl

@[simp] theorem relationHeight_faceX (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (p : BoundaryFaceIndex a n) :
    relationHeight I hZ a n (faceX p) = faceHeight I hZ a n p := rfl

def thirdDifferential {a : ℕ} {n : ℕ → ℕ}
    (face : BoundaryFaceIndex a n → BoundaryRelationIndex a n → Ring K) :
    (BoundaryFaceIndex a n → Ring K) →ₗ[Ring K]
      (BoundaryRelationIndex a n → Ring K) :=
  Fintype.linearCombination (Ring K) face

@[simp] theorem thirdDifferential_single {a : ℕ} {n : ℕ → ℕ}
    (face : BoundaryFaceIndex a n → BoundaryRelationIndex a n → Ring K)
    (p : BoundaryFaceIndex a n) (c : Ring K) :
    thirdDifferential face (Pi.single p c) = c • face p := by
  classical
  exact Fintype.linearCombination_apply_single _ _ _ _

def TriangularFaces (I : Ideal (Ring K)) (hZ : ∃ b, monomial3 0 0 b ∈ I)
    (a : ℕ) (n : ℕ → ℕ)
    (face : BoundaryFaceIndex a n → BoundaryRelationIndex a n → Ring K) : Prop :=
  ∀ p r, faceHeight I hZ a n p ≤ relationHeight I hZ a n r →
    face p r = if r = faceX p then X 1 else if r = faceY p then -X 0 else 0

theorem boundary_source_monomial (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (r : BoundaryRelationIndex a n) :
    monomial (boundaryRelationDegree I hZ a n r -
      (boundaryRelationSource I hZ a n r).val) (1 : K) =
        X (match r with | .inl _ => 0 | .inr (_, q) => if q = 0 then 0 else 1) := by
  have hx (i j k : ℕ) : exponent (i + 1) j k - exponent i j k =
      Finsupp.single (0 : Fin 3) 1 := by
    ext q
    fin_cases q <;> simp [exponent]
  have hy (i j k : ℕ) : exponent i (j + 1) k - exponent i j k =
      Finsupp.single (1 : Fin 3) 1 := by
    ext q
    fin_cases q <;> simp [exponent]
  rcases r with i | ⟨⟨i, j⟩, q⟩
  · simp [boundaryRelationDegree, boundaryRelationSource, hx, X]
  · by_cases hq : q = 0
    · simp [boundaryRelationDegree, boundaryRelationSource, hq, hx, X]
    · simp [boundaryRelationDegree, boundaryRelationSource, hq, hy, X]

theorem boundary_source_eq_inl (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (r : BoundaryRelationIndex a n) (i : Fin a) :
    boundaryRelationSource I hZ a n r = boundaryRelationSource I hZ a n (.inl i) ↔
      r = .inl i := by
  constructor
  · intro h
    have h0 := congrArg (fun e : boundaryExponents I hZ a n => e.val 0) h
    have h1 := congrArg (fun e : boundaryExponents I hZ a n => e.val 1) h
    rcases r with j | ⟨⟨j, k⟩, q⟩
    · simp only [boundaryRelationSource, exponent_zero] at h0
      exact congrArg Sum.inl (Fin.ext h0)
    · simp only [boundaryRelationSource, exponent_zero] at h0
      have hj : j = i := Fin.ext h0
      subst j
      simp only [boundaryRelationSource, exponent_one] at h1
      have := k.isLt
      omega
  · rintro rfl
    rfl

theorem boundary_source_eq_face (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (r : BoundaryRelationIndex a n) (p : BoundaryFaceIndex a n) :
    boundaryRelationSource I hZ a n r = boundaryRelationSource I hZ a n (faceX p) ↔
      r = faceX p ∨ r = faceY p := by
  constructor
  · intro h
    have h0 := congrArg (fun e : boundaryExponents I hZ a n => e.val 0) h
    have h1 := congrArg (fun e : boundaryExponents I hZ a n => e.val 1) h
    rcases p with ⟨i, j⟩
    rcases r with k | ⟨⟨k, l⟩, q⟩
    · simp only [boundaryRelationSource, faceX, exponent_zero] at h0
      have hk : k = i := Fin.ext h0
      subst k
      simp only [boundaryRelationSource, faceX, exponent_one] at h1
      have := j.isLt
      omega
    · simp only [boundaryRelationSource, faceX, exponent_zero] at h0
      have hk : k = i := Fin.ext h0
      subst k
      simp only [boundaryRelationSource, faceX, exponent_one] at h1
      have hl : l = j := Fin.ext h1
      subst l
      fin_cases q <;> simp [faceX, faceY]
  · rintro (rfl | rfl) <;> rfl

theorem secondDifferential_top_coordinate (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I) (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (c : BoundaryRelationIndex a n → Ring K) (H : ℕ)
    (hc : ∀ r, H < relationHeight I hZ a n r → c r = 0)
    (u : boundaryExponents I hZ a n) (hu : boundaryHeight a n u.val = H) :
    secondDifferential I hZ a n c u =
      ∑ r, if boundaryRelationSource I hZ a n r = u then
        c r * X (match r with | .inl _ => (0 : Fin 3) | .inr (_, q) => if q = 0 then 0 else 1)
      else 0 := by
  classical
  change (∑ r, c r • boundaryRelation I hZ a n r) u = _
  rw [Finset.sum_apply]
  apply Finset.sum_congr rfl
  intro r _
  have ht : c r * (if u = boundaryRelationTarget I hZ a n r then
      monomial (boundaryRelationDegree I hZ a n r -
        (boundaryRelationTarget I hZ a n r).val) (1 : K) else 0) = 0 := by
    by_cases he : boundaryRelationTarget I hZ a n r = u
    · have hlt := boundaryRelationTarget_height_lt I hZ a n hLex hn hInitial r
      rw [he, hu] at hlt
      rw [hc r hlt, zero_mul]
    · simp [Ne.symm he]
  simp only [boundaryRelation, commonRelation, Pi.smul_apply, smul_eq_mul,
    Pi.sub_apply, Pi.single_apply]
  rw [mul_sub, ht, sub_zero, boundary_source_monomial]
  by_cases he : boundaryRelationSource I hZ a n r = u
  · simp [he]
  · simp [he, Ne.symm he]

theorem secondDifferential_top_inl (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I) (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (c : BoundaryRelationIndex a n → Ring K) (H : ℕ)
    (hc : ∀ r, H < relationHeight I hZ a n r → c r = 0)
    (i : Fin a) (hi : relationHeight I hZ a n (.inl i) = H) :
    secondDifferential I hZ a n c (boundaryRelationSource I hZ a n (.inl i)) =
      c (.inl i) * X 0 := by
  classical
  rw [secondDifferential_top_coordinate I hZ a n hLex hn hInitial c H hc _ hi]
  simp only [boundary_source_eq_inl]
  simp

theorem secondDifferential_top_face (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I) (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (c : BoundaryRelationIndex a n → Ring K) (H : ℕ)
    (hc : ∀ r, H < relationHeight I hZ a n r → c r = 0)
    (p : BoundaryFaceIndex a n) (hp : faceHeight I hZ a n p = H) :
    secondDifferential I hZ a n c (boundaryRelationSource I hZ a n (faceX p)) =
      c (faceX p) * X 0 + c (faceY p) * X 1 := by
  classical
  rw [secondDifferential_top_coordinate I hZ a n hLex hn hInitial c H hc _ hp]
  simp only [boundary_source_eq_face]
  have hne : faceX p ≠ faceY p := by simp [faceX, faceY]
  trans ∑ r : BoundaryRelationIndex a n,
    ((if r = faceX p then c (faceX p) * X 0 else 0) +
      (if r = faceY p then c (faceY p) * X 1 else 0))
  · apply Finset.sum_congr rfl
    intro r _
    by_cases hx : r = faceX p
    · subst r
      simp [faceX, faceY]
    · by_cases hy : r = faceY p
      · subst r
        simp [faceX, faceY]
      · simp [hx, hy]
  · simp [Finset.sum_add_distrib]
theorem thirdDifferential_top (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (face : BoundaryFaceIndex a n → BoundaryRelationIndex a n → Ring K)
    (hf : TriangularFaces I hZ a n face)
    (b : BoundaryFaceIndex a n → Ring K) (r : BoundaryRelationIndex a n)
    (hb : ∀ p, relationHeight I hZ a n r < faceHeight I hZ a n p → b p = 0) :
    thirdDifferential face b r = match r with
      | .inl _ => 0
      | .inr (p, q) => if q = 0 then b p * X 1 else -(b p * X 0) := by
  classical
  change (∑ p, b p • face p) r = _
  rw [Finset.sum_apply]
  trans ∑ p, b p * (if r = faceX p then X 1 else if r = faceY p then -X 0 else 0)
  · apply Finset.sum_congr rfl
    intro p _
    by_cases hp : faceHeight I hZ a n p ≤ relationHeight I hZ a n r
    · exact congrArg (b p * ·) (hf p r hp)
    · simp [hb p (by omega)]
  · rcases r with i | ⟨p, q⟩
    · simp [faceX, faceY]
    · fin_cases q
      · simp only [faceX, faceY, Sum.inr.injEq, Prod.mk.injEq, mul_ite, mul_zero]
        simp
      · simp only [faceX, faceY, Sum.inr.injEq, Prod.mk.injEq, mul_ite, mul_zero]
        simp

theorem secondDifferential_thirdDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (face : BoundaryFaceIndex a n → BoundaryRelationIndex a n → Ring K)
    (hk : ∀ p, secondDifferential I hZ a n (face p) = 0)
    (b : BoundaryFaceIndex a n → Ring K) :
    secondDifferential I hZ a n (thirdDifferential face b) = 0 := by
  simp [thirdDifferential, Fintype.linearCombination_apply, map_sum, hk]

theorem thirdDifferential_injective (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (face : BoundaryFaceIndex a n → BoundaryRelationIndex a n → Ring K)
    (hf : TriangularFaces I hZ a n face) :
    Function.Injective (thirdDifferential face) := by
  classical
  apply (LinearMap.ker_eq_bot).mp
  apply LinearMap.ker_eq_bot'.mpr
  intro b hb
  have hbound : ∀ H : ℕ, (∀ p, H ≤ faceHeight I hZ a n p → b p = 0) → b = 0 := by
    intro H
    induction H with
    | zero =>
      intro hs
      funext p
      exact hs p (Nat.zero_le _)
    | succ H ih =>
      intro hs
      apply ih
      intro p hp
      by_cases he : faceHeight I hZ a n p = H
      · have htop := thirdDifferential_top I hZ a n face hf b (faceX p)
          (fun q hq => hs q (by simpa only [relationHeight_faceX, he] using hq))
        have hz := congrFun hb (faceX p)
        rw [htop] at hz
        have hx : b p * X (1 : Fin 3) = 0 := by simpa [faceX] using hz
        exact (mul_eq_zero.mp hx).resolve_right (X_ne_zero 1)
      · exact hs p (by omega)
  apply hbound ((Finset.univ.sup (faceHeight I hZ a n)) + 1)
  intro p hp
  have hle : faceHeight I hZ a n p ≤ Finset.univ.sup (faceHeight I hZ a n) :=
    Finset.le_sup (Finset.mem_univ p)
  omega

theorem range_thirdDifferential (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I) (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (face : BoundaryFaceIndex a n → BoundaryRelationIndex a n → Ring K)
    (hk : ∀ p, secondDifferential I hZ a n (face p) = 0)
    (hf : TriangularFaces I hZ a n face) :
    LinearMap.range (thirdDifferential face) = LinearMap.ker (secondDifferential I hZ a n) := by
  classical
  apply le_antisymm
  · rintro c ⟨b, rfl⟩
    exact LinearMap.mem_ker.mpr (secondDifferential_thirdDifferential I hZ a n face hk b)
  · intro c hc
    have hP : ∀ H : ℕ, ∀ c : BoundaryRelationIndex a n → Ring K,
        secondDifferential I hZ a n c = 0 →
        (∀ r, H ≤ relationHeight I hZ a n r → c r = 0) →
        ∃ b, thirdDifferential face b = c := by
      intro H
      induction H with
      | zero =>
        intro c _ hs
        refine ⟨0, ?_⟩
        rw [map_zero]
        funext r
        exact (hs r (Nat.zero_le _)).symm
      | succ H ih =>
        intro c hc hs
        have htop : ∀ r, H < relationHeight I hZ a n r → c r = 0 := hs
        have hcx : ∀ i : Fin a, relationHeight I hZ a n (.inl i) = H →
            c (.inl i) = 0 := by
          intro i hi
          have he := secondDifferential_top_inl I hZ a n hLex hn hInitial c H htop i hi
          rw [hc] at he
          exact (mul_eq_zero.mp he.symm).resolve_right (X_ne_zero 0)
        have hct : ∀ p : BoundaryFaceIndex a n, ∃ t : Ring K,
            faceHeight I hZ a n p = H →
              c (faceX p) = X 1 * t ∧ c (faceY p) = -(X 0 * t) := by
          intro p
          by_cases hp : faceHeight I hZ a n p = H
          · have he := secondDifferential_top_face I hZ a n hLex hn hInitial c H htop p hp
            rw [hc] at he
            have he' : X (0 : Fin 3) * c (faceX p) + X 1 * c (faceY p) = 0 := by
              simpa only [mul_comm] using he.symm
            obtain ⟨t, ht⟩ := polynomial_xy_relation (c (faceX p)) (c (faceY p)) he'
            exact ⟨t, fun _ => ht⟩
          · exact ⟨0, fun h => (hp h).elim⟩
        choose t ht using hct
        let b : BoundaryFaceIndex a n → Ring K := fun p =>
          if faceHeight I hZ a n p = H then t p else 0
        have hb : ∀ r, H ≤ relationHeight I hZ a n r →
            thirdDifferential face b r = c r := by
          intro r hr
          rw [thirdDifferential_top I hZ a n face hf b r (by
            intro p hp
            have hne : faceHeight I hZ a n p ≠ H := by omega
            simp [b, hne])]
          rcases r with i | ⟨p, q⟩
          · by_cases hi : relationHeight I hZ a n (.inl i) = H
            · exact (hcx i hi).symm
            · exact (hs (.inl i) (by omega)).symm
          · have hheight : relationHeight I hZ a n (.inr (p, q)) =
                faceHeight I hZ a n p := by cases p; rfl
            rw [hheight] at hr
            by_cases hp : faceHeight I hZ a n p = H
            · obtain ⟨hx, hy⟩ := ht p hp
              fin_cases q
              · simpa [b, hp, faceX, mul_comm] using hx.symm
              · simpa [b, hp, faceY, mul_comm] using hy.symm
            · have hz : c (.inr (p, q)) = 0 := hs _ (by rw [hheight]; omega)
              simp [b, hp, hz]
        let c' := c - thirdDifferential face b
        have hc' : secondDifferential I hZ a n c' = 0 := by
          simp [c', map_sub, hc, secondDifferential_thirdDifferential I hZ a n face hk b]
        have hs' : ∀ r, H ≤ relationHeight I hZ a n r → c' r = 0 := by
          intro r hr
          simp [c', hb r hr]
        obtain ⟨b', hb'⟩ := ih c' hc' hs'
        refine ⟨b' + b, ?_⟩
        rw [map_add, hb']
        exact sub_add_cancel c (thirdDifferential face b)
    apply hP ((Finset.univ.sup (relationHeight I hZ a n)) + 1) c
      (LinearMap.mem_ker.mp hc)
    intro r hr
    have hle : relationHeight I hZ a n r ≤ Finset.univ.sup (relationHeight I hZ a n) :=
      Finset.le_sup (Finset.mem_univ r)
    omega

#print axioms secondDifferential_top_coordinate
#print axioms secondDifferential_top_inl
#print axioms secondDifferential_top_face
#print axioms secondDifferential_thirdDifferential
#print axioms thirdDifferential_injective
#print axioms range_thirdDifferential

end WidthBounds.MonomialPresentation


