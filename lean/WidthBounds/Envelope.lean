import WidthBounds.Certificate
import Mathlib.Tactic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-! The new cumulative counting argument, for arbitrary natural-valued profiles.
No ring-theoretic facts are assumed or axiomatized in this file.
-/

namespace WidthBounds

open scoped BigOperators

def qCount (d h : Nat) : Nat := ∑ i ∈ Finset.range h, (d + 1 - i)

theorem qCount_mono {d h k : Nat} (hh : h ≤ k) : qCount d h ≤ qCount d k := by
  exact Finset.sum_le_sum_of_subset (Finset.range_mono hh)

theorem two_qCount (d h : Nat) :
    h ≤ d + 1 → 2 * qCount d h = h * (2 * d + 3 - h) := by
  induction h with
  | zero => simp [qCount]
  | succ h ih =>
    intro hh
    have ih' := ih (by omega)
    have h₁ : d + 1 - h + h = d + 1 := Nat.sub_add_cancel (by omega)
    have h₂ : 2 * d + 3 - h + h = 2 * d + 3 := Nat.sub_add_cancel (by omega)
    have h₃ : 2 * d + 3 - (h + 1) + (h + 1) = 2 * d + 3 :=
      Nat.sub_add_cancel (by omega)
    have hs : qCount d (h + 1) = qCount d h + (d + 1 - h) := by
      simp only [qCount, Finset.sum_range_succ]
    rw [hs]
    nlinarith

theorem two_sum_qCount (a n h : Nat) (hh : h ≤ a) :
    2 * (∑ i ∈ Finset.range n, qCount (a + i) h) =
      n * h * (2 * a + n + 2 - h) := by
  induction n with
  | zero => simp
  | succ n ih =>
    have hq := two_qCount (a + n) h (by omega)
    have h₁ : 2 * a + n + 2 - h = (a - h) + a + n + 2 := by omega
    have h₂ : 2 * a + (n + 1) + 2 - h = (a - h) + a + n + 3 := by omega
    have h₃ : 2 * (a + n) + 3 - h = (a - h) + a + 2 * n + 3 := by omega
    rw [Finset.sum_range_succ, Nat.mul_add, ih, hq, h₁, h₂, h₃]
    ring

/-- Every earlier height bounds the last height; cumulative cost bounds its envelope. -/
theorem admissible_of_cumulative {w a n : Nat} {h : Nat → Nat}
    (hHeight : h (a + n) ≤ a)
    (hMono : ∀ i, i ≤ n → h (a + n) ≤ h (a + i))
    (hBudget : choose3 (a + 2) +
      (∑ i ∈ Finset.range (n + 1), qCount (a + i) (h (a + i))) ≤
        1 + (a + n) * w) :
    admissibleHeight w a (a + n) (h (a + n)) = true := by
  have hSum : (∑ i ∈ Finset.range (n + 1), qCount (a + i) (h (a + n))) ≤
      ∑ i ∈ Finset.range (n + 1), qCount (a + i) (h (a + i)) := by
    apply Finset.sum_le_sum
    intro i hi
    exact qCount_mono (hMono i (by simpa using Nat.le_of_lt_succ (Finset.mem_range.mp hi)))
  have hClosed := two_sum_qCount a (n + 1) (h (a + n)) hHeight
  have hTail : a + n - a + 1 = n + 1 := by omega
  have hInside : a + (a + n) + 3 - h (a + n) =
      2 * a + (n + 1) + 2 - h (a + n) := by omega
  simp only [admissibleHeight, decide_eq_true_eq, hTail, hInside]
  omega

theorem height_le_cap_of_cumulative {w a n : Nat} {h : Nat → Nat}
    (hHeight : h (a + n) ≤ a)
    (hMono : ∀ i, i ≤ n → h (a + n) ≤ h (a + i))
    (hBudget : choose3 (a + 2) +
      (∑ i ∈ Finset.range (n + 1), qCount (a + i) (h (a + i))) ≤
        1 + (a + n) * w) :
    h (a + n) ≤ degreeCap w a (a + n) := by
  exact height_le_degreeCap hHeight (admissible_of_cumulative hHeight hMono hBudget)

/-- The abstract cost condition follows from an actual Hilbert function and its budget. -/
theorem cumulative_cost_of_hilbert {w a n : Nat} {h H : Nat → Nat}
    (hPrefix : (∑ t ∈ Finset.range a, H t) = choose3 (a + 2))
    (hCount : ∀ t, qCount t (h t) ≤ H t)
    (hHS : (∑ t ∈ Finset.range (a + n + 1), H t) ≤ 1 + (a + n) * w) :
    choose3 (a + 2) +
      (∑ i ∈ Finset.range (n + 1), qCount (a + i) (h (a + i))) ≤
        1 + (a + n) * w := by
  have hTail : (∑ i ∈ Finset.range (n + 1), qCount (a + i) (h (a + i))) ≤
      ∑ i ∈ Finset.range (n + 1), H (a + i) :=
    Finset.sum_le_sum (fun i _ => hCount (a + i))
  have hSplit := Finset.sum_range_add H a (n + 1)
  rw [hPrefix] at hSplit
  have hAssoc : a + (n + 1) = a + n + 1 := by omega
  rw [hAssoc] at hSplit
  omega

end WidthBounds
