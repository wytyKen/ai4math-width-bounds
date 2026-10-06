import WidthBounds.TorOneBridge

/-!
R069 supporting R054: a bounded API probe in the fixed library.
This file proves no higher Tor statement about a lex quotient.
The two small instances below use only the projectivity of the ring module
and right exactness of residue tensoring.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open WidthBounds.MonomialInterface

#check CategoryTheory.ProjectiveResolution
#check CategoryTheory.ProjectiveResolution.lift
#check CategoryTheory.ProjectiveResolution.lift_commutes
#check CategoryTheory.ProjectiveResolution.liftHomotopy
#check CategoryTheory.ProjectiveResolution.homotopyEquiv
#check CategoryTheory.ProjectiveResolution.isoLeftDerivedObj
#check CategoryTheory.ProjectiveResolution.isoLeftDerivedObj_hom_naturality
#check CategoryTheory.Functor.mapProjectiveResolution
#check CategoryTheory.NatTrans.leftDerived
#check CategoryTheory.Functor.leftDerivedZeroIsoSelf
#check CategoryTheory.Functor.isZero_leftDerived_obj_projective_succ
#check CategoryTheory.isZero_Tor_succ_of_projective
#check CategoryTheory.isZero_Tor'_succ_of_projective
#check WidthBounds.ChosenResolution.resolution
#check WidthBounds.DerivedKernel.isoLeftDerivedOne

namespace R054TorAuditProbe

variable (K : Type) [Field K]

abbrev A := MvPolynomial (Fin 3) K

/-- Complete small instance: the derived argument is the free rank-one A-module.
This does not assert that A/I is projective or has a finite resolution. -/
theorem torWithRingIsZero (n : ℕ) :
    IsZero (((CategoryTheory.Tor (ModuleCat (A K)) (n + 1)).obj
      (ModuleCat.of (A K) (A K ⧸ variableIdeal (K := K)))).obj
        (ModuleCat.of (A K) (A K))) :=
  CategoryTheory.isZero_Tor_succ_of_projective (ModuleCat (A K)) _ _ n

/-- Complete small instance: H0 comparison has precisely the existing
right-exactness assumption supplied by residueTensorFunctor. -/
def residueDerivedZeroIso :
    (residueTensorFunctor (K := K)).leftDerived 0 ≅ residueTensorFunctor (K := K) :=
  (residueTensorFunctor (K := K)).leftDerivedZeroIsoSelf

/-- Resolution comparison applies to two resolutions of the same quotient.
It does not compare resolutions of the two different Tor arguments. -/
def sameQuotientResolutionComparison (I : Ideal (A K))
    (P Q : ProjectiveResolution (ModuleCat.of (A K) (A K ⧸ I))) :
    HomotopyEquiv P.complex Q.complex :=
  ProjectiveResolution.homotopyEquiv P Q

#print axioms torWithRingIsZero
#print axioms residueDerivedZeroIso
#print axioms sameQuotientResolutionComparison

end R054TorAuditProbe
