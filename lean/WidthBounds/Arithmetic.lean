import Std

/-!
Finite arithmetic certificate only.

This file does NOT formalize semigroups, lex ideals, Hilbert functions, the
published reduction, or the implication from that reduction to these formulas.
See research/first_pass.md. No mathlib, sorry, custom axioms, or native_decide.
-/

namespace WidthBounds

def choose2 (n : Nat) : Nat := n * (n - 1) / 2
def choose3 (n : Nat) : Nat := n * (n - 1) * (n - 2) / 6
def choose4 (n : Nat) : Nat := n * (n - 1) * (n - 2) * (n - 3) / 24

def admissibleAlpha (w a : Nat) : Bool :=
  2 ≤ a && a ≤ 2 * w + 1 && choose3 (a + 2) ≤ 1 + (a - 1) * w

def admissibleHeight (w a d h : Nat) : Bool :=
  2 * choose3 (a + 2) + (d - a + 1) * h * (a + d + 3 - h) ≤ 2 * (1 + d * w)

def degreeCap (w a d : Nat) : Nat :=
  ((List.range (a + 1)).filter fun h => admissibleHeight w a d h).foldl max 0

def envelopeLength (w a : Nat) : Nat :=
  choose2 (a + 1) +
    ((List.range (2 * w + 1)).filter fun d => a ≤ d).foldl
      (fun total d => total + degreeCap w a d) 0

def checkAlpha (w a : Nat) : Bool :=
  if admissibleAlpha w a then
    let length := envelopeLength w a
    a + 1 + length ≤ choose2 (w + 1) &&
      a + 2 * length ≤ 2 * choose3 (w + 1) &&
      length ≤ 3 * choose4 (w + 1)
  else true

def checkWidth (w : Nat) : Bool :=
  (List.range (2 * w + 2)).all (checkAlpha w)

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem finite_envelope_certificate :
    (List.range 36).all (fun offset => checkWidth (offset + 4)) = true := by
  decide

#print axioms finite_envelope_certificate

end WidthBounds
