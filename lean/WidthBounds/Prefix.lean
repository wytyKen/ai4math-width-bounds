import WidthBounds.Arithmetic
import WidthBounds.LexCounting
import Mathlib.Data.Nat.Choose.Sum

/-!
Exact low-degree counts derived from the sets of standard monomials.
If the pure power `x^d` is standard, lex closure makes every degree `d`
monomial standard.  Counting these sets gives the two required prefix sums.
-/

namespace WidthBounds

open Finset

theorem choose2_eq_natChoose (n : ℕ) : choose2 n = n.choose 2 := by
  exact (Nat.choose_two_right n).symm

theorem choose3_eq_natChoose (n : ℕ) : choose3 n = n.choose 3 := by
  rw [Nat.choose_eq_descFactorial_div_factorial]
  simp only [choose3, Nat.descFactorial_succ, Nat.descFactorial_zero,
    Nat.sub_zero, Nat.mul_one]
  norm_num [Nat.factorial]
  congr 1
  ring

private theorem sum_succ_eq_choose2 (a : ℕ) :
    (∑ d ∈ range a, (d + 1)) = choose2 (a + 1) := by
  cases a with
  | zero => simp [choose2]
  | succ a =>
    rw [choose2_eq_natChoose]
    simpa [Nat.add_assoc] using Nat.sum_range_add_choose a 1

private theorem sum_choose2_eq_choose3 (a : ℕ) :
    (∑ d ∈ range a, choose2 (d + 2)) = choose3 (a + 2) := by
  cases a with
  | zero => simp [choose3]
  | succ a =>
    simp_rw [choose2_eq_natChoose, choose3_eq_natChoose]
    simpa [Nat.add_assoc] using Nat.sum_range_add_choose a 2

namespace LexCounting

theorem standard_of_pure_x {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {d i j k : ℕ} (hx : A d 0 0) (hTotal : i + j + k = d) : A i j k := by
  apply hA.lex (i := d) (j := 0) (k := 0) (by omega) _ hx
  by_cases hi : i < d
  · exact Or.inl hi
  · exact Or.inr ⟨by omega, by omega⟩

theorem hilbert2_eq_of_pure_x {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {d : ℕ} (hx : A d 0 0) : hilbert2 A d = d + 1 := by
  have hSet : standard2 A d = range (d + 1) := by
    ext i
    simp only [mem_standard2, mem_range]
    constructor
    · intro hi
      omega
    · intro hi
      refine ⟨by omega, standard_of_pure_x hA hx ?_⟩
      omega
  simp only [hilbert2, hSet, card_range]

theorem hilbert3_eq_of_pure_x {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {d : ℕ} (hx : A d 0 0) : hilbert3 A d = choose2 (d + 2) := by
  classical
  let columns : Finset (Σ _ : ℕ, ℕ) :=
    (range (d + 1)).sigma (fun i => range (d - i + 1))
  have hCard : (standard3 A d).card = columns.card := by
    apply card_bij (fun p _ => (⟨p.1, p.2⟩ : Σ _ : ℕ, ℕ))
    · intro p hp
      obtain ⟨hpSum, _⟩ := mem_standard3.mp hp
      simp only [columns, mem_sigma, mem_range]
      omega
    · intro p hp q hq hpq
      cases p with | mk i j =>
        cases q with | mk i' j' =>
          simpa using hpq
    · intro p hp
      obtain ⟨hi, hj⟩ := mem_sigma.mp hp
      have hid := mem_range.mp hi
      have hjd := mem_range.mp hj
      refine ⟨(p.1, p.2), ?_, rfl⟩
      apply mem_standard3.mpr
      refine ⟨by omega, standard_of_pure_x hA hx ?_⟩
      omega
  have hSum : columns.card = ∑ i ∈ range (d + 1), (d - i + 1) := by
    simp [columns]
  have hReflect : (∑ i ∈ range (d + 1), (d - i + 1)) =
      ∑ i ∈ range (d + 1), (i + 1) := by
    simpa using sum_range_reflect (fun i : ℕ => i + 1) (d + 1)
  calc
    hilbert3 A d = columns.card := hCard
    _ = ∑ i ∈ range (d + 1), (d - i + 1) := hSum
    _ = ∑ i ∈ range (d + 1), (i + 1) := hReflect
    _ = choose2 (d + 2) := sum_succ_eq_choose2 (d + 1)

theorem sum_hilbert2_initial {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {a : ℕ} (hInitial : ∀ d, d < a → A d 0 0) :
    (∑ d ∈ range a, hilbert2 A d) = choose2 (a + 1) := by
  calc
    (∑ d ∈ range a, hilbert2 A d) = ∑ d ∈ range a, (d + 1) := by
      apply sum_congr rfl
      intro d hd
      exact hilbert2_eq_of_pure_x hA (hInitial d (mem_range.mp hd))
    _ = choose2 (a + 1) := sum_succ_eq_choose2 a

theorem sum_hilbert3_initial {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {a : ℕ} (hInitial : ∀ d, d < a → A d 0 0) :
    (∑ d ∈ range a, hilbert3 A d) = choose3 (a + 2) := by
  calc
    (∑ d ∈ range a, hilbert3 A d) = ∑ d ∈ range a, choose2 (d + 2) := by
      apply sum_congr rfl
      intro d hd
      exact hilbert3_eq_of_pure_x hA (hInitial d (mem_range.mp hd))
    _ = choose3 (a + 2) := sum_choose2_eq_choose3 a

end LexCounting
end WidthBounds
