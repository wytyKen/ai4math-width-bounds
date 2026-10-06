import WidthBounds.TorOneBounds

/-!
# Standard Tor from a resolution with zero residue differentials

The first factor is `A / variableIdeal`, and mathlib derives the second factor
`A / I`.  Scalar restriction uses the coefficient algebra map.  No change of
factors or definition of Tor by a desired dimension is used.
-/

namespace WidthBounds

noncomputable section

open CategoryTheory CategoryTheory.Limits

/-- For a complex with zero differentials, its actual homology is isomorphic
to the corresponding complex term. -/
def homologyIsoTermOfZeroDifferentials
    {C : Type*} [Category C] [HasZeroMorphisms C]
    {ι : Type*} {c : ComplexShape ι} (L : HomologicalComplex C c)
    (hzero : ∀ i j, L.d i j = 0) (n : ι) [L.HasHomology n] :
    L.homology n ≅ L.X n :=
  (ShortComplex.HomologyData.ofZeros (L.sc n)
    (hzero _ _) (hzero _ _)).left.homologyIso

namespace MonomialInterface

open MvPolynomial

variable {K : Type*} [Field K]

/-- The standard mathlib Tor object, deriving the quotient in the second
factor in every degree. -/
abbrev IdealQuotientTor (I : Ideal (MvPolynomial (Fin 3) K)) (n : ℕ) :
    ModuleCat (MvPolynomial (Fin 3) K) :=
  ((CategoryTheory.Tor (ModuleCat (MvPolynomial (Fin 3) K)) n).obj
    (ModuleCat.of (MvPolynomial (Fin 3) K)
      (MvPolynomial (Fin 3) K ⧸ variableIdeal (K := K)))).obj
        (ModuleCat.of (MvPolynomial (Fin 3) K) (MvPolynomial (Fin 3) K ⧸ I))

/-- The standard Tor object with scalars restricted along the coefficient
inclusion, not along a transported scalar action. -/
abbrev IdealQuotientTorK (I : Ideal (MvPolynomial (Fin 3) K)) (n : ℕ) : ModuleCat K :=
  (ModuleCat.restrictScalars (algebraMap K (MvPolynomial (Fin 3) K))).obj
    (IdealQuotientTor I n)

@[simp] theorem idealQuotientTor_one (I : Ideal (MvPolynomial (Fin 3) K)) :
    IdealQuotientTor I 1 = IdealQuotientTorOne I := rfl

@[simp] theorem idealQuotientTorK_one (I : Ideal (MvPolynomial (Fin 3) K)) :
    IdealQuotientTorK I 1 = IdealQuotientTorOneK I := rfl

/-- The actual projective resolution computes the standard Tor object as
the homology of its actual residue tensor complex. -/
def idealQuotientTorIsoHomology
    (I : Ideal (MvPolynomial (Fin 3) K))
    (P : ProjectiveResolution
      (ModuleCat.of (MvPolynomial (Fin 3) K) (MvPolynomial (Fin 3) K ⧸ I)))
    (n : ℕ) :
    IdealQuotientTor I n ≅
      (((residueTensorFunctor (K := K)).mapHomologicalComplex
        (ComplexShape.down ℕ)).obj P.complex).homology n :=
  P.isoLeftDerivedObj (residueTensorFunctor (K := K)) n

/-- When the residue differentials vanish, the actual resolution term
computes the standard Tor object. No finiteness assumption is needed. -/
def idealQuotientTorIsoResidueTensor
    (I : Ideal (MvPolynomial (Fin 3) K))
    (P : ProjectiveResolution
      (ModuleCat.of (MvPolynomial (Fin 3) K) (MvPolynomial (Fin 3) K ⧸ I)))
    (hzero : ∀ i j, (residueTensorFunctor (K := K)).map (P.complex.d i j) = 0)
    (n : ℕ) :
    IdealQuotientTor I n ≅ (residueTensorFunctor (K := K)).obj (P.complex.X n) :=
  idealQuotientTorIsoHomology I P n ≪≫
    homologyIsoTermOfZeroDifferentials _ hzero n

/-- The comparison preserves the actual coefficient-field module structures
because it is the scalar restriction of the proved polynomial-module iso. -/
def idealQuotientTorEquivResidueTensor
    (I : Ideal (MvPolynomial (Fin 3) K))
    (P : ProjectiveResolution
      (ModuleCat.of (MvPolynomial (Fin 3) K) (MvPolynomial (Fin 3) K ⧸ I)))
    (hzero : ∀ i j, (residueTensorFunctor (K := K)).map (P.complex.d i j) = 0)
    (n : ℕ) :
    IdealQuotientTorK I n ≃ₗ[K]
      (ModuleCat.restrictScalars (algebraMap K (MvPolynomial (Fin 3) K))).obj
        ((residueTensorFunctor (K := K)).obj (P.complex.X n)) :=
  ((ModuleCat.restrictScalars (algebraMap K (MvPolynomial (Fin 3) K))).mapIso
    (idealQuotientTorIsoResidueTensor I P hzero n)).toLinearEquiv

/-- A zero resolution term gives actual vanishing of standard Tor, rather
than only the numerical statement that its finrank is zero. -/
theorem idealQuotientTor_isZero_of_resolution_isZero
    (I : Ideal (MvPolynomial (Fin 3) K))
    (P : ProjectiveResolution
      (ModuleCat.of (MvPolynomial (Fin 3) K) (MvPolynomial (Fin 3) K ⧸ I)))
    (hzero : ∀ i j, (residueTensorFunctor (K := K)).map (P.complex.d i j) = 0)
    (n : ℕ) (hX : IsZero (P.complex.X n)) : IsZero (IdealQuotientTor I n) :=
  IsZero.of_iso ((residueTensorFunctor (K := K)).map_isZero hX)
    (idealQuotientTorIsoResidueTensor I P hzero n)

end MonomialInterface

#print axioms homologyIsoTermOfZeroDifferentials
#print axioms MonomialInterface.idealQuotientTorIsoHomology
#print axioms MonomialInterface.idealQuotientTorIsoResidueTensor
#print axioms MonomialInterface.idealQuotientTorEquivResidueTensor
#print axioms MonomialInterface.idealQuotientTor_isZero_of_resolution_isZero

end

end WidthBounds
