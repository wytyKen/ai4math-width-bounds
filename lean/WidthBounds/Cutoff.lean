import WidthBounds.LexCounting

/-!
# Finite cutoff from the Hilbert--Samuel budget

A surviving `y^d` forces every `y,z` monomial in degrees at most `d`.
Counting that triangle and using the linear cumulative budget gives a
finite-support statement for the two-variable Hilbert function.
-/

namespace WidthBounds.LexCounting

open Finset

/-- A standard pure `y` power forces the entire `y,z` slice in each lower degree. -/
theorem degree_yz_le_hilbert3 {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {d t : ℕ} (hy : A 0 d 0) (htd : t ≤ d) : t + 1 ≤ hilbert3 A t := by
  have hyt : A 0 t 0 := hA.down (by rfl) htd (by rfl) hy
  have hcard : (range (t + 1)).card ≤ (standard3 A t).card := by
    apply card_le_card_of_injOn (fun j : ℕ => (0, j))
    · intro j hj
      have hjt : j ≤ t := Nat.lt_succ_iff.mp (mem_range.mp hj)
      apply mem_standard3.mpr
      refine ⟨by omega, ?_⟩
      exact hA.lex (by omega) (Or.inr ⟨rfl, hjt⟩) hyt
    · intro i hi j hj hij
      exact (Prod.mk.inj hij).2
  simpa [hilbert3] using hcard

/-- Twice a triangular sum, avoiding division in the later arithmetic argument. -/
theorem twice_sum_range_add_one (n : ℕ) :
    2 * (∑ t ∈ range n, (t + 1)) = n * (n + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [sum_range_succ]
      nlinarith

/-- A nonzero two-variable slice forces a triangular cumulative lower bound. -/
theorem triangle_le_cumulative_of_hilbert2_pos
    {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A) {d : ℕ}
    (hd : 0 < hilbert2 A d) :
    (d + 1) * (d + 2) ≤ 2 * (∑ t ∈ range (d + 1), hilbert3 A t) := by
  have hy : A 0 d 0 := by
    simpa using (standard_of_lt_hilbert2 hA hd).2
  have hsum : (∑ t ∈ range (d + 1), (t + 1)) ≤
      ∑ t ∈ range (d + 1), hilbert3 A t := by
    apply sum_le_sum
    intro t ht
    exact degree_yz_le_hilbert3 hA hy (Nat.lt_succ_iff.mp (mem_range.mp ht))
  have hmul := Nat.mul_le_mul_left 2 hsum
  rw [twice_sum_range_add_one] at hmul
  exact hmul

/-- The cumulative linear budget kills every two-variable slice from `2*w-2` on.
The pure `x` threshold is not needed for this independent cutoff argument. -/
theorem hilbert2_eq_zero_of_cutoff {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w d : ℕ} (hw : 4 ≤ w)
    (hbudget : ∀ n, (∑ t ∈ range (n + 1), hilbert3 A t) ≤ 1 + n * w)
    (hd : 2 * w - 2 ≤ d) : hilbert2 A d = 0 := by
  by_contra hne
  have htriangle := triangle_le_cumulative_of_hilbert2_pos hA (Nat.pos_of_ne_zero hne)
  have hbound := htriangle.trans (Nat.mul_le_mul_left 2 (hbudget d))
  have hdpos : 0 < d := by omega
  have hgap : 2 * w < d + 3 := by omega
  have hstrict := Nat.mul_lt_mul_of_pos_left hgap hdpos
  nlinarith

/-- A deliberately looser version matching a sum truncated at `2*w`. -/
theorem hilbert2_eq_zero_of_two_mul_lt {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w d : ℕ} (hw : 4 ≤ w)
    (hbudget : ∀ n, (∑ t ∈ range (n + 1), hilbert3 A t) ≤ 1 + n * w)
    (hd : 2 * w < d) : hilbert2 A d = 0 :=
  hilbert2_eq_zero_of_cutoff hA hw hbudget (by omega)

/-- The first forbidden pure `x` degree is within the finite parameter range. -/
theorem alpha_le_two_mul_add_one {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w α : ℕ} (hw : 4 ≤ w)
    (hbudget : ∀ n, (∑ t ∈ range (n + 1), hilbert3 A t) ≤ 1 + n * w)
    (hInitial : ∀ d < α, A d 0 0) : α ≤ 2 * w + 1 := by
  by_contra hnot
  have hx : A (2 * w + 1) 0 0 := hInitial _ (by omega)
  have hmem : 2 * w + 1 ∈ standard2 A (2 * w + 1) := by
    apply mem_standard2.mpr
    exact ⟨le_rfl, by simpa using hx⟩
  have hpos : 0 < hilbert2 A (2 * w + 1) :=
    card_pos.mpr ⟨_, hmem⟩
  have hzero := hilbert2_eq_zero_of_two_mul_lt hA hw hbudget (by omega : 2 * w < 2 * w + 1)
  omega

#print axioms hilbert2_eq_zero_of_cutoff
#print axioms alpha_le_two_mul_add_one

end WidthBounds.LexCounting

