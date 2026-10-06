import WidthBounds.MonomialInterface
import Mathlib.LinearAlgebra.Isomorphisms
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.RingTheory.MvPolynomial.Basic
import Mathlib.RingTheory.MvPolynomial.Homogeneous
import Mathlib.RingTheory.Ideal.Quotient.Operations

/-!
# Standard monomials in the quotient by a monomial ideal

The quotient is the actual ideal quotient of `MvPolynomial (Fin 3) K`.
Coefficient restriction has kernel exactly the ideal, by the support criterion
in `MonomialInterface`. Thus standard monomials form a basis; this fact is not
an input hypothesis. No Betti-number or numerical-semigroup reduction is claimed.
-/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial Module

variable {K : Type*} [Field K]

/-- Coefficients indexed by the standard exponents, i.e. the complement of `S`. -/
def standardCoeffs (S : Set (Fin 3 →₀ ℕ)) :
    MvPolynomial (Fin 3) K →ₗ[K] (↥(Sᶜ) →₀ K) :=
  Finsupp.lsubtypeDomain Sᶜ

@[simp] theorem standardCoeffs_apply (S : Set (Fin 3 →₀ ℕ))
    (p : MvPolynomial (Fin 3) K) (e : ↥(Sᶜ)) :
    standardCoeffs S p e = coeff e.1 p := rfl

/-- Restriction is onto: extend a finitely supported standard coefficient
family by zero on the nonstandard exponents. -/
theorem standardCoeffs_surjective (S : Set (Fin 3 →₀ ℕ)) :
    Function.Surjective (standardCoeffs (K := K) S) := by
  classical
  intro f
  refine ⟨f.extendDomain, ?_⟩
  exact Finsupp.subtypeDomain_extendDomain f

/-- The kernel is proved to be the actual monomial ideal, viewed as a
`K`-submodule. Upward closure is the only condition on `S`. -/
theorem ker_standardCoeffs (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) :
    LinearMap.ker (standardCoeffs (K := K) S) =
      (monomialIdeal (R := K) S).restrictScalars K := by
  ext p
  rw [LinearMap.mem_ker]
  change standardCoeffs S p = 0 ↔ p ∈ monomialIdeal S
  rw [mem_monomialIdeal_iff_support S hUp]
  constructor
  · intro h e he
    by_contra hnot
    have hz := DFunLike.congr_fun h (⟨e, hnot⟩ : ↥(Sᶜ))
    exact (mem_support_iff.mp he) hz
  · intro h
    ext e
    change coeff e.1 p = 0
    by_contra hz
    exact e.2 (h e.1 (mem_support_iff.mpr hz))

/-- The actual ideal quotient has the standard coefficient space as its
underlying vector space. -/
def quotientStandardEquiv (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) :
    (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S) ≃ₗ[K] (↥(Sᶜ) →₀ K) :=
  (Submodule.quotEquivOfEq
    ((monomialIdeal (R := K) S).restrictScalars K)
    (LinearMap.ker (standardCoeffs (K := K) S))
    (ker_standardCoeffs (K := K) S hUp).symm).trans
    ((standardCoeffs (K := K) S).quotKerEquivOfSurjective
      (standardCoeffs_surjective (K := K) S))

@[simp] theorem quotientStandardEquiv_mk (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (p : MvPolynomial (Fin 3) K) :
    quotientStandardEquiv (K := K) S hUp
      (Ideal.Quotient.mk (monomialIdeal (R := K) S) p) =
      standardCoeffs S p := by
  rfl

/-- A standard monomial is sent to its unit coordinate. -/
@[simp] theorem standardCoeffs_monomial (S : Set (Fin 3 →₀ ℕ))
    (e : ↥(Sᶜ)) (c : K) :
    standardCoeffs S (monomial e.1 c) = Finsupp.single e c := by
  classical
  ext d
  simp only [standardCoeffs_apply, coeff_monomial, Finsupp.single_apply]
  congr 1
  exact propext Subtype.val_inj

/-- The standard monomials form a basis of the actual monomial-ideal quotient. -/
def standardMonomialBasis (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) :
    Basis ↥(Sᶜ) K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S) :=
  Basis.ofRepr (quotientStandardEquiv S hUp)

