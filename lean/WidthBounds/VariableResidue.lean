import WidthBounds.GeneratorQuotient
import Mathlib.RingTheory.Ideal.Quotient.Operations

/-!
# The residue algebra of the actual variable ideal

The ideal is the existing span of the three variables, not a kernel by
definition. Its equality with the constant-coefficient kernel gives a
`K`-algebra equivalence from the actual quotient to the coefficient field.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial

variable {K : Type*} [Field K]

/-- Vanishing constant coefficient characterizes the actual variable ideal. -/
theorem mem_variableIdeal_iff_constantCoeff_eq_zero (p : MvPolynomial (Fin 3) K) :
    p ∈ variableIdeal ↔ constantCoeff p = 0 := by
  constructor
  · exact constantCoeff_eq_zero_of_mem_variableIdeal
  · intro hp
    classical
    rw [p.as_sum]
    apply (variableIdeal (K := K)).sum_mem
    intro d hd
    have hd0 : d ≠ 0 := by
      intro h
      subst d
      exact (mem_support_iff.mp hd) hp
    have hm := (variableIdeal (K := K)).mul_mem_left (C (coeff d p))
      (monomial_mem_variableIdeal_of_ne_zero (K := K) hd0)
    simpa only [C_mul_monomial, mul_one] using hm

/-- This is a theorem about the span-defined ideal, rather than its definition. -/
theorem variableIdeal_eq_ker_constantCoeff :
    variableIdeal (K := K) = RingHom.ker (constantCoeff : MvPolynomial (Fin 3) K →+* K) := by
  ext p
  exact mem_variableIdeal_iff_constantCoeff_eq_zero p

/-- The constant coefficient map with its coefficient-field algebra structure. -/
def constantCoeffAlgHom : MvPolynomial (Fin 3) K →ₐ[K] K :=
  { constantCoeff with
    commutes' := fun c => constantCoeff_C (Fin 3) c }

@[simp]
theorem constantCoeffAlgHom_apply (p : MvPolynomial (Fin 3) K) :
    constantCoeffAlgHom p = constantCoeff p := rfl

/-- The genuine quotient by the variables is the coefficient field as a `K`-algebra. -/
def variableResidueEquiv :
    (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)) ≃ₐ[K] K :=
  (Ideal.quotientEquivAlgOfEq K variableIdeal_eq_ker_constantCoeff).trans
    (Ideal.quotientKerAlgEquivOfRightInverse
      (f := constantCoeffAlgHom (K := K)) (g := C) (constantCoeff_C (Fin 3)))

@[simp]
theorem variableResidueEquiv_mk (p : MvPolynomial (Fin 3) K) :
    variableResidueEquiv (Ideal.Quotient.mk (variableIdeal (K := K)) p) =
      constantCoeff p := rfl

@[simp]
theorem variableResidueEquiv_symm_apply (c : K) :
    (variableResidueEquiv (K := K)).symm c =
      Ideal.Quotient.mk (variableIdeal (K := K)) (C c) := rfl

#print axioms mem_variableIdeal_iff_constantCoeff_eq_zero
#print axioms variableIdeal_eq_ker_constantCoeff
#print axioms variableResidueEquiv
#print axioms variableResidueEquiv_mk
#print axioms variableResidueEquiv_symm_apply

end

end WidthBounds.MonomialInterface
