import WidthBounds.TorOneBounds
import Mathlib.LinearAlgebra.Finsupp.LinearCombination

/-!
# An actual finite free monomial presentation

For a finite exponent set generating an actual ideal, the first differential
is its explicit linear-combination map. Its kernel is the actual first syzygy
module; no freeness of that kernel or later resolution terms is asserted.
-/

noncomputable section

namespace WidthBounds.MonomialPresentation

open CategoryTheory CategoryTheory.Limits
open WidthBounds.MonomialInterface

variable (K : Type*) [Field K]

abbrev Ring := MvPolynomial (Fin 3) K

/-- The finite free module on the supplied exponent set. -/
abbrev FreeModule (E : Finset (Fin 3 →₀ ℕ)) := E → Ring K

variable {K} (E : Finset (Fin 3 →₀ ℕ))

/-- The actual first differential, with coefficient-one monomial columns. -/
def differential : FreeModule K E →ₗ[Ring K] Ring K :=
  Fintype.linearCombination (Ring K) (fun e : E => MvPolynomial.monomial e.val (1 : K))

theorem differential_apply (c : FreeModule K E) :
    differential E c = ∑ e : E, c e * MvPolynomial.monomial e.val (1 : K) := rfl

@[simp]
theorem differential_single (e : E) (a : Ring K) :
    differential E (Pi.single e a) = a * MvPolynomial.monomial e.val (1 : K) := by
  classical
  exact Fintype.linearCombination_apply_single _ _ _ _

/-- The standard coordinate basis of the actual free module. -/
def freeBasis : Module.Basis E (Ring K) (FreeModule K E) := Pi.basisFun (Ring K) E

@[simp]
theorem differential_freeBasis (e : E) :
    differential E (freeBasis E e) = MvPolynomial.monomial e.val (1 : K) := by
  classical
  simp [freeBasis, Pi.basisFun_apply]

theorem freeModule_free : Module.Free (Ring K) (FreeModule K E) := by infer_instance
theorem freeModule_finite : Module.Finite (Ring K) (FreeModule K E) := by infer_instance
theorem freeModule_projective : Projective (ModuleCat.of (Ring K) (FreeModule K E)) := by
  infer_instance

theorem ring_free : Module.Free (Ring K) (Ring K) := by infer_instance
theorem ring_finite : Module.Finite (Ring K) (Ring K) := by infer_instance
theorem ring_projective : Projective (ModuleCat.of (Ring K) (Ring K)) := by infer_instance

def differentialMap : ModuleCat.of (Ring K) (FreeModule K E) ⟶
    ModuleCat.of (Ring K) (Ring K) := ModuleCat.ofHom (differential E)

@[simp]
theorem differentialMap_hom : (differentialMap (K := K) E).hom = differential E := rfl

theorem range_differential :
    LinearMap.range (differential (K := K) E) =
      Ideal.span (exponentMonomials (R := K) E : Set (Ring K)) := by
  rw [differential, Fintype.range_linearCombination, coe_exponentMonomials]
  congr 1
  ext p
  constructor
  · rintro ⟨e, rfl⟩
    exact ⟨e.val, e.property, rfl⟩
  · rintro ⟨e, he, rfl⟩
    exact ⟨⟨e, he⟩, rfl⟩

variable (I : Ideal (Ring K))
  (hSpan : Ideal.span (exponentMonomials (R := K) E : Set (Ring K)) = I)

include hSpan

theorem range_differential_eq_ideal : LinearMap.range (differential E) = I :=
  (range_differential E).trans hSpan

theorem range_differential_eq_ker_quotient :
    LinearMap.range (differential E) = LinearMap.ker I.mkQ := by
  rw [Submodule.ker_mkQ, range_differential_eq_ideal E I hSpan]

theorem differential_mem_ideal (c : FreeModule K E) : differential E c ∈ I := by
  rw [← range_differential_eq_ideal E I hSpan]
  exact LinearMap.mem_range_self _ c

/-- Restrict the actual differential to its image ideal. -/
def differentialIntoIdeal : FreeModule K E →ₗ[Ring K] I :=
  (differential E).codRestrict I (differential_mem_ideal E I hSpan)

