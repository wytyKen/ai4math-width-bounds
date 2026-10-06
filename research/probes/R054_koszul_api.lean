import WidthBounds.TorOneBounds
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-! R054 interface probe only: no Koszul resolution or higher Tor computation is defined. -/

open CategoryTheory Limits

#check MvPolynomial.isRegular_X
#check ChainComplex.of
#check ShortComplex.moduleCatMk
#check ShortComplex.moduleCat_exact_iff_range_eq_ker
#check ShortComplex.moduleCatHomologyIso
#check ShortComplex.isZero_homology_of_isZero_X₂
#check HomologicalComplex.ExactAt.isZero_homology
#check Submodule.finrank_quotient_add_finrank
#check LinearMap.finrank_range_add_finrank_ker
#check Module.Finite.equiv

namespace R054KoszulAPI

variable {K : Type*} [Field K]

/-- A finite middle module gives finite actual categorical homology. -/
theorem finite_homology (S : ShortComplex (ModuleCat K))
    [Module.Finite K S.X₂] : Module.Finite K S.homology := by
  letI : Module.Finite K S.moduleCatLeftHomologyData.H := by
    change Module.Finite K (LinearMap.ker S.g.hom ⧸ LinearMap.range S.moduleCatToCycles)
    infer_instance
  exact Module.Finite.equiv S.moduleCatHomologyIso.toLinearEquiv.symm

/-- Local Euler decomposition, using the actual categorical homology.
This is a generic short-complex API check, not a Koszul result. -/
theorem local_finrank_decomposition (S : ShortComplex (ModuleCat K))
    [Module.Finite K S.X₂] :
    Module.finrank K S.homology +
      Module.finrank K (LinearMap.range S.moduleCatToCycles) +
      Module.finrank K (LinearMap.range S.g.hom) = Module.finrank K S.X₂ := by
  have hH := S.moduleCatHomologyIso.toLinearEquiv.finrank_eq
  have hQ := Submodule.finrank_quotient_add_finrank (LinearMap.range S.moduleCatToCycles)
  have hN := LinearMap.finrank_range_add_finrank_ker S.g.hom
  change Module.finrank K S.homology =
    Module.finrank K (LinearMap.ker S.g.hom ⧸ LinearMap.range S.moduleCatToCycles) at hH
  omega

/-- The same decomposition with the usual incoming boundary range. -/
theorem local_finrank_decomposition_ambient (S : ShortComplex (ModuleCat K))
    [Module.Finite K S.X₁] [Module.Finite K S.X₂] :
    Module.finrank K S.homology +
      Module.finrank K (LinearMap.range S.f.hom) +
      Module.finrank K (LinearMap.range S.g.hom) = Module.finrank K S.X₂ := by
  have h := local_finrank_decomposition S
  have hf := LinearMap.finrank_range_add_finrank_ker S.f.hom
  have hc := LinearMap.finrank_range_add_finrank_ker S.moduleCatToCycles
  have hk : LinearMap.ker S.moduleCatToCycles = LinearMap.ker S.f.hom :=
    LinearMap.ker_codRestrict _ _ _
  rw [hk] at hc
  omega

/-- Vanishing comes directly from a zero chain term and gives a zero object. -/
theorem homology_zero_of_term_zero (C : ChainComplex (ModuleCat K) ℕ)
    (n : ℕ) (h : IsZero (C.X n)) : IsZero (C.homology n) := by
  exact (C.sc n).isZero_homology_of_isZero_X₂ h

#print axioms finite_homology
#print axioms local_finrank_decomposition
#print axioms local_finrank_decomposition_ambient
#print axioms homology_zero_of_term_zero

end R054KoszulAPI
