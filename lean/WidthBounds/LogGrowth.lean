import WidthBounds.Growth
import Mathlib.NumberTheory.Harmonic.Bounds

/-! Real logarithmic upper bounds for the actual quotient dimensions in the
lexicographic Hilbert-budget class. The coefficient field remains arbitrary. -/

namespace WidthBounds.LogGrowth

open Finset LexCounting MonomialInterface

/-- The project's rational sum is the standard harmonic number. -/
theorem harmonicQ_eq_harmonic (n : ℕ) : Growth.harmonicQ n = harmonic n := by
  simp only [Growth.harmonicQ, harmonic, Nat.cast_add, Nat.cast_one, one_div]

theorem log_add_one_le_harmonicQ (n : ℕ) :
    Real.log ((n : ℝ) + 1) ≤ (Growth.harmonicQ n : ℝ) := by
  simpa only [harmonicQ_eq_harmonic, Nat.cast_add, Nat.cast_one] using
    (_root_.log_add_one_le_harmonic n)

theorem harmonicQ_le_one_add_log (n : ℕ) :
    (Growth.harmonicQ n : ℝ) ≤ 1 + Real.log (n : ℝ) := by
  simpa only [harmonicQ_eq_harmonic] using (_root_.harmonic_le_one_add_log n)

/-- A uniform elementary threshold used to absorb additive linear terms. -/
theorem one_le_log_of_four_le {w : ℕ} (hw : 4 ≤ w) : 1 ≤ Real.log (w : ℝ) := by
  have hTwo := Real.one_sub_inv_le_log_of_pos (by norm_num : (0 : ℝ) < 2)
  have hFour : 1 ≤ Real.log (4 : ℝ) := by
    rw [show (4 : ℝ) = 2 * 2 by norm_num,
      Real.log_mul (by norm_num) (by norm_num)]
    norm_num at hTwo
    linarith
  exact hFour.trans (Real.log_le_log (by norm_num) (by exact_mod_cast hw))

/-- The exact real logarithmic bound before coarsening its constants. -/
theorem harmonic_upper_le_log (w : ℕ) :
    3 * (w : ℝ) + ((2 * w - 1 : ℕ) : ℝ) *
      (Growth.harmonicQ (2 * w - 1) : ℝ) ≤
    3 * (w : ℝ) + ((2 * w - 1 : ℕ) : ℝ) *
      (1 + Real.log ((2 * w - 1 : ℕ) : ℝ)) := by
  exact add_le_add_left (mul_le_mul_of_nonneg_left
    (harmonicQ_le_one_add_log _) (by positivity)) _

/-- A positive fixed constant valid for every integer width at least four. -/
theorem log_upper_le_ten_mul_width_log {w : ℕ} (hw : 4 ≤ w) :
    3 * (w : ℝ) + ((2 * w - 1 : ℕ) : ℝ) *
      (1 + Real.log ((2 * w - 1 : ℕ) : ℝ)) ≤
    10 * (w : ℝ) * Real.log (w : ℝ) := by
  have hwPos : (0 : ℝ) < w := by exact_mod_cast (show 0 < w by omega)
  have hnPos : (0 : ℝ) < ((2 * w - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < 2 * w - 1 by omega)
  have hnLe : ((2 * w - 1 : ℕ) : ℝ) ≤ 2 * (w : ℝ) := by
    exact_mod_cast (show 2 * w - 1 ≤ 2 * w by omega)
  have hLogOne := one_le_log_of_four_le hw
  have hLogTwo : Real.log (2 : ℝ) ≤ 1 := by
    convert Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2) using 1
    norm_num
  have hLog : Real.log ((2 * w - 1 : ℕ) : ℝ) ≤ 1 + Real.log (w : ℝ) := by
    calc
      _ ≤ Real.log (2 * (w : ℝ)) := Real.log_le_log hnPos hnLe
      _ = Real.log (2 : ℝ) + Real.log (w : ℝ) :=
        Real.log_mul (by norm_num) (ne_of_gt hwPos)
      _ ≤ 1 + Real.log (w : ℝ) := add_le_add_right hLogTwo _
  have hFirst := mul_le_mul_of_nonneg_left (add_le_add_left hLog 1)
    (by positivity : (0 : ℝ) ≤ ((2 * w - 1 : ℕ) : ℝ))
  have hSecond := mul_le_mul_of_nonneg_right hnLe
    (show 0 ≤ 1 + (1 + Real.log (w : ℝ)) by linarith)
  have hScale : (w : ℝ) ≤ (w : ℝ) * Real.log (w : ℝ) := by
    nlinarith [mul_nonneg (le_of_lt hwPos) (sub_nonneg.mpr hLogOne)]
  nlinarith

