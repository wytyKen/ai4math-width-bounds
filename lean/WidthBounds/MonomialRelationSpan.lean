import WidthBounds.FiniteMonomialPresentation
import Mathlib.RingTheory.MvPolynomial.Basic

/-!
# All relations among finitely many monomial columns

The criterion below concerns the actual kernel on arbitrary polynomial
coefficient vectors. It uses a coefficient-field-linear lift in a quotient,
not a presumed polynomial-ring-linear splitting.
-/

noncomputable section

namespace WidthBounds.MonomialPresentation

variable {K : Type*} [Field K] (E : Finset (Fin 3 →₀ ℕ))

/-- The difference of two expressions for the same monomial, when both
column exponents divide `d`. -/
def commonRelation (d : Fin 3 →₀ ℕ) (u v : E) : FreeModule K E := by
  classical
  exact Pi.single u (MvPolynomial.monomial (d - u.val) 1) -
    Pi.single v (MvPolynomial.monomial (d - v.val) 1)

theorem commonRelation_mem_ker (d : Fin 3 →₀ ℕ) (u v : E)
    (hu : u.val ≤ d) (hv : v.val ≤ d) :
    commonRelation (K := K) E d u v ∈ LinearMap.ker (differential E) := by
  classical
  simp [LinearMap.mem_ker, commonRelation, differential_single,
    MvPolynomial.monomial_mul, tsub_add_cancel_of_le hu, tsub_add_cancel_of_le hv]

/-- Passing from one common multiple to a larger one multiplies the
relation by the corresponding monomial. -/
theorem commonRelation_smul (d δ : Fin 3 →₀ ℕ) (u v : E)
    (hu : u.val ≤ d) (hv : v.val ≤ d) (hd : d ≤ δ) :
    MvPolynomial.monomial (δ - d) (1 : K) • commonRelation (K := K) E d u v =
      commonRelation (K := K) E δ u v := by
  classical
  have hsingle (w : E) (hw : w.val ≤ d) :
      MvPolynomial.monomial (δ - d) (1 : K) •
        (Pi.single w (MvPolynomial.monomial (d - w.val) 1) : FreeModule K E) =
      Pi.single w (MvPolynomial.monomial (δ - w.val) 1) := by
    ext e
    by_cases he : e = w
    · subst e
      simp [smul_eq_mul, MvPolynomial.monomial_mul, tsub_add_tsub_cancel hd hw]
    · simp [he]
  simp only [commonRelation, smul_sub, hsingle u hu, hsingle v hv]

private abbrev RelationQuotient (N : Submodule (Ring K) (FreeModule K E)) :=
  FreeModule K E ⧸ N.restrictScalars K

private def chosenMonomialClass (N : Submodule (Ring K) (FreeModule K E))
    (d : Fin 3 →₀ ℕ) : RelationQuotient E N := by
  classical
  exact if h : ∃ u : E, u.val ≤ d then
    (N.restrictScalars K).mkQ
      (Pi.single h.choose (MvPolynomial.monomial (d - h.choose.val) 1))
    else 0

private def relationLift (N : Submodule (Ring K) (FreeModule K E)) :
    Ring K →ₗ[K] RelationQuotient E N :=
  (MvPolynomial.basisMonomials (Fin 3) K).constr K (chosenMonomialClass E N)

private theorem chosenMonomialClass_eq
    (N : Submodule (Ring K) (FreeModule K E))
    (hN : ∀ d u v, u.val ≤ d → v.val ≤ d → commonRelation E d u v ∈ N)
    (d : Fin 3 →₀ ℕ) (u : E) (hu : u.val ≤ d) :
    chosenMonomialClass E N d = (N.restrictScalars K).mkQ
      (Pi.single u (MvPolynomial.monomial (d - u.val) 1)) := by
  classical
  have h : ∃ v : E, v.val ≤ d := ⟨u, hu⟩
  rw [chosenMonomialClass, dif_pos h]
  apply (Submodule.Quotient.eq _).2
  exact hN d h.choose u h.choose_spec hu

