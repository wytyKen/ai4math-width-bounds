import WidthBounds.MonomialBasis
import WidthBounds.AllWidths

/-!
# Width bounds with actual quotient-space dimensions

The Hilbert budget is expressed using the image of homogeneous polynomials
in an actual monomial-ideal quotient. The `x,y` subspace is the span of all
quotient monomials with zero `z` exponent; its dimension is proved equal to
the combinatorial section length using the standard-monomial basis and cutoff.
The resulting inequalities are not a formalized Betti-number reduction.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Module Finset LexCounting Columns

variable {K : Type*} [Field K]

/-- The image of `x^i y^j` in the actual ideal quotient. -/
def xyMonomial (I : Ideal (MvPolynomial (Fin 3) K)) (i j : ℕ) :
    MvPolynomial (Fin 3) K ⧸ I :=
  Ideal.Quotient.mk I (monomial3 i j 0)

/-- The full `x,y` subspace: the span of all monomials with zero `z` exponent,
without any truncation in its definition. -/
def xySubspace (I : Ideal (MvPolynomial (Fin 3) K)) :
    Submodule K (MvPolynomial (Fin 3) K ⧸ I) :=
  Submodule.span K (Set.range (fun ij : ℕ × ℕ => xyMonomial I ij.1 ij.2))

/-- Finite standard indices `(degree, x exponent)`, using the proven cutoff. -/
def xyStandardIndices (A : ℕ → ℕ → ℕ → Prop) (w : ℕ) : Finset (Σ _ : ℕ, ℕ) :=
  (range (2 * w + 1)).sigma (standard2 A)

theorem card_xyStandardIndices (A : ℕ → ℕ → ℕ → Prop) (w : ℕ) :
    (xyStandardIndices A w).card = sectionLength A w := by
  simp [xyStandardIndices, sectionLength, hilbert2]

/-- The finite family of standard `x,y` monomials. -/
def boundedXYMonomial (S : Set (Fin 3 →₀ ℕ)) (w : ℕ)
    (di : xyStandardIndices (standard (monomialIdeal (R := K) S)) w) :
    MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S :=
  xyMonomial (monomialIdeal (R := K) S) di.1.2 (di.1.1 - di.1.2)

