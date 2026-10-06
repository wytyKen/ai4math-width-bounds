import WidthBounds.GeneratorMinimality

/-!
# Coefficients at divisibility-minimal exponents

The coefficient map is defined on the full polynomial space. On a monomial
ideal, multiplication acts on its minimal-exponent coordinates through the
constant coefficient. Every vector of these coordinates is attained by an
actual polynomial in the ideal. No exhaustive list of minimal exponents is
required, and the finite coordinate set may be empty.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial

variable {K : Type*} [Field K]

/-- The coordinates at a finite set of exponents, defined on all polynomials. -/
def minimalCoefficientMap (E : Finset (Fin 3 →₀ ℕ)) :
    MvPolynomial (Fin 3) K →ₗ[K] (↥E → K) where
  toFun p e := coeff e.val p
  map_add' p q := by ext e; exact coeff_add e.val p q
  map_smul' c p := by ext e; exact coeff_smul e.val c p

@[simp] theorem minimalCoefficientMap_apply (E : Finset (Fin 3 →₀ ℕ))
    (p : MvPolynomial (Fin 3) K) (e : ↥E) :
    minimalCoefficientMap E p e = coeff e.val p := rfl

/-- The only contribution to a minimal coefficient of a product with an
ideal member comes from the constant coefficient of the other factor. -/
theorem coeff_mul_of_minimalExponent (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) {e : Fin 3 →₀ ℕ}
    (he : IsMinimalExponent (monomialIdeal (R := K) S) e)
    {p : MvPolynomial (Fin 3) K} (hp : p ∈ monomialIdeal S)
    (q : MvPolynomial (Fin 3) K) :
    coeff e (q * p) = constantCoeff q * coeff e p := by
  classical
  rw [coeff_mul, constantCoeff_eq]
  apply Finset.sum_eq_single (0, e)
  · intro ab hab hne
    by_cases hb : coeff ab.2 p = 0
    · simp [hb]
    · have hbS : ab.2 ∈ S :=
        (mem_monomialIdeal_iff_support S hUp p).mp hp ab.2
          (mem_support_iff.mpr hb)
      have habsum : ab.1 + ab.2 = e := Finset.mem_antidiagonal.mp hab
      have hbe : ab.2 = e := he.2 ab.2
        (by rw [← habsum]; exact le_add_left le_rfl)
        ((monomial_mem_monomialIdeal_iff S hUp ab.2).mpr hbS)
      have hae : ab.1 = 0 := by
        apply add_right_cancel (b := e)
        simpa [hbe] using habsum
      exact (hne (Prod.ext hae hbe)).elim
  · intro hnot
    exact (hnot (Finset.mem_antidiagonal.mpr (zero_add e))).elim

/-- On the ideal, the coordinate map turns polynomial multiplication into
scalar multiplication by the constant coefficient. -/
theorem minimalCoefficientMap_mul (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    {p : MvPolynomial (Fin 3) K} (hp : p ∈ monomialIdeal S)
    (q : MvPolynomial (Fin 3) K) :
    minimalCoefficientMap E (q * p) = constantCoeff q • minimalCoefficientMap E p := by
  ext e
  exact coeff_mul_of_minimalExponent S hUp (hMin e.val e.property) hp q

/-- All coordinate vectors are realized inside any ideal containing the
coefficient-one monomials at the chosen exponents. -/
theorem minimalCoefficientMap_exists_preimage_of_mem
    (I : Ideal (MvPolynomial (Fin 3) K)) (E : Finset (Fin 3 →₀ ℕ))
    (hMem : ∀ e ∈ E, monomial e (1 : K) ∈ I) (v : ↥E → K) :
    ∃ p ∈ I, minimalCoefficientMap E p = v := by
  classical
  refine ⟨∑ e : ↥E, monomial e.val (v e), ?_, ?_⟩
  · apply I.sum_mem
    intro e _
    have hm := I.mul_mem_left (C (v e)) (hMem e.val e.property)
    simpa only [C_mul_monomial, mul_one] using hm
  · ext e
    change coeff e.val (∑ f : ↥E, monomial f.val (v f)) = v e
    rw [coeff_sum]
    simp only [coeff_monomial, Subtype.val_inj]
    simp

/-- A finite selection of minimal-exponent coordinates is attained by ideal
members; this is proved by an explicit finite sum of monomials. -/
theorem minimalCoefficientMap_exists_preimage
    (I : Ideal (MvPolynomial (Fin 3) K)) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent I e) (v : ↥E → K) :
    ∃ p ∈ I, minimalCoefficientMap E p = v :=
  minimalCoefficientMap_exists_preimage_of_mem I E (fun e he => (hMin e he).1) v

#print axioms coeff_mul_of_minimalExponent
#print axioms minimalCoefficientMap_mul
#print axioms minimalCoefficientMap_exists_preimage_of_mem
#print axioms minimalCoefficientMap_exists_preimage

end

end WidthBounds.MonomialInterface