private theorem relationLift_monomial
    (N : Submodule (Ring K) (FreeModule K E))
    (hN : ∀ d u v, u.val ≤ d → v.val ≤ d → commonRelation E d u v ∈ N)
    (d : Fin 3 →₀ ℕ) (u : E) (hu : u.val ≤ d) (a : K) :
    relationLift E N (MvPolynomial.monomial d a) = (N.restrictScalars K).mkQ
      (Pi.single u (MvPolynomial.monomial (d - u.val) a)) := by
  classical
  have hmono : MvPolynomial.monomial d a =
      a • (MvPolynomial.basisMonomials (Fin 3) K) d := by
    simp [MvPolynomial.coe_basisMonomials, MvPolynomial.smul_monomial]
  rw [hmono, map_smul, relationLift, Module.Basis.constr_basis,
    chosenMonomialClass_eq E N hN d u hu, ← map_smul]
  congr 1
  ext v
  by_cases hv : v = u
  · subst v
    simp [MvPolynomial.smul_monomial]
  · simp [hv]

private theorem relationLift_column
    (N : Submodule (Ring K) (FreeModule K E))
    (hN : ∀ d u v, u.val ≤ d → v.val ≤ d → commonRelation E d u v ∈ N)
    (u : E) (p : Ring K) :
    relationLift E N (p * MvPolynomial.monomial u.val 1) =
      (N.restrictScalars K).mkQ (Pi.single u p) := by
  classical
  induction p using MvPolynomial.induction_on' with
  | monomial d a =>
    rw [MvPolynomial.monomial_mul, mul_one]
    simpa using relationLift_monomial E N hN (d + u.val) u
      (le_add_of_nonneg_left (zero_le d)) a
  | add p q hp hq =>
    simp only [add_mul, map_add, hp, hq, Pi.single_add]

/-- If an A-submodule contains all common-multiple binomial relations, then
it contains every polynomial-coefficient relation among the given columns. -/
theorem ker_differential_le_of_commonRelation
    (N : Submodule (Ring K) (FreeModule K E))
    (hN : ∀ d u v, u.val ≤ d → v.val ≤ d → commonRelation E d u v ∈ N) :
    LinearMap.ker (differential E) ≤ N := by
  classical
  intro c hc
  have hcomp : relationLift E N (differential E c) = (N.restrictScalars K).mkQ c := by
    rw [differential_apply, map_sum]
    simp_rw [relationLift_column E N hN]
    rw [← map_sum, Finset.univ_sum_single]
  have hz : (N.restrictScalars K).mkQ c = 0 := by
    rw [← hcomp, LinearMap.mem_ker.mp hc, map_zero]
  exact (Submodule.Quotient.mk_eq_zero _).mp hz

/-- The relation at the least common multiple of a pair of columns. -/
def lcmRelation (u v : E) : FreeModule K E :=
  commonRelation E (u.val ⊔ v.val) u v

/-- It is enough to check the finite family indexed by ordered pairs of
columns; arbitrary common multiples follow by polynomial scalar closure. -/
theorem ker_differential_le_of_lcmRelation
    (N : Submodule (Ring K) (FreeModule K E))
    (hN : ∀ u v, lcmRelation E u v ∈ N) :
    LinearMap.ker (differential E) ≤ N := by
  apply ker_differential_le_of_commonRelation E N
  intro d u v hu hv
  rw [← commonRelation_smul E (u.val ⊔ v.val) d u v le_sup_left le_sup_right
    (sup_le hu hv)]
  exact N.smul_mem _ (hN u v)

/-- The actual kernel is the span of a finite, possibly redundant family
of least-common-multiple pair relations. -/
theorem ker_differential_eq_span_lcmRelation :
    LinearMap.ker (differential (K := K) E) =
      Submodule.span (Ring K) (Set.range (fun p : E × E => lcmRelation E p.1 p.2)) := by
  apply le_antisymm
  · apply ker_differential_le_of_lcmRelation E
    intro u v
    exact Submodule.subset_span ⟨(u, v), rfl⟩
  · apply Submodule.span_le.mpr
    rintro _ ⟨⟨u, v⟩, rfl⟩
    exact commonRelation_mem_ker E _ u v le_sup_left le_sup_right

#print axioms commonRelation_mem_ker
#print axioms commonRelation_smul
#print axioms ker_differential_le_of_commonRelation
#print axioms ker_differential_eq_span_lcmRelation

end WidthBounds.MonomialPresentation
