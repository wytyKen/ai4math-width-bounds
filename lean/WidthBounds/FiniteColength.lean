import WidthBounds.MonomialBasis

/-!
# Finite colength supplies a pure z power

Finite colength means finite dimension of the actual polynomial quotient over
the coefficient field. The standard-monomial basis proves that its standard
exponent set is finite. In particular, some pure z power belongs to the ideal.
Neither a Hilbert-budget assumption nor lex closure is needed for this direction.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial

variable {K : Type*} [Field K]

/-- Actual finite-dimensionality is equivalent to finiteness of the standard
exponent set; the equivalence uses the already constructed quotient basis. -/
theorem quotient_finite_iff_standard_finite (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) :
    Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S) ↔
      (Sᶜ).Finite := by
  constructor
  · intro h
    letI := h
    letI := Module.Finite.finite_basis (standardMonomialBasis (K := K) S hUp)
    exact Set.toFinite _
  · intro h
    letI := h.to_subtype
    exact Module.Finite.of_basis (standardMonomialBasis (K := K) S hUp)

/-- A finite standard exponent set cannot contain every pure z power. -/
theorem exists_pure_z_exponent_of_standard_finite (S : Set (Fin 3 →₀ ℕ))
    (hFinite : (Sᶜ).Finite) : ∃ N : ℕ, exponent 0 0 N ∈ S := by
  obtain ⟨N, hN⟩ := (hFinite.image (fun e => e 2)).bddAbove
  refine ⟨N + 1, ?_⟩
  by_contra hnot
  have hle : N + 1 ≤ N := hN ⟨exponent 0 0 (N + 1), hnot, by simp⟩
  omega

/-- Finite colength of the genuine quotient gives the pure-z membership
needed to define every z threshold in a finite generating family. -/
theorem exists_pure_z_mem_of_finite_quotient (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)] :
    ∃ N : ℕ, monomial3 0 0 N ∈ monomialIdeal (R := K) S := by
  obtain ⟨N, hN⟩ := exists_pure_z_exponent_of_standard_finite S
    ((quotient_finite_iff_standard_finite (K := K) S hUp).mp inferInstance)
  exact ⟨N, (monomial_mem_monomialIdeal_iff S hUp _).mpr hN⟩

/-- In a lex upper set, a pure z power bounds the degree of every standard
monomial, so the standard exponent set is finite. -/
theorem standard_finite_of_pure_z (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    {N : ℕ} (hZ : exponent 0 0 N ∈ S) : (Sᶜ).Finite := by
  classical
  have hDegree : ∀ e : ↥(Sᶜ), e.1 0 + e.1 1 + e.1 2 < N := by
    intro e
    by_contra hnot
    have hz : exponent 0 0 (e.1 0 + e.1 1 + e.1 2) ∈ S :=
      hUp (exponent_le_iff.mpr ⟨le_rfl, le_rfl, by omega⟩) hZ
    have he : exponent (e.1 0) (e.1 1) (e.1 2) ∈ S := by
      apply hLex (by omega) _ hz
      by_cases hx : e.1 0 = 0
      · exact Or.inr ⟨hx.symm, Nat.zero_le _⟩
      · exact Or.inl (by omega)
    exact e.2 (by simpa only [exponent_coordinates] using he)
  let f : ↥(Sᶜ) → (Fin 3 → Fin N) := fun e v =>
    ⟨e.1 v, by have hd := hDegree e; fin_cases v <;> dsimp <;> omega⟩
  have hf : Function.Injective f := by
    intro e d h
    apply Subtype.ext
    ext v
    exact congrArg Fin.val (congrFun h v)
  letI := Finite.of_injective f hf
  exact Set.toFinite _

/-- For genuine lex monomial quotients, the explicit pure-z assumption and
finite colength are equivalent. -/
theorem quotient_finite_iff_exists_pure_z (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (hLex : IsLexExponentSet S) :
    Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S) ↔
      ∃ N : ℕ, monomial3 0 0 N ∈ monomialIdeal (R := K) S := by
  constructor
  · intro h
    letI := h
    exact exists_pure_z_mem_of_finite_quotient S hUp
  · rintro ⟨N, hN⟩
    apply (quotient_finite_iff_standard_finite S hUp).mpr
    exact standard_finite_of_pure_z S hUp hLex
      ((monomial_mem_monomialIdeal_iff S hUp _).mp hN)

#print axioms quotient_finite_iff_standard_finite
#print axioms exists_pure_z_mem_of_finite_quotient
#print axioms quotient_finite_iff_exists_pure_z

end

end WidthBounds.MonomialInterface