theorem boundedXYMonomial_linearIndependent (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (w : ℕ) :
    LinearIndependent K (boundedXYMonomial (K := K) S w) := by
  let f : xyStandardIndices (standard (monomialIdeal (R := K) S)) w → ↥(Sᶜ) :=
    fun di => ⟨exponent di.1.2 (di.1.1 - di.1.2) 0,
      (standard_monomialIdeal_iff S hUp _ _ _).mp
        (mem_standard2.mp (mem_sigma.mp di.2).2).2⟩
  have hf : Function.Injective f := by
    intro a b h
    have ha : a.1.2 ≤ a.1.1 := (mem_standard2.mp (mem_sigma.mp a.2).2).1
    have hb : b.1.2 ≤ b.1.1 := (mem_standard2.mp (mem_sigma.mp b.2).2).1
    have hi : a.1.2 = b.1.2 := by
      have hc := congrArg (fun e : ↥(Sᶜ) => e.1 0) h
      simpa only [f, exponent_zero] using hc
    have hj : a.1.1 - a.1.2 = b.1.1 - b.1.2 := by
      have hc := congrArg (fun e : ↥(Sᶜ) => e.1 1) h
      simpa only [f, exponent_one] using hc
    have hd : a.1.1 = b.1.1 := by omega
    apply Subtype.ext
    exact Sigma.ext hd (heq_of_eq hi)
  simpa only [Function.comp_def, standardMonomialBasis_apply,
    boundedXYMonomial, xyMonomial, monomial3, f] using
    (standardMonomialBasis (K := K) S hUp).linearIndependent.comp f hf

theorem finrank_boundedXYMonomialSpan (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (w : ℕ) :
    Module.finrank K (Submodule.span K
      (Set.range (boundedXYMonomial (K := K) S w))) =
      sectionLength (standard (monomialIdeal (R := K) S)) w := by
  rw [finrank_span_eq_card (boundedXYMonomial_linearIndependent S hUp w)]
  simpa only [Fintype.card_coe] using card_xyStandardIndices
    (standard (monomialIdeal (R := K) S)) w

/-- Replace every Hilbert count by its already proved actual quotient dimension. -/
theorem hilbertBudget_of_finrankBudget (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (w : ℕ)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∀ d, (∑ t ∈ range (d + 1),
      hilbert3 (standard (monomialIdeal (R := K) S)) t) ≤ 1 + d * w := by
  simpa only [finrank_quotientHomogeneous S hUp] using hBudget

/-- The finite family spans the full `x,y` subspace. Its truncation follows
from the actual homogeneous-dimension budget, not a finiteness hypothesis. -/
theorem xySubspace_eq_boundedSpan (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (hLex : IsLexExponentSet S) {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    xySubspace (monomialIdeal (R := K) S) =
      Submodule.span K (Set.range (boundedXYMonomial (K := K) S w)) := by
  classical
  have hA := monomialIdeal_standardLex (R := K) S hUp hLex
  have hHS := hilbertBudget_of_finrankBudget S hUp w hBudget
  apply le_antisymm
  · apply Submodule.span_le.mpr
    rintro q ⟨⟨i, j⟩, rfl⟩
    change xyMonomial (monomialIdeal (R := K) S) i j ∈
      Submodule.span K (Set.range (boundedXYMonomial (K := K) S w))
    by_cases hs : standard (monomialIdeal (R := K) S) i j 0
    · have hd : i + j < 2 * w + 1 := standard_degree_lt hA hw hHS hs
      have hmem : i ∈ standard2 (standard (monomialIdeal (R := K) S)) (i + j) :=
        mem_standard2.mpr ⟨by omega, by simpa using hs⟩
      let di : xyStandardIndices (standard (monomialIdeal (R := K) S)) w :=
        ⟨⟨i + j, i⟩, mem_sigma.mpr ⟨mem_range.mpr hd, hmem⟩⟩
      have hm : boundedXYMonomial (K := K) S w di ∈
          Submodule.span K (Set.range (boundedXYMonomial (K := K) S w)) :=
        Submodule.subset_span ⟨di, rfl⟩
      simpa only [boundedXYMonomial, di, Nat.add_sub_cancel_left] using hm
    · have hm : monomial3 i j 0 ∈ monomialIdeal (R := K) S := not_not.mp hs
      have hz : xyMonomial (monomialIdeal (R := K) S) i j = 0 :=
        Ideal.Quotient.eq_zero_iff_mem.mpr hm
      rw [hz]
      exact Submodule.zero_mem _
  · apply Submodule.span_le.mpr
    rintro q ⟨di, rfl⟩
    exact Submodule.subset_span ⟨(di.1.2, di.1.1 - di.1.2), rfl⟩

/-- The actual full `x,y` subspace dimension equals the combinatorial length. -/
theorem finrank_xySubspace (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (hLex : IsLexExponentSet S) {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    Module.finrank K (xySubspace (monomialIdeal (R := K) S)) =
      sectionLength (standard (monomialIdeal (R := K) S)) w := by
  rw [xySubspace_eq_boundedSpan S hUp hLex hw hBudget]
  exact finrank_boundedXYMonomialSpan S hUp w

/-- All-width inequalities formulated using actual quotient subspace dimensions.
The initial degree is constructed from the nonzero lex monomial ideal and `x`
being standard. The displayed expressions have not been identified with Betti numbers. -/
theorem monomialIdeal_all_widths_dimension_bounds (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    (hNonzero : monomialIdeal (R := K) S ≠ ⊥)
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ a : ℕ, 2 ≤ a ∧
      ¬ standard (monomialIdeal (R := K) S) a 0 0 ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) <
        (w + 1).choose 2 ∧
      a + 2 * Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ≤
        2 * (w + 1).choose 3 ∧
      Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ≤
        3 * (w + 1).choose 4 := by
  obtain ⟨a, ha, hx, hInitial, _⟩ :=
    monomialIdeal_exists_initial_degree S hUp hLex hNonzero hOne
  refine ⟨a, ha, hx, hInitial, ?_⟩
  rw [finrank_xySubspace S hUp hLex hw hBudget]
  exact all_widths_analytic_bounds (monomialIdeal_standardLex S hUp hLex)
    hw ha hInitial hx (hilbertBudget_of_finrankBudget S hUp w hBudget)

#print axioms finrank_xySubspace
#print axioms monomialIdeal_all_widths_dimension_bounds

end

end WidthBounds.MonomialInterface
