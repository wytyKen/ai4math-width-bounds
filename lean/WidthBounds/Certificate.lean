import WidthBounds.Arithmetic

/-!
Logical consequences of the kernel-checked finite arithmetic certificate.
These theorems concern the arithmetic envelope only; identifying that envelope
with a bound for a mathematical object requires a separate reduction theorem.
-/

namespace WidthBounds

theorem envelope_bounds {w a : Nat}
    (hwLower : 4 ≤ w) (hwUpper : w ≤ 39)
    (haLower : 2 ≤ a) (haUpper : a ≤ 2 * w + 1)
    (hAlpha : choose3 (a + 2) ≤ 1 + (a - 1) * w) :
    a + 1 + envelopeLength w a ≤ choose2 (w + 1) ∧
    a + 2 * envelopeLength w a ≤ 2 * choose3 (w + 1) ∧
    envelopeLength w a ≤ 3 * choose4 (w + 1) := by
  have hOffset : w - 4 ∈ List.range 36 := by
    apply List.mem_range.mpr
    omega
  have hWidth : checkWidth w = true := by
    have h := List.all_eq_true.mp finite_envelope_certificate (w - 4) hOffset
    have hAdd : w - 4 + 4 = w := by omega
    simpa only [hAdd] using h
  have haMem : a ∈ List.range (2 * w + 2) := by
    apply List.mem_range.mpr
    omega
  have hCheck : checkAlpha w a = true :=
    List.all_eq_true.mp hWidth a haMem
  have hAdmissible : admissibleAlpha w a = true := by
    simp [admissibleAlpha, haLower, haUpper, hAlpha]
  simpa [checkAlpha, hAdmissible, Bool.and_eq_true, and_assoc] using hCheck

theorem length_bounds_of_le_envelope {w a ell : Nat}
    (hwLower : 4 ≤ w) (hwUpper : w ≤ 39)
    (haLower : 2 ≤ a) (haUpper : a ≤ 2 * w + 1)
    (hAlpha : choose3 (a + 2) ≤ 1 + (a - 1) * w)
    (hLength : ell ≤ envelopeLength w a) :
    a + 1 + ell ≤ choose2 (w + 1) ∧
    a + 2 * ell ≤ 2 * choose3 (w + 1) ∧
    ell ≤ 3 * choose4 (w + 1) := by
  obtain ⟨hOne, hTwo, hThree⟩ :=
    envelope_bounds hwLower hwUpper haLower haUpper hAlpha
  exact ⟨Nat.le_trans (Nat.add_le_add_left hLength (a + 1)) hOne,
    Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul_left 2 hLength) a) hTwo,
    Nat.le_trans hLength hThree⟩

private theorem le_foldl_max_initial (xs : List Nat) (initial : Nat) :
    initial ≤ xs.foldl max initial := by
  induction xs generalizing initial with
  | nil => simp
  | cons x xs ih =>
    simp only [List.foldl_cons]
    exact Nat.le_trans (Nat.le_max_left initial x) (ih (max initial x))

private theorem le_foldl_max_of_mem {xs : List Nat} {h : Nat}
    (hMem : h ∈ xs) (initial : Nat) : h ≤ xs.foldl max initial := by
  induction xs generalizing initial with
  | nil => simp at hMem
  | cons x xs ih =>
    simp only [List.foldl_cons]
    rcases List.mem_cons.mp hMem with rfl | hTail
    · exact Nat.le_trans (Nat.le_max_right initial h)
        (le_foldl_max_initial xs (max initial h))
    · exact ih hTail (max initial x)

theorem height_le_degreeCap {w a d h : Nat}
    (hHeight : h ≤ a) (hAdmissible : admissibleHeight w a d h = true) :
    h ≤ degreeCap w a d := by
  apply le_foldl_max_of_mem (initial := 0)
  apply List.mem_filter.mpr
  exact ⟨List.mem_range.mpr (by omega), hAdmissible⟩

end WidthBounds
