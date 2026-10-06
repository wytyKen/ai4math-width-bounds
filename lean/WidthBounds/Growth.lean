import WidthBounds.AllWidths
import WidthBounds.IdealBounds

/-! Exact integer divisor-sum growth bound. No asymptotic notation or lower
construction is claimed to be formalized in this module. -/
namespace WidthBounds.Growth

open Finset LexCounting

theorem product_lt_two_width {w a d h : ℕ} (hw : 0 < w) (hh : h ≤ a)
    (hAdmissible : admissibleHeight w a d h = true) :
    (d - a + 1) * h < 2 * w := by
  have hb : 2 * choose3 (a + 2) +
      (d - a + 1) * h * (a + d + 3 - h) ≤ 2 * (1 + d * w) := by
    simpa only [admissibleHeight, decide_eq_true_eq] using hAdmissible
  by_contra hn
  have hFactor : d + 3 ≤ a + d + 3 - h := by omega
  have hBase : 2 * w ≤ (d - a + 1) * h := by omega
  have hLeft := Nat.mul_le_mul_right (d + 3) hBase
  have hRight := Nat.mul_le_mul_left ((d - a + 1) * h) hFactor
  have hImpossible : 2 * w * (d + 3) ≤ 2 * (1 + d * w) :=
    hLeft.trans (hRight.trans (Nat.le_trans (Nat.le_add_left _ _) hb))
  nlinarith

theorem degree_product_bound {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a d : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a) (had : a ≤ d)
    (hInitial : ∀ t, t < a → A t 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ t, (∑ s ∈ range (t + 1), hilbert3 A s) ≤ 1 + t * w) :
    (d - a + 1) * hilbert2 A d < 2 * w := by
  let n := d - a
  have hd : a + n = d := by dsimp [n]; omega
  have hHeight : hilbert2 A (a + n) ≤ a := by
    have hm := hilbert2_antitone hA hx (t := a - 1) (d := a + n) (by omega) (by omega)
    have hb := hilbert2_le A (a - 1)
    omega
  have hMono : ∀ i, i ≤ n → hilbert2 A (a + n) ≤ hilbert2 A (a + i) := by
    intro i hi
    exact hilbert2_antitone hA hx (by omega) (by omega)
  have hCost := cumulative_cost_of_hilbert (w := w) (a := a) (n := n)
    (sum_hilbert3_initial hA hInitial) (sum_sub_le_hilbert3 hA) (hHS (a + n))
  have hAdmissible := admissible_of_cumulative hHeight hMono hCost
  have hResult := product_lt_two_width (by omega : 0 < w) hHeight hAdmissible
  simpa only [hd] using hResult

theorem degree_divisor_bound {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a r : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ t, t < a → A t 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ t, (∑ s ∈ range (t + 1), hilbert3 A s) ≤ 1 + t * w) :
    hilbert2 A (a + r) ≤ (2 * w - 1) / (r + 1) := by
  have hp := degree_product_bound hA hw ha (d := a + r) (by omega) hInitial hx hHS
  have heq : a + r - a + 1 = r + 1 := by omega
  rw [heq, Nat.mul_comm] at hp
  apply (Nat.le_div_iff_mul_le (by omega : 0 < r + 1)).mpr
  omega

theorem sectionLength_le_divisor_sum {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ t, t < a → A t 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ t, (∑ s ∈ range (t + 1), hilbert3 A s) ≤ 1 + t * w) :
    sectionLength A w ≤ choose2 (a + 1) +
      ∑ r ∈ range (2 * w + 1 - a), (2 * w - 1) / (r + 1) := by
  have haUpper := alpha_le_two_mul_add_one hA hw hHS hInitial
  have hPrefix := sum_hilbert2_initial hA hInitial
  have hSplit := sum_range_add (hilbert2 A) a (2 * w + 1 - a)
  have hn : a + (2 * w + 1 - a) = 2 * w + 1 := by omega
  rw [hn, hPrefix] at hSplit
  have hTail : (∑ r ∈ range (2 * w + 1 - a), hilbert2 A (a + r)) ≤
      ∑ r ∈ range (2 * w + 1 - a), (2 * w - 1) / (r + 1) := by
    apply sum_le_sum
    intro r hr
    exact degree_divisor_bound hA hw ha hInitial hx hHS
  change (∑ d ∈ range (2 * w + 1), hilbert2 A d) ≤ _
  rw [hSplit]
  exact Nat.add_le_add_left hTail _

def harmonicQ (n : ℕ) : ℚ := ∑ r ∈ range n, (1 : ℚ) / (r + 1)

theorem harmonicQ_mono {m n : ℕ} (h : m ≤ n) : harmonicQ m ≤ harmonicQ n := by
  apply sum_le_sum_of_subset_of_nonneg (range_mono h)
  intro r hr hnot
  positivity

theorem cast_divisor_sum_le (m n : ℕ) :
    ((∑ r ∈ range n, m / (r + 1) : ℕ) : ℚ) ≤ (m : ℚ) * harmonicQ n := by
  rw [Nat.cast_sum, harmonicQ, mul_sum]
  apply sum_le_sum
  intro r hr
  have h := (Nat.cast_div_le (α := ℚ) (m := m) (n := r + 1))
  simpa [div_eq_mul_inv] using h

