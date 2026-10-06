import WidthBounds.GeneratorTensorBounds
import Mathlib.CategoryTheory.Monoidal.Tor
import Mathlib.Algebra.Category.ModuleCat.Projective
import Mathlib.Algebra.Category.ModuleCat.Monoidal.Basic
import Mathlib.Algebra.Category.ModuleCat.Abelian
import Mathlib.Algebra.Category.ModuleCat.Monoidal.Closed
import WidthBounds.IdealExactSequence
import WidthBounds.DerivedKernel

/-!
# Low-degree Tor interface: the residue tensor of an ideal inclusion

This file first proves the actual tensor inclusion map is zero when `I` is
contained in the variable ideal. This lemma alone does not identify Tor one.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial
open CategoryTheory CategoryTheory.Limits CategoryTheory.MonoidalCategory
open scoped TensorProduct

variable {K : Type*} [Field K]

/-- The actual functor tensoring on the left with the residue ring.
Its second argument is the one derived in mathlib's standard `Tor`. -/
abbrev residueTensorFunctor : ModuleCat (MvPolynomial (Fin 3) K) ⥤
    ModuleCat (MvPolynomial (Fin 3) K) :=
  (tensoringLeft (ModuleCat (MvPolynomial (Fin 3) K))).obj
    (ModuleCat.of (MvPolynomial (Fin 3) K)
      (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)))

instance residueTensorFunctor_preservesColimits :
    PreservesColimits (residueTensorFunctor (K := K)) := by
  change PreservesColimits (tensorLeft
    (ModuleCat.of (MvPolynomial (Fin 3) K)
      (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K))))
  infer_instance

/-- The standard mathlib Tor-one object, derived in the second factor.
This is only a name for the existing derived functor, not a definition by
generator number or by a replacement complex. -/
abbrev IdealQuotientTorOne (I : Ideal (MvPolynomial (Fin 3) K)) :
    ModuleCat (MvPolynomial (Fin 3) K) :=
  ((CategoryTheory.Tor (ModuleCat (MvPolynomial (Fin 3) K)) 1).obj
    (ModuleCat.of (MvPolynomial (Fin 3) K)
      (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)))).obj
        (ModuleCat.of (MvPolynomial (Fin 3) K) (MvPolynomial (Fin 3) K ⧸ I))

/-- The actual ideal inclusion tensored on the left by the residue ring. -/
def residueTensorInclusion (I : Ideal (MvPolynomial (Fin 3) K)) :
    GeneratorTensorFiber I →ₗ[MvPolynomial (Fin 3) K]
      ((MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)) ⊗[MvPolynomial (Fin 3) K]
        MvPolynomial (Fin 3) K) :=
  I.subtype.lTensor (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K))

theorem residueTensorInclusion_eq_zero
    (I : Ideal (MvPolynomial (Fin 3) K)) (hI : I ≤ variableIdeal) :
    residueTensorInclusion I = 0 := by
  apply TensorProduct.ext'
  intro q p
  apply (TensorProduct.rid (MvPolynomial (Fin 3) K)
    (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K))).injective
  change (TensorProduct.rid (MvPolynomial (Fin 3) K)
    (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)))
      (q ⊗ₜ[MvPolynomial (Fin 3) K] p.val) =
    (TensorProduct.rid (MvPolynomial (Fin 3) K)
      (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K))) 0
  rw [TensorProduct.rid_tmul, LinearEquiv.map_zero]
  obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective q
  change p.val • Ideal.Quotient.mk (variableIdeal (K := K)) r = 0
  change Ideal.Quotient.mk (variableIdeal (K := K)) (p.val * r) = 0
  apply Ideal.Quotient.eq_zero_iff_mem.mpr
  exact (variableIdeal (K := K)).mul_mem_right r (hI p.property)

/-- The established monomial hypotheses supply the necessary containment. -/
theorem monomial_residueTensorInclusion_eq_zero
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S)
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0) :
    residueTensorInclusion (monomialIdeal (R := K) S) = 0 :=
  residueTensorInclusion_eq_zero _ (monomialIdeal_le_variableIdeal_of_x_standard S hUp hOne)

/-- Hence the kernel of the actual tensored inclusion is the entire fiber.
The remaining derived-functor step must still identify Tor with this kernel. -/
theorem ker_residueTensorInclusion
    (I : Ideal (MvPolynomial (Fin 3) K)) (hI : I ≤ variableIdeal) :
    LinearMap.ker (residueTensorInclusion I) = ⊤ := by
  rw [residueTensorInclusion_eq_zero I hI, LinearMap.ker_zero]

/-- The categorical tensor functor sends the actual ideal inclusion to zero. -/
theorem residueTensorFunctor_map_inclusion_eq_zero
    (I : Ideal (MvPolynomial (Fin 3) K)) (hI : I ≤ variableIdeal) :
    (residueTensorFunctor (K := K)).map (WidthBounds.idealInclusion I) = 0 := by
  apply ModuleCat.hom_ext
  change residueTensorInclusion I = 0
  exact residueTensorInclusion_eq_zero I hI

/-- The standard categorical kernel inclusion also maps to zero, using its
proved identification with the actual ideal inclusion. -/
theorem residueTensorFunctor_map_kernel_eq_zero
    (I : Ideal (MvPolynomial (Fin 3) K)) (hI : I ≤ variableIdeal) :
    (residueTensorFunctor (K := K)).map
      (kernel.ι (WidthBounds.idealQuotientMap I)) = 0 := by
  rw [← WidthBounds.idealQuotientKernelIso_hom_inclusion I,
    Functor.map_comp, residueTensorFunctor_map_inclusion_eq_zero I hI, comp_zero]

/-- The standard mathlib Tor-one object is the actual residue tensor fiber
when the ideal is contained in the variable ideal. The second factor is the
derived argument; no balancing or interchange of Tor factors is used. -/
def idealQuotientTorOneIsoTensor
    (I : Ideal (MvPolynomial (Fin 3) K)) (hI : I ≤ variableIdeal) :
    IdealQuotientTorOne I ≅
      ModuleCat.of (MvPolynomial (Fin 3) K) (GeneratorTensorFiber I) := by
  change ((residueTensorFunctor (K := K)).leftDerived 1).obj
      (ModuleCat.of (MvPolynomial (Fin 3) K) (MvPolynomial (Fin 3) K ⧸ I)) ≅
    (residueTensorFunctor (K := K)).obj (ModuleCat.of (MvPolynomial (Fin 3) K) I)
  exact DerivedKernel.isoLeftDerivedOne (WidthBounds.idealQuotientMap I)
    (residueTensorFunctor (K := K)) (residueTensorFunctor_map_kernel_eq_zero I hI) ≪≫
      (residueTensorFunctor (K := K)).mapIso (WidthBounds.idealQuotientKernelIso I)

#print axioms residueTensorInclusion_eq_zero
#print axioms monomial_residueTensorInclusion_eq_zero
#print axioms ker_residueTensorInclusion
#print axioms residueTensorFunctor_map_kernel_eq_zero
#print axioms idealQuotientTorOneIsoTensor

end

end WidthBounds.MonomialInterface
