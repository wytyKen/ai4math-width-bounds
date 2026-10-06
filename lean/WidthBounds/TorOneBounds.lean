import WidthBounds.TorOneBridge
import Mathlib.Algebra.Category.ModuleCat.ChangeOfRings

/-!
# Coefficient-field structure on the standard Tor-one object

Scalar restriction is along the actual algebra map from the coefficient field
to the polynomial ring. No scalar action is transported from a desired answer.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open CategoryTheory MvPolynomial Module Finset
open scoped TensorProduct

variable {K : Type*} [Field K]

/-- The standard Tor object, restricted along the actual coefficient inclusion. -/
abbrev IdealQuotientTorOneK (I : Ideal (MvPolynomial (Fin 3) K)) : ModuleCat K :=
  (ModuleCat.restrictScalars (algebraMap K (MvPolynomial (Fin 3) K))).obj
    (IdealQuotientTorOne I)

/-- Categorical scalar restriction agrees with an existing compatible scalar
action. The underlying map is the identity, with compatibility proved explicitly. -/
def restrictScalarsNaturalEquiv {A M : Type*} [CommRing A] [Algebra K A]
    [AddCommGroup M] [Module A M] [Module K M] [IsScalarTower K A M] :
    ((ModuleCat.restrictScalars (algebraMap K A)).obj (ModuleCat.of A M)) ≃ₗ[K] M where
  toFun := fun x => x
  invFun := fun x => x
  left_inv := fun _ => rfl
  right_inv := fun _ => rfl
  map_add' := fun _ _ => rfl
  map_smul' := by
    intro r x
    exact IsScalarTower.algebraMap_smul (M := M) A r x

/-- The standard Tor-one object and the actual tensor fiber have the same
coefficient-field structure, by restriction of their proved `A`-module iso. -/
def idealQuotientTorOneEquivTensor
    (I : Ideal (MvPolynomial (Fin 3) K)) (hI : I ≤ variableIdeal) :
    IdealQuotientTorOneK I ≃ₗ[K] GeneratorTensorFiber I :=
  (((ModuleCat.restrictScalars (algebraMap K (MvPolynomial (Fin 3) K))).mapIso
    (idealQuotientTorOneIsoTensor I hI)).toLinearEquiv).trans
      (restrictScalarsNaturalEquiv (K := K) (A := MvPolynomial (Fin 3) K)
        (M := GeneratorTensorFiber I))

/-- Minimal monomial coordinates for a standard, not redefined, Tor object. -/
def torOneCoordinates
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (hI : monomialIdeal (R := K) S ≤ variableIdeal) :
    IdealQuotientTorOneK (monomialIdeal (R := K) S) ≃ₗ[K] (↥E → K) :=
  (idealQuotientTorOneEquivTensor _ hI).trans
    (generatorTensorCoordinates S hUp E hMin hSpan)

/-- A basis of standard Tor one, transported from the actual minimal
generator tensors through the derived-functor comparison. -/
def torOneBasis
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (hI : monomialIdeal (R := K) S ≤ variableIdeal) :
    Basis ↥E K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) :=
  (generatorTensorBasis S hUp E hMin hSpan).map
    (idealQuotientTorOneEquivTensor _ hI).symm

/-- The basis corresponds to `1 tensor g`, for the original minimal monomials. -/
theorem torOneBasis_toTensor
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (hI : monomialIdeal (R := K) S ≤ variableIdeal) (e : ↥E) :
    idealQuotientTorOneEquivTensor _ hI (torOneBasis S hUp E hMin hSpan hI e) =
      (1 : MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)) ⊗ₜ[MvPolynomial (Fin 3) K]
        (⟨monomial e.val (1 : K), (hMin e.val e.property).1⟩ : monomialIdeal (R := K) S) := by
  simp only [torOneBasis, Basis.map_apply, LinearEquiv.apply_symm_apply]
  exact generatorTensorBasis_apply S hUp E hMin hSpan e

theorem finrank_torOne_eq_tensor
    (I : Ideal (MvPolynomial (Fin 3) K)) (hI : I ≤ variableIdeal) :
    Module.finrank K (IdealQuotientTorOneK I) = Module.finrank K (GeneratorTensorFiber I) :=
  (idealQuotientTorOneEquivTensor I hI).finrank_eq

theorem torOne_finite
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (hI : monomialIdeal (R := K) S ≤ variableIdeal) :
    Module.Finite K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) :=
  Module.Finite.equiv (torOneCoordinates S hUp E hMin hSpan hI).symm

theorem finrank_torOne
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (hI : monomialIdeal (R := K) S ≤ variableIdeal) :
    Module.finrank K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) = E.card := by
  rw [finrank_torOne_eq_tensor _ hI]
  exact finrank_generatorTensor S hUp E hMin hSpan

theorem torOne_finrank_isLeast
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (E : Finset (Fin 3 →₀ ℕ))
    (hMin : ∀ e ∈ E, IsMinimalExponent (monomialIdeal (R := K) S) e)
    (hSpan : Ideal.span (exponentMonomials (R := K) E :
      Set (MvPolynomial (Fin 3) K)) = monomialIdeal S)
    (hI : monomialIdeal (R := K) S ≤ variableIdeal) :
    IsLeast (generatorCardinalities (monomialIdeal (R := K) S))
      (Module.finrank K (IdealQuotientTorOneK (monomialIdeal (R := K) S))) := by
  rw [finrank_torOne_eq_tensor _ hI]
  exact generatorTensor_finrank_isLeast S hUp E hMin hSpan

/-- Actual standard Tor-one dimension in the finite-colength lex model.
The order is `Tor_1^A(A/m,A/I)`, deriving the second factor as in mathlib.
No result for higher Tor or for the numerical-semigroup reduction is asserted. -/
theorem finiteColength_torOne_bounds
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ a : ℕ, 2 ≤ a ∧
      monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      Module.Finite K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) ∧
      Module.finrank K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      IsLeast (generatorCardinalities (monomialIdeal (R := K) S))
        (Module.finrank K (IdealQuotientTorOneK (monomialIdeal (R := K) S))) ∧
      Module.finrank K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) <
        (w + 1).choose 2 ∧
      (Module.finrank K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) : ℚ) ≤
        4 * (w : ℚ) - 1 + ((2 * w - 1 : ℕ) : ℚ) * Growth.harmonicQ (2 * w - 1) := by
  have hI := monomialIdeal_le_variableIdeal_of_x_standard S hUp hOne
  obtain ⟨a, ha, hx, hInitial, hFinite, hDim, hLeast, hStrict, hHarm⟩ :=
    finiteColength_generatorTensor_bounds S hUp hLex hOne hw hBudget
  letI := hFinite
  have hTorFinite : Module.Finite K (IdealQuotientTorOneK (monomialIdeal (R := K) S)) :=
    Module.Finite.equiv (idealQuotientTorOneEquivTensor _ hI).symm
  refine ⟨a, ha, hx, hInitial, hTorFinite, ?_, ?_, ?_, ?_⟩
  · rwa [finrank_torOne_eq_tensor _ hI]
  · rwa [finrank_torOne_eq_tensor _ hI]
  · rwa [finrank_torOne_eq_tensor _ hI]
  · rwa [finrank_torOne_eq_tensor _ hI]

#print axioms idealQuotientTorOneEquivTensor
#print axioms torOneBasis_toTensor
#print axioms finrank_torOne
#print axioms finiteColength_torOne_bounds

end

end WidthBounds.MonomialInterface