theorem prefix_choose2_le_three_width {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hPrefix : choose3 (a + 2) ≤ 1 + (a - 1) * w) :
    choose2 (a + 1) ≤ 3 * w := by
  have hP := six_mul_choose3_add_two a
  have hC : 2 * choose2 (a + 1) = a * (a + 1) := by
    rw [choose2_eq_natChoose]
    exact two_mul_natChoose_two a
  have hId : 2 * choose2 (a + 1) * (a + 2) = 6 * choose3 (a + 2) := by
    rw [hC]
    exact hP.symm
  have hBudget := Nat.mul_le_mul_left 6 hPrefix
  have hPred : a - 1 + 1 = a := by omega
  have hPredMul : (a - 1) * w + w = a * w := by
    calc
      (a - 1) * w + w = (a - 1 + 1) * w := by ring
      _ = a * w := by rw [hPred]
  by_contra hn
  have hBase : 6 * w ≤ 2 * choose2 (a + 1) := by omega
  have hm := Nat.mul_le_mul_right (a + 2) hBase
  rw [hId] at hm
  nlinarith

/-- A rational harmonic upper bound, uniform in every integer width at least four.
The customary real logarithmic consequence is recorded separately in the paper proof. -/
theorem sectionLength_le_harmonic {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a : ℕ} (hw : 4 ≤ w) (ha : 2 ≤ a)
    (hInitial : ∀ t, t < a → A t 0 0) (hx : ¬ A a 0 0)
    (hHS : ∀ t, (∑ s ∈ range (t + 1), hilbert3 A s) ≤ 1 + t * w) :
    (sectionLength A w : ℚ) ≤ 3 * (w : ℚ) +
      ((2 * w - 1 : ℕ) : ℚ) * harmonicQ (2 * w - 1) := by
  have hPrefix : choose3 (a + 2) ≤ 1 + (a - 1) * w := by
    have hp := sum_hilbert3_initial hA hInitial
    have hb := hHS (a - 1)
    have heq : a - 1 + 1 = a := by omega
    rwa [heq, hp] at hb
  have hP := prefix_choose2_le_three_width hw ha hPrefix
  have hPq : (choose2 (a + 1) : ℚ) ≤ 3 * (w : ℚ) := by exact_mod_cast hP
  have hBase := sectionLength_le_divisor_sum hA hw ha hInitial hx hHS
  have hBaseq : (sectionLength A w : ℚ) ≤ (choose2 (a + 1) : ℚ) +
      ((∑ r ∈ range (2 * w + 1 - a), (2 * w - 1) / (r + 1) : ℕ) : ℚ) := by
    exact_mod_cast hBase
  have hN : 2 * w + 1 - a ≤ 2 * w - 1 := by omega
  have hH := mul_le_mul_of_nonneg_left (harmonicQ_mono hN)
    (by positivity : (0 : ℚ) ≤ ((2 * w - 1 : ℕ) : ℚ))
  calc
    (sectionLength A w : ℚ) ≤ (choose2 (a + 1) : ℚ) +
        ((∑ r ∈ range (2 * w + 1 - a), (2 * w - 1) / (r + 1) : ℕ) : ℚ) := hBaseq
    _ ≤ 3 * (w : ℚ) + ((∑ r ∈ range (2 * w + 1 - a),
        (2 * w - 1) / (r + 1) : ℕ) : ℚ) := add_le_add_right hPq _
    _ ≤ 3 * (w : ℚ) + ((2 * w - 1 : ℕ) : ℚ) * harmonicQ (2 * w + 1 - a) :=
      add_le_add_left (cast_divisor_sum_le (2 * w - 1) (2 * w + 1 - a)) _
    _ ≤ 3 * (w : ℚ) + ((2 * w - 1 : ℕ) : ℚ) * harmonicQ (2 * w - 1) :=
      add_le_add_left hH _

#print axioms sectionLength_le_divisor_sum
#print axioms sectionLength_le_harmonic

open MonomialInterface in
/-- The harmonic estimate with the actual quotient's homogeneous-dimension
budget and the actual full x,y subspace dimension. -/
theorem quotient_xy_le_harmonic {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    (hNonzero : monomialIdeal (R := K) S ≠ ⊥)
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    (Module.finrank K (xySubspace (monomialIdeal (R := K) S)) : ℚ) ≤
      3 * (w : ℚ) + ((2 * w - 1 : ℕ) : ℚ) * harmonicQ (2 * w - 1) := by
  obtain ⟨a, ha, hx, hInitial, _⟩ :=
    monomialIdeal_exists_initial_degree S hUp hLex hNonzero hOne
  rw [finrank_xySubspace S hUp hLex hw hBudget]
  exact sectionLength_le_harmonic (monomialIdeal_standardLex S hUp hLex)
    hw ha hInitial hx (hilbertBudget_of_finrankBudget S hUp w hBudget)

#print axioms quotient_xy_le_harmonic

end WidthBounds.Growth
