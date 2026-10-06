import WidthBounds.TorOneBounds
import Mathlib.LinearAlgebra.Finsupp.LinearCombination

/-!
R054 interface probe only. No project root import depends on this file.
The conditional comparison below assumes a supplied projective resolution;
it does not construct a finite resolution or prove a higher Betti formula.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open WidthBounds.MonomialInterface

#check Finsupp.linearCombination
#check Finsupp.range_linearCombination
#check Fintype.linearCombination
#check CategoryTheory.ProjectiveResolution.isoLeftDerivedObj
#check CategoryTheory.ProjectiveResolution.exact₀
#check WidthBounds.MonomialInterface.monomialIdeal_exists_exact_minimal_exponents
#check WidthBounds.MonomialInterface.span_boundary_exponentMonomials
#check WidthBounds.MonomialInterface.monomial_mem_span_exponentMonomials_iff

namespace R054Probe

variable (K : Type) [Field K]

abbrev A := MvPolynomial (Fin 3) K

example (E : Finset (Fin 3 →₀ ℕ)) :
    Projective (ModuleCat.of (A K) (E → A K)) := by
  infer_instance

/-- Supplying a resolution of the second factor computes the standard Tor
object in every degree, with no factor exchange. This is only an API check. -/
def suppliedResolutionComputesTor (I : Ideal (A K))
    (P : ProjectiveResolution (ModuleCat.of (A K) (A K ⧸ I))) (n : ℕ) :
    ((CategoryTheory.Tor (ModuleCat (A K)) n).obj
      (ModuleCat.of (A K) (A K ⧸ variableIdeal (K := K)))).obj
        (ModuleCat.of (A K) (A K ⧸ I)) ≅
      ((residueTensorFunctor (K := K)).mapHomologicalComplex (ComplexShape.down ℕ)).obj
        P.complex |>.homology n :=
  P.isoLeftDerivedObj (residueTensorFunctor (K := K)) n

#print axioms suppliedResolutionComputesTor

end R054Probe
