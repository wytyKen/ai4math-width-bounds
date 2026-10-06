import WidthBounds.MonomialFirstSyzygies
import WidthBounds.ChosenResolution

/-!
# A finite three-step projective resolution constructor

This module packages four projective terms after all exactness and injectivity
data have been supplied. It does not prove those hypotheses for any concrete
lex quotient. The augmentation is the actual ideal quotient map, and the terms
from degree four onwards are the categorical zero object.
-/

noncomputable section

namespace WidthBounds.FiniteThreeResolution

open CategoryTheory CategoryTheory.Limits
open scoped ZeroObject

universe u
variable {A : Type u} [CommRing A]
variable (F₁ F₂ F₃ : ModuleCat A)

def objects : ℕ → ModuleCat A
  | 0 => ModuleCat.of A A
  | 1 => F₁
  | 2 => F₂
  | 3 => F₃
  | _ + 4 => 0

variable (d₁ : F₁ ⟶ ModuleCat.of A A) (d₂ : F₂ ⟶ F₁) (d₃ : F₃ ⟶ F₂)

def maps : ∀ n, objects F₁ F₂ F₃ (n + 1) ⟶ objects F₁ F₂ F₃ n
  | 0 => d₁
  | 1 => d₂
  | 2 => d₃
  | 3 => 0
  | _ + 4 => 0

variable (h₂₁ : d₂ ≫ d₁ = 0) (h₃₂ : d₃ ≫ d₂ = 0)

include h₂₁ h₃₂ in
theorem maps_comp (n : ℕ) :
    maps F₁ F₂ F₃ d₁ d₂ d₃ (n + 1) ≫ maps F₁ F₂ F₃ d₁ d₂ d₃ n = 0 := by
  rcases n with _ | _ | _ | _ | n
  · exact h₂₁
  · exact h₃₂
  · simp [maps]
  · simp [maps]
  · simp [maps]

def complex : ChainComplex (ModuleCat A) ℕ :=
  ChainComplex.of (objects F₁ F₂ F₃) (maps F₁ F₂ F₃ d₁ d₂ d₃)
    (maps_comp F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂)

@[simp] theorem complex_X_zero :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X 0 = ModuleCat.of A A := rfl

@[simp] theorem complex_X_one :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X 1 = F₁ := rfl

@[simp] theorem complex_X_two :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X 2 = F₂ := rfl

@[simp] theorem complex_X_three :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X 3 = F₃ := rfl

@[simp] theorem complex_X_zero_tail (n : ℕ) :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X (n + 4) = 0 := rfl

theorem complex_d_succ (n : ℕ) :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).d (n + 1) n =
      maps F₁ F₂ F₃ d₁ d₂ d₃ n :=
  ChainComplex.of_d _ _ _ n

@[simp] theorem complex_d_one_zero :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).d 1 0 = d₁ :=
  complex_d_succ F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ 0

@[simp] theorem complex_d_two_one :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).d 2 1 = d₂ :=
  complex_d_succ F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ 1

@[simp] theorem complex_d_three_two :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).d 3 2 = d₃ :=
  complex_d_succ F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ 2

section MappedDifferentials

variable {D : Type*} [Category D] [HasZeroMorphisms D]
    (F : ModuleCat A ⥤ D) [F.PreservesZeroMorphisms]
    (hd₁ : F.map d₁ = 0) (hd₂ : F.map d₂ = 0) (hd₃ : F.map d₃ = 0)

include hd₁ hd₂ hd₃ in
/-- Zero images of the three supplied maps imply zero images of all adjacent maps.
Any additive functor between preadditive categories preserves zero morphisms. -/
theorem map_maps_eq_zero (n : ℕ) :
    F.map (maps F₁ F₂ F₃ d₁ d₂ d₃ n) = 0 := by
  rcases n with _ | _ | _ | _ | n
  · exact hd₁
  · exact hd₂
  · exact hd₃
  · exact F.map_zero _ _
  · exact F.map_zero _ _

include hd₁ hd₂ hd₃ in
/-- Every differential maps to zero, including all nonadjacent indices. -/
theorem map_complex_d_eq_zero (i j : ℕ) :
    F.map ((complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).d i j) = 0 := by
  by_cases h : i = j + 1
  · subst i
    rw [complex_d_succ]
    exact map_maps_eq_zero F₁ F₂ F₃ d₁ d₂ d₃ F hd₁ hd₂ hd₃ j
  · rw [show (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).d i j = 0 from
      ChainComplex.of_d_ne _ _ _ h, F.map_zero]

end MappedDifferentials

