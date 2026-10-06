import WidthBounds.Certificate
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-!
The passage from bounds in each degree to the finite total length.

The interface consists of the value of the prefix sum and a pointwise upper
bound on the remaining degrees.  No bound on the total length is assumed.
-/

namespace WidthBounds

private theorem range_sum_le_prefix_add_foldl
    (h g : Nat → Nat) (a n : Nat) :
    a ≤ n →
    (∀ d, a ≤ d → d < n → h d ≤ g d) →
    (∑ d ∈ Finset.range n, h d) ≤
      (∑ d ∈ Finset.range a, h d) +
        ((List.range n).filter fun d => a ≤ d).foldl
          (fun total d => total + g d) 0 := by
  induction n with
  | zero =>
    intro ha _
    have haZero : a = 0 := Nat.eq_zero_of_le_zero ha
    subst a
    simp
  | succ n ih =>
    intro ha hTail
    by_cases han : a ≤ n
    · have hTailPrevious : ∀ d, a ≤ d → d < n → h d ≤ g d := by
        intro d had hdn
        exact hTail d had (Nat.lt_trans hdn (Nat.lt_succ_self n))
      have hSum := Nat.add_le_add (ih han hTailPrevious)
        (hTail n han (Nat.lt_succ_self n))
      simpa [Finset.sum_range_succ, List.range_succ, List.filter_append,
        han, List.foldl_append, Nat.add_assoc] using hSum
    · have haSucc : a = n + 1 := by omega
      subst a
      exact Nat.le_add_right _ _

theorem finite_length_le_envelope {w a : Nat} (h : Nat → Nat)
    (hPrefix : (∑ d ∈ Finset.range a, h d) = choose2 (a + 1))
    (haUpper : a ≤ 2 * w + 1)
    (hDegree : ∀ d, a ≤ d → d ≤ 2 * w → h d ≤ degreeCap w a d) :
    (∑ d ∈ Finset.range (2 * w + 1), h d) ≤ envelopeLength w a := by
  have hTail : ∀ d, a ≤ d → d < 2 * w + 1 → h d ≤ degreeCap w a d := by
    intro d had hdn
    exact hDegree d had (by omega)
  have hSum := range_sum_le_prefix_add_foldl h (degreeCap w a) a
    (2 * w + 1) haUpper hTail
  simpa only [hPrefix, envelopeLength] using hSum

theorem finite_length_bounds {w a : Nat} (h : Nat → Nat)
    (hwLower : 4 ≤ w) (hwUpper : w ≤ 39)
    (haLower : 2 ≤ a) (haUpper : a ≤ 2 * w + 1)
    (hAlpha : choose3 (a + 2) ≤ 1 + (a - 1) * w)
    (hPrefix : (∑ d ∈ Finset.range a, h d) = choose2 (a + 1))
    (hDegree : ∀ d, a ≤ d → d ≤ 2 * w → h d ≤ degreeCap w a d) :
    a + 1 + (∑ d ∈ Finset.range (2 * w + 1), h d) ≤ choose2 (w + 1) ∧
    a + 2 * (∑ d ∈ Finset.range (2 * w + 1), h d) ≤ 2 * choose3 (w + 1) ∧
    (∑ d ∈ Finset.range (2 * w + 1), h d) ≤ 3 * choose4 (w + 1) := by
  exact length_bounds_of_le_envelope hwLower hwUpper haLower haUpper hAlpha
    (finite_length_le_envelope h hPrefix haUpper hDegree)

theorem length_bounds_of_eq_finite_sum {w a ell : Nat} (h : Nat → Nat)
    (hwLower : 4 ≤ w) (hwUpper : w ≤ 39)
    (haLower : 2 ≤ a) (haUpper : a ≤ 2 * w + 1)
    (hAlpha : choose3 (a + 2) ≤ 1 + (a - 1) * w)
    (hPrefix : (∑ d ∈ Finset.range a, h d) = choose2 (a + 1))
    (hDegree : ∀ d, a ≤ d → d ≤ 2 * w → h d ≤ degreeCap w a d)
    (hLength : ell = ∑ d ∈ Finset.range (2 * w + 1), h d) :
    a + 1 + ell ≤ choose2 (w + 1) ∧
    a + 2 * ell ≤ 2 * choose3 (w + 1) ∧
    ell ≤ 3 * choose4 (w + 1) := by
  subst ell
  exact finite_length_bounds h hwLower hwUpper haLower haUpper hAlpha hPrefix hDegree

end WidthBounds
