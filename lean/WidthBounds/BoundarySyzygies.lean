import WidthBounds.FiniteMonomialPresentation
import WidthBounds.GeneratorMinimality

/-! Explicit adjacent relations for the actual boundary exponent family. -/

noncomputable section

namespace WidthBounds.MonomialPresentation

open MvPolynomial Finset
open WidthBounds.MonomialInterface

variable {K : Type*} [Field K]

/-- One x relation at each xy boundary and x/y relations at every z threshold. -/
abbrev BoundaryRelationIndex (a : ℕ) (n : ℕ → ℕ) :=
  (Fin a) ⊕ ((Σ i : Fin a, Fin (n i)) × Fin 2)

theorem card_boundaryRelationIndex (a : ℕ) (n : ℕ → ℕ) :
    Fintype.card (BoundaryRelationIndex a n) = a + 2 * ∑ i ∈ range a, n i := by
  simp only [BoundaryRelationIndex, Fintype.card_sum, Fintype.card_fin,
    Fintype.card_prod, Fintype.card_sigma]
  rw [Fin.sum_univ_eq_sum_range]
  omega

/-- A fixed, coordinate-controlled boundary divisor. -/
def canonicalBoundaryExponent (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (d : Fin 3 →₀ ℕ) : Fin 3 →₀ ℕ :=
  if a ≤ d 0 then exponent a 0 0
  else if n (d 0) ≤ d 1 then exponent (d 0) (n (d 0)) 0
  else exponent (d 0) (d 1) (zThreshold I hZ (d 0) (d 1))

theorem canonicalBoundaryExponent_mem (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (d : Fin 3 →₀ ℕ) :
    canonicalBoundaryExponent I hZ a n d ∈ boundaryExponents I hZ a n := by
  apply (mem_boundaryExponents_iff I hZ a n _).mpr
  unfold canonicalBoundaryExponent
  split_ifs with hi hj
  · exact Or.inl rfl
  · exact Or.inr (Or.inl ⟨d 0, by omega, rfl⟩)
  · exact Or.inr (Or.inr ⟨d 0, d 1, by omega, by omega, rfl⟩)

theorem canonicalBoundaryExponent_le (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (d : Fin 3 →₀ ℕ) (hm : monomial d (1 : K) ∈ I) :
    canonicalBoundaryExponent I hZ a n d ≤ d := by
  have hm' : monomial3 (d 0) (d 1) (d 2) ∈ I := by
    simpa only [monomial3, exponent_coordinates] using hm
  rw [← exponent_coordinates d]
  unfold canonicalBoundaryExponent
  simp only [exponent_zero, exponent_one]
  split_ifs with hi hj
  · exact exponent_le_iff.mpr ⟨hi, Nat.zero_le _, Nat.zero_le _⟩
  · exact exponent_le_iff.mpr ⟨le_rfl, hj, Nat.zero_le _⟩
  · exact exponent_le_iff.mpr ⟨le_rfl, le_rfl, zThreshold_le I hZ hm'⟩

def canonicalBoundary (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (d : Fin 3 →₀ ℕ) : boundaryExponents I hZ a n :=
  ⟨canonicalBoundaryExponent I hZ a n d,
    canonicalBoundaryExponent_mem I hZ a n d⟩

/-- The source boundary generator of an adjacent relation. -/
def boundaryRelationSource (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ) :
    BoundaryRelationIndex a n → boundaryExponents I hZ a n
  | Sum.inl i => ⟨exponent i (n i) 0,
      (mem_boundaryExponents_iff I hZ a n _).mpr
        (Or.inr (Or.inl ⟨i, i.isLt, rfl⟩))⟩
  | Sum.inr ⟨⟨i, j⟩, _⟩ => ⟨exponent i j (zThreshold I hZ i j),
      (mem_boundaryExponents_iff I hZ a n _).mpr
        (Or.inr (Or.inr ⟨i, j, i.isLt, j.isLt, rfl⟩))⟩

/-- Multiplication by x, or by y for the second z-boundary relation. -/
def boundaryRelationDegree (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ) :
    BoundaryRelationIndex a n → (Fin 3 →₀ ℕ)
  | Sum.inl i => exponent (i + 1) (n i) 0
  | Sum.inr ⟨⟨i, j⟩, q⟩ =>
      if q = 0 then exponent (i + 1) j (zThreshold I hZ i j)
      else exponent i (j + 1) (zThreshold I hZ i j)

def boundaryRelationTarget (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (s : BoundaryRelationIndex a n) : boundaryExponents I hZ a n :=
  canonicalBoundary I hZ a n (boundaryRelationDegree I hZ a n s)

theorem boundaryRelationSource_le_degree (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (s : BoundaryRelationIndex a n) :
    (boundaryRelationSource I hZ a n s).val ≤ boundaryRelationDegree I hZ a n s := by
  rcases s with i | ⟨⟨i, j⟩, q⟩
  · exact exponent_le_iff.mpr ⟨by omega, le_rfl, le_rfl⟩
  · dsimp [boundaryRelationSource, boundaryRelationDegree]
    split_ifs <;> exact exponent_le_iff.mpr ⟨by omega, by omega, le_rfl⟩

theorem boundaryRelationDegree_mem (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (s : BoundaryRelationIndex a n) :
    monomial (boundaryRelationDegree I hZ a n s) (1 : K) ∈ I := by
  apply I.mem_of_dvd _
    (boundaryExponents_monomial_mem I hZ a n hx hn
      (boundaryRelationSource I hZ a n s).property)
  exact monomial_dvd_monomial.mpr
    ⟨Or.inr (boundaryRelationSource_le_degree I hZ a n s), dvd_rfl⟩

theorem boundaryRelationTarget_le_degree (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (s : BoundaryRelationIndex a n) :
    (boundaryRelationTarget I hZ a n s).val ≤ boundaryRelationDegree I hZ a n s :=
  canonicalBoundaryExponent_le I hZ a n _
    (boundaryRelationDegree_mem I hZ a n hx hn s)

theorem canonicalBoundaryExponent_zero (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (d : Fin 3 →₀ ℕ) (hd : d 0 ≤ a) :
    canonicalBoundaryExponent I hZ a n d 0 = d 0 := by
  unfold canonicalBoundaryExponent
  split_ifs with hi hj <;> simp only [exponent_zero]
  · omega

theorem canonicalBoundaryExponent_one (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (d : Fin 3 →₀ ℕ) (hi : d 0 < a) (hj : d 1 ≤ n (d 0)) :
    canonicalBoundaryExponent I hZ a n d 1 = d 1 := by
  unfold canonicalBoundaryExponent
  rw [if_neg (by omega)]
  split_ifs with h <;> simp only [exponent_one]
  · omega

/-- Every actual boundary lies in a finite horizontal rectangle. -/
theorem boundary_coordinates_le (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (u : boundaryExponents I hZ a n) : u.val 0 ≤ a ∧ u.val 1 ≤ n 0 := by
  have hcols : ∀ i, i < a → n i ≤ n 0 := by
    intro i hi
    by_cases hi0 : i = 0
    · simp only [hi0, le_refl]
    · exact (column_strictAnti_of_initial I hLex n hn hInitial (by omega) hi).le
  rcases (mem_boundaryExponents_iff I hZ a n u.val).mp u.property with
    hu | ⟨i, hi, hu⟩ | ⟨i, j, hi, hj, hu⟩
  · simp only [hu, exponent_zero, exponent_one, le_refl, Nat.zero_le, and_self]
  · simpa only [hu, exponent_zero, exponent_one] using And.intro hi.le (hcols i hi)
  · simpa only [hu, exponent_zero, exponent_one] using
      And.intro hi.le (hj.le.trans (hcols i hi))

/-- A natural-valued rank strictly decreases along an adjacent step. -/
def boundaryHeight (a : ℕ) (n : ℕ → ℕ) (e : Fin 3 →₀ ℕ) : ℕ :=
  (a - e 0) * (n 0 + 1) + (n 0 - e 1)

theorem boundaryHeight_lt_of_x_step (a : ℕ) (n : ℕ → ℕ)
    (u v : Fin 3 →₀ ℕ) (hu : u 0 < a) (hyu : u 1 ≤ n 0)
    (hyv : v 1 ≤ n 0) (hx : v 0 = u 0 + 1) :
    boundaryHeight a n v < boundaryHeight a n u := by
  unfold boundaryHeight
  have hsub : a - u 0 = a - v 0 + 1 := by omega
  rw [hsub, Nat.add_mul]
  omega

theorem boundaryHeight_lt_of_y_step (a : ℕ) (n : ℕ → ℕ)
    (u v : Fin 3 →₀ ℕ) (hyv : v 1 ≤ n 0)
    (hx : v 0 = u 0) (hy : v 1 = u 1 + 1) :
    boundaryHeight a n v < boundaryHeight a n u := by
  unfold boundaryHeight
  rw [hx]
  omega

theorem boundaryRelationTarget_forward (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (s : BoundaryRelationIndex a n) :
    ((boundaryRelationTarget I hZ a n s).val 0 =
      (boundaryRelationSource I hZ a n s).val 0 + 1) ∨
    ((boundaryRelationTarget I hZ a n s).val 0 =
      (boundaryRelationSource I hZ a n s).val 0 ∧
     (boundaryRelationTarget I hZ a n s).val 1 =
      (boundaryRelationSource I hZ a n s).val 1 + 1) := by
  rcases s with i | ⟨⟨i, j⟩, q⟩
  · left
    simpa only [boundaryRelationTarget, canonicalBoundary, boundaryRelationDegree,
      boundaryRelationSource, exponent_zero] using
      canonicalBoundaryExponent_zero I hZ a n (exponent (i.val + 1) (n i) 0)
        (by simpa only [exponent_zero] using i.isLt)
  · by_cases hq : q = 0
    · left
      change canonicalBoundaryExponent I hZ a n
        (boundaryRelationDegree I hZ a n (Sum.inr ⟨⟨i, j⟩, q⟩)) 0 = _
      simp only [boundaryRelationDegree, hq, ↓reduceIte]
      simpa only [boundaryRelationSource, exponent_zero] using
        canonicalBoundaryExponent_zero I hZ a n
          (exponent (i.val + 1) j (zThreshold I hZ i j))
          (by simpa only [exponent_zero] using i.isLt)
    · right
      change canonicalBoundaryExponent I hZ a n
        (boundaryRelationDegree I hZ a n (Sum.inr ⟨⟨i, j⟩, q⟩)) 0 = _ ∧
        canonicalBoundaryExponent I hZ a n
        (boundaryRelationDegree I hZ a n (Sum.inr ⟨⟨i, j⟩, q⟩)) 1 = _
      simp only [boundaryRelationDegree, hq, ↓reduceIte]
      constructor
      · simpa only [boundaryRelationSource, exponent_zero] using
          canonicalBoundaryExponent_zero I hZ a n
            (exponent i (j.val + 1) (zThreshold I hZ i j))
            (by simpa only [exponent_zero] using i.isLt.le)
      · simpa only [boundaryRelationSource, exponent_one] using
          canonicalBoundaryExponent_one I hZ a n
            (exponent i (j.val + 1) (zThreshold I hZ i j))
            (by simpa only [exponent_zero] using i.isLt)
            (by simpa only [exponent_zero, exponent_one] using j.isLt)

theorem boundaryRelationTarget_height_lt (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (s : BoundaryRelationIndex a n) :
    boundaryHeight a n (boundaryRelationTarget I hZ a n s).val <
      boundaryHeight a n (boundaryRelationSource I hZ a n s).val := by
  have hs := boundary_coordinates_le I hZ a n hLex hn hInitial
    (boundaryRelationSource I hZ a n s)
  have ht := boundary_coordinates_le I hZ a n hLex hn hInitial
    (boundaryRelationTarget I hZ a n s)
  rcases boundaryRelationTarget_forward I hZ a n s with hx | ⟨hx, hy⟩
  · exact boundaryHeight_lt_of_x_step a n _ _ (by omega) hs.2 ht.2 hx
  · exact boundaryHeight_lt_of_y_step a n _ _ ht.2 hx hy

/-- Every noncanonical boundary divisor admits one of the finitely indexed
adjacent steps, still dividing the specified common multidegree. -/
theorem exists_boundary_step (I : Ideal (Ring K))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (d : Fin 3 →₀ ℕ) (u : boundaryExponents I hZ a n)
    (hud : u.val ≤ d) (hne : u ≠ canonicalBoundary I hZ a n d) :
    ∃ s : BoundaryRelationIndex a n,
      boundaryRelationSource I hZ a n s = u ∧ boundaryRelationDegree I hZ a n s ≤ d := by
  have hu0 := hud 0
  have hu1 := hud 1
  have hu2 := hud 2
  have hexp : ∀ i j k, i ≤ d 0 → j ≤ d 1 → k ≤ d 2 → exponent i j k ≤ d := by
    intro i j k hi hj hk
    simpa only [exponent_coordinates] using exponent_le_iff.mpr ⟨hi, hj, hk⟩
  rcases (mem_boundaryExponents_iff I hZ a n u.val).mp u.property with
    hu | ⟨i, hi, hu⟩ | ⟨i, j, hi, hj, hu⟩
  · exfalso
    apply hne
    apply Subtype.ext
    change u.val = canonicalBoundaryExponent I hZ a n d
    simp only [hu, exponent_zero] at hu0
    simp only [canonicalBoundaryExponent, hu0, ↓reduceIte, hu]
  · simp only [hu, exponent_zero, exponent_one, exponent_two] at hu0 hu1 hu2
    by_cases he : i = d 0
    · exfalso
      apply hne
      apply Subtype.ext
      change u.val = canonicalBoundaryExponent I hZ a n d
      rw [hu]
      simp only [canonicalBoundaryExponent, ← he, if_neg (by omega : ¬a ≤ i),
        hu1, ↓reduceIte]
    · refine ⟨Sum.inl ⟨i, hi⟩, Subtype.ext hu.symm, ?_⟩
      exact hexp (i + 1) (n i) 0 (by omega) hu1 hu2
  · simp only [hu, exponent_zero, exponent_one, exponent_two] at hu0 hu1 hu2
    by_cases hei : i = d 0
    · by_cases hej : j = d 1
      · exfalso
        apply hne
        apply Subtype.ext
        change u.val = canonicalBoundaryExponent I hZ a n d
        rw [hu]
        simp only [canonicalBoundaryExponent, ← hei, ← hej,
          if_neg (by omega : ¬a ≤ i), if_neg (by omega : ¬n i ≤ j)]
      · refine ⟨Sum.inr ⟨⟨⟨i, hi⟩, ⟨j, hj⟩⟩, 1⟩, Subtype.ext hu.symm, ?_⟩
        change exponent i (j + 1) (zThreshold I hZ i j) ≤ d
        exact hexp i (j + 1) _ hu0 (by omega) hu2
    · refine ⟨Sum.inr ⟨⟨⟨i, hi⟩, ⟨j, hj⟩⟩, 0⟩, Subtype.ext hu.symm, ?_⟩
      change exponent (i + 1) j (zThreshold I hZ i j) ≤ d
      exact hexp (i + 1) j _ (by omega) hu1 hu2

#print axioms card_boundaryRelationIndex
#print axioms canonicalBoundaryExponent_le
#print axioms boundaryRelationTarget_le_degree
#print axioms boundaryRelationTarget_forward
#print axioms boundaryRelationTarget_height_lt
#print axioms exists_boundary_step

end WidthBounds.MonomialPresentation
