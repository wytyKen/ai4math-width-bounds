import WidthBounds.MinimalGenerators

/-! Explicit boundary exponents and their exact cardinality. These results
do not assert divisibility minimality or a minimal number of polynomial generators. -/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Finset

variable {R : Type*} [CommSemiring R]

/-- The pure `x` boundary, horizontal column boundaries, and vertical thresholds. -/
def boundaryExponents (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ) :
    Finset (Fin 3 →₀ ℕ) :=
  insert (exponent a 0 0)
    (((range a).image (fun i => exponent i (n i) 0)) ∪
      (((range a).sigma (fun i => range (n i))).image
        (fun p => exponent p.1 p.2 (zThreshold I hZ p.1 p.2))))

theorem mem_boundaryExponents_iff (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (e : Fin 3 →₀ ℕ) :
    e ∈ boundaryExponents I hZ a n ↔
      e = exponent a 0 0 ∨
      (∃ i, i < a ∧ e = exponent i (n i) 0) ∨
      (∃ i j, i < a ∧ j < n i ∧ e = exponent i j (zThreshold I hZ i j)) := by
  classical
  simp only [boundaryExponents, mem_insert, mem_union, mem_image, mem_range]
  constructor
  · rintro (hx | hb | hv)
    · exact Or.inl hx
    · obtain ⟨i, hi, he⟩ := hb
      exact Or.inr (Or.inl ⟨i, hi, he.symm⟩)
    · obtain ⟨⟨i, j⟩, hp, he⟩ := hv
      have hp' := mem_sigma.mp hp
      exact Or.inr (Or.inr ⟨i, j, mem_range.mp hp'.1, mem_range.mp hp'.2, he.symm⟩)
  · rintro (hx | ⟨i, hi, he⟩ | ⟨i, j, hi, hj, he⟩)
    · exact Or.inl hx
    · exact Or.inr (Or.inl ⟨i, hi, he.symm⟩)
    · exact Or.inr (Or.inr ⟨⟨i, j⟩,
        mem_sigma.mpr ⟨mem_range.mpr hi, mem_range.mpr hj⟩, he.symm⟩)

/-- Every boundary candidate is a coefficient-one monomial in the ideal. -/
theorem boundaryExponents_monomial_mem (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    {e : Fin 3 →₀ ℕ} (he : e ∈ boundaryExponents I hZ a n) :
    monomial e (1 : R) ∈ I := by
  rcases (mem_boundaryExponents_iff I hZ a n e).mp he with
    rfl | ⟨i, hi, rfl⟩ | ⟨i, j, hi, hj, rfl⟩
  · exact hx
  · change monomial3 i (n i) 0 ∈ I
    by_contra hm
    exact (Nat.lt_irrefl (n i)) ((hn i (n i)).mp hm)
  · exact zThreshold_mem I hZ i j

/-- Any ideal monomial is divisible by a boundary candidate. -/
theorem exists_boundaryExponent_le (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    {e : Fin 3 →₀ ℕ} (hm : monomial e (1 : R) ∈ I) :
    ∃ b ∈ boundaryExponents I hZ a n, b ≤ e := by
  by_cases hi : a ≤ e 0
  · refine ⟨exponent a 0 0, (mem_boundaryExponents_iff I hZ a n _).mpr
      (Or.inl rfl), ?_⟩
    simpa only [exponent_coordinates] using
      (exponent_le_iff.mpr ⟨hi, Nat.zero_le _, Nat.zero_le _⟩ :
        exponent a 0 0 ≤ exponent (e 0) (e 1) (e 2))
  · have hi' : e 0 < a := by omega
    by_cases hj : n (e 0) ≤ e 1
    · refine ⟨exponent (e 0) (n (e 0)) 0,
        (mem_boundaryExponents_iff I hZ a n _).mpr
          (Or.inr (Or.inl ⟨e 0, hi', rfl⟩)), ?_⟩
      simpa only [exponent_coordinates] using
        (exponent_le_iff.mpr ⟨le_rfl, hj, Nat.zero_le _⟩ :
          exponent (e 0) (n (e 0)) 0 ≤ exponent (e 0) (e 1) (e 2))
    · have hj' : e 1 < n (e 0) := by omega
      refine ⟨exponent (e 0) (e 1) (zThreshold I hZ (e 0) (e 1)),
        (mem_boundaryExponents_iff I hZ a n _).mpr
          (Or.inr (Or.inr ⟨e 0, e 1, hi', hj', rfl⟩)), ?_⟩
      have hm' : monomial3 (e 0) (e 1) (e 2) ∈ I := by
        simpa only [monomial3, exponent_coordinates] using hm
      simpa only [exponent_coordinates] using
        (exponent_le_iff.mpr ⟨le_rfl, le_rfl, zThreshold_le I hZ hm'⟩ :
          exponent (e 0) (e 1) (zThreshold I hZ (e 0) (e 1)) ≤
            exponent (e 0) (e 1) (e 2))

theorem boundary_zThreshold_pos (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (n : ℕ → ℕ)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    {i j : ℕ} (hj : j < n i) : 0 < zThreshold I hZ i j := by
  have hs := (hn i j).mpr hj
  have hm := zThreshold_mem I hZ i j
  by_contra h
  have hz : zThreshold I hZ i j = 0 := by omega
  exact hs (hz ▸ hm)

/-- The three parts are disjoint and both indexed maps are injective, so the
candidate count is exact even without lex closure or minimality of `a`. -/
theorem card_boundaryExponents (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) (a : ℕ) (n : ℕ → ℕ)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i) :
    (boundaryExponents I hZ a n).card = a + 1 + ∑ i ∈ range a, n i := by
  classical
  let B : Finset (Fin 3 →₀ ℕ) := (range a).image (fun i => exponent i (n i) 0)
  let C : Finset (Σ _ : ℕ, ℕ) := (range a).sigma (fun i => range (n i))
  let V : Finset (Fin 3 →₀ ℕ) :=
    C.image (fun p => exponent p.1 p.2 (zThreshold I hZ p.1 p.2))
  have hB : B.card = a := by
    calc
      B.card = (range a).card := card_image_of_injective _ (by
        intro i j he
        simpa only [exponent_zero] using congrArg (fun e => e 0) he)
      _ = a := card_range a
  have hV : V.card = ∑ i ∈ range a, n i := by
    calc
      V.card = C.card := card_image_of_injective _ (by
        rintro ⟨i, j⟩ ⟨i', j'⟩ he
        have hi : i = i' := by
          simpa only [exponent_zero] using congrArg (fun e => e 0) he
        have hj : j = j' := by
          simpa only [exponent_one] using congrArg (fun e => e 1) he
        cases hi
        cases hj
        rfl)
      _ = ∑ i ∈ range a, n i := by simp only [C, card_sigma, card_range]
  have hBV : Disjoint B V := by
    apply disjoint_left.mpr
    intro e hb hv
    obtain ⟨i, hi, rfl⟩ := mem_image.mp hb
    obtain ⟨⟨i', j'⟩, hp, he⟩ := mem_image.mp hv
    have hj' : j' < n i' := mem_range.mp (mem_sigma.mp hp).2
    have hz := boundary_zThreshold_pos I hZ n hn hj'
    have he' : zThreshold I hZ i' j' = 0 := by
      simpa only [exponent_two] using congrArg (fun e => e 2) he
    omega
  have hx : exponent a 0 0 ∉ B ∪ V := by
    intro h
    rcases mem_union.mp h with hb | hv
    · obtain ⟨i, hi, he⟩ := mem_image.mp hb
      have hi' := mem_range.mp hi
      have ha : i = a := by
        simpa only [exponent_zero] using congrArg (fun e => e 0) he
      omega
    · obtain ⟨⟨i, j⟩, hp, he⟩ := mem_image.mp hv
      have hi : i < a := mem_range.mp (mem_sigma.mp hp).1
      have ha : i = a := by
        simpa only [exponent_zero] using congrArg (fun e => e 0) he
      omega
  change (insert (exponent a 0 0) (B ∪ V)).card = _
  rw [card_insert_of_notMem hx, card_union_of_disjoint hBV, hB, hV]
  omega

/-- The explicit boundary monomials generate the original monomial ideal.
No upward closure or lex assumption on its presenting exponent set is needed. -/
theorem span_boundaryExponents (S : Set (Fin 3 →₀ ℕ))
    (hZ : ∃ b, monomial3 0 0 b ∈ monomialIdeal (R := R) S) (a : ℕ) (n : ℕ → ℕ)
    (hx : monomial3 a 0 0 ∈ monomialIdeal (R := R) S)
    (hn : ∀ i j, standard (monomialIdeal (R := R) S) i j 0 ↔ j < n i) :
    Ideal.span ((fun e => monomial e (1 : R)) ''
      (boundaryExponents (monomialIdeal (R := R) S) hZ a n : Set (Fin 3 →₀ ℕ))) =
      monomialIdeal (R := R) S := by
  let I : Ideal (MvPolynomial (Fin 3) R) := monomialIdeal S
  let G : Set (MvPolynomial (Fin 3) R) :=
    (fun e => monomial e (1 : R)) '' (boundaryExponents I hZ a n : Set (Fin 3 →₀ ℕ))
  change Ideal.span G = I
  apply le_antisymm
  · apply Ideal.span_le.mpr
    rintro g ⟨e, he, rfl⟩
    exact boundaryExponents_monomial_mem I hZ a n hx hn he
  · apply Ideal.span_le.mpr
    rintro g ⟨e, he, rfl⟩
    have hm : monomial e (1 : R) ∈ I := Ideal.subset_span ⟨e, he, rfl⟩
    obtain ⟨b, hb, hbe⟩ := exists_boundaryExponent_le I hZ a n hm
    have hb' : monomial b (1 : R) ∈ Ideal.span G := Ideal.subset_span ⟨b, hb, rfl⟩
    apply (Ideal.span G).mem_of_dvd _ hb'
    exact monomial_dvd_monomial.mpr ⟨Or.inr hbe, dvd_rfl⟩

#print axioms boundaryExponents_monomial_mem
#print axioms exists_boundaryExponent_le
#print axioms card_boundaryExponents
#print axioms span_boundaryExponents

end

end WidthBounds.MonomialInterface