@[simp]
theorem differentialIntoIdeal_coe (c : FreeModule K E) :
    (differentialIntoIdeal E I hSpan c : Ring K) = differential E c := rfl

theorem subtype_comp_differentialIntoIdeal :
    I.subtype.comp (differentialIntoIdeal E I hSpan) = differential E := rfl

theorem differentialIntoIdeal_surjective :
    Function.Surjective (differentialIntoIdeal E I hSpan) := by
  intro x
  have hx : x.val ∈ LinearMap.range (differential E) := by
    rw [range_differential_eq_ideal E I hSpan]
    exact x.property
  obtain ⟨c, hc⟩ := hx
  exact ⟨c, Subtype.ext hc⟩

def mapToIdeal : ModuleCat.of (Ring K) (FreeModule K E) ⟶ ModuleCat.of (Ring K) I :=
  ModuleCat.ofHom (differentialIntoIdeal E I hSpan)

@[simp]
theorem mapToIdeal_hom : (mapToIdeal E I hSpan).hom = differentialIntoIdeal E I hSpan := rfl

instance mapToIdeal_epi : Epi (mapToIdeal E I hSpan) :=
  (ModuleCat.epi_iff_surjective _).2 (differentialIntoIdeal_surjective E I hSpan)

@[reassoc (attr := simp)]
theorem mapToIdeal_comp_inclusion :
    mapToIdeal E I hSpan ≫ idealInclusion I = differentialMap (K := K) E := rfl

@[simp]
theorem differentialMap_comp_quotient : differentialMap (K := K) E ≫ idealQuotientMap I = 0 := by
  rw [← mapToIdeal_comp_inclusion E I hSpan, Category.assoc,
    idealInclusion_comp_quotient, comp_zero]

/-- The finite free presentation ending in the actual quotient. -/
def presentation : ShortComplex (ModuleCat (Ring K)) :=
  ShortComplex.mk (differentialMap (K := K) E) (idealQuotientMap I)
    (differentialMap_comp_quotient E I hSpan)

theorem presentation_exact : (presentation E I hSpan).Exact := by
  apply (ShortComplex.moduleCat_exact_iff_range_eq_ker _).2
  exact range_differential_eq_ker_quotient E I hSpan

instance presentation_epi : Epi (presentation E I hSpan).g := by
  dsimp [presentation]
  infer_instance

omit hSpan in
/-- The actual first syzygy submodule, with no freeness assertion. -/
def firstSyzygies : Submodule (Ring K) (FreeModule K E) :=
  LinearMap.ker (differential E)

omit hSpan in
def firstSyzygiesInclusion : ModuleCat.of (Ring K) (firstSyzygies (K := K) E) ⟶
    ModuleCat.of (Ring K) (FreeModule K E) :=
  ModuleCat.ofHom (firstSyzygies (K := K) E).subtype

omit hSpan in
@[simp]
theorem firstSyzygiesInclusion_comp_differential :
    firstSyzygiesInclusion (K := K) E ≫ differentialMap (K := K) E = 0 := by
  apply ModuleCat.hom_ext
  exact LinearMap.comp_ker_subtype _

omit hSpan in
/-- The library categorical kernel identifies with the actual syzygy module. -/
def firstSyzygiesKernelIso : kernel (differentialMap (K := K) E) ≅
    ModuleCat.of (Ring K) (firstSyzygies (K := K) E) :=
  ModuleCat.kernelIsoKer (differentialMap (K := K) E)

omit hSpan in
@[reassoc (attr := simp)]
theorem firstSyzygiesKernelIso_hom_inclusion :
    (firstSyzygiesKernelIso (K := K) E).hom ≫ firstSyzygiesInclusion (K := K) E =
      kernel.ι (differentialMap (K := K) E) :=
  ModuleCat.kernelIsoKer_hom_ker_subtype _

omit hSpan in
@[reassoc (attr := simp)]
theorem firstSyzygiesKernelIso_inv_kernel_ι :
    (firstSyzygiesKernelIso (K := K) E).inv ≫ kernel.ι (differentialMap (K := K) E) =
      firstSyzygiesInclusion (K := K) E :=
  ModuleCat.kernelIsoKer_inv_kernel_ι _