@[simp] theorem standardMonomialBasis_apply (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (e : ↥(Sᶜ)) :
    standardMonomialBasis (K := K) S hUp e =
      Ideal.Quotient.mk (monomialIdeal (R := K) S) (monomial e.1 1) := by
  apply (quotientStandardEquiv (K := K) S hUp).injective
  change (standardMonomialBasis (K := K) S hUp).repr
    (standardMonomialBasis (K := K) S hUp e) = _
  rw [Basis.repr_self, quotientStandardEquiv_mk, standardCoeffs_monomial]

/-- Any finite standard exponent slice gives a linearly independent family
of genuine quotient monomials. -/
theorem standardMonomials_linearIndependent (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (T : Finset (Fin 3 →₀ ℕ))
    (hT : ∀ e ∈ T, e ∉ S) :
    LinearIndependent K (fun e : T =>
      Ideal.Quotient.mk (monomialIdeal (R := K) S) (monomial e.1 1)) := by
  let f : T → ↥(Sᶜ) := fun e => ⟨e.1, hT e.1 e.2⟩
  have hf : Function.Injective f := by
    intro a b h
    apply Subtype.ext
    exact congrArg (fun e : ↥(Sᶜ) => e.1) h
  simpa only [Function.comp_def, standardMonomialBasis_apply, f] using
    (standardMonomialBasis (K := K) S hUp).linearIndependent.comp f hf

/-- The span of a finite standard exponent slice has dimension its exact
cardinality; no finite-dimensionality assumption on the entire quotient is used. -/
theorem finrank_standardMonomialSpan (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (T : Finset (Fin 3 →₀ ℕ))
    (hT : ∀ e ∈ T, e ∉ S) :
    Module.finrank K (Submodule.span K (Set.range (fun e : T =>
      Ideal.Quotient.mk (monomialIdeal (R := K) S) (monomial e.1 1)))) = T.card := by
  simpa using finrank_span_eq_card
    (standardMonomials_linearIndependent (K := K) S hUp T hT)

@[simp] theorem exponent_degree (i j k : ℕ) :
    (exponent i j k).degree = i + j + k := by
  simp [exponent, Finsupp.degree_add]

/-- The actual degree-`d` subspace in the ideal quotient: the image of the
standard mathlib homogeneous polynomial submodule. -/
def quotientHomogeneous (S : Set (Fin 3 →₀ ℕ)) (d : ℕ) :
    Submodule K (MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S) :=
  (homogeneousSubmodule (Fin 3) K d).map
    (Ideal.Quotient.mkₐ K (monomialIdeal (R := K) S)).toLinearMap

/-- The quotient monomial indexed by the existing combinatorial degree slice. -/
def quotientDegreeMonomial (S : Set (Fin 3 →₀ ℕ)) (d : ℕ)
    (ij : LexCounting.standard3 (standard (monomialIdeal (R := K) S)) d) :
    MvPolynomial (Fin 3) K ⧸ monomialIdeal (R := K) S :=
  Ideal.Quotient.mk (monomialIdeal (R := K) S)
    (monomial3 ij.1.1 ij.1.2 (d - ij.1.1 - ij.1.2))

theorem quotientDegreeMonomial_linearIndependent (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (d : ℕ) :
    LinearIndependent K (quotientDegreeMonomial (K := K) S d) := by
  let f : LexCounting.standard3 (standard (monomialIdeal (R := K) S)) d → ↥(Sᶜ) :=
    fun ij => ⟨exponent ij.1.1 ij.1.2 (d - ij.1.1 - ij.1.2),
      (standard_monomialIdeal_iff S hUp _ _ _).mp
        (LexCounting.mem_standard3.mp ij.2).2⟩
  have hf : Function.Injective f := by
    intro a b h
    apply Subtype.ext
    apply Prod.ext
    · have hc := congrArg (fun e : ↥(Sᶜ) => e.1 0) h
      simpa only [f, exponent_zero] using hc
    · have hc := congrArg (fun e : ↥(Sᶜ) => e.1 1) h
      simpa only [f, exponent_one] using hc
  simpa only [Function.comp_def, standardMonomialBasis_apply,
    quotientDegreeMonomial, f, monomial3] using
    (standardMonomialBasis (K := K) S hUp).linearIndependent.comp f hf

theorem finrank_quotientDegreeMonomialSpan (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (d : ℕ) :
    Module.finrank K (Submodule.span K
      (Set.range (quotientDegreeMonomial (K := K) S d))) =
      LexCounting.hilbert3 (standard (monomialIdeal (R := K) S)) d := by
  simpa only [Fintype.card_coe, LexCounting.hilbert3] using
    finrank_span_eq_card (quotientDegreeMonomial_linearIndependent (K := K) S hUp d)

/-- All homogeneous polynomials map into the span of standard monomials of
the same degree, and each such monomial comes from a homogeneous polynomial. -/
theorem quotientHomogeneous_eq_span (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (d : ℕ) :
    quotientHomogeneous (K := K) S d =
      Submodule.span K (Set.range (quotientDegreeMonomial (K := K) S d)) := by
  classical
  apply le_antisymm
  · rintro q hq
    obtain ⟨p, hp, rfl⟩ := Submodule.mem_map.mp hq
    change p.IsHomogeneous d at hp
    have hsum : (Ideal.Quotient.mkₐ K (monomialIdeal (R := K) S)).toLinearMap p =
        ∑ e ∈ p.support,
          (Ideal.Quotient.mkₐ K (monomialIdeal (R := K) S)).toLinearMap
            (monomial e (coeff e p)) := by
      rw [← map_sum, p.support_sum_monomial_coeff]
    rw [hsum]
    apply Submodule.sum_mem
    intro e he
    have hdeg : e.degree = d := by
      by_contra hd
      exact (mem_support_iff.mp he) (hp.coeff_eq_zero hd)
    have hcoords : e 0 + e 1 + e 2 = d := by
      calc
        e 0 + e 1 + e 2 = (exponent (e 0) (e 1) (e 2)).degree :=
          (exponent_degree _ _ _).symm
        _ = e.degree := congrArg Finsupp.degree (exponent_coordinates e)
        _ = d := hdeg
    by_cases hnonstd : e ∈ S
    · have hm : monomial e (1 : K) ∈ monomialIdeal S :=
        (monomial_mem_monomialIdeal_iff S hUp e).mpr hnonstd
      have hz : Ideal.Quotient.mk (monomialIdeal (R := K) S)
          (monomial e 1) = 0 := Ideal.Quotient.eq_zero_iff_mem.mpr hm
      have hsmul : monomial e (coeff e p) = coeff e p • monomial e (1 : K) := by
        simp [smul_monomial]
      rw [hsmul, map_smul]
      change coeff e p • Ideal.Quotient.mk (monomialIdeal (R := K) S)
        (monomial e 1) ∈ _
      rw [hz, smul_zero]
      exact Submodule.zero_mem _
    · have hk : d - e 0 - e 1 = e 2 := by omega
      have hstd : standard (monomialIdeal (R := K) S) (e 0) (e 1) (d - e 0 - e 1) := by
        apply (standard_monomialIdeal_iff S hUp _ _ _).mpr
        simpa only [hk, exponent_coordinates] using hnonstd
      let ij : LexCounting.standard3 (standard (monomialIdeal (R := K) S)) d :=
        ⟨(e 0, e 1), LexCounting.mem_standard3.mpr ⟨by omega, hstd⟩⟩
      have hb : quotientDegreeMonomial (K := K) S d ij ∈
          Submodule.span K (Set.range (quotientDegreeMonomial (K := K) S d)) :=
        Submodule.subset_span ⟨ij, rfl⟩
      have hmon : monomial e (coeff e p) =
          coeff e p • monomial3 (e 0) (e 1) (d - e 0 - e 1) := by
        simp only [monomial3, hk, exponent_coordinates, smul_monomial, smul_eq_mul, mul_one]
      rw [hmon, map_smul]
      exact Submodule.smul_mem _ (coeff e p) hb
  · apply Submodule.span_le.mpr
    rintro q ⟨ij, rfl⟩
    apply Submodule.mem_map.mpr
    refine ⟨monomial3 ij.1.1 ij.1.2 (d - ij.1.1 - ij.1.2), ?_, rfl⟩
    apply isHomogeneous_monomial
    rw [exponent_degree]
    have hsum : ij.1.1 + ij.1.2 ≤ d := (LexCounting.mem_standard3.mp ij.2).1
    omega

/-- The existing combinatorial `hilbert3` is the vector-space dimension of
the image of the degree-`d` homogeneous polynomial submodule in the actual quotient. -/
theorem finrank_quotientHomogeneous (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (d : ℕ) :
    Module.finrank K (quotientHomogeneous (K := K) S d) =
      LexCounting.hilbert3 (standard (monomialIdeal (R := K) S)) d := by
  rw [quotientHomogeneous_eq_span S hUp d]
  exact finrank_quotientDegreeMonomialSpan S hUp d

#print axioms quotientStandardEquiv
#print axioms standardMonomialBasis_apply
#print axioms finrank_standardMonomialSpan
#print axioms finrank_quotientHomogeneous

end

end WidthBounds.MonomialInterface
