import WidthBounds.Envelope
import WidthBounds.Length
import WidthBounds.Prefix
import WidthBounds.Cutoff

/-!
The complete new combinatorial argument, starting from explicit standard
monomial sets.  The algebraic identification with lex ideals, their Hilbert
functions, Betti numbers, and semigroup rings remains a separate published
mathematical reduction; this file does not claim to formalize that reduction.
-/

namespace WidthBounds

open scoped BigOperators
open LexCounting

/-- The finite sum is the entire two-variable count by the proved cutoff. -/
noncomputable def sectionLength (A : Nat → Nat → Nat → Prop) (w : Nat) : Nat :=
  ∑ d ∈ Finset.range (2 * w + 1), hilbert2 A d

/-- Every sufficiently long sum equals `sectionLength`; no surviving tail is omitted. -/
theorem sectionLength_eq_sum_of_ge {A : Nat → Nat → Nat → Prop}
    (hA : StandardLex A) {w n : Nat} (hw : 4 ≤ w)
    (hHS : ∀ d, (∑ t ∈ Finset.range (d + 1), hilbert3 A t) ≤ 1 + d * w)
    (hn : 2 * w + 1 ≤ n) :
    (∑ d ∈ Finset.range n, hilbert2 A d) = sectionLength A w := by
  have hTail : (∑ i ∈ Finset.range (n - (2 * w + 1)),
      hilbert2 A (2 * w + 1 + i)) = 0 := by
    apply Finset.sum_eq_zero
    intro i hi
    exact hilbert2_eq_zero_of_two_mul_lt hA hw hHS (by omega)
  have hSplit := Finset.sum_range_add (hilbert2 A) (2 * w + 1) (n - (2 * w + 1))
  have hnEq : 2 * w + 1 + (n - (2 * w + 1)) = n := by omega
  rw [hnEq, hTail, Nat.add_zero] at hSplit
  exact hSplit

theorem sectionLength_le_envelope {A : Nat → Nat → Nat → Prop}
    (hA : StandardLex A) {w a : Nat}
    (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ d, d < a → A d 0 0)
    (hx : ¬ A a 0 0)
    (hHS : ∀ d, (∑ t ∈ Finset.range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    sectionLength A w ≤ envelopeLength w a := by
  have haUpper := alpha_le_two_mul_add_one hA hw hHS hInitial
  have hPrefix := sum_hilbert2_initial hA hInitial
  have hPrefixH := sum_hilbert3_initial hA hInitial
  apply finite_length_le_envelope (hilbert2 A) hPrefix haUpper
  intro d had hdw
  let n := d - a
  have hd : a + n = d := by dsimp [n]; omega
  have hHeight : hilbert2 A (a + n) ≤ a := by
    have hMono := hilbert2_antitone hA hx (t := a - 1) (d := a + n)
      (by omega) (by omega)
    have hBound := hilbert2_le A (a - 1)
    omega
  have hMono : ∀ i, i ≤ n → hilbert2 A (a + n) ≤ hilbert2 A (a + i) := by
    intro i hi
    exact hilbert2_antitone hA hx (by omega) (by omega)
  have hCount : ∀ t, qCount t (hilbert2 A t) ≤ hilbert3 A t := by
    intro t
    exact sum_sub_le_hilbert3 hA t
  have hBudget := cumulative_cost_of_hilbert (w := w) (a := a) (n := n)
    hPrefixH hCount (hHS (a + n))
  have hCap := height_le_cap_of_cumulative hHeight hMono hBudget
  simpa only [hd] using hCap

/-- Quantified small-width theorem for concrete standard-monomial families.
Neither the prefix count, monotonicity, the envelope, nor the support bound
is assumed: all are consequences of the hypotheses displayed here. -/
theorem small_width_combinatorial_bounds {A : Nat → Nat → Nat → Prop}
    (hA : StandardLex A) {w a : Nat}
    (hwLower : 4 ≤ w) (hwUpper : w ≤ 39) (ha : 2 ≤ a)
    (hInitial : ∀ d, d < a → A d 0 0)
    (hx : ¬ A a 0 0)
    (hHS : ∀ d, (∑ t ∈ Finset.range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    (∀ d, 2 * w < d → hilbert2 A d = 0) ∧
    a + 1 + sectionLength A w ≤ choose2 (w + 1) ∧
    a + 2 * sectionLength A w ≤ 2 * choose3 (w + 1) ∧
    sectionLength A w ≤ 3 * choose4 (w + 1) := by
  have haUpper := alpha_le_two_mul_add_one hA hwLower hHS hInitial
  have hAlpha : choose3 (a + 2) ≤ 1 + (a - 1) * w := by
    have hPrefix := sum_hilbert3_initial hA hInitial
    have hBound := hHS (a - 1)
    have hPred : a - 1 + 1 = a := by omega
    rw [hPred, hPrefix] at hBound
    exact hBound
  have hLength := sectionLength_le_envelope hA hwLower ha hInitial hx hHS
  refine ⟨?_, length_bounds_of_le_envelope hwLower hwUpper ha haUpper hAlpha hLength⟩
  intro d hd
  exact hilbert2_eq_zero_of_two_mul_lt hA hwLower hHS hd

theorem choose4_eq_natChoose (n : Nat) : choose4 n = n.choose 4 := by
  rw [Nat.choose_eq_descFactorial_div_factorial]
  simp only [choose4, Nat.descFactorial_succ, Nat.descFactorial_zero,
    Nat.sub_zero, Nat.mul_one]
  norm_num [Nat.factorial]
  congr 1
  ring

/-- The same three inequalities in conventional binomial-coefficient notation. -/
theorem small_width_binomial_bounds {A : Nat → Nat → Nat → Prop}
    (hA : StandardLex A) {w a : Nat}
    (hwLower : 4 ≤ w) (hwUpper : w ≤ 39) (ha : 2 ≤ a)
    (hInitial : ∀ d, d < a → A d 0 0)
    (hx : ¬ A a 0 0)
    (hHS : ∀ d, (∑ t ∈ Finset.range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    a + 1 + sectionLength A w ≤ (w + 1).choose 2 ∧
    a + 2 * sectionLength A w ≤ 2 * (w + 1).choose 3 ∧
    sectionLength A w ≤ 3 * (w + 1).choose 4 := by
  have h := (small_width_combinatorial_bounds hA hwLower hwUpper ha hInitial hx hHS).2
  simpa only [choose2_eq_natChoose, choose3_eq_natChoose, choose4_eq_natChoose] using h

#print axioms small_width_combinatorial_bounds
#print axioms small_width_binomial_bounds

end WidthBounds
