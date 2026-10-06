import WidthBounds.LowerConstructionBounds
import Mathlib.NumberTheory.Harmonic.Bounds
import Mathlib.Data.Nat.Sqrt

/-!
# A real logarithmic lower bound at every sufficiently large width

The explicit finite-colength lex ideal uses the integer parameter `Nat.sqrt w`.
Its square-width budget is at most `w`. These statements concern the abstract
lex class only and do not construct numerical semigroups.
-/

namespace WidthBounds.LogLower

noncomputable section

private theorem harmonicQ_eq_harmonic (n : ℕ) : Growth.harmonicQ n = harmonic n := by
  simp [Growth.harmonicQ, harmonic, one_div]

/-- The integer square-root parameter is valid for the explicit lower family. -/
theorem sqrt_admissible {w : ℕ} (hw : 64 ≤ w) :
    2 ≤ Nat.sqrt w ∧ Nat.sqrt w * Nat.sqrt w ≤ w := by
  exact ⟨Nat.le_sqrt.mpr (by omega), Nat.sqrt_le w⟩

private theorem three_le_log_of_sixtyFour_le {w : ℕ} (hw : 64 ≤ w) :
    3 ≤ Real.log (w : ℝ) := by
  have htwo : (1 / 2 : ℝ) ≤ Real.log 2 := by
    have h := Real.one_sub_inv_le_log_of_pos (show (0 : ℝ) < 2 by norm_num)
    norm_num at h ⊢
    exact h
  have hpow := Real.log_pow (2 : ℝ) 6
  norm_num at hpow
  have h64 : (3 : ℝ) ≤ Real.log 64 := by linarith
  exact h64.trans (Real.log_le_log (by norm_num) (by exact_mod_cast hw))

/-- The finite harmonic lower bound, transported to the real logarithm. -/
theorem lowerSectionLength_log_add_one (s : ℕ) :
    (s : ℝ) ^ 2 * Real.log (s + 1 : ℕ) ≤
      (Lower.lowerSectionLength s : ℝ) + ((s : ℝ) ^ 2 + s) / 2 := by
  have hrat := Lower.lowerSectionLength_harmonic s
  rw [harmonicQ_eq_harmonic] at hrat
  have hrat' : (s : ℚ) ^ 2 * harmonic s ≤
      (Lower.lowerSectionLength s : ℚ) + ((s : ℚ) ^ 2 + s) / 2 := by
    simpa only [Nat.cast_mul, pow_two] using hrat
  have hreal : (s : ℝ) ^ 2 * (harmonic s : ℝ) ≤
      (Lower.lowerSectionLength s : ℝ) + ((s : ℝ) ^ 2 + s) / 2 := by
    have h := (Rat.cast_le (K := ℝ)).mpr hrat'
    simpa only [Rat.cast_mul, Rat.cast_pow, Rat.cast_natCast, Rat.cast_add,
      Rat.cast_div, Rat.cast_ofNat] using h
  exact (mul_le_mul_of_nonneg_left (log_add_one_le_harmonic s) (sq_nonneg _)).trans hreal

/-- An explicit lower bound for every width `w ≥ 64`, not only square widths. -/
theorem lowerSectionLength_log_lower {w : ℕ} (hw : 64 ≤ w) :
    (w : ℝ) * Real.log w / 16 ≤
      (Lower.lowerSectionLength (Nat.sqrt w) : ℝ) := by
  let s := Nat.sqrt w
  have hsNat : 2 ≤ s := (sqrt_admissible hw).1
  have hs : (2 : ℝ) ≤ s := by exact_mod_cast hsNat
  have hnextNat : w < (s + 1) * (s + 1) := by
    simpa [s, Nat.succ_eq_add_one] using Nat.lt_succ_sqrt w
  have hnext : (w : ℝ) ≤ ((s : ℝ) + 1) ^ 2 := by
    have hc : (w : ℝ) < ((s : ℝ) + 1) * ((s : ℝ) + 1) := by
      exact_mod_cast hnextNat
    nlinarith
  have hwidth : (w : ℝ) ≤ 4 * (s : ℝ) ^ 2 := by nlinarith
  have hwpos : (0 : ℝ) < w := by exact_mod_cast (show 0 < w by omega)
  have hlog : Real.log (w : ℝ) ≤ 2 * Real.log ((s : ℝ) + 1) := by
    have h := Real.log_le_log hwpos hnext
    rw [Real.log_pow] at h
    norm_num at h ⊢
    exact h
  have hfinite := lowerSectionLength_log_add_one s
  push_cast at hfinite
  have hlog3 := three_le_log_of_sixtyFour_le hw
  have hmul := mul_le_mul_of_nonneg_left hlog (sq_nonneg (s : ℝ))
  have hlog3mul := mul_le_mul_of_nonneg_left hlog3 (sq_nonneg (s : ℝ))
  have hsmall : (s : ℝ) ≤ (s : ℝ) ^ 2 / 2 := by nlinarith
  have hsLower : (s : ℝ) ^ 2 * Real.log w / 4 ≤
      (Lower.lowerSectionLength s : ℝ) := by
    nlinarith
  have hscale := mul_le_mul_of_nonneg_right hwidth (show 0 ≤ Real.log (w : ℝ) by linarith)
  change (w : ℝ) * Real.log w / 16 ≤ (Lower.lowerSectionLength s : ℝ)
  nlinarith

/-- The lower bound is attained by the full xy quotient subspace of a real
finite-colength lex ideal over any field. -/
theorem lowerIdeal_xy_log_lower {K : Type*} [Field K] {w : ℕ} (hw : 64 ≤ w) :
    (w : ℝ) * Real.log w / 16 ≤
      (Module.finrank K (MonomialInterface.xySubspace
        (Lower.lowerIdeal (K := K) (Nat.sqrt w))) : ℝ) := by
  rw [Lower.lowerIdeal_xy_finrank (sqrt_admissible hw).1]
  exact lowerSectionLength_log_lower hw

#print axioms sqrt_admissible
#print axioms lowerSectionLength_log_add_one
#print axioms lowerSectionLength_log_lower
#print axioms lowerIdeal_xy_log_lower

end

end WidthBounds.LogLower
