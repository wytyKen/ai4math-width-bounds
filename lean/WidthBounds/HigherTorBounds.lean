import WidthBounds.LexQuotientResolution
import WidthBounds.ResidueFreeDimension
import WidthBounds.MinimalResolutionTor

/-!
# Standard higher Tor for the actual finite-colength lex quotient

The first factor is the actual residue module A/m, and the second factor A/I
is derived. All coefficient-field structures are restrictions along K → A.
-/

noncomputable section

namespace WidthBounds.MonomialPresentation

open CategoryTheory CategoryTheory.Limits MvPolynomial Finset MonomialInterface

variable {K : Type*} [Field K]

/-- Degree one has precisely the old Tor object and coefficient action, so
the previously proved generator-fiber dimension formula applies unchanged. -/
theorem higherTor_one_dimension_compatibility (I : Ideal (Ring K))
    (hI : I ≤ variableIdeal (K := K)) :
    Module.finrank K (IdealQuotientTorK I 1) =
      Module.finrank K (GeneratorTensorFiber I) :=
  finrank_torOne_eq_tensor I hI

/-- Finite dimensionality is proved through the actual residual tensor term. -/
theorem minimalResolution_tor_finite (I : Ideal (Ring K))
    (P : ProjectiveResolution (ModuleCat.of (Ring K) (Ring K ⧸ I)))
    (hzero : ∀ i j, (residueTensorFunctor (K := K)).map (P.complex.d i j) = 0)
    (n : ℕ) [Module.Free (Ring K) (P.complex.X n)]
    [Module.Finite (Ring K) (P.complex.X n)] :
    Module.Finite K (IdealQuotientTorK I n) := by
  letI := residueTensor_free_finite (P.complex.X n)
  exact Module.Finite.equiv (idealQuotientTorEquivResidueTensor I P hzero n).symm

/-- The K-dimension of standard Tor equals the A-rank of the resolution term,
using a proved base-change equivalence, not an identification of scalar rings. -/
theorem minimalResolution_tor_finrank (I : Ideal (Ring K))
    (P : ProjectiveResolution (ModuleCat.of (Ring K) (Ring K ⧸ I)))
    (hzero : ∀ i j, (residueTensorFunctor (K := K)).map (P.complex.d i j) = 0)
    (n : ℕ) [Module.Free (Ring K) (P.complex.X n)]
    [Module.Finite (Ring K) (P.complex.X n)] :
    Module.finrank K (IdealQuotientTorK I n) =
      Module.finrank (Ring K) (P.complex.X n) := by
  calc
    _ = Module.finrank K (ResidueTensorK (P.complex.X n)) :=
      (idealQuotientTorEquivResidueTensor I P hzero n).finrank_eq
    _ = _ := finrank_residueTensor_free (P.complex.X n)

/-- A standard zero Tor object has zero coefficient-field dimension. -/
theorem finrank_tor_eq_zero_of_isZero (I : Ideal (Ring K)) (n : ℕ)
    (h : IsZero (IdealQuotientTor I n)) :
    Module.finrank K (IdealQuotientTorK I n) = 0 := by
  have hK : IsZero (IdealQuotientTorK I n) :=
    (ModuleCat.restrictScalars (algebraMap K (Ring K))).map_isZero h
  letI := ModuleCat.subsingleton_of_isZero hK
  exact Module.finrank_zero_of_subsingleton

section BoundaryData

variable (I : Ideal (Ring K)) (hZ : ∃ b, monomial3 0 0 b ∈ I)
    (a : ℕ) (n : ℕ → ℕ) (hx : monomial3 a 0 0 ∈ I) (hLex : IsLex I)
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (hSpan : Ideal.span (exponentMonomials (R := K)
      (boundaryExponents I hZ a n) : Set (Ring K)) = I)
    (hI : I ≤ variableIdeal (K := K))

include hZ hx hLex hn hInitial hSpan hI in
/-- Concrete boundary data compute standard Tor in all degrees, without a
width or Hilbert-budget hypothesis. Properness is retained explicitly. -/
theorem lexQuotient_tor_dimensions :
    (∀ j, Module.Finite K (IdealQuotientTorK I j)) ∧
    Module.finrank K (IdealQuotientTorK I 0) = 1 ∧
    Module.finrank K (IdealQuotientTorK I 1) = a + 1 + ∑ i ∈ range a, n i ∧
    Module.finrank K (IdealQuotientTorK I 2) = a + 2 * ∑ i ∈ range a, n i ∧
    Module.finrank K (IdealQuotientTorK I 3) = (∑ i ∈ range a, n i) ∧
    ∀ j, IsZero (IdealQuotientTor I (j + 4)) := by
  let P := lexQuotientResolution I hZ a n hx hLex hn hInitial hSpan
  have hz := lexQuotientResolution_residue_d_zero I hZ a n hx hLex hn hInitial hSpan hI
  have hr (j : ℕ) := minimalResolution_tor_finrank I P hz j
  refine ⟨fun j => minimalResolution_tor_finite I P hz j, ?_, ?_, ?_, ?_, ?_⟩
  · exact (hr 0).trans (lexQuotientResolution_rank_zero I hZ a n hx hLex hn hInitial hSpan)
  · exact (hr 1).trans (lexQuotientResolution_rank_one I hZ a n hx hLex hn hInitial hSpan)
  · exact (hr 2).trans (lexQuotientResolution_rank_two I hZ a n hx hLex hn hInitial hSpan)
  · exact (hr 3).trans (lexQuotientResolution_rank_three I hZ a n hx hLex hn hInitial hSpan)
  · intro j
    exact idealQuotientTor_isZero_of_resolution_isZero I P hz (j + 4)
      (lexQuotientResolution_zero_tail I hZ a n hx hLex hn hInitial hSpan j)

