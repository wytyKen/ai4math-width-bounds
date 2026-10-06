import WidthBounds.ColumnBounds
import WidthBounds.AnalyticArithmetic

/-!
Uniform analytic bounds for standard-monomial families in every width `w ≥ 4`.
The terminal budget, prefix formula, column sum, and Cauchy consequence are all
proved, not assumed. No upper limit on w or finite parameter certificate is used.
The algebraic Hilbert/Bettinumber identifications remain a separate layer.
-/

namespace WidthBounds

open Finset LexCounting Columns

theorem all_widths_analytic_bounds {A : ℕ → ℕ → ℕ → Prop}
    (hA : StandardLex A) {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ d, d < a → A d 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    a + 1 + sectionLength A w < (w + 1).choose 2 ∧
    a + 2 * sectionLength A w ≤ 2 * (w + 1).choose 3 ∧
    sectionLength A w ≤ 3 * (w + 1).choose 4 := by
  let n : Fin a → ℕ := fun i => columnLength A w i
  have h0 : 1 ≤ n ⟨0, by omega⟩ := by
    have hp := columnLength_pos hA hw hHS hInitial (by omega : 0 < a)
    dsimp [n]
    omega
  have hPrefix : choose3 (a + 2) ≤ 1 + (a - 1) * w := by
    have hp := sum_hilbert3_initial hA hInitial
    have hb := hHS (a - 1)
    have hPred : a - 1 + 1 = a := by omega
    rw [hPred, hp] at hb
    exact hb
  have hBudget : (∑ i, n i * (n i + 1)) ≤
      2 * (1 + (n ⟨0, by omega⟩ - 1) * w) := by
    have hb := terminal_triangle_budget hA hw (by omega : 0 < a) hInitial hHS
    change (∑ i : Fin a, columnLength A w i * (columnLength A w i + 1)) ≤ _
    rw [Fin.sum_univ_eq_sum_range (fun i => columnLength A w i * (columnLength A w i + 1)) a]
    exact hb
  have hLength : (∑ i, n i) = sectionLength A w := by
    simpa only [n, Fin.sum_univ_eq_sum_range] using
      sum_columns_eq_sectionLength hA hw hx hHS
  have hBounds := analytic_column_binomial_bounds hw ha n h0 hPrefix hBudget
  simpa only [hLength] using hBounds

theorem all_widths_strict_improvement {A : ℕ → ℕ → ℕ → Prop}
    (hA : StandardLex A) {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ d, d < a → A d 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    a + 1 + sectionLength A w ≤ (w + 1).choose 2 - 1 := by
  have h := (all_widths_analytic_bounds hA hw ha hInitial hx hHS).1
  omega

#print axioms all_widths_analytic_bounds
#print axioms all_widths_strict_improvement

end WidthBounds
