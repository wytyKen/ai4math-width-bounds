import WidthBounds.SmallWidth

/-! Column counts and the terminal triangular budget, for arbitrary `w ≥ 4`.
The finite cutoffs are consequences of StandardLex and the Hilbert budget.
-/
namespace WidthBounds.Columns

open Finset LexCounting

noncomputable def column (A : ℕ → ℕ → ℕ → Prop) (w i : ℕ) : Finset ℕ := by
  classical
  exact (range (2 * w + 1)).filter (fun j => A i j 0)

noncomputable def columnLength (A : ℕ → ℕ → ℕ → Prop) (w i : ℕ) : ℕ :=
  (column A w i).card

theorem column_eq_range {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A) (w i : ℕ) :
    column A w i = range (columnLength A w i) := by
  classical
  have hlow : ∀ {j k}, j ≤ k → k ∈ column A w i → j ∈ column A w i := by
    intro j k hjk hk
    obtain ⟨hkN, hkA⟩ := mem_filter.mp hk
    exact mem_filter.mpr ⟨mem_range.mpr (by have := mem_range.mp hkN; omega),
      hA.down le_rfl hjk le_rfl hkA⟩
  ext j
  simp only [mem_range]
  constructor
  · intro hj
    have hs : range (j + 1) ⊆ column A w i := by
      intro k hk
      exact hlow (by have := mem_range.mp hk; omega) hj
    have hc := card_le_card hs
    simpa [columnLength] using hc
  · intro hj
    by_contra hn
    have hs : column A w i ⊆ range j := by
      intro k hk
      apply mem_range.mpr
      by_contra hn'
      exact hn (hlow (by omega) hk)
    have hc := card_le_card hs
    simp only [card_range] at hc
    change columnLength A w i ≤ j at hc
    omega

theorem standard_degree_lt {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w i j : ℕ} (hw : 4 ≤ w)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w)
    (hij : A i j 0) : i + j < 2 * w + 1 := by
  have hm : i ∈ standard2 A (i + j) := mem_standard2.mpr ⟨by omega, by simpa using hij⟩
  have hp : 0 < hilbert2 A (i + j) := card_pos.mpr ⟨i, hm⟩
  by_contra hn
  have hz := hilbert2_eq_zero_of_two_mul_lt hA hw hHS (by omega : 2 * w < i + j)
  omega

theorem standard_iff_lt_columnLength {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w i j : ℕ} (hw : 4 ≤ w)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    A i j 0 ↔ j < columnLength A w i := by
  classical
  constructor
  · intro hij
    have hjN := standard_degree_lt hA hw hHS hij
    have hm : j ∈ column A w i := mem_filter.mpr ⟨mem_range.mpr (by omega), hij⟩
    rw [column_eq_range hA] at hm
    exact mem_range.mp hm
  · intro hj
    have hm : j ∈ column A w i := by
      rw [column_eq_range hA]
      exact mem_range.mpr hj
    exact (mem_filter.mp hm).2

theorem columnLength_pos {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a i : ℕ} (hw : 4 ≤ w)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w)
    (hInitial : ∀ d, d < a → A d 0 0) (hi : i < a) :
    0 < columnLength A w i :=
  (standard_iff_lt_columnLength hA hw hHS).mp (hInitial i hi)

/-- The last standard monomial in a column forces a pure y power of its degree. -/
theorem column_endpoint_le {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w i : ℕ} (hw : 4 ≤ w)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w)
    (hp : 0 < columnLength A w i) :
    i + columnLength A w i ≤ columnLength A w 0 := by
  let n := columnLength A w i
  have hTop : A i (n - 1) 0 :=
    (standard_iff_lt_columnLength hA hw hHS).mpr (by dsimp [n]; omega)
  have hy : A 0 (i + (n - 1)) 0 := by
    apply hA.lex (i := i) (j := n - 1) (k := 0) (by omega) _ hTop
    by_cases hi : i = 0
    · exact Or.inr ⟨hi.symm, by omega⟩
    · exact Or.inl (by omega)
  have hBound := (standard_iff_lt_columnLength hA hw hHS).mp hy
  dsimp [n] at *
  omega

theorem sum_columns_eq_sectionLength {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a : ℕ} (hw : 4 ≤ w) (hx : ¬ A a 0 0)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    (∑ i ∈ range a, columnLength A w i) = sectionLength A w := by
  classical
  let C : Finset (Σ _ : ℕ, ℕ) := (range a).sigma (fun i => range (columnLength A w i))
  let D : Finset (Σ _ : ℕ, ℕ) := (range (2 * w + 1)).sigma (standard2 A)
  have hCard : C.card = D.card := by
    apply card_bij (fun p _ => (⟨p.1 + p.2, p.1⟩ : Σ _ : ℕ, ℕ))
    · intro p hp
      obtain ⟨hi, hj⟩ := mem_sigma.mp hp
      have hstd := (standard_iff_lt_columnLength hA hw hHS).mpr (mem_range.mp hj)
      have hM : p.1 ∈ standard2 A (p.1 + p.2) :=
        mem_standard2.mpr ⟨Nat.le_add_right _ _, by simpa using hstd⟩
      apply mem_sigma.mpr
      exact ⟨mem_range.mpr (standard_degree_lt hA hw hHS hstd), hM⟩
    · intro p hp q hq heq
      have hdeg := congrArg Sigma.fst heq
      have hx' := congrArg (fun r : Σ _ : ℕ, ℕ => r.2) heq
      cases p with | mk i j =>
        cases q with | mk k l =>
          simp only [Sigma.mk.inj_iff, heq_eq_eq]
          dsimp only at hdeg hx'
          omega
    · intro p hp
      obtain ⟨hd, hi⟩ := mem_sigma.mp hp
      obtain ⟨hid, hstd⟩ := mem_standard2.mp hi
      have hia : p.2 < a := by
        by_contra hn
        exact hx (hA.down (by omega) (Nat.zero_le _) le_rfl hstd)
      refine ⟨⟨p.2, p.1 - p.2⟩, ?_, ?_⟩
      · exact mem_sigma.mpr ⟨mem_range.mpr hia,
          mem_range.mpr ((standard_iff_lt_columnLength hA hw hHS).mp hstd)⟩
      · cases p with | mk d i =>
          dsimp only at hid
          simp only [Sigma.mk.inj_iff, heq_eq_eq]
          exact ⟨by omega, trivial⟩
  simpa [C, D, hilbert2, sectionLength] using hCard

