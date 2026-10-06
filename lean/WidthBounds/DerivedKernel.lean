import WidthBounds.ChosenResolution

/-!
# First left-derived object when the kernel inclusion maps to zero

The chosen resolution begins with a specified projective epimorphism. Its next
two projectives present the actual kernel, so a right exact functor sends their
cokernel to the image of that kernel. If the kernel inclusion maps to zero, this
cokernel computes degree-one homology, hence the standard first left-derived
object.
-/

noncomputable section

universe v u v' u'

namespace WidthBounds.DerivedKernel

open CategoryTheory CategoryTheory.Category CategoryTheory.Limits

variable {C : Type u} [Category.{v} C] [Abelian C] [EnoughProjectives C]
  {P X : C} (f : P ⟶ X)

lemma differential_comp_cover :
    Projective.d (Projective.d f) ≫ Projective.π (kernel f) = 0 := by
  apply (cancel_mono (kernel.ι f)).1
  simpa only [Projective.d, assoc, zero_comp] using
    (show Projective.d (Projective.d f) ≫ Projective.d f = 0 by simp)

/-- The first two syzygy projectives present the actual kernel of `f`. -/
def presentation : ShortComplex C :=
  ShortComplex.mk (Projective.d (Projective.d f)) (Projective.π (kernel f))
    (differential_comp_cover f)

lemma presentation_exact : (presentation f).Exact := by
  let α : presentation f ⟶
      ShortComplex.mk (Projective.d (Projective.d f)) (Projective.d f) (by simp) :=
    { τ₁ := 𝟙 _
      τ₂ := 𝟙 _
      τ₃ := kernel.ι f }
  have : Epi α.τ₁ := by dsimp [α]; infer_instance
  have : IsIso α.τ₂ := by dsimp [α]; infer_instance
  have : Mono α.τ₃ := by dsimp [α]; infer_instance
  rw [ShortComplex.exact_iff_of_epi_of_isIso_of_mono α]
  exact CategoryTheory.exact_d_f (Projective.d f)

instance : Epi (presentation f).g := by
  dsimp [presentation]
  infer_instance

/-- The actual kernel is a cokernel of the second differential. -/
def kernelIsCokernel :
    IsColimit (CokernelCofork.ofπ (Projective.π (kernel f))
      (differential_comp_cover f)) :=
  (presentation_exact f).gIsCokernel

variable {D : Type u'} [Category.{v'} D] [Abelian D]
  (F : C ⥤ D) [F.Additive] [PreservesFiniteColimits F]

omit [F.Additive] [PreservesFiniteColimits F] in
lemma map_d_zero (h : F.map (kernel.ι f) = 0) : F.map (Projective.d f) = 0 := by
  simp only [Projective.d, F.map_comp, h, comp_zero]

/-- The homology of the mapped specified resolution is the image of its kernel. -/
def homologyOneIso (h : F.map (kernel.ι f) = 0) :
    ((F.mapHomologicalComplex (ComplexShape.down ℕ)).obj
      (ChosenResolution.complex f)).homology 1 ≅ F.obj (kernel f) := by
  let K := (F.mapHomologicalComplex (ComplexShape.down ℕ)).obj
    (ChosenResolution.complex f)
  refine K.homologyIsoSc' 2 1 0 (by simp) (by simp) ≪≫ ?_
  let S : ShortComplex D :=
    ShortComplex.mk (F.map (Projective.d (Projective.d f)))
      (F.map (Projective.d f)) (by simp only [← F.map_comp]; simp)
  let e : K.sc' 2 1 0 ≅ S :=
    ShortComplex.isoMk (Iso.refl _) (Iso.refl _) (Iso.refl _)
      (by simp [K, S])
      (by simp [K, S])
  refine ShortComplex.homologyMapIso e ≪≫ ?_
  let c := (CokernelCofork.ofπ (Projective.π (kernel f))
    (differential_comp_cover f)).map F
  exact (ShortComplex.HomologyData.ofIsColimitCokernelCofork S (map_d_zero f F h) c
    (CokernelCofork.mapIsColimit _ (kernelIsCokernel f) F)).left.homologyIso

/-- Compute the standard first left-derived object from a projective epi whose
kernel inclusion becomes zero under the additive right exact functor. -/
def isoLeftDerivedOne [Projective P] [Epi f]
    (h : F.map (kernel.ι f) = 0) :
    (F.leftDerived 1).obj X ≅ F.obj (kernel f) :=
  ChosenResolution.isoLeftDerivedObj f F 1 ≪≫ homologyOneIso f F h

#print axioms presentation_exact
#print axioms kernelIsCokernel
#print axioms homologyOneIso
#print axioms isoLeftDerivedOne

end WidthBounds.DerivedKernel
