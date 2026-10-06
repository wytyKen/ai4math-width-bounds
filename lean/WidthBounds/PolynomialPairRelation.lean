import WidthBounds.FiniteMonomialPresentation
import Mathlib.Algebra.MvPolynomial.Division

/-! The two-variable Koszul relation in the actual three-variable ring. -/

namespace WidthBounds.MonomialPresentation

noncomputable section

open MvPolynomial

variable {K : Type*} [Field K]

/-- Distinct polynomial variables form the required relation pair; this does
not assert that their generated ideal is the unit ideal. -/
theorem polynomial_pair_relation {i j : Fin 3} (hij : i ≠ j)
    (f g : Ring K) (h : X i * f + X j * g = 0) :
    ∃ t : Ring K, f = X j * t ∧ g = -(X i * t) := by
  classical
  have hcoeff : ∀ d : Fin 3 →₀ ℕ, d j = 0 → coeff d f = 0 := by
    intro d hd
    have hc := congrArg (coeff (Finsupp.single i 1 + d)) h
    have hz : coeff (Finsupp.single i 1 + d) (X j * g) = 0 := by
      rw [coeff_X_mul']
      simp [Finsupp.mem_support_iff, hd, hij]
    simpa only [coeff_add, coeff_X_mul, hz, add_zero, coeff_zero] using hc
  have hdvd : (X j : Ring K) ∣ f := by
    apply X_dvd_iff_modMonomial_eq_zero.mpr
    ext d
    by_cases hd : Finsupp.single j 1 ≤ d
    · simp only [coeff_modMonomial_of_le f hd, coeff_zero]
    · rw [coeff_modMonomial_of_not_le f hd, coeff_zero]
      apply hcoeff
      have : ¬ 1 ≤ d j := by simpa only [Finsupp.single_le_iff] using hd
      omega
  obtain ⟨t, ht⟩ := hdvd
  refine ⟨t, ht, ?_⟩
  have hz : X j * (X i * t + g) = (0 : Ring K) := by
    rw [ht] at h
    linear_combination h
  have hn : X i * t + g = (0 : Ring K) :=
    (mul_eq_zero.mp hz).resolve_left (X_ne_zero j)
  exact eq_neg_of_add_eq_zero_right hn

theorem polynomial_xy_relation (f g : Ring K)
    (h : X (0 : Fin 3) * f + X (1 : Fin 3) * g = 0) :
    ∃ t : Ring K, f = X (1 : Fin 3) * t ∧ g = -(X (0 : Fin 3) * t) :=
  polynomial_pair_relation (by decide) f g h

#print axioms polynomial_pair_relation
#print axioms polynomial_xy_relation

end

end WidthBounds.MonomialPresentation
