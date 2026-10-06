import WidthBounds.Prefix
import Mathlib.Algebra.Order.BigOperators.Ring.Finset

/-!
The arithmetic part of the uniform column-length argument. The inputs are
natural-number prefix and terminal budgets. Completing the square and
Cauchy--Schwarz are proved in the integers, so the exceptional first entry
may be negative. No finite enumeration or square-root approximation occurs.
-/

namespace WidthBounds

open Finset

/-- Remove the factorial from the prefix binomial coefficient. -/
theorem six_mul_choose3_add_two (a : ℕ) :
    6 * choose3 (a + 2) = a * (a + 1) * (a + 2) := by
  rw [choose3_eq_natChoose]
  have h := Nat.descFactorial_eq_factorial_mul_choose (a + 2) 3
  norm_num [Nat.descFactorial_succ, Nat.descFactorial_zero, Nat.factorial] at h
  nlinarith [h]

/-- The low-degree budget forces a uniform upper bound on the number of columns. -/
theorem alpha_le_width_sub_two {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hPrefix : choose3 (a + 2) ≤ 1 + (a - 1) * w) : a ≤ w - 2 := by
  have hprod := six_mul_choose3_add_two a
  have hBudget := Nat.mul_le_mul_left 6 hPrefix
  have hpred : a - 1 + 1 = a := by omega
  have hpoly : a ^ 2 + 4 * a + 6 ≤ 6 * w := by
    by_contra h
    have hstrict : 6 * w < a ^ 2 + 4 * a + 6 := by omega
    have hmul := Nat.mul_lt_mul_of_pos_left hstrict (show 0 < a - 1 by omega)
    nlinarith
  by_contra h
  have haw : w - 1 ≤ a := by omega
  have hwPred : w - 1 + 1 = w := by omega
  have hsq : (w - 1) ^ 2 ≤ a ^ 2 := Nat.pow_le_pow_left haw 2
  nlinarith [sq_nonneg (w - 3 : ℤ)]

/-- A squared Cauchy inequality for arbitrary signed integer vectors. -/
theorem int_sum_sq_le {a : ℕ} (v : Fin a → ℤ) :
    (∑ i, v i) ^ 2 ≤ (a : ℤ) * ∑ i, (v i) ^ 2 := by
  have h := Finset.sum_mul_sq_le_sq_mul_sq (R := ℤ) univ v (fun _ => 1)
  simpa [mul_comm] using h

/-- Complete the square before discarding the correlation with the first column. -/
theorem column_cauchy_bound {w a : ℕ} (ha : 2 ≤ a) (n : Fin a → ℕ)
    (h0 : 1 ≤ n ⟨0, by omega⟩)
    (hBudget : (∑ i, n i * (n i + 1)) ≤
      2 * (1 + (n ⟨0, by omega⟩ - 1) * w)) :
    (2 * (∑ i, (n i : ℤ)) + (a : ℤ) - 2 * w) ^ 2 ≤
      (a : ℤ) * (4 * ((w : ℤ) - 1) * ((w : ℤ) - 2) + a) := by
  let z : Fin a := ⟨0, by omega⟩
  let v : Fin a → ℤ := fun i => 2 * n i + 1 - if i = z then 2 * (w : ℤ) else 0
  have hsum : (∑ i, v i) = 2 * (∑ i, (n i : ℤ)) + (a : ℤ) - 2 * w := by
    simp [v, sum_sub_distrib, sum_add_distrib, mul_sum]
  have hpoint (i : Fin a) : (v i) ^ 2 = 4 * ((n i : ℤ) * (n i + 1)) + 1 +
      if i = z then -8 * (w : ℤ) * n z - 4 * w + 4 * (w : ℤ) ^ 2 else 0 := by
    dsimp [v]
    split_ifs with hi
    · subst i; ring
    · ring
  have hsqsum : (∑ i, (v i) ^ 2) =
      4 * (∑ i, ((n i : ℤ) * (n i + 1))) + a -
      8 * (w : ℤ) * n z - 4 * w + 4 * (w : ℤ) ^ 2 := by
    simp_rw [hpoint]
    simp [sum_add_distrib, mul_sum]
    ring
  have hBudgetInt : (∑ i, ((n i : ℤ) * (n i + 1))) ≤
      2 * (1 + ((n z : ℤ) - 1) * w) := by
    have h := (Int.ofNat_le.mpr hBudget)
    simpa only [Nat.cast_sum, Nat.cast_mul, Nat.cast_add,
      Nat.cast_ofNat, Int.natCast_sub h0, z] using h
  have hsq : (∑ i, (v i) ^ 2) ≤
      4 * ((w : ℤ) - 1) * ((w : ℤ) - 2) + a := by
    rw [hsqsum]
    nlinarith
  have hc := int_sum_sq_le v
  rw [hsum] at hc
  exact hc.trans (mul_le_mul_of_nonneg_left hsq (Int.natCast_nonneg a))

