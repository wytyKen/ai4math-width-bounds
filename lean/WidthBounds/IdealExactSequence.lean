import Mathlib.Algebra.Category.ModuleCat.Abelian
import Mathlib.Algebra.Category.ModuleCat.Projective
import Mathlib.Algebra.Homology.ShortComplex.ModuleCat
import Mathlib.RingTheory.Ideal.Quotient.Operations

/-!
# The actual short exact sequence of an ideal and its quotient

For an ideal `I` of a commutative ring `A`, this file packages the actual
inclusion and quotient maps as a short exact sequence in `ModuleCat A`.
The middle object is projective. No Tor identification is asserted here.
-/

universe u

namespace WidthBounds

open CategoryTheory CategoryTheory.Limits

variable {A : Type u} [CommRing A]

/-- The actual inclusion of the ideal as an `A`-module. -/
def idealInclusion (I : Ideal A) : ModuleCat.of A I ⟶ ModuleCat.of A A :=
  ModuleCat.ofHom I.subtype

/-- The actual linear quotient map to the ideal quotient. -/
def idealQuotientMap (I : Ideal A) :
    ModuleCat.of A A ⟶ ModuleCat.of A (A ⧸ I) :=
  ModuleCat.ofHom I.mkQ

@[simp]
theorem idealInclusion_apply (I : Ideal A) (x : I) : idealInclusion I x = x.val := rfl

@[simp]
theorem idealQuotientMap_apply (I : Ideal A) (x : A) :
    idealQuotientMap I x = Ideal.Quotient.mk I x := rfl

@[simp]
theorem idealInclusion_hom (I : Ideal A) : (idealInclusion I).hom = I.subtype := rfl

@[simp]
theorem idealQuotientMap_hom (I : Ideal A) : (idealQuotientMap I).hom = I.mkQ := rfl

instance idealInclusion_mono (I : Ideal A) : Mono (idealInclusion I) := by
  apply (ModuleCat.mono_iff_injective _).2
  exact Subtype.val_injective

instance idealQuotientMap_epi (I : Ideal A) : Epi (idealQuotientMap I) := by
  apply (ModuleCat.epi_iff_surjective _).2
  exact Ideal.Quotient.mk_surjective

@[simp]
theorem idealInclusion_comp_quotient (I : Ideal A) :
    idealInclusion I ≫ idealQuotientMap I = 0 := by
  apply ModuleCat.hom_ext
  apply LinearMap.ext
  intro x
  exact (Ideal.Quotient.eq_zero_iff_mem).2 x.property

/-- The complex `I → A → A/I` uses the actual inclusion and quotient maps. -/
def idealQuotientShortComplex (I : Ideal A) : ShortComplex (ModuleCat A) :=
  ShortComplex.mk (idealInclusion I) (idealQuotientMap I) (idealInclusion_comp_quotient I)

@[simp]
theorem idealQuotientShortComplex_f (I : Ideal A) :
    (idealQuotientShortComplex I).f = idealInclusion I := rfl

@[simp]
theorem idealQuotientShortComplex_g (I : Ideal A) :
    (idealQuotientShortComplex I).g = idealQuotientMap I := rfl

theorem idealQuotientShortComplex_exact (I : Ideal A) :
    (idealQuotientShortComplex I).Exact := by
  apply (ShortComplex.moduleCat_exact_iff_range_eq_ker _).2
  change LinearMap.range I.subtype = LinearMap.ker I.mkQ
  rw [Submodule.range_subtype, Submodule.ker_mkQ]

/-- The actual ideal inclusion and quotient form a short exact sequence. -/
theorem idealQuotientShortExact (I : Ideal A) :
    (idealQuotientShortComplex I).ShortExact where
  exact := idealQuotientShortComplex_exact I
  mono_f := idealInclusion_mono I
  epi_g := idealQuotientMap_epi I

/-- The standard categorical kernel of the quotient map is isomorphic to the
actual ideal. This is induced by the kernel universal property of the actual
short exact sequence, rather than by redefining the categorical kernel. -/
noncomputable def idealQuotientKernelIso (I : Ideal A) :
    kernel (idealQuotientMap I) ≅ ModuleCat.of A I :=
  limit.isoLimitCone
    ⟨KernelFork.ofι (idealInclusion I) (idealInclusion_comp_quotient I),
      (idealQuotientShortExact I).fIsKernel⟩

/-- The kernel identification preserves the actual map into the ring. -/
@[reassoc (attr := simp)]
theorem idealQuotientKernelIso_hom_inclusion (I : Ideal A) :
    (idealQuotientKernelIso I).hom ≫ idealInclusion I =
      kernel.ι (idealQuotientMap I) :=
  limit.isoLimitCone_hom_π
    ⟨KernelFork.ofι (idealInclusion I) (idealInclusion_comp_quotient I),
      (idealQuotientShortExact I).fIsKernel⟩ WalkingParallelPair.zero

/-- The inverse kernel identification preserves the inclusion as well. -/
@[reassoc (attr := simp)]
theorem idealQuotientKernelIso_inv_kernel_ι (I : Ideal A) :
    (idealQuotientKernelIso I).inv ≫ kernel.ι (idealQuotientMap I) =
      idealInclusion I :=
  limit.isoLimitCone_inv_π
    ⟨KernelFork.ofι (idealInclusion I) (idealInclusion_comp_quotient I),
      (idealQuotientShortExact I).fIsKernel⟩ WalkingParallelPair.zero

/-- The middle object is the free rank-one `A`-module, hence projective. -/
theorem ringModuleProjective (A : Type u) [CommRing A] :
    CategoryTheory.Projective (ModuleCat.of A A) := by
  infer_instance

#print axioms idealQuotientShortExact
#print axioms idealQuotientKernelIso
#print axioms idealQuotientKernelIso_hom_inclusion
#print axioms idealQuotientKernelIso_inv_kernel_ι
#print axioms ringModuleProjective

end WidthBounds
