import WidthBounds.TorOneBounds
import WidthBounds.LowerConstruction
import WidthBounds.LowerProfile

/-!
# Exact counts for the explicit square-parameter lex family

The construction belongs to the abstract lex class with the cumulative Hilbert
budget. It does not construct a numerical semigroup or a semigroup lower bound.
-/

namespace WidthBounds.Lower

noncomputable section

open Finset LexCounting MonomialInterface Columns

/-- The product test describes a full column, including the zero-length cases. -/
theorem lower_column_test (s i j : ℕ) :
    (i + 1) * (i + j + 1) ≤ s * s ↔ j < s * s / (i + 1) - i := by
  have hdiv : i + j + 1 ≤ s * s / (i + 1) ↔
      (i + j + 1) * (i + 1) ≤ s * s :=
    Nat.le_div_iff_mul_le (show 0 < i + 1 by omega)
  rw [Nat.mul_comm (i + j + 1) (i + 1)] at hdiv
  omega

/-- An elementary rational upper bound for a natural quotient's rounding error. -/
theorem rational_div_le_nat_div_add_one (m r : ℕ) :
    (m : ℚ) / (r + 1 : ℕ) ≤ (m / (r + 1) : ℕ) + (1 : ℚ) := by
  have hPos : (0 : ℚ) < (r + 1 : ℕ) := by positivity
  apply (div_le_iff₀ hPos).mpr
  have hRem := Nat.mod_lt m (show 0 < r + 1 by omega)
  have hEq := Nat.div_add_mod m (r + 1)
  have hNat : m ≤ (m / (r + 1) + 1) * (r + 1) := by nlinarith
  exact_mod_cast hNat

/-- A finite harmonic comparison, with no logarithmic asymptotic interface. -/
theorem harmonic_le_divisor_sum_add (m s : ℕ) :
    (m : ℚ) * Growth.harmonicQ s ≤
      ((∑ i ∈ range s, m / (i + 1) : ℕ) : ℚ) + s := by
  rw [Growth.harmonicQ, Finset.mul_sum]
  have h := Finset.sum_le_sum (s := range s)
    (fun i _ => rational_div_le_nat_div_add_one m i)
  simpa [mul_one_div, Nat.cast_sum, sum_add_distrib] using h

theorem sum_range_rat (s : ℕ) :
    (∑ i ∈ range s, (i : ℚ)) = (s : ℚ) * ((s : ℚ) - 1) / 2 := by
  induction s with
  | zero => simp
  | succ s ih =>
    rw [sum_range_succ, ih]
    push_cast
    ring

/-- The exact finite column sum for the square-parameter construction. -/
def lowerSectionLength (s : ℕ) : ℕ :=
  ∑ i ∈ range s, (s * s / (i + 1) - i)

theorem lowerSectionLength_add_sum_indices (s : ℕ) :
    lowerSectionLength s + (∑ i ∈ range s, i) =
      ∑ i ∈ range s, s * s / (i + 1) := by
  rw [lowerSectionLength, ← sum_add_distrib]
  apply sum_congr rfl
  intro i hi
  have hiS : i + 1 ≤ s := by have := mem_range.mp hi; omega
  have hDiv : s ≤ s * s / (i + 1) :=
    (Nat.le_div_iff_mul_le (show 0 < i + 1 by omega)).mpr
      (Nat.mul_le_mul_left s hiS)
  exact Nat.sub_add_cancel (by omega)

/-- A precise rational harmonic lower bound; no logarithmic asymptotic claim
or numerical-semigroup realization is part of this statement. -/
theorem lowerSectionLength_harmonic (s : ℕ) :
    ((s * s : ℕ) : ℚ) * Growth.harmonicQ s ≤
      (lowerSectionLength s : ℚ) + ((s : ℚ) ^ 2 + s) / 2 := by
  have h := harmonic_le_divisor_sum_add (s * s) s
  have hSum : ((∑ i ∈ range s, s * s / (i + 1) : ℕ) : ℚ) =
      (lowerSectionLength s : ℚ) + (∑ i ∈ range s, (i : ℚ)) := by
    have hc := congrArg (fun n : ℕ => (n : ℚ))
      (lowerSectionLength_add_sum_indices s).symm
    simpa only [Nat.cast_add, Nat.cast_sum] using hc
  rw [hSum, sum_range_rat] at h
  calc
    _ ≤ (lowerSectionLength s : ℚ) + (s : ℚ) * ((s : ℚ) - 1) / 2 + s := h
    _ = _ := by ring