theorem terminal_triangle_budget {A : ℕ → ℕ → ℕ → Prop} (hA : StandardLex A)
    {w a : ℕ} (hw : 4 ≤ w) (ha : 0 < a)
    (hInitial : ∀ d, d < a → A d 0 0)
    (hHS : ∀ d, (∑ t ∈ range (d + 1), hilbert3 A t) ≤ 1 + d * w) :
    (∑ i ∈ range a, columnLength A w i * (columnLength A w i + 1)) ≤
      2 * (1 + (columnLength A w 0 - 1) * w) := by
  classical
  let n := columnLength A w
  have hn0 : 0 < n 0 := columnLength_pos hA hw hHS hInitial ha
  let C : Finset (Σ _ : ℕ, Σ _ : ℕ, ℕ) :=
    (range a).sigma (fun i => (range (n i)).sigma (fun j => range (n i - j)))
  let D : Finset (Σ _ : ℕ, ℕ × ℕ) := (range (n 0)).sigma (standard3 A)
  have hCard : C.card ≤ D.card := by
    apply card_le_card_of_injOn
      (fun p : Σ _ : ℕ, Σ _ : ℕ, ℕ => (⟨p.1 + p.2.1 + p.2.2, (p.1, p.2.1)⟩ : Σ _ : ℕ, ℕ × ℕ))
    · intro p hp
      obtain ⟨hi, hjk⟩ := mem_sigma.mp hp
      obtain ⟨hj, hk⟩ := mem_sigma.mp hjk
      have hia := mem_range.mp hi
      have hjn := mem_range.mp hj
      have hkn := mem_range.mp hk
      have hn : 0 < n p.1 := columnLength_pos hA hw hHS hInitial hia
      have hEnd := column_endpoint_le hA hw hHS hn
      change p.1 + n p.1 ≤ n 0 at hEnd
      have hstd : A p.1 (p.2.1 + p.2.2) 0 :=
        (standard_iff_lt_columnLength hA hw hHS).mpr (by dsimp [n] at *; omega)
      have hA3 : A p.1 p.2.1 p.2.2 :=
        hA.lex (by omega) (Or.inr ⟨rfl, by omega⟩) hstd
      apply mem_sigma.mpr
      constructor
      · apply mem_range.mpr
        change p.1 + p.2.1 + p.2.2 < n 0
        omega
      · apply mem_standard3.mpr
        change p.1 + p.2.1 ≤ p.1 + p.2.1 + p.2.2 ∧
          A p.1 p.2.1 (p.1 + p.2.1 + p.2.2 - p.1 - p.2.1)
        refine ⟨by omega, ?_⟩
        have hsub : p.1 + p.2.1 + p.2.2 - p.1 - p.2.1 = p.2.2 := by omega
        simpa only [hsub] using hA3
    · intro p hp q hq heq
      have hdeg := congrArg Sigma.fst heq
      have hxy := congrArg (fun r : Σ _ : ℕ, ℕ × ℕ => r.2) heq
      have hi := congrArg Prod.fst hxy
      have hj := congrArg Prod.snd hxy
      cases p with | mk i p =>
        cases p with | mk j k =>
          cases q with | mk i' q =>
            cases q with | mk j' k' =>
              dsimp only at hdeg hi hj
              have hk : k = k' := by omega
              simp_all
  have hTriangle : 2 * C.card = ∑ i ∈ range a, n i * (n i + 1) := by
    simp only [C, card_sigma, card_range, Finset.mul_sum]
    apply sum_congr rfl
    intro i hi
    have hReflect : (∑ j ∈ range (n i), (n i - j)) = ∑ j ∈ range (n i), (j + 1) := by
      have hh := sum_range_reflect (fun j : ℕ => j + 1) (n i)
      have heq : (∑ j ∈ range (n i), (n i - 1 - j + 1)) =
          ∑ j ∈ range (n i), (n i - j) := by
        apply sum_congr rfl
        intro j hj
        have := mem_range.mp hj
        omega
      exact heq.symm.trans hh
    rw [← Finset.mul_sum, hReflect]
    exact twice_sum_range_add_one (n i)
  have hDC : D.card = ∑ d ∈ range (n 0), hilbert3 A d := by simp [D, hilbert3]
  have hBound := hHS (n 0 - 1)
  have hnEq : n 0 - 1 + 1 = n 0 := by omega
  rw [hnEq] at hBound
  have hFinal := (Nat.mul_le_mul_left 2 hCard).trans (Nat.mul_le_mul_left 2 (by
    simpa only [hDC] using hBound))
  simpa only [hTriangle, n] using hFinal

#print axioms sum_columns_eq_sectionLength
#print axioms terminal_triangle_budget

end WidthBounds.Columns
