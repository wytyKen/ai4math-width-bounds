import WidthBounds.IdealBounds

/-! Explicit finite monomial generating sets. The cardinality bound does not
assert minimality or identify a Betti number. -/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Finset LexCounting Columns

variable {R : Type*} [CommSemiring R]

/-- Any pure `z` power in an ideal bounds every vertical column. -/
theorem exists_vertical_mem (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (i j : ℕ) :
    ∃ k, monomial3 i j k ∈ I := by
  obtain ⟨b, hb⟩ := hZ
  exact ⟨b, monomial3_mem_of_le I (Nat.zero_le _) (Nat.zero_le _) le_rfl hb⟩

/-- First exponent at which the vertical column enters the ideal. -/
def zThreshold (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (i j : ℕ) : ℕ := by
  classical
  exact Nat.find (exists_vertical_mem I hZ i j)

theorem zThreshold_mem (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (i j : ℕ) :
    monomial3 i j (zThreshold I hZ i j) ∈ I := by
  classical
  exact Nat.find_spec (exists_vertical_mem I hZ i j)

theorem zThreshold_le (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) {i j k : ℕ}
    (hm : monomial3 i j k ∈ I) : zThreshold I hZ i j ≤ k := by
  classical
  exact Nat.find_min' (exists_vertical_mem I hZ i j) hm

/-- An explicit finite generating set from finite horizontal columns and a
vertical bound. No minimality, field assumption, or lex closure is needed here. -/
theorem monomialIdeal_exists_generators_of_columns
    (S : Set (Fin 3 →₀ ℕ)) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ monomialIdeal (R := R) S)
    (hZ : ∃ b, monomial3 0 0 b ∈ monomialIdeal (R := R) S)
    (hn : ∀ i j, standard (monomialIdeal (R := R) S) i j 0 ↔ j < n i) :
    ∃ G : Finset (MvPolynomial (Fin 3) R),
      (∀ g ∈ G, ∃ i j k, g = monomial3 i j k) ∧
      Ideal.span (G : Set (MvPolynomial (Fin 3) R)) = monomialIdeal S ∧
      G.card ≤ a + 1 + ∑ i ∈ range a, n i := by
  classical
  let I : Ideal (MvPolynomial (Fin 3) R) := monomialIdeal S
  let B : Finset (MvPolynomial (Fin 3) R) :=
    (range a).image (fun i => monomial3 i (n i) 0)
  let C : Finset (Σ _ : ℕ, ℕ) := (range a).sigma (fun i => range (n i))
  let V : Finset (MvPolynomial (Fin 3) R) :=
    C.image (fun p => monomial3 p.1 p.2 (zThreshold I hZ p.1 p.2))
  let G : Finset (MvPolynomial (Fin 3) R) := insert (monomial3 a 0 0) (B ∪ V)
  have hB : ∀ i, monomial3 i (n i) 0 ∈ I := by
    intro i
    by_contra h
    have hlt := (hn i (n i)).mp h
    omega
  have hG : ∀ g ∈ G, g ∈ I := by
    intro g hg
    rcases mem_insert.mp hg with hg | hg
    · simpa only [hg] using hx
    · rcases mem_union.mp hg with hg | hg
      · obtain ⟨i, hi, rfl⟩ := mem_image.mp hg
        exact hB i
      · obtain ⟨p, hp, rfl⟩ := mem_image.mp hg
        exact zThreshold_mem I hZ p.1 p.2
  have hxG : monomial3 a 0 0 ∈ Ideal.span (G : Set (MvPolynomial (Fin 3) R)) :=
    Ideal.subset_span (mem_insert_self _ _)
  have hBG : ∀ i, i < a →
      monomial3 i (n i) 0 ∈ Ideal.span (G : Set (MvPolynomial (Fin 3) R)) := by
    intro i hi
    apply Ideal.subset_span
    apply mem_insert_of_mem
    apply mem_union_left
    exact mem_image.mpr ⟨i, mem_range.mpr hi, rfl⟩
  have hVG : ∀ i j, i < a → j < n i →
      monomial3 i j (zThreshold I hZ i j) ∈
        Ideal.span (G : Set (MvPolynomial (Fin 3) R)) := by
    intro i j hi hj
    apply Ideal.subset_span
    apply mem_insert_of_mem
    apply mem_union_right
    exact mem_image.mpr ⟨⟨i, j⟩,
      mem_sigma.mpr ⟨mem_range.mpr hi, mem_range.mpr hj⟩, rfl⟩
  refine ⟨G, ?_, ?_, ?_⟩
  · intro g hg
    rcases mem_insert.mp hg with hg | hg
    · exact ⟨a, 0, 0, hg⟩
    · rcases mem_union.mp hg with hg | hg
      · obtain ⟨i, hi, rfl⟩ := mem_image.mp hg
        exact ⟨i, n i, 0, rfl⟩
      · obtain ⟨p, hp, rfl⟩ := mem_image.mp hg
        exact ⟨p.1, p.2, zThreshold I hZ p.1 p.2, rfl⟩
  · apply le_antisymm
    · exact Ideal.span_le.mpr hG
    · apply Ideal.span_le.mpr
      rintro g ⟨e, he, rfl⟩
      have hm : monomial3 (e 0) (e 1) (e 2) ∈ I := by
        simpa only [monomial3, exponent_coordinates] using
          (Ideal.subset_span ⟨e, he, rfl⟩ : monomial e (1 : R) ∈ monomialIdeal S)
      have hgm : monomial3 (e 0) (e 1) (e 2) ∈
          Ideal.span (G : Set (MvPolynomial (Fin 3) R)) := by
        by_cases hi : a ≤ e 0
        · exact monomial3_mem_of_le _ hi (Nat.zero_le _) (Nat.zero_le _) hxG
        · have hi' : e 0 < a := by omega
          by_cases hj : n (e 0) ≤ e 1
          · exact monomial3_mem_of_le _ le_rfl hj (Nat.zero_le _) (hBG _ hi')
          · have hj' : e 1 < n (e 0) := by omega
            exact monomial3_mem_of_le _ le_rfl le_rfl (zThreshold_le I hZ hm)
              (hVG _ _ hi' hj')
      simpa only [monomial3, exponent_coordinates] using hgm
  · have hcardB : B.card ≤ a := (card_image_le).trans_eq (card_range a)
    have hcardV : V.card ≤ ∑ i ∈ range a, n i := by
      calc
        V.card ≤ C.card := card_image_le
        _ = ∑ i ∈ range a, n i := by simp only [C, card_sigma, card_range]
    have hcardG : G.card ≤ B.card + V.card + 1 :=
      (card_insert_le _ _).trans (Nat.add_le_add_right (card_union_le B V) 1)
    omega

variable [Nontrivial R]

/-- Under the previously established Hilbert budget, a lex monomial ideal
with a pure `z` power has a genuine finite polynomial generating set. -/
theorem monomialIdeal_exists_generators_le
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    {w a : ℕ} (hw : 4 ≤ w)
    (hHS : ∀ d, (∑ t ∈ range (d + 1),
      hilbert3 (standard (monomialIdeal (R := R) S)) t) ≤ 1 + d * w)
    (hx : monomial3 a 0 0 ∈ monomialIdeal (R := R) S)
    (hZ : ∃ b, monomial3 0 0 b ∈ monomialIdeal (R := R) S) :
    ∃ G : Finset (MvPolynomial (Fin 3) R),
      (∀ g ∈ G, ∃ i j k, g = monomial3 i j k) ∧
      Ideal.span (G : Set (MvPolynomial (Fin 3) R)) = monomialIdeal S ∧
      G.card ≤ a + 1 + sectionLength (standard (monomialIdeal (R := R) S)) w := by
  have hA := monomialIdeal_standardLex (R := R) S hUp hLex
  obtain ⟨G, hMon, hSpan, hCard⟩ := monomialIdeal_exists_generators_of_columns S a
    (columnLength (standard (monomialIdeal (R := R) S)) w) hx hZ
    (fun _ _ => standard_iff_lt_columnLength hA hw hHS)
  refine ⟨G, hMon, hSpan, ?_⟩
  rwa [sum_columns_eq_sectionLength hA hw (not_not.mpr hx) hHS] at hCard

/-- The same generating bound using actual homogeneous quotient dimensions
for the budget and the actual full `x,y` quotient subspace for the conclusion. -/
theorem monomialIdeal_exists_generators_finrank_le
    {K : Type*} [Field K]
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    {w a : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w)
    (hx : monomial3 a 0 0 ∈ monomialIdeal (R := K) S)
    (hZ : ∃ b, monomial3 0 0 b ∈ monomialIdeal (R := K) S) :
    ∃ G : Finset (MvPolynomial (Fin 3) K),
      (∀ g ∈ G, ∃ i j k, g = monomial3 i j k) ∧
      Ideal.span (G : Set (MvPolynomial (Fin 3) K)) = monomialIdeal S ∧
      G.card ≤ a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) := by
  rw [finrank_xySubspace S hUp hLex hw hBudget]
  exact monomialIdeal_exists_generators_le S hUp hLex hw
    (hilbertBudget_of_finrankBudget S hUp w hBudget) hx hZ

#print axioms monomialIdeal_exists_generators_of_columns
#print axioms monomialIdeal_exists_generators_le
#print axioms monomialIdeal_exists_generators_finrank_le

end

end WidthBounds.MonomialInterface
