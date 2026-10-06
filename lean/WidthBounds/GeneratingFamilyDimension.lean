import Mathlib.Algebra.MvPolynomial.CommRing
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.RingTheory.Ideal.Span

/-!
# Dimension bounds from arbitrary polynomial ideal generators

A linear map on a polynomial ideal whose polynomial action factors through the
constant coefficient sends any ideal generating family to a vector-space
spanning family, provided that its restriction to the ideal is surjective.
No monomial, homogeneity, or independence condition is placed on the generators.
-/

namespace WidthBounds.MonomialInterface

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- An ideal generating family spans the target of a surjective linear map on
the ideal when multiplication acts through constant coefficients. -/
theorem span_image_eq_top_of_ideal_generators
    (I : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hMul : ∀ q p, p ∈ I → F (q * p) = MvPolynomial.constantCoeff q • F p)
    (hSurj : ∀ v : V, ∃ p, p ∈ I ∧ F p = v)
    (P : Finset (MvPolynomial (Fin 3) K))
    (hSpan : Ideal.span (P : Set (MvPolynomial (Fin 3) K)) = I) :
    Submodule.span K (F '' (P : Set (MvPolynomial (Fin 3) K))) = ⊤ := by
  let W := Submodule.span K (F '' (P : Set (MvPolynomial (Fin 3) K)))
  have hImage : ∀ p, p ∈ I → F p ∈ W := by
    intro p hp
    rw [← hSpan] at hp
    change p ∈ Submodule.span (MvPolynomial (Fin 3) K)
      (P : Set (MvPolynomial (Fin 3) K)) at hp
    induction hp using Submodule.span_induction with
    | mem p hp =>
        exact Submodule.subset_span ⟨p, hp, rfl⟩
    | zero =>
        simpa only [map_zero] using W.zero_mem
    | add p q _ _ hp hq =>
        simpa only [map_add] using W.add_mem hp hq
    | smul q p hp ih =>
        have hpI : p ∈ I := by
          change p ∈ Ideal.span (P : Set (MvPolynomial (Fin 3) K)) at hp
          rwa [hSpan] at hp
        change F (q * p) ∈ W
        rw [hMul q p hpI]
        exact W.smul_mem _ ih
  apply top_unique
  intro v _
  obtain ⟨p, hp, rfl⟩ := hSurj v
  exact hImage p hp

/-- The dimension of the target is a lower bound on the cardinality of every
finite polynomial generating set. Images of distinct generators may coincide. -/
theorem finrank_le_card_of_ideal_generators [Module.Finite K V]
    (I : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hMul : ∀ q p, p ∈ I → F (q * p) = MvPolynomial.constantCoeff q • F p)
    (hSurj : ∀ v : V, ∃ p, p ∈ I ∧ F p = v)
    (P : Finset (MvPolynomial (Fin 3) K))
    (hSpan : Ideal.span (P : Set (MvPolynomial (Fin 3) K)) = I) :
    Module.finrank K V ≤ P.card := by
  classical
  have hTop := span_image_eq_top_of_ideal_generators I F hMul hSurj P hSpan
  have hDim := finrank_span_finset_le_card (R := K) (P.image F)
  change Module.finrank K
    (Submodule.span K ((P.image F : Finset V) : Set V)) ≤ (P.image F).card at hDim
  rw [Finset.coe_image, hTop, finrank_top] at hDim
  exact hDim.trans Finset.card_image_le

end WidthBounds.MonomialInterface

#print axioms WidthBounds.MonomialInterface.span_image_eq_top_of_ideal_generators
#print axioms WidthBounds.MonomialInterface.finrank_le_card_of_ideal_generators
