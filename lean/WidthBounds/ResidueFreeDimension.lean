import WidthBounds.TorOneBounds
import WidthBounds.VariableResidue
import Mathlib.LinearAlgebra.TensorProduct.Basis
import Mathlib.LinearAlgebra.Dimension.Free

/-!
# The coefficient-field dimension of a finite free module's residue tensor

The object is the actual left residue tensor functor, restricted along the
coefficient inclusion. Free-basis tensor coordinates and the proved residue algebra
equivalence identify it with a finite coordinate space over the coefficient
field. No scalar action is transported from a desired dimension.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open CategoryTheory MvPolynomial Module
open scoped TensorProduct

variable {K : Type*} [Field K]

/-- The actual residue tensor, with scalars restricted along `K → K[x,y,z]`. -/
abbrev ResidueTensorK (M : ModuleCat (MvPolynomial (Fin 3) K)) : ModuleCat K :=
  (ModuleCat.restrictScalars (algebraMap K (MvPolynomial (Fin 3) K))).obj
    ((residueTensorFunctor (K := K)).obj M)

/-- Restriction of scalars agrees with the natural coefficient action on the
actual tensor product. -/
def residueTensorKNaturalEquiv (M : ModuleCat (MvPolynomial (Fin 3) K)) :
    ResidueTensorK M ≃ₗ[K]
      ((MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)) ⊗[MvPolynomial (Fin 3) K] M) :=
  restrictScalarsNaturalEquiv (K := K) (A := MvPolynomial (Fin 3) K)
    (M := (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)) ⊗[MvPolynomial (Fin 3) K] M)

/-- Coordinates for the actual residue tensor of any finite free module. -/
def residueTensorFreeCoordinates (M : ModuleCat (MvPolynomial (Fin 3) K))
    [Module.Free (MvPolynomial (Fin 3) K) M]
    [Module.Finite (MvPolynomial (Fin 3) K) M] :
    ResidueTensorK M ≃ₗ[K] (Module.Free.ChooseBasisIndex (MvPolynomial (Fin 3) K) M → K) := by
  classical
  exact (residueTensorKNaturalEquiv M).trans
    (((TensorProduct.equivFinsuppOfBasisRight
      (M := MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K))
      (Module.Free.chooseBasis (MvPolynomial (Fin 3) K) M)).restrictScalars K).trans
        ((Finsupp.linearEquivFunOnFinite K _ _).trans
          (LinearEquiv.piCongrRight fun _ => (variableResidueEquiv (K := K)).toLinearEquiv)))

/-- The residue tensor has actual finite dimension over the coefficient field. -/
theorem residueTensor_free_finite (M : ModuleCat (MvPolynomial (Fin 3) K))
    [Module.Free (MvPolynomial (Fin 3) K) M]
    [Module.Finite (MvPolynomial (Fin 3) K) M] :
    Module.Finite K (ResidueTensorK M) :=
  Module.Finite.equiv (residueTensorFreeCoordinates M).symm

/-- Its coefficient-field dimension equals the original module's free rank. -/
theorem finrank_residueTensor_free (M : ModuleCat (MvPolynomial (Fin 3) K))
    [Module.Free (MvPolynomial (Fin 3) K) M]
    [Module.Finite (MvPolynomial (Fin 3) K) M] :
    Module.finrank K (ResidueTensorK M) = Module.finrank (MvPolynomial (Fin 3) K) M := by
  calc
    Module.finrank K (ResidueTensorK M) =
        Module.finrank K (Module.Free.ChooseBasisIndex (MvPolynomial (Fin 3) K) M → K) :=
      (residueTensorFreeCoordinates M).finrank_eq
    _ = Fintype.card (Module.Free.ChooseBasisIndex (MvPolynomial (Fin 3) K) M) :=
      Module.finrank_fintype_fun_eq_card K
    _ = Module.finrank (MvPolynomial (Fin 3) K) M :=
      (Module.finrank_eq_card_chooseBasisIndex (MvPolynomial (Fin 3) K) M).symm

#print axioms residueTensorKNaturalEquiv
#print axioms residueTensorFreeCoordinates
#print axioms residueTensor_free_finite
#print axioms finrank_residueTensor_free

end

end WidthBounds.MonomialInterface
