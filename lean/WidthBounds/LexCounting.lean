import Mathlib.Algebra.BigOperators.Group.Finset.Sigma
import Mathlib.Data.Finset.Prod
import Mathlib.Tactic

/-!
# Counting standard monomials for a lex order ideal

`A i j k` says that `x^i y^j z^k` is standard.  The variable order is
`x > y > z`: lowering the first differing exponent, while keeping total
degree fixed, preserves standardness.  No ideal or homological hypothesis
is hidden in the two closure properties below.
-/

namespace WidthBounds.LexCounting

open Finset

/-- The elementary properties of the complement of a lex monomial ideal. -/
structure StandardLex (A : ℕ → ℕ → ℕ → Prop) : Prop where
  down : ∀ {i j k i' j' k'},
    i' ≤ i → j' ≤ j → k' ≤ k → A i j k → A i' j' k'
  lex : ∀ {i j k i' j' k'},
    i' + j' + k' = i + j + k →
    (i' < i ∨ (i' = i ∧ j' ≤ j)) → A i j k → A i' j' k'

/-- Degree `d` standard monomials in the `x,y` plane, encoded by the `x` exponent. -/
noncomputable def standard2 (A : ℕ → ℕ → ℕ → Prop) (d : ℕ) : Finset ℕ := by
  classical
  exact (range (d + 1)).filter (fun i => A i (d - i) 0)

noncomputable def hilbert2 (A : ℕ → ℕ → ℕ → Prop) (d : ℕ) : ℕ :=
  (standard2 A d).card

/-- Degree `d` standard monomials, encoded by their `x,y` exponents. -/
noncomputable def standard3 (A : ℕ → ℕ → ℕ → Prop) (d : ℕ) : Finset (ℕ × ℕ) := by
  classical
  exact ((range (d + 1)).product (range (d + 1))).filter
    (fun p => p.1 + p.2 ≤ d ∧ A p.1 p.2 (d - p.1 - p.2))

noncomputable def hilbert3 (A : ℕ → ℕ → ℕ → Prop) (d : ℕ) : ℕ :=
  (standard3 A d).card

@[simp] theorem mem_standard2 {A : ℕ → ℕ → ℕ → Prop} {d i : ℕ} :
    i ∈ standard2 A d ↔ i ≤ d ∧ A i (d - i) 0 := by
  classical
  simp only [standard2, mem_filter, mem_range, Nat.lt_succ_iff]

@[simp] theorem mem_standard3 {A : ℕ → ℕ → ℕ → Prop} {d i j : ℕ} :
    (i, j) ∈ standard3 A d ↔ i + j ≤ d ∧ A i j (d - i - j) := by
  classical
  simp only [standard3, mem_filter, product_eq_sprod, mem_product, mem_range]
  constructor
  · rintro ⟨_, hsum, hA⟩
    exact ⟨hsum, hA⟩
  · rintro ⟨hsum, hA⟩
    exact ⟨⟨by omega, by omega⟩, hsum, hA⟩

theorem hilbert2_le (A : ℕ → ℕ → ℕ → Prop) (d : ℕ) :
    hilbert2 A d ≤ d + 1 := by
  classical
  simpa [hilbert2] using
    (card_le_card (filter_subset (fun i => A i (d - i) 0) (range (d + 1))))

/-- Every finite lower subset of the naturals is the range of its cardinality. -/
private theorem lower_finset_eq_range (s : Finset ℕ)
    (hlower : ∀ ⦃i j⦄, i ≤ j → j ∈ s → i ∈ s) : s = range s.card := by
  ext i
  simp only [mem_range]
  constructor
  · intro hi
    have hsub : range (i + 1) ⊆ s := by
      intro j hj
      exact hlower (Nat.lt_succ_iff.mp (mem_range.mp hj)) hi
    have hc := card_le_card hsub
    simpa using hc
  · intro hi
    by_contra hnot
    have hsub : s ⊆ range i := by
      intro j hj
      apply mem_range.mpr
      by_contra hn
      exact hnot (hlower (by omega) hj)
    have hc := card_le_card hsub
    simp only [card_range] at hc
    omega

/-- Lex standardness makes the two-variable degree slice an initial interval. -/
theorem standard2_eq_range {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A) (d : ℕ) :
    standard2 A d = range (hilbert2 A d) := by
  apply lower_finset_eq_range
  intro i j hij hj
  obtain ⟨hjd, hAj⟩ := mem_standard2.mp hj
  apply mem_standard2.mpr
  refine ⟨by omega, ?_⟩
  apply hA.lex (i := j) (j := d - j) (k := 0) (by omega) _ hAj
  by_cases heq : i = j
  · exact Or.inr ⟨heq, by omega⟩
  · exact Or.inl (by omega)

theorem standard_of_lt_hilbert2 {A : ℕ → ℕ → ℕ → Prop}
    (hA : StandardLex A) {d i : ℕ} (hi : i < hilbert2 A d) :
    i ≤ d ∧ A i (d - i) 0 := by
  apply mem_standard2.mp
  rw [standard2_eq_range hA]
  exact mem_range.mpr hi

/-- A forbidden pure `x` power stays forbidden at every larger exponent. -/
theorem not_standard_pure_x {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {α n : ℕ} (hx : ¬ A α 0 0) (han : α ≤ n) : ¬ A n 0 0 := by
  intro hn
  exact hx (hA.down han (by rfl) (by rfl) hn)

/-- Division by `y` injects the next two-variable degree slice into the current one. -/
theorem standard2_succ_subset {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {α d : ℕ} (hx : ¬ A α 0 0) (had : α ≤ d + 1) :
    standard2 A (d + 1) ⊆ standard2 A d := by
  intro i hi
  obtain ⟨hi, hAi⟩ := mem_standard2.mp hi
  have hid : i ≤ d := by
    by_contra hn
    have heq : i = d + 1 := by omega
    subst i
    simp only [Nat.sub_self] at hAi
    exact not_standard_pure_x hA hx had hAi
  exact mem_standard2.mpr ⟨hid,
    hA.down (by rfl) (by omega) (by rfl) hAi⟩

theorem hilbert2_succ_le {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {α d : ℕ} (hx : ¬ A α 0 0) (had : α ≤ d + 1) :
    hilbert2 A (d + 1) ≤ hilbert2 A d :=
  card_le_card (standard2_succ_subset hA hx had)

/-- The usual formulation of the Hilbert-function monotonicity threshold. -/
theorem hilbert2_succ_le_of_sub_one_le {A : ℕ → ℕ → ℕ → Prop}
    (hA : StandardLex A) {α d : ℕ} (hx : ¬ A α 0 0) (had : α - 1 ≤ d) :
    hilbert2 A (d + 1) ≤ hilbert2 A d :=
  hilbert2_succ_le hA hx (by omega)

/-- Monotonicity between any two degrees past the pure-power threshold. -/
theorem hilbert2_antitone {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {α t d : ℕ} (hx : ¬ A α 0 0) (hat : α - 1 ≤ t) (htd : t ≤ d) :
    hilbert2 A d ≤ hilbert2 A t := by
  induction d, htd using Nat.le_induction with
  | base => exact le_refl _
  | succ d htd ih =>
      exact (hilbert2_succ_le hA hx (by omega)).trans ih

/-- A standard monomial on the `x,y` plane forces its entire `y,z` column. -/
theorem standard_column {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {d i j : ℕ} (hi : i < hilbert2 A d) (hj : j ≤ d - i) :
    (i, j) ∈ standard3 A d := by
  obtain ⟨hid, hAi⟩ := standard_of_lt_hilbert2 hA hi
  apply mem_standard3.mpr
  refine ⟨by omega, ?_⟩
  exact hA.lex (by omega) (Or.inr ⟨rfl, hj⟩) hAi

/-- Count disjoint columns of forced standard monomials.  This is a lower bound;
there may be additional standard monomials with larger `x` exponent. -/
theorem sum_le_hilbert3 {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A) (d : ℕ) :
    (∑ i ∈ range (hilbert2 A d), (d - i + 1)) ≤ hilbert3 A d := by
  classical
  let columns : Finset (Σ _ : ℕ, ℕ) :=
    (range (hilbert2 A d)).sigma (fun i => range (d - i + 1))
  have hcard : columns.card = ∑ i ∈ range (hilbert2 A d), (d - i + 1) := by
    simp [columns]
  rw [← hcard]
  apply card_le_card_of_injOn (fun p : Σ _ : ℕ, ℕ => (p.1, p.2))
  · intro p hp
    obtain ⟨hi, hj⟩ := mem_sigma.mp hp
    exact standard_column hA (mem_range.mp hi) (Nat.lt_succ_iff.mp (mem_range.mp hj))
  · intro p hp q hq heq
    cases p with | mk i j =>
      cases q with | mk i' j' =>
        simpa using heq

/-- Equivalent summand convention, convenient for arithmetic envelopes. -/
theorem sum_sub_le_hilbert3 {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A) (d : ℕ) :
    (∑ i ∈ range (hilbert2 A d), (d + 1 - i)) ≤ hilbert3 A d := by
  have heq : (∑ i ∈ range (hilbert2 A d), (d + 1 - i)) =
      ∑ i ∈ range (hilbert2 A d), (d - i + 1) := by
    apply sum_congr rfl
    intro i hi
    have hid := (standard_of_lt_hilbert2 hA (mem_range.mp hi)).1
    omega
  rw [heq]
  exact sum_le_hilbert3 hA d

#print axioms hilbert2_succ_le
#print axioms sum_le_hilbert3

end WidthBounds.LexCounting