theorem sectionLength_le_log {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ t, t < a → A t 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ t, (∑ s ∈ range (t + 1), hilbert3 A s) ≤ 1 + t * w) :
    (sectionLength A w : ℝ) ≤ 3 * (w : ℝ) +
      ((2 * w - 1 : ℕ) : ℝ) * (1 + Real.log ((2 * w - 1 : ℕ) : ℝ)) := by
  have hQ := Growth.sectionLength_le_harmonic hA hw ha hInitial hx hHS
  have hR : (sectionLength A w : ℝ) ≤ 3 * (w : ℝ) +
      ((2 * w - 1 : ℕ) : ℝ) * (Growth.harmonicQ (2 * w - 1) : ℝ) := by
    exact_mod_cast hQ
  exact hR.trans (harmonic_upper_le_log w)

theorem sectionLength_le_ten_mul_width_log {A : ℕ → ℕ → ℕ → Prop}
    (hA : StandardLex A) {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ t, t < a → A t 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ t, (∑ s ∈ range (t + 1), hilbert3 A s) ≤ 1 + t * w) :
    (sectionLength A w : ℝ) ≤ 10 * (w : ℝ) * Real.log (w : ℝ) :=
  (sectionLength_le_log hA hw ha hInitial hx hHS).trans
    (log_upper_le_ten_mul_width_log hw)

/-- The actual full `x,y` quotient subspace has the exact logarithmic upper bound.
Only its natural dimension is cast to the reals; no characteristic restriction
is placed on the coefficient field. -/
theorem quotient_xy_le_log {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    (hNonzero : monomialIdeal (R := K) S ≠ ⊥)
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    (Module.finrank K (xySubspace (monomialIdeal (R := K) S)) : ℝ) ≤
      3 * (w : ℝ) + ((2 * w - 1 : ℕ) : ℝ) *
        (1 + Real.log ((2 * w - 1 : ℕ) : ℝ)) := by
  have hQ := Growth.quotient_xy_le_harmonic S hUp hLex hNonzero hOne hw hBudget
  have hR :
      (Module.finrank K (xySubspace (monomialIdeal (R := K) S)) : ℝ) ≤
        3 * (w : ℝ) + ((2 * w - 1 : ℕ) : ℝ) *
          (Growth.harmonicQ (2 * w - 1) : ℝ) := by exact_mod_cast hQ
  exact hR.trans (harmonic_upper_le_log w)

theorem quotient_xy_le_ten_mul_width_log {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    (hNonzero : monomialIdeal (R := K) S ≠ ⊥)
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    (Module.finrank K (xySubspace (monomialIdeal (R := K) S)) : ℝ) ≤
      10 * (w : ℝ) * Real.log (w : ℝ) :=
  (quotient_xy_le_log S hUp hLex hNonzero hOne hw hBudget).trans
    (log_upper_le_ten_mul_width_log hw)

#print axioms harmonicQ_eq_harmonic
#print axioms log_add_one_le_harmonicQ
#print axioms harmonicQ_le_one_add_log
#print axioms quotient_xy_le_log
#print axioms quotient_xy_le_ten_mul_width_log

end WidthBounds.LogGrowth
