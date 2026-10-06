import WidthBounds.MinimalGenerators
import WidthBounds.FiniteColength

/-!
# Strict width bounds for an actual finite generating set

The conclusion concerns the cardinality of coefficient-one monomials spanning
the actual polynomial ideal. It does not identify this cardinality with a Betti
number, or assert minimality of the generating set.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Finset

variable {K : Type*} [Field K]

/-- The dimension-budget bound now controls a finite generating set of the
actual lex monomial ideal, assuming explicitly that some pure z power belongs. -/
theorem monomialIdeal_exists_generators_card_lt
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    (hZ : ∃ N, monomial3 0 0 N ∈ monomialIdeal (R := K) S)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ G : Finset (MvPolynomial (Fin 3) K),
      (∀ g ∈ G, ∃ i j k, g = monomial3 i j k) ∧
      Ideal.span (G : Set (MvPolynomial (Fin 3) K)) = monomialIdeal S ∧
      G.card < (w + 1).choose 2 := by
  have hNonzero : monomialIdeal (R := K) S ≠ ⊥ := by
    obtain ⟨N, hN⟩ := hZ
    apply (monomialIdeal_ne_bot_iff S).mpr
    exact ⟨exponent 0 0 N, (monomial_mem_monomialIdeal_iff S hUp _).mp hN⟩
  obtain ⟨a, _, hx, _, hStrict, _⟩ :=
    monomialIdeal_all_widths_dimension_bounds S hUp hLex hNonzero hOne hw hBudget
  obtain ⟨G, hMon, hSpan, hCard⟩ := monomialIdeal_exists_generators_finrank_le
    S hUp hLex hw hBudget (not_not.mp hx) hZ
  exact ⟨G, hMon, hSpan, hCard.trans_lt hStrict⟩

/-- A finite-colength version using finite dimension of the genuine quotient.
The pure z power and the initial degree are derived rather than assumed. -/
theorem finiteColength_exists_generators_card_lt
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ G : Finset (MvPolynomial (Fin 3) K),
      (∀ g ∈ G, ∃ i j k, g = monomial3 i j k) ∧
      Ideal.span (G : Set (MvPolynomial (Fin 3) K)) = monomialIdeal S ∧
      G.card < (w + 1).choose 2 :=
  monomialIdeal_exists_generators_card_lt S hUp hLex hOne
    (exists_pure_z_mem_of_finite_quotient S hUp) hw hBudget

#print axioms monomialIdeal_exists_generators_card_lt
#print axioms finiteColength_exists_generators_card_lt

end

end WidthBounds.MonomialInterface