theorem lower_columnLength_eq {s : ℕ} (hs : 2 ≤ s) (i : ℕ) :
    columnLength (lowerStandard s) (s * s) i = s * s / (i + 1) - i := by
  have hw : 4 ≤ s * s := by nlinarith
  have hTest : ∀ j, j < columnLength (lowerStandard s) (s * s) i ↔
      j < s * s / (i + 1) - i := by
    intro j
    have hColumn : lowerStandard s i j 0 ↔
        j < columnLength (lowerStandard s) (s * s) i :=
      standard_iff_lt_columnLength (lowerStandard_standardLex s) hw
        (lower_hilbert3_budget (by omega : 1 ≤ s))
    rw [← hColumn]
    simpa only [lowerStandard, Nat.add_zero] using lower_column_test s i j
  have hLeft := hTest (columnLength (lowerStandard s) (s * s) i)
  have hRight := hTest (s * s / (i + 1) - i)
  omega

theorem lower_sectionLength_eq {s : ℕ} (hs : 2 ≤ s) :
    sectionLength (lowerStandard s) (s * s) = lowerSectionLength s := by
  have hw : 4 ≤ s * s := by nlinarith
  have hx : ¬ lowerStandard s s 0 0 := by
    unfold lowerStandard
    simp only [Nat.add_zero]
    nlinarith
  have hSum := sum_columns_eq_sectionLength (lowerStandard_standardLex s) hw hx
    (lower_hilbert3_budget (by omega : 1 ≤ s))
  rw [← hSum]
  unfold lowerSectionLength
  exact sum_congr rfl (fun i _ => lower_columnLength_eq hs i)

variable {K : Type*} [Field K]

theorem standard_lowerIdeal_eq_lowerStandard (s : ℕ) :
    standard (lowerIdeal (K := K) s) = lowerStandard s := by
  funext i j k
  exact propext (standard_lowerIdeal_iff s i j k)

/-- The actual homogeneous quotient dimensions satisfy the budget at every
degree. Finiteness and lex closure were proved from the exponent construction. -/
theorem lowerIdeal_finrank_budget {s : ℕ} (hs : 1 ≤ s) (d : ℕ) :
    (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) (lowerExponentSet s) t)) ≤
      1 + d * (s * s) := by
  simp_rw [finrank_quotientHomogeneous _ (lowerExponentSet_isUpper s)]
  change (∑ t ∈ range (d + 1), hilbert3 (standard (lowerIdeal (K := K) s)) t) ≤ _
  rw [standard_lowerIdeal_eq_lowerStandard]
  exact lower_hilbert3_budget hs d

/-- The same actual ideal is admissible for every larger width budget. -/
theorem lowerIdeal_finrank_budget_of_square_le {s w : ℕ}
    (hs : 1 ≤ s) (hw : s * s ≤ w) (d : ℕ) :
    (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) (lowerExponentSet s) t)) ≤
      1 + d * w :=
  (lowerIdeal_finrank_budget hs d).trans (Nat.add_le_add_left (Nat.mul_le_mul_left d hw) 1)

/-- The constructed ideal really belongs to the required square-width lex
class; none of its closure, finite-colength or budget properties is assumed. -/
theorem lowerIdeal_admissible {s : ℕ} (hs : 2 ≤ s) :
    4 ≤ s * s ∧ IsLex (lowerIdeal (K := K) s) ∧
      Module.Finite K (MvPolynomial (Fin 3) K ⧸ lowerIdeal (K := K) s) ∧
      standard (lowerIdeal (K := K) s) 1 0 0 ∧
      ∀ d, (∑ t ∈ range (d + 1),
        Module.finrank K (quotientHomogeneous (K := K) (lowerExponentSet s) t)) ≤
          1 + d * (s * s) :=
  ⟨by nlinarith, lowerIdeal_isLex s, lowerIdeal_quotient_finite s,
    x_standard_lowerIdeal hs, lowerIdeal_finrank_budget (by omega : 1 ≤ s)⟩