instance complex_free [Module.Free A F₁] [Module.Free A F₂] [Module.Free A F₃] (n : ℕ) :
    Module.Free A ((complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X n) := by
  rcases n with _ | _ | _ | _ | n
  · change Module.Free A A
    infer_instance
  · change Module.Free A F₁
    infer_instance
  · change Module.Free A F₂
    infer_instance
  · change Module.Free A F₃
    infer_instance
  · change Module.Free A (0 : ModuleCat A)
    letI : Subsingleton (0 : ModuleCat A) := ModuleCat.subsingleton_of_isZero (isZero_zero _)
    infer_instance

instance complex_finite [Module.Finite A F₁] [Module.Finite A F₂] [Module.Finite A F₃]
    (n : ℕ) : Module.Finite A ((complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X n) := by
  rcases n with _ | _ | _ | _ | n
  · change Module.Finite A A
    infer_instance
  · change Module.Finite A F₁
    infer_instance
  · change Module.Finite A F₂
    infer_instance
  · change Module.Finite A F₃
    infer_instance
  · change Module.Finite A (0 : ModuleCat A)
    letI : Subsingleton (0 : ModuleCat A) := ModuleCat.subsingleton_of_isZero (isZero_zero _)
    infer_instance

variable [Projective F₁] [Projective F₂] [Projective F₃]

instance complex_projective (n : ℕ) :
    Projective ((complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).X n) := by
  rcases n with _ | _ | _ | _ | n
  · change Projective (ModuleCat.of A A)
    infer_instance
  · change Projective F₁
    infer_instance
  · change Projective F₂
    infer_instance
  · change Projective F₃
    infer_instance
  · apply IsZero.projective
    exact isZero_zero _

variable (hex₁ : (ShortComplex.mk d₂ d₁ h₂₁).Exact)
    (hex₂ : (ShortComplex.mk d₃ d₂ h₃₂).Exact) [Mono d₃]

include hex₁ hex₂ in
omit [Projective F₁] [Projective F₂] [Projective F₃] in
theorem complex_exactAt_succ (n : ℕ) :
    (complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂).ExactAt (n + 1) := by
  rw [HomologicalComplex.exactAt_iff' _ (n + 1 + 1) (n + 1) n (by simp) (by simp)]
  rcases n with _ | _ | _ | n
  · simpa [complex, HomologicalComplex.sc', HomologicalComplex.shortComplexFunctor',
      ChainComplex.of_d, maps, objects] using hex₁
  · simpa [complex, HomologicalComplex.sc', HomologicalComplex.shortComplexFunctor',
      ChainComplex.of_d, maps, objects] using hex₂
  · apply (ShortComplex.exact_iff_mono _ ?_).mpr
    · change Mono d₃
      infer_instance
    · exact ChainComplex.of_d (objects F₁ F₂ F₃) (maps F₁ F₂ F₃ d₁ d₂ d₃)
        (maps_comp F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂) 3
  · apply ShortComplex.exact_of_isZero_X₂
    exact isZero_zero _

variable (I : Ideal A) (h₁₀ : d₁ ≫ idealQuotientMap I = 0)
    (hex₀ : (ShortComplex.mk d₁ (idealQuotientMap I) h₁₀).Exact)

def resolution : ProjectiveResolution (ModuleCat.of A (A ⧸ I)) where
  complex := complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂
  π := (ChainComplex.toSingle₀Equiv _ _).symm ⟨idealQuotientMap I, by
    simpa [complex, ChainComplex.of_d, maps] using h₁₀⟩
  quasiIso := ⟨fun n => by
    cases n
    · rw [ChainComplex.quasiIsoAt₀_iff, ShortComplex.quasiIso_iff_of_zeros']
      · refine (ShortComplex.exact_and_epi_g_iff_of_iso ?_).2 ⟨hex₀, by infer_instance⟩
        exact ShortComplex.isoMk (Iso.refl _) (Iso.refl _) (Iso.refl _)
          (by
            simp only [Iso.refl_hom, Category.comp_id, Category.id_comp]
            exact (ChainComplex.of_d (objects F₁ F₂ F₃) (maps F₁ F₂ F₃ d₁ d₂ d₃)
              (maps_comp F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂) 0).symm)
          (by
            simp
            exact (ChainComplex.toSingle₀Equiv_symm_apply_f_zero
              (C := complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂) (idealQuotientMap I) _).symm)
      all_goals rfl
    · rw [quasiIsoAt_iff_exactAt']
      · exact complex_exactAt_succ F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ _
      · apply ChainComplex.exactAt_succ_single_obj⟩

instance resolution_free [Module.Free A F₁] [Module.Free A F₂] [Module.Free A F₃] (n : ℕ) :
    Module.Free A
      ((resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X n) :=
  complex_free F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ n

instance resolution_finite [Module.Finite A F₁] [Module.Finite A F₂] [Module.Finite A F₃]
    (n : ℕ) : Module.Finite A
      ((resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X n) :=
  complex_finite F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ n

@[simp] theorem resolution_X_zero :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X 0 =
      ModuleCat.of A A := rfl

@[simp] theorem resolution_X_one :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X 1 = F₁ := rfl

@[simp] theorem resolution_X_two :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X 2 = F₂ := rfl

@[simp] theorem resolution_X_three :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X 3 = F₃ := rfl

@[simp] theorem resolution_X_zero_tail (n : ℕ) :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X (n + 4) = 0 := rfl

theorem resolution_X_isZero_tail (n : ℕ) :
    IsZero ((resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.X
      (n + 4)) := isZero_zero _

@[simp] theorem resolution_d_one_zero :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.d 1 0 = d₁ :=
  complex_d_one_zero F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂

@[simp] theorem resolution_d_two_one :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.d 2 1 = d₂ :=
  complex_d_two_one F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂

@[simp] theorem resolution_d_three_two :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.d 3 2 = d₃ :=
  complex_d_three_two F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂

@[simp] theorem resolution_π_f_zero :
    (resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).π.f 0 =
      idealQuotientMap I := by
  exact ChainComplex.toSingle₀Equiv_symm_apply_f_zero _ _

theorem map_resolution_d_eq_zero {D : Type*} [Category D] [HasZeroMorphisms D]
    (F : ModuleCat A ⥤ D) [F.PreservesZeroMorphisms]
    (hd₁ : F.map d₁ = 0) (hd₂ : F.map d₂ = 0) (hd₃ : F.map d₃ = 0) (i j : ℕ) :
    F.map ((resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀).complex.d i j) = 0 :=
  map_complex_d_eq_zero F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ F hd₁ hd₂ hd₃ i j

#print axioms complex_exactAt_succ
#print axioms resolution
#print axioms resolution_π_f_zero
#print axioms map_resolution_d_eq_zero
#print axioms resolution_free
#print axioms resolution_finite

end WidthBounds.FiniteThreeResolution
