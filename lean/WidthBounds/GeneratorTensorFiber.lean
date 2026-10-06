import WidthBounds.GeneratorQuotientBounds
import Mathlib.LinearAlgebra.TensorProduct.Quotient

/-!
# The actual tensor fiber of an ideal

For every ideal `I` in the three-variable polynomial ring, the genuine tensor
product `(A / (x,y,z)) ⊗[A] I` is identified with the actual generator quotient
`I / (x,y,z)I`, as a `K`-vector space. This is a tensor-product statement and
does not identify a derived functor.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial
open scoped TensorProduct

variable {K : Type*} [Field K]

/-- The genuine tensor product of the residue ring with the ideal as an
`A`-module, with its standard restricted `K`-scalar action. -/
abbrev GeneratorTensorFiber (I : Ideal (MvPolynomial (Fin 3) K)) :=
  (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)) ⊗[MvPolynomial (Fin 3) K] I

/-- The scalar-product denominator in the standard tensor quotient is the
pullback of the actual ideal product, after restricting scalars to `K`. -/
theorem generator_smul_top_restrictScalars
    (I : Ideal (MvPolynomial (Fin 3) K)) :
    (variableIdeal (K := K) • (⊤ : Submodule (MvPolynomial (Fin 3) K) I)).restrictScalars K =
      idealSubmodule I (variableIdeal * I) := by
  ext p
  exact Submodule.mem_smul_top_iff _ I p

/-- The standard tensor/quotient equivalence, followed by restriction of
scalars and the independently proved identification of the denominator. -/
def generatorTensorEquiv (I : Ideal (MvPolynomial (Fin 3) K)) :
    GeneratorTensorFiber I ≃ₗ[K] GeneratorQuotient I :=
  ((TensorProduct.quotTensorEquivQuotSMul I (variableIdeal (K := K))).restrictScalars K).trans
    ((Submodule.Quotient.restrictScalarsEquiv K
      (variableIdeal (K := K) • (⊤ : Submodule (MvPolynomial (Fin 3) K) I))).symm.trans
      (Submodule.quotEquivOfEq _ _ (generator_smul_top_restrictScalars I)))

@[simp] theorem generatorTensorEquiv_mk_tmul
    (I : Ideal (MvPolynomial (Fin 3) K))
    (q : MvPolynomial (Fin 3) K) (p : I) :
    generatorTensorEquiv I
      (Ideal.Quotient.mk (variableIdeal (K := K)) q ⊗ₜ[MvPolynomial (Fin 3) K] p) =
      Submodule.Quotient.mk (q • p) := by
  change (Submodule.quotEquivOfEq _ _ (generator_smul_top_restrictScalars I))
    ((Submodule.Quotient.restrictScalarsEquiv K
      (variableIdeal (K := K) • (⊤ : Submodule (MvPolynomial (Fin 3) K) I))).symm
      ((TensorProduct.quotTensorEquivQuotSMul I (variableIdeal (K := K)))
        (Ideal.Quotient.mk (variableIdeal (K := K)) q ⊗ₜ[MvPolynomial (Fin 3) K] p))) = _
  rw [TensorProduct.quotTensorEquivQuotSMul_mk_tmul]
  rfl

@[simp] theorem generatorTensorEquiv_one_tmul
    (I : Ideal (MvPolynomial (Fin 3) K)) (p : I) :
    generatorTensorEquiv I (1 ⊗ₜ[MvPolynomial (Fin 3) K] p) =
      Submodule.Quotient.mk p := by
  simpa using generatorTensorEquiv_mk_tmul I 1 p

@[simp] theorem generatorTensorEquiv_symm_mk
    (I : Ideal (MvPolynomial (Fin 3) K)) (p : I) :
    (generatorTensorEquiv I).symm (Submodule.Quotient.mk p) =
      1 ⊗ₜ[MvPolynomial (Fin 3) K] p := by
  apply (generatorTensorEquiv I).injective
  simp

#print axioms generator_smul_top_restrictScalars
#print axioms generatorTensorEquiv
#print axioms generatorTensorEquiv_mk_tmul
#print axioms generatorTensorEquiv_one_tmul
#print axioms generatorTensorEquiv_symm_mk

end

end WidthBounds.MonomialInterface
