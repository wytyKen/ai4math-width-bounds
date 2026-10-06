import Mathlib.CategoryTheory.Abelian.LeftDerived

/-!
# Projective resolutions starting with a specified projective epimorphism

This is the construction of `CategoryTheory.ProjectiveResolution.of`, with its
degree-zero projective cover replaced by a specified `f : P ⟶ X`.
It supplies a standard mathlib projective resolution and a standard left-derived
functor computation; it makes no identification of that homology with a tensor
fiber or with a concrete presentation of Tor.
-/

noncomputable section

universe v u

namespace WidthBounds.ChosenResolution

open CategoryTheory CategoryTheory.Category CategoryTheory.Limits

variable {C : Type u} [Category.{v} C] [Abelian C] [EnoughProjectives C]
  {P X : C} (f : P ⟶ X)

/-- Iterate projective covers of kernels, starting with the specified morphism. -/
def complex : ChainComplex C ℕ :=
  ChainComplex.mk' P (Projective.syzygies f) (Projective.d f)
    (fun g => ⟨_, Projective.d g, by simp⟩)

@[simp] lemma complex_X_zero : (complex f).X 0 = P := rfl

@[simp] lemma complex_X_one : (complex f).X 1 = Projective.syzygies f := rfl

@[simp] lemma complex_d_one_zero : (complex f).d 1 0 = Projective.d f := by
  simp [complex]

@[simp] lemma complex_d_two_one :
    (complex f).d 2 1 = Projective.d (Projective.d f) := by
  simp [complex, ChainComplex.mk']

/-- The iterative kernel-cover construction is exact in every positive degree. -/
lemma complex_exactAt_succ (n : ℕ) : (complex f).ExactAt (n + 1) := by
  rw [HomologicalComplex.exactAt_iff' _ (n + 1 + 1) (n + 1) n (by simp) (by simp)]
  dsimp [complex, HomologicalComplex.sc', HomologicalComplex.shortComplexFunctor',
    ChainComplex.mk', ChainComplex.mk]
  simp only [ChainComplex.of_d]
  match n with
  | 0 => apply CategoryTheory.exact_d_f
  | n + 1 => apply CategoryTheory.exact_d_f

instance [Projective P] (n : ℕ) : Projective ((complex f).X n) := by
  obtain (_ | _ | _ | n) := n
  · change Projective P
    infer_instance
  all_goals apply Projective.projective_over

/-- A standard projective resolution whose first augmentation is the given epi. -/
def resolution [Projective P] [Epi f] : ProjectiveResolution X where
  complex := complex f
  π := (ChainComplex.toSingle₀Equiv _ _).symm ⟨f, by
    rw [complex_d_one_zero, assoc, kernel.condition, comp_zero]⟩
  quasiIso := ⟨fun n => by
    cases n
    · rw [ChainComplex.quasiIsoAt₀_iff, ShortComplex.quasiIso_iff_of_zeros']
      · dsimp
        refine (ShortComplex.exact_and_epi_g_iff_of_iso ?_).2
          ⟨CategoryTheory.exact_d_f f, by dsimp; infer_instance⟩
        exact ShortComplex.isoMk (Iso.refl _) (Iso.refl _) (Iso.refl _)
          (by simp [complex]) (by
            simp
            exact (ChainComplex.toSingle₀Equiv_symm_apply_f_zero (C := complex f) f _).symm)
      all_goals rfl
    · rw [quasiIsoAt_iff_exactAt']
      · apply complex_exactAt_succ
      · apply ChainComplex.exactAt_succ_single_obj⟩

@[simp] lemma resolution_X_zero [Projective P] [Epi f] :
    (resolution f).complex.X 0 = P := rfl

@[simp] lemma resolution_X_one [Projective P] [Epi f] :
    (resolution f).complex.X 1 = Projective.syzygies f := rfl

@[simp] lemma resolution_π_f_zero [Projective P] [Epi f] :
    (resolution f).π.f 0 = f := by
  simp [resolution]
  exact ChainComplex.toSingle₀Equiv_symm_apply_f_zero _ _

@[simp] lemma resolution_d_one_zero [Projective P] [Epi f] :
    (resolution f).complex.d 1 0 = Projective.d f := complex_d_one_zero f

/-- Compute a standard left-derived object using this specified augmentation. -/
def isoLeftDerivedObj [Projective P] [Epi f]
    {D : Type*} [Category D] [Abelian D] (F : C ⥤ D) [F.Additive] (n : ℕ) :
    (F.leftDerived n).obj X ≅
      (HomologicalComplex.homologyFunctor D (ComplexShape.down ℕ) n).obj
        ((F.mapHomologicalComplex (ComplexShape.down ℕ)).obj (complex f)) :=
  (resolution f).isoLeftDerivedObj F n

#print axioms complex_exactAt_succ
#print axioms resolution
#print axioms resolution_π_f_zero
#print axioms isoLeftDerivedObj

end WidthBounds.ChosenResolution