theorem ker_differentialIntoIdeal :
    LinearMap.ker (differentialIntoIdeal E I hSpan) = firstSyzygies (K := K) E :=
  LinearMap.ker_codRestrict _ _ _

/-- Restricting the codomain to the image preserves the concrete kernel. -/
def restrictedKernelEquiv : LinearMap.ker (differentialIntoIdeal E I hSpan) ≃ₗ[Ring K]
    firstSyzygies (K := K) E :=
  LinearEquiv.ofEq _ _ (ker_differentialIntoIdeal E I hSpan)

@[simp]
theorem restrictedKernelEquiv_coe (s : LinearMap.ker (differentialIntoIdeal E I hSpan)) :
    (restrictedKernelEquiv E I hSpan s : FreeModule K E) = s := rfl

/-- The standard kernel of the map onto the ideal is the same syzygy module. -/
def mapToIdealKernelIso : kernel (mapToIdeal E I hSpan) ≅
    ModuleCat.of (Ring K) (firstSyzygies (K := K) E) :=
  ModuleCat.kernelIsoKer (mapToIdeal E I hSpan) ≪≫
    (restrictedKernelEquiv E I hSpan).toModuleIso

@[reassoc (attr := simp)]
theorem mapToIdealKernelIso_hom_inclusion :
    (mapToIdealKernelIso E I hSpan).hom ≫ firstSyzygiesInclusion (K := K) E =
      kernel.ι (mapToIdeal E I hSpan) := by
  change (ModuleCat.kernelIsoKer (mapToIdeal E I hSpan)).hom ≫
    (restrictedKernelEquiv E I hSpan).toModuleIso.hom ≫ firstSyzygiesInclusion (K := K) E = _
  have h : (restrictedKernelEquiv E I hSpan).toModuleIso.hom ≫
      firstSyzygiesInclusion (K := K) E =
      ModuleCat.ofHom (LinearMap.ker (differentialIntoIdeal E I hSpan)).subtype := rfl
  rw [h]
  exact ModuleCat.kernelIsoKer_hom_ker_subtype _

/-- The actual differential lifts to the standard kernel of the quotient. -/
def mapToQuotientKernel : ModuleCat.of (Ring K) (FreeModule K E) ⟶
    kernel (idealQuotientMap I) :=
  kernel.lift (idealQuotientMap I) (differentialMap (K := K) E)
    (differentialMap_comp_quotient E I hSpan)

@[reassoc (attr := simp)]
theorem mapToQuotientKernel_comp_ι :
    mapToQuotientKernel E I hSpan ≫ kernel.ι (idealQuotientMap I) = differentialMap (K := K) E :=
  kernel.lift_ι _ _ _

/-- The quotient-kernel identification used for Tor agrees with the actual
finite monomial map to the ideal, not merely with an unrelated cover. -/
@[reassoc (attr := simp)]
theorem mapToQuotientKernel_comp_idealQuotientKernelIso :
    mapToQuotientKernel E I hSpan ≫ (idealQuotientKernelIso I).hom =
      mapToIdeal E I hSpan := by
  apply (cancel_mono (idealInclusion I)).1
  simp only [Category.assoc, idealQuotientKernelIso_hom_inclusion,
    mapToQuotientKernel_comp_ι, mapToIdeal_comp_inclusion]

theorem mapToQuotientKernel_eq_mapToIdeal_comp :
    mapToQuotientKernel E I hSpan = mapToIdeal E I hSpan ≫
      (idealQuotientKernelIso I).inv := by
  rw [← mapToQuotientKernel_comp_idealQuotientKernelIso E I hSpan]
  simp only [Category.assoc, Iso.hom_inv_id, Category.comp_id]

#print axioms differential_single
#print axioms range_differential_eq_ideal
#print axioms presentation_exact
#print axioms differentialIntoIdeal_surjective
#print axioms firstSyzygiesKernelIso_hom_inclusion
#print axioms mapToIdealKernelIso_hom_inclusion
#print axioms mapToQuotientKernel_comp_idealQuotientKernelIso

end WidthBounds.MonomialPresentation


