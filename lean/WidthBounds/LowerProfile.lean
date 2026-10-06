import WidthBounds.LexCounting

/-!
# The standard-monomial profile of the explicit lower family

This module counts the predicate defined by a product inequality.  Its
realization as the complement of a genuine monomial ideal is supplied
separately.  All degree and cumulative bounds below quantify over every
natural degree.
-/

namespace WidthBounds.Lower

open Finset LexCounting

/-- Product description of the explicit standard monomial family. -/
def lowerStandard (s i j k : ℕ) : Prop :=
  (i + 1) * (i + j + k + 1) ≤ s * s

theorem lowerStandard_standardLex (s : ℕ) : StandardLex (lowerStandard s) := by
  constructor
  · intro i j k i' j' k' hi hj hk h
    exact (Nat.mul_le_mul (by omega) (by omega)).trans h
  · intro i j k i' j' k' hdeg hlex h
    unfold lowerStandard at *
    rw [hdeg]
    exact (Nat.mul_le_mul_right _ (by rcases hlex with hlt | ⟨heq, _⟩ <;> omega)).trans h

/-- The full degree slice injects into an interval of length `s²`. -/
theorem lower_hilbert3_le (s d : ℕ) : hilbert3 (lowerStandard s) d ≤ s * s := by
  classical
  rw [hilbert3, ← card_range (s * s)]
  apply card_le_card_of_injOn (fun p : ℕ × ℕ => p.1 * (d + 1) + p.2)
  · intro p hp
    obtain ⟨hdeg, hprod⟩ := mem_standard3.mp hp
    have hsum : p.1 + p.2 + (d - p.1 - p.2) = d := by omega
    unfold lowerStandard at hprod
    rw [hsum] at hprod
    apply mem_range.mpr
    nlinarith
  · intro p hp q hq heq
    have hpj : p.2 < d + 1 := by
      have h := (mem_standard3.mp hp).1
      omega
    have hqj : q.2 < d + 1 := by
      have h := (mem_standard3.mp hq).1
      omega
    have hfirst : p.1 = q.1 := by
      rcases lt_trichotomy p.1 q.1 with hlt | he | hgt
      · have hm := Nat.mul_le_mul_right (d + 1) (show p.1 + 1 ≤ q.1 by omega)
        nlinarith
      · exact he
      · have hm := Nat.mul_le_mul_right (d + 1) (show q.1 + 1 ≤ p.1 by omega)
        nlinarith
    apply Prod.ext hfirst
    simpa [hfirst] using heq

theorem lower_hilbert3_zero {s : ℕ} (hs : 1 ≤ s) :
    hilbert3 (lowerStandard s) 0 = 1 := by
  classical
  have hsq : 1 ≤ s * s := by nlinarith
  have hset : standard3 (lowerStandard s) 0 = {(0, 0)} := by
    ext ⟨i, j⟩
    simp only [mem_standard3, mem_singleton, Prod.mk.injEq]
    constructor
    · rintro ⟨hdeg, _⟩
      constructor <;> omega
    · rintro ⟨rfl, rfl⟩
      simpa [lowerStandard] using hsq
  rw [hilbert3, hset, card_singleton]

/-- The entire cumulative Hilbert budget, with no cutoff restriction. -/
theorem lower_hilbert3_budget {s : ℕ} (hs : 1 ≤ s) (d : ℕ) :
    (∑ t ∈ range (d + 1), hilbert3 (lowerStandard s) t) ≤ 1 + d * (s * s) := by
  induction d with
  | zero => simp [lower_hilbert3_zero hs]
  | succ d ih =>
      rw [sum_range_succ]
      have hb := lower_hilbert3_le s (d + 1)
      nlinarith

theorem lower_standard2_eq (s d : ℕ) :
    standard2 (lowerStandard s) d = range (min (d + 1) (s * s / (d + 1))) := by
  classical
  ext i
  rw [mem_standard2, mem_range, lt_min_iff]
  constructor
  · rintro ⟨hid, hprod⟩
    refine ⟨by omega, ?_⟩
    have hsum : i + (d - i) + 0 = d := by omega
    unfold lowerStandard at hprod
    rw [hsum] at hprod
    have hd := (Nat.le_div_iff_mul_le (show 0 < d + 1 by omega)).mpr hprod
    omega
  · rintro ⟨hid, hdiv⟩
    refine ⟨by omega, ?_⟩
    unfold lowerStandard
    have hsum : i + (d - i) + 0 = d := by omega
    rw [hsum]
    apply (Nat.le_div_iff_mul_le (show 0 < d + 1 by omega)).mp
    omega

theorem lower_hilbert2_eq (s d : ℕ) :
    hilbert2 (lowerStandard s) d = min (d + 1) (s * s / (d + 1)) := by
  simp [hilbert2, lower_standard2_eq]

theorem lower_hilbert2_of_lt {s d : ℕ} (hd : d < s) :
    hilbert2 (lowerStandard s) d = d + 1 := by
  rw [lower_hilbert2_eq, min_eq_left]
  apply (Nat.le_div_iff_mul_le (show 0 < d + 1 by omega)).mpr
  exact Nat.mul_self_le_mul_self (by omega)

theorem lower_hilbert2_of_le {s d : ℕ} (hd : s ≤ d) :
    hilbert2 (lowerStandard s) d = s * s / (d + 1) := by
  rw [lower_hilbert2_eq, min_eq_right]
  have hsquares := Nat.mul_self_le_mul_self hd
  have hdiv : s * s / (d + 1) < d + 1 := by
    apply (Nat.div_lt_iff_lt_mul (show 0 < d + 1 by omega)).mpr
    nlinarith
  omega

#print axioms lowerStandard_standardLex
#print axioms lower_hilbert3_le
#print axioms lower_hilbert3_budget
#print axioms lower_hilbert2_eq
#print axioms lower_hilbert2_of_lt
#print axioms lower_hilbert2_of_le

end WidthBounds.Lower