/-- The full, untruncated xy quotient subspace has the asserted exact size. -/
theorem lowerIdeal_xy_finrank {s : ℕ} (hs : 2 ≤ s) :
    Module.finrank K (xySubspace (lowerIdeal (K := K) s)) = lowerSectionLength s := by
  have hw : 4 ≤ s * s := by nlinarith
  rw [show lowerIdeal (K := K) s = monomialIdeal (lowerExponentSet s) from rfl]
  rw [finrank_xySubspace _ (lowerExponentSet_isUpper s) (lowerExponentSet_isLex s) hw
    (lowerIdeal_finrank_budget (K := K) (by omega : 1 ≤ s))]
  change sectionLength (standard (lowerIdeal (K := K) s)) (s * s) = _
  rw [standard_lowerIdeal_eq_lowerStandard]
  exact lower_sectionLength_eq hs

theorem lowerIdeal_xy_harmonic_lower {s : ℕ} (hs : 2 ≤ s) :
    ((s * s : ℕ) : ℚ) * Growth.harmonicQ s ≤
      (Module.finrank K (xySubspace (lowerIdeal (K := K) s)) : ℚ) +
        ((s : ℚ) ^ 2 + s) / 2 := by
  rw [lowerIdeal_xy_finrank hs]
  exact lowerSectionLength_harmonic s

/-- The exact count also describes the standard Tor-one dimension of this
explicit lex family. It remains a result about lex ideals, not semigroups. -/
theorem lowerIdeal_torOne_finrank {s : ℕ} (hs : 2 ≤ s) :
    Module.finrank K (IdealQuotientTorOneK (lowerIdeal (K := K) s)) =
      s + 1 + lowerSectionLength s := by
  letI : Module.Finite K
      (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) (lowerExponentSet s)) :=
    lowerIdeal_quotient_finite (K := K) s
  have hw : 4 ≤ s * s := by nlinarith
  obtain ⟨a, _, hx, hInitial, _, hDim, _⟩ := finiteColength_torOne_bounds
    (K := K) (lowerExponentSet s) (lowerExponentSet_isUpper s) (lowerExponentSet_isLex s)
    (x_standard_lowerIdeal hs) hw (lowerIdeal_finrank_budget (K := K) (by omega : 1 ≤ s))
  have has : a = s := by
    have hForbidden := pure_x_mem_lowerIdeal (K := K) s
    have hLow := fun d (hd : d < s) => pure_x_standard_of_lt (K := K) hd
    by_contra hne
    rcases lt_or_gt_of_ne hne with hlt | hgt
    · exact hLow a hlt hx
    · exact hInitial s hgt hForbidden
  subst a
  change Module.finrank K (IdealQuotientTorOneK (lowerIdeal (K := K) s)) =
    s + 1 + Module.finrank K (xySubspace (lowerIdeal (K := K) s)) at hDim
  rwa [lowerIdeal_xy_finrank hs] at hDim

/-- The same finite formula is the attained least number of arbitrary
polynomial generators of this actual ideal. -/
theorem lowerIdeal_generator_number {s : ℕ} (hs : 2 ≤ s) :
    IsLeast (generatorCardinalities (lowerIdeal (K := K) s))
      (s + 1 + lowerSectionLength s) := by
  letI : Module.Finite K
      (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) (lowerExponentSet s)) :=
    lowerIdeal_quotient_finite (K := K) s
  obtain ⟨_, _, _, _, _, _, hLeast, _⟩ := finiteColength_torOne_bounds
    (K := K) (lowerExponentSet s) (lowerExponentSet_isUpper s) (lowerExponentSet_isLex s)
    (x_standard_lowerIdeal hs) (by nlinarith : 4 ≤ s * s)
    (lowerIdeal_finrank_budget (K := K) (by omega : 1 ≤ s))
  change IsLeast (generatorCardinalities (lowerIdeal (K := K) s))
    (Module.finrank K (IdealQuotientTorOneK (lowerIdeal (K := K) s))) at hLeast
  rwa [lowerIdeal_torOne_finrank hs] at hLeast

#print axioms lowerIdeal_finrank_budget
#print axioms lowerIdeal_admissible
#print axioms lowerIdeal_xy_finrank
#print axioms lowerIdeal_xy_harmonic_lower
#print axioms lowerIdeal_torOne_finrank
#print axioms lowerIdeal_generator_number

end

end WidthBounds.Lower
