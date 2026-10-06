import WidthBounds.MinimalGenerators

/-! Divisibility minimality of the three kinds of boundary monomials.
These statements concern actual ideal membership, without an identification
with the minimum size of an arbitrary polynomial generating family. -/

namespace WidthBounds.MonomialInterface

noncomputable section

open MvPolynomial

variable {R : Type*} [CommSemiring R]

/-- A coefficient-one monomial belongs to the ideal and has no proper
coefficient-one monomial divisor in the ideal. -/
def IsMinimalExponent (I : Ideal (MvPolynomial (Fin 3) R))
    (e : Fin 3 →₀ ℕ) : Prop :=
  monomial e (1 : R) ∈ I ∧
    ∀ f, f ≤ e → monomial f (1 : R) ∈ I → f = e

/-- It suffices to check the at most three immediate monomial divisors. -/
theorem isMinimalExponent_of_standard_predecessors
    (I : Ideal (MvPolynomial (Fin 3) R)) {i j k : ℕ}
    (hm : monomial3 i j k ∈ I)
    (hX : 0 < i → standard I (i - 1) j k)
    (hY : 0 < j → standard I i (j - 1) k)
    (hZ : 0 < k → standard I i j (k - 1)) :
    IsMinimalExponent I (exponent i j k) := by
  refine ⟨hm, ?_⟩
  intro f hf hfm
  have hf0 : f 0 ≤ i := by simpa using hf 0
  have hf1 : f 1 ≤ j := by simpa using hf 1
  have hf2 : f 2 ≤ k := by simpa using hf 2
  have hmem : monomial3 (f 0) (f 1) (f 2) ∈ I := by
    simpa only [monomial3, exponent_coordinates] using hfm
  have h0 : f 0 = i := by
    by_contra h
    exact hX (by omega) (monomial3_mem_of_le I (by omega) hf1 hf2 hmem)
  have h1 : f 1 = j := by
    by_contra h
    exact hY (by omega) (monomial3_mem_of_le I hf0 (by omega) hf2 hmem)
  have h2 : f 2 = k := by
    by_contra h
    exact hZ (by omega) (monomial3_mem_of_le I hf0 hf1 (by omega) hmem)
  rw [← exponent_coordinates f, h0, h1, h2]

/-- The first forbidden pure `x` power is divisibility minimal. -/
theorem isMinimalExponent_pure_x (I : Ideal (MvPolynomial (Fin 3) R))
    {a : ℕ} (hx : monomial3 a 0 0 ∈ I)
    (hInitial : ∀ d, d < a → standard I d 0 0) :
    IsMinimalExponent I (exponent a 0 0) := by
  apply isMinimalExponent_of_standard_predecessors I hx
  · intro ha
    exact hInitial (a - 1) (by omega)
  · intro h
    omega
  · intro h
    omega

/-- Exact finite columns before the first forbidden pure `x` power are positive. -/
theorem column_pos_of_initial (I : Ideal (MvPolynomial (Fin 3) R))
    (n : ℕ → ℕ) {a i : ℕ}
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) (hi : i < a) :
    0 < n i :=
  (hn i 0).mp (hInitial i hi)

/-- Positive finite columns of a lex ideal strictly decrease with the `x`
exponent. The hypotheses describe the true, untruncated columns. -/
theorem column_strictAnti_of_initial (I : Ideal (MvPolynomial (Fin 3) R))
    (hLex : IsLex I) (n : ℕ → ℕ) {a i i' : ℕ}
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0)
    (hii' : i < i') (hi' : i' < a) : n i' < n i := by
  have hp := column_pos_of_initial I n hn hInitial hi'
  have htop : standard I i' (n i' - 1) 0 := (hn i' _).mpr (by omega)
  have hlow : standard I i (i' - i + (n i' - 1)) 0 := by
    apply (standardLex I hLex).lex (by omega) (Or.inl hii') htop
  have hbound := (hn i _).mp hlow
  omega

/-- Each horizontal column boundary before the first forbidden pure `x`
power is divisibility minimal. -/
theorem isMinimalExponent_xy_boundary (I : Ideal (MvPolynomial (Fin 3) R))
    (hLex : IsLex I) (n : ℕ → ℕ) {a i : ℕ}
    (hn : ∀ i j, standard I i j 0 ↔ j < n i)
    (hInitial : ∀ d, d < a → standard I d 0 0) (hi : i < a) :
    IsMinimalExponent I (exponent i (n i) 0) := by
  have hp := column_pos_of_initial I n hn hInitial hi
  have hm : monomial3 i (n i) 0 ∈ I := by
    by_contra h
    have := (hn i (n i)).mp h
    omega
  apply isMinimalExponent_of_standard_predecessors I hm
  · intro hi0
    exact (hn (i - 1) (n i)).mpr
      (column_strictAnti_of_initial I hLex n hn hInitial (by omega) hi)
  · intro _
    exact (hn i (n i - 1)).mpr (by omega)
  · intro h
    omega

/-- Above a standard horizontal monomial the first forbidden vertical
exponent is strictly positive. -/
theorem zThreshold_pos_of_standard (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) {i j : ℕ}
    (hstd : standard I i j 0) : 0 < zThreshold I hZ i j := by
  have hm := zThreshold_mem I hZ i j
  by_contra h
  have heq : zThreshold I hZ i j = 0 := by omega
  exact hstd (by simpa only [heq] using hm)

/-- Every exponent strictly below the vertical threshold is standard. -/
theorem standard_of_lt_zThreshold (I : Ideal (MvPolynomial (Fin 3) R))
    (hZ : ∃ b, monomial3 0 0 b ∈ I) {i j k : ℕ}
    (hk : k < zThreshold I hZ i j) : standard I i j k := by
  intro hm
  have := zThreshold_le I hZ hm
  omega

/-- A vertical boundary above a standard horizontal monomial is divisibility
minimal: lex closure rules out its horizontal immediate divisors. -/
theorem isMinimalExponent_zThreshold (I : Ideal (MvPolynomial (Fin 3) R))
    (hLex : IsLex I) (hZ : ∃ b, monomial3 0 0 b ∈ I) {i j : ℕ}
    (hstd : standard I i j 0) :
    IsMinimalExponent I (exponent i j (zThreshold I hZ i j)) := by
  have hp := zThreshold_pos_of_standard I hZ hstd
  have hprev : standard I i j (zThreshold I hZ i j - 1) :=
    standard_of_lt_zThreshold I hZ (by omega)
  apply isMinimalExponent_of_standard_predecessors I (zThreshold_mem I hZ i j)
  · intro hi hm
    apply hprev
    exact hLex (by omega) (Or.inl (by omega)) hm
  · intro hj hm
    apply hprev
    exact hLex (by omega) (Or.inr ⟨rfl, by omega⟩) hm
  · intro _
    exact hprev

#print axioms isMinimalExponent_pure_x
#print axioms column_strictAnti_of_initial
#print axioms isMinimalExponent_xy_boundary
#print axioms zThreshold_pos_of_standard
#print axioms isMinimalExponent_zThreshold

end

end WidthBounds.MonomialInterface
