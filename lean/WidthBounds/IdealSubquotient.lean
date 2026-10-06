import Mathlib.LinearAlgebra.Isomorphisms
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.Algebra.MvPolynomial.CommRing
import Mathlib.RingTheory.MvPolynomial.Basic

/-!
# A quotient of an actual polynomial ideal by an actual subideal

`IdealSubquotient I J` quotients the vector space `I` by the inverse image of
the actual ideal `J`. Thus it is `I / (I ∩ J)` without a containment hypothesis,
and is `I / J` when `J ≤ I`. The denominator does not depend on a linear map.

An identification with another vector space requires an explicit kernel
criterion on `I` and explicit surjectivity from `I`. This file does not prove
those hypotheses for a particular ideal product or coefficient map.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

variable {K : Type*} [Field K]
variable {V : Type*} [AddCommGroup V] [Module K V]

/-- The actual ideal `J`, pulled back to the vector space underlying `I`. -/
def idealSubmodule (I J : Ideal (MvPolynomial (Fin 3) K)) :
    Submodule K (I.restrictScalars K) :=
  Submodule.comap (I.restrictScalars K).subtype (J.restrictScalars K)

@[simp] theorem mem_idealSubmodule (I J : Ideal (MvPolynomial (Fin 3) K))
    (p : I.restrictScalars K) : p ∈ idealSubmodule I J ↔ p.1 ∈ J := Iff.rfl

/-- The vector space `I / (I ∩ J)`, in particular `I / J` when `J ≤ I`. -/
abbrev IdealSubquotient (I J : Ideal (MvPolynomial (Fin 3) K)) : Type _ :=
  ↥(I.restrictScalars K) ⧸ idealSubmodule I J

/-- Restrict an ambient polynomial linear map to the actual ideal `I`. -/
def restrictedIdealMap (I : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V) : (I.restrictScalars K) →ₗ[K] V :=
  F.comp (I.restrictScalars K).subtype

@[simp] theorem restrictedIdealMap_apply (I : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V) (p : I.restrictScalars K) :
    restrictedIdealMap I F p = F p.1 := rfl

/-- An ambient kernel criterion on `I` identifies the restricted kernel with
the pullback of the actual ideal `J`. -/
theorem ker_restrictedIdealMap (I J : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hKer : ∀ p, p ∈ I → (F p = 0 ↔ p ∈ J)) :
    LinearMap.ker (restrictedIdealMap I F) = idealSubmodule I J := by
  ext p
  rw [LinearMap.mem_ker, restrictedIdealMap_apply, mem_idealSubmodule]
  exact hKer p.1 p.2

theorem restrictedIdealMap_surjective (I : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hSurj : ∀ v, ∃ p, p ∈ I ∧ F p = v) :
    Function.Surjective (restrictedIdealMap I F) := by
  intro v
  obtain ⟨p, hp, hF⟩ := hSurj v
  exact ⟨⟨p, hp⟩, hF⟩

/-- The first isomorphism theorem with an independently defined denominator. -/
def idealSubquotientEquiv (I J : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hKer : ∀ p, p ∈ I → (F p = 0 ↔ p ∈ J))
    (hSurj : ∀ v, ∃ p, p ∈ I ∧ F p = v) :
    IdealSubquotient I J ≃ₗ[K] V :=
  (Submodule.quotEquivOfEq (idealSubmodule I J)
    (LinearMap.ker (restrictedIdealMap I F))
    (ker_restrictedIdealMap I J F hKer).symm).trans
    ((restrictedIdealMap I F).quotKerEquivOfSurjective
      (restrictedIdealMap_surjective I F hSurj))

@[simp] theorem idealSubquotientEquiv_mk (I J : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hKer : ∀ p, p ∈ I → (F p = 0 ↔ p ∈ J))
    (hSurj : ∀ v, ∃ p, p ∈ I ∧ F p = v) (p : I.restrictScalars K) :
    idealSubquotientEquiv I J F hKer hSurj (Submodule.Quotient.mk p) = F p.1 := by
  rfl

/-- The quotient and target have equal `finrank`, without a finiteness hypothesis. -/
theorem finrank_idealSubquotient (I J : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hKer : ∀ p, p ∈ I → (F p = 0 ↔ p ∈ J))
    (hSurj : ∀ v, ∃ p, p ∈ I ∧ F p = v) :
    Module.finrank K (IdealSubquotient I J) = Module.finrank K V :=
  (idealSubquotientEquiv I J F hKer hSurj).finrank_eq

/-- Finite dimensionality of the target transfers to the actual ideal subquotient. -/
theorem finite_idealSubquotient (I J : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hKer : ∀ p, p ∈ I → (F p = 0 ↔ p ∈ J))
    (hSurj : ∀ v, ∃ p, p ∈ I ∧ F p = v) [Module.Finite K V] :
    Module.Finite K (IdealSubquotient I J) :=
  (idealSubquotientEquiv I J F hKer hSurj).symm.finiteDimensional

#print axioms ker_restrictedIdealMap
#print axioms idealSubquotientEquiv
#print axioms idealSubquotientEquiv_mk
#print axioms finrank_idealSubquotient
#print axioms finite_idealSubquotient

end

end WidthBounds.MonomialInterface