/-- The strict polynomial comparison, without any bounded parameter search. -/
theorem analytic_polynomial_bound {w a ell : ℤ} (hw : 4 ≤ w)
    (haUpper : a ≤ w - 2)
    (hc : (2 * ell + a - 2 * w) ^ 2 ≤ a * (4 * (w - 1) * (w - 2) + a)) :
    2 * (a + 1 + ell) < w * (w + 1) := by
  let T := w ^ 2 - w - a - 2
  have hpos : 0 < (w - 2) ^ 2 * (w - 1) * (w - 3) := by
    exact mul_pos (mul_pos (sq_pos_of_pos (by omega)) (by omega)) (by omega)
  have hextra : 0 ≤ 2 * (w - 2) * (w - 2 - a) * (3 * w - 1) := by
    apply mul_nonneg
    · exact mul_nonneg (by nlinarith) (by omega)
    · omega
  have hdiff : a * (4 * (w - 1) * (w - 2) + a) < T ^ 2 := by
    dsimp [T]
    nlinarith only [hpos, hextra]
  have hT : 0 < T := by
    dsimp [T]
    nlinarith [mul_pos (show 0 < w by omega) (show 0 < w - 2 by omega)]
  have hS : 2 * ell + a - 2 * w < T := by
    nlinarith [sq_nonneg (2 * ell + a - 2 * w - T)]
  dsimp [T] at hS
  linarith

theorem two_mul_natChoose_two (w : ℕ) :
    2 * (w + 1).choose 2 = w * (w + 1) := by
  have h := Nat.descFactorial_eq_factorial_mul_choose (w + 1) 2
  norm_num [Nat.descFactorial_succ, Nat.descFactorial_zero, Nat.factorial] at h
  nlinarith [h]

/-- The higher two target binomials dominate the first one for every width at least four. -/
theorem higher_binomial_comparison {w : ℕ} (hw : 4 ≤ w) :
    (w + 1).choose 2 ≤ (w + 1).choose 3 ∧
    (w + 1).choose 2 ≤ 3 * (w + 1).choose 4 := by
  have h3 := Nat.choose_succ_right_eq (w + 1) 2
  have h4 := Nat.choose_succ_right_eq (w + 1) 3
  have hp2 : w + 1 - 2 = w - 1 := by omega
  have hp3 : w + 1 - 3 = w - 2 := by omega
  norm_num only at h3 h4
  rw [hp2] at h3
  rw [hp3] at h4
  have hmul2 := Nat.mul_le_mul_left ((w + 1).choose 2) (show 3 ≤ w - 1 by omega)
  have hmul3 := Nat.mul_le_mul_left ((w + 1).choose 3) (show 2 ≤ w - 2 by omega)
  constructor <;> nlinarith

/-- Uniform arithmetic theorem. Its hypotheses are the original two budgets,
not a completed-square estimate or a bound on the resulting length. -/
theorem analytic_column_binomial_bounds {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (n : Fin a → ℕ) (h0 : 1 ≤ n ⟨0, by omega⟩)
    (hPrefix : choose3 (a + 2) ≤ 1 + (a - 1) * w)
    (hBudget : (∑ i, n i * (n i + 1)) ≤
      2 * (1 + (n ⟨0, by omega⟩ - 1) * w)) :
    a + 1 + (∑ i, n i) < (w + 1).choose 2 ∧
    a + 2 * (∑ i, n i) ≤ 2 * (w + 1).choose 3 ∧
    (∑ i, n i) ≤ 3 * (w + 1).choose 4 := by
  have hAlpha := alpha_le_width_sub_two hw ha hPrefix
  have hc := column_cauchy_bound ha n h0 hBudget
  have hAlphaInt : (a : ℤ) ≤ (w : ℤ) - 2 := by
    have h := Int.ofNat_le.mpr hAlpha
    simpa only [Int.natCast_sub (show 2 ≤ w by omega), Nat.cast_ofNat] using h
  have hstrict := analytic_polynomial_bound (w := (w : ℤ))
    (by exact_mod_cast hw) hAlphaInt hc
  have hNat : 2 * (a + 1 + (∑ i, n i)) < w * (w + 1) := by
    exact_mod_cast hstrict
  have h2 := two_mul_natChoose_two w
  have hfirst : a + 1 + (∑ i, n i) < (w + 1).choose 2 := by omega
  have hHigher := higher_binomial_comparison hw
  exact ⟨hfirst, by omega, by omega⟩

#print axioms analytic_column_binomial_bounds

end WidthBounds