end BoundaryData

/-- Two descriptions of the first forbidden pure x exponent agree. -/
theorem initialExponent_unique (I : Ideal (Ring K)) {a b : ℕ}
    (ha : monomial3 a 0 0 ∈ I) (hb : monomial3 b 0 0 ∈ I)
    (haInit : ∀ d, d < a → standard I d 0 0)
    (hbInit : ∀ d, d < b → standard I d 0 0) : a = b := by
  apply Nat.le_antisymm
  · by_contra h
    exact haInit b (Nat.lt_of_not_ge h) hb
  · by_contra h
    exact hbInit a (Nat.lt_of_not_ge h) ha

/-- The original actual finite-colength lex model now computes standard Tor,
including true K-finiteness and zero objects above degree three. -/
theorem finiteColength_higherTor_dimensions
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (Ring K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    ∃ a : ℕ, 2 ≤ a ∧
      monomial3 a 0 0 ∈ monomialIdeal (R := K) S ∧
      (∀ d, d < a → standard (monomialIdeal (R := K) S) d 0 0) ∧
      (∀ j, Module.Finite K (IdealQuotientTorK (monomialIdeal (R := K) S) j)) ∧
      Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) 0) = 1 ∧
      Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) 1) =
        a + 1 + Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) 2) =
        a + 2 * Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) 3) =
        Module.finrank K (xySubspace (monomialIdeal (R := K) S)) ∧
      ∀ j, IsZero (IdealQuotientTor (monomialIdeal (R := K) S) (j + 4)) := by
  obtain ⟨a, P, ha, hx, hInitial, hFree, hFinite, h0, h1, h2, h3, hTail, hz⟩ :=
    finiteColength_exists_residue_minimal_resolution S hUp hLex hOne hw hBudget
  letI (j : ℕ) := hFree j
  letI (j : ℕ) := hFinite j
  have hr (j : ℕ) := minimalResolution_tor_finrank _ P hz j
  exact ⟨a, ha, hx, hInitial, fun j => minimalResolution_tor_finite _ P hz j,
    (hr 0).trans h0, (hr 1).trans h1, (hr 2).trans h2, (hr 3).trans h3,
    fun j => idealQuotientTor_isZero_of_resolution_isZero _ P hz (j + 4) (hTail j)⟩

/-- The three all-width bounds now concern the dimensions of standard Tor. -/
theorem finiteColength_higherTor_width_bounds
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (Ring K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w) :
    (∀ j, Module.Finite K (IdealQuotientTorK (monomialIdeal (R := K) S) j)) ∧
    Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) 1) <
      (w + 1).choose 2 ∧
    Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) 2) ≤
      2 * (w + 1).choose 3 ∧
    Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) 3) ≤
      3 * (w + 1).choose 4 ∧
    ∀ j, IsZero (IdealQuotientTor (monomialIdeal (R := K) S) (j + 4)) := by
  obtain ⟨a, _, hx, hInitial, hFinite, _, h1, h2, h3, hTail⟩ :=
    finiteColength_higherTor_dimensions S hUp hLex hOne hw hBudget
  have hZ := exists_pure_z_mem_of_finite_quotient (K := K) S hUp
  have hNonzero : monomialIdeal (R := K) S ≠ ⊥ := by
    obtain ⟨b, hb⟩ := hZ
    apply (monomialIdeal_ne_bot_iff S).mpr
    exact ⟨exponent 0 0 b, (monomial_mem_monomialIdeal_iff S hUp _).mp hb⟩
  obtain ⟨a', _, hx', hInitial', hb1, hb2, hb3⟩ :=
    monomialIdeal_all_widths_dimension_bounds S hUp hLex hNonzero hOne hw hBudget
  have haa : a = a' :=
    initialExponent_unique _ hx (not_not.mp hx') hInitial hInitial'
  subst a'
  refine ⟨hFinite, ?_, ?_, ?_, hTail⟩
  · simpa only [h1] using hb1
  · simpa only [h2] using hb2
  · simpa only [h3] using hb3

/-- All positive degrees, with zero higher Tor supplying the unbounded tail. -/
theorem finiteColength_tor_all_positive_bounds
    (S : Set (Fin 3 →₀ ℕ)) (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
    [Module.Finite K (Ring K ⧸ monomialIdeal (R := K) S)]
    (hOne : standard (monomialIdeal (R := K) S) 1 0 0)
    {w : ℕ} (hw : 4 ≤ w)
    (hBudget : ∀ d, (∑ t ∈ range (d + 1),
      Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w)
    (i : ℕ) (hi : 1 ≤ i) :
    Module.finrank K (IdealQuotientTorK (monomialIdeal (R := K) S) i) ≤
      i * (w + 1).choose (i + 1) := by
  obtain ⟨_, h1, h2, h3, hTail⟩ :=
    finiteColength_higherTor_width_bounds S hUp hLex hOne hw hBudget
  by_cases h : i = 1
  · subst i
    simpa using Nat.le_of_lt h1
  by_cases h' : i = 2
  · subst i
    exact h2
  by_cases h'' : i = 3
  · subst i
    exact h3
  have h4 : 4 ≤ i := by omega
  obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le h4
  have hz := hTail j
  rw [Nat.add_comm] at hz
  rw [finrank_tor_eq_zero_of_isZero _ _ hz]
  exact Nat.zero_le _

#print axioms minimalResolution_tor_finite
#print axioms higherTor_one_dimension_compatibility
#print axioms minimalResolution_tor_finrank
#print axioms lexQuotient_tor_dimensions
#print axioms finiteColength_higherTor_dimensions
#print axioms finiteColength_higherTor_width_bounds
#print axioms finiteColength_tor_all_positive_bounds

end WidthBounds.MonomialPresentation
