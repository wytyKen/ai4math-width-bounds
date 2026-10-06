import WidthBounds.LowerConstructionBounds
import Mathlib.Analysis.Asymptotics.Theta
import Mathlib.Data.Nat.Lattice
import WidthBounds.LogGrowth
import WidthBounds.LogLower

/-!
# The extremal xy dimension in the actual finite-colength lex class

The set of lengths is defined using actual polynomial ideals and actual
quotient-space dimensions. Its supremum is proved to be attained for `w >= 4`.
This class is not asserted to be realizable by numerical semigroups.
-/

namespace WidthBounds.LexExtremal

noncomputable section

open MvPolynomial Module Finset MonomialInterface

variable {K : Type*} [Field K]

/-- The actual finite-colength lex class with the cumulative dimension budget. -/
structure Admissible (w : ℕ) (S : Set (Fin 3 →₀ ℕ)) : Prop where
  upper : IsUpperSet S
  lex : IsLexExponentSet S
  finite : Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)
  x_standard : standard (monomialIdeal (R := K) S) 1 0 0
  budget : ∀ d, (∑ t ∈ range (d + 1),
    Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w

theorem Admissible.nonzero {w : ℕ} {S : Set (Fin 3 →₀ ℕ)}
    (h : Admissible (K := K) w S) : monomialIdeal (R := K) S ≠ ⊥ := by
  letI := h.finite
  obtain ⟨n, hn⟩ := exists_pure_z_mem_of_finite_quotient (K := K) S h.upper
  apply (monomialIdeal_ne_bot_iff S).mpr
  exact ⟨exponent 0 0 n, (monomial_mem_monomialIdeal_iff S h.upper _).mp hn⟩

/-- The lengths attained by genuine ideals in the specified class. -/
def lengthSet (K : Type*) [Field K] (w : ℕ) : Set ℕ :=
  {n | ∃ S : Set (Fin 3 →₀ ℕ), Admissible (K := K) w S ∧
    Module.finrank K (xySubspace (monomialIdeal (R := K) S)) = n}

/-- The natural supremum; actual maximality is proved for `w >= 4`. -/
def maxLexLength (K : Type*) [Field K] (w : ℕ) : ℕ := sSup (lengthSet K w)

theorem lower_admissible {s w : ℕ} (hs : 2 ≤ s) (hw : s * s ≤ w) :
    Admissible (K := K) w (Lower.lowerExponentSet s) where
  upper := Lower.lowerExponentSet_isUpper s
  lex := Lower.lowerExponentSet_isLex s
  finite := Lower.lowerIdeal_quotient_finite s
  x_standard := Lower.x_standard_lowerIdeal hs
  budget := Lower.lowerIdeal_finrank_budget_of_square_le (K := K) (by omega) hw

theorem lower_length_mem {s w : ℕ} (hs : 2 ≤ s) (hw : s * s ≤ w) :
    Lower.lowerSectionLength s ∈ lengthSet K w :=
  ⟨Lower.lowerExponentSet s, lower_admissible hs hw, Lower.lowerIdeal_xy_finrank hs⟩

theorem lengthSet_nonempty {w : ℕ} (hw : 4 ≤ w) : (lengthSet K w).Nonempty :=
  ⟨Lower.lowerSectionLength 2, lower_length_mem (by omega) (by omega)⟩

theorem lengthSet_bddAbove {w : ℕ} (hw : 4 ≤ w) : BddAbove (lengthSet K w) := by
  refine ⟨(w + 1).choose 2, ?_⟩
  rintro n ⟨S, h, rfl⟩
  obtain ⟨a, _, _, _, hStrict, _⟩ := monomialIdeal_all_widths_dimension_bounds
    S h.upper h.lex h.nonzero h.x_standard hw h.budget
  omega

/-- The extremal value is the length of an actual member of the class. -/
theorem maxLexLength_mem {w : ℕ} (hw : 4 ≤ w) : maxLexLength K w ∈ lengthSet K w :=
  Nat.sSup_mem (lengthSet_nonempty hw) (lengthSet_bddAbove hw)

theorem length_le_maxLexLength {w n : ℕ} (hw : 4 ≤ w) (hn : n ∈ lengthSet K w) :
    n ≤ maxLexLength K w := le_csSup (lengthSet_bddAbove hw) hn

/-- The supremum is a maximum, rather than an arbitrary upper envelope. -/
theorem maxLexLength_isGreatest {w : ℕ} (hw : 4 ≤ w) :
    IsGreatest (lengthSet K w) (maxLexLength K w) :=
  ⟨maxLexLength_mem hw, fun _ hn => length_le_maxLexLength hw hn⟩

/-- Every extremal value satisfies the same actual-ideal logarithmic bound. -/
theorem maxLexLength_le_log {w : ℕ} (hw : 4 ≤ w) :
    (maxLexLength K w : ℝ) ≤ 10 * (w : ℝ) * Real.log (w : ℝ) := by
  obtain ⟨S, h, hDim⟩ := maxLexLength_mem (K := K) hw
  have hb := LogGrowth.quotient_xy_le_ten_mul_width_log
    S h.upper h.lex h.nonzero h.x_standard hw h.budget
  simpa only [hDim] using hb

/-- For each sufficiently large budget, an actual square-parameter ideal
with parameter `sqrt w` supplies the logarithmic lower bound. -/
theorem log_le_maxLexLength {w : ℕ} (hw : 64 ≤ w) :
    (w : ℝ) * Real.log (w : ℝ) / 16 ≤ (maxLexLength K w : ℝ) := by
  obtain ⟨hs, hsq⟩ := LogLower.sqrt_admissible hw
  have hMem := lower_length_mem (K := K) hs hsq
  have hle := length_le_maxLexLength (by omega : 4 ≤ w) hMem
  have hReal : (Lower.lowerSectionLength (Nat.sqrt w) : ℝ) ≤
      (maxLexLength K w : ℝ) := by exact_mod_cast hle
  exact (LogLower.lowerSectionLength_log_lower hw).trans hReal

theorem maxLexLength_log_bounds {w : ℕ} (hw : 64 ≤ w) :
    (w : ℝ) * Real.log (w : ℝ) / 16 ≤ (maxLexLength K w : ℝ) ∧
      (maxLexLength K w : ℝ) ≤ 10 * (w : ℝ) * Real.log (w : ℝ) :=
  ⟨log_le_maxLexLength hw, maxLexLength_le_log (by omega)⟩

/-- The attained extremal xy dimension of the actual finite-colength lex
class has standard mathlib growth order `Theta(w log w)` along natural widths.
This is not a claim about a class of numerical semigroups. -/
theorem maxLexLength_isTheta :
    Asymptotics.IsTheta Filter.atTop
      (fun w : ℕ => (maxLexLength K w : ℝ))
      (fun w : ℕ => (w : ℝ) * Real.log (w : ℝ)) := by
  constructor
  · apply Asymptotics.IsBigO.of_bound 10
    apply Filter.eventually_atTop.mpr
    refine ⟨64, ?_⟩
    intro w hw
    have hLog : 0 ≤ Real.log (w : ℝ) :=
      Real.log_nonneg (by exact_mod_cast (show 1 ≤ w by omega))
    have hProd : 0 ≤ (w : ℝ) * Real.log (w : ℝ) := mul_nonneg (by positivity) hLog
    change ‖(maxLexLength K w : ℝ)‖ ≤ 10 * ‖(w : ℝ) * Real.log (w : ℝ)‖
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg (by positivity), abs_of_nonneg hProd]
    simpa only [mul_assoc] using maxLexLength_le_log (K := K) (show 4 ≤ w by omega)
  · apply Asymptotics.IsBigO.of_bound 16
    apply Filter.eventually_atTop.mpr
    refine ⟨64, ?_⟩
    intro w hw
    have hLog : 0 ≤ Real.log (w : ℝ) :=
      Real.log_nonneg (by exact_mod_cast (show 1 ≤ w by omega))
    have hProd : 0 ≤ (w : ℝ) * Real.log (w : ℝ) := mul_nonneg (by positivity) hLog
    change ‖(w : ℝ) * Real.log (w : ℝ)‖ ≤ 16 * ‖(maxLexLength K w : ℝ)‖
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg hProd, abs_of_nonneg (by positivity)]
    have h := log_le_maxLexLength (K := K) hw
    nlinarith

#print axioms maxLexLength_isGreatest
#print axioms maxLexLength_log_bounds
#print axioms maxLexLength_isTheta

end

end WidthBounds.LexExtremal
