"""Exact integer audits of CMS (2024), Section 5.

This does not compute semigroup Betti numbers.  The DP optimizes a necessary
Hilbert-function relaxation; its connection to the paper must be proved
separately. All arithmetic is integer arithmetic from the Python standard library.
"""

from __future__ import annotations

import argparse
import json
from math import comb
from pathlib import Path
from time import perf_counter


def scalar_pairs(w: int) -> list[dict]:
    """Enumerate exactly the pairs allowed by CMS (15) and (17)."""
    pairs = []
    for a in range(2, 2 * w + 2):
        if comb(a + 2, 3) > 1 + (a - 1) * w:
            continue
        for b in range(a, 2 * w + 2):
            if comb(a + 1, 3) + comb(b + 1, 2) > 1 + (b - 1) * w:
                continue
            length = comb(a + 1, 2) + a * (b - a)
            pairs.append({
                "alpha": a, "beta": b, "length_upper": length,
                "b0_upper": a + 1 + length,
                "b1_upper": a + 2 * length,
            })
    return pairs


def q(d: int, h: int) -> int:
    """Number of forced three-variable standard monomials at degree d."""
    return h * (d + 1) - h * (h - 1) // 2


def check_witness(w: int, alpha: int, hs: tuple[int, ...]) -> None:
    """Check a witness directly, independently of the DP state transitions."""
    assert hs[:alpha] == tuple(range(1, alpha + 1))
    assert all(0 < hs[d] <= hs[d - 1] for d in range(alpha, len(hs)))
    cumulative = 0
    for d, h in enumerate(hs):
        # Independent sum rather than the closed-form q used in transitions.
        cumulative += sum(d - i + 1 for i in range(h))
        assert cumulative <= 1 + d * w
    assert len(hs) <= 2 * w + 1


def optimize(w: int, alpha: int) -> dict:
    """Maximize sum(h_d), subject to every cumulative lower-bound constraint.

At fixed (degree, last_h, length), only the history with the least cumulative
cost is kept. Such a history dominates every other history with that key,
because all subsequent transitions depend only on these values.

CMS (18) gives beta <= 2*w+1. A sequence ends at beta, so the last possible
positive entry is at degree 2*w. The DP includes every allowed transition.
"""
    prefix = tuple(range(1, alpha + 1))
    cost = comb(alpha + 2, 3)
    length = comb(alpha + 1, 2)
    if any(comb(d + 3, 3) > 1 + d * w for d in range(alpha)):
        raise ValueError("Infeasible initial degree")
    states = {(alpha, length): (cost, prefix)}
    best_length, best_hs = length, prefix
    peak_states = 1
    transitions = 0
    for degree in range(alpha, 2 * w + 1):
        next_states = {}
        cap = 1 + degree * w
        for (last_h, old_length), (old_cost, history) in states.items():
            # h=0 terminates a sequence; every prefix was already considered.
            for h in range(1, last_h + 1):
                transitions += 1
                new_cost = old_cost + q(degree, h)
                if new_cost > cap:
                    continue
                new_length = old_length + h
                key = h, new_length
                previous = next_states.get(key)
                if previous is None or new_cost < previous[0]:
                    new_history = history + (h,)
                    next_states[key] = new_cost, new_history
                    if new_length > best_length:
                        best_length, best_hs = new_length, new_history
        states = next_states
        peak_states = max(peak_states, len(states))
        if not states:
            break
    check_witness(w, alpha, best_hs)
    return {
        "alpha": alpha, "max_length": best_length,
        "b0_upper": alpha + 1 + best_length,
        "b1_upper": alpha + 2 * best_length,
        "witness_h": best_hs, "peak_states": peak_states,
        "transitions": transitions,
    }


def audit(w: int, run_dp: bool) -> dict:
    bound0, bound1 = comb(w + 1, 2), 2 * comb(w + 1, 3)
    pairs = scalar_pairs(w)
    bad = [p for p in pairs if p["b0_upper"] > bound0 or p["b1_upper"] > bound1]
    result = {
        "width": w, "target_b0": bound0, "target_b1": bound1,
        "scalar_pair_count": len(pairs), "scalar_exceptions": bad,
    }
    if run_dp:
        rows = [optimize(w, a) for a in sorted({p["alpha"] for p in pairs})]
        result["dp"] = rows
        result["dp_max_b0"] = max(r["b0_upper"] for r in rows)
        result["dp_max_b1"] = max(r["b1_upper"] for r in rows)
        result["dp_covers_targets"] = all(
            r["b0_upper"] <= bound0 and r["b1_upper"] <= bound1 for r in rows
        )
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--min-width", type=int, default=4)
    parser.add_argument("--max-width", type=int, default=39)
    parser.add_argument("--scalar-only", action="store_true")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if not 3 <= args.min_width <= args.max_width:
        parser.error("Require 3 <= min-width <= max-width")
    start = perf_counter()
    rows = []
    for w in range(args.min_width, args.max_width + 1):
        row = audit(w, not args.scalar_only)
        rows.append(row)
        if args.scalar_only:
            print(f"w={w}: scalar exceptions={len(row['scalar_exceptions'])}", flush=True)
        else:
            print(
                f"w={w}: b0 <= {row['dp_max_b0']}/{row['target_b0']}, "
                f"b1 <= {row['dp_max_b1']}/{row['target_b1']}, "
                f"pass={row['dp_covers_targets']}", flush=True,
            )
    result = {
        "source": "https://arxiv.org/html/2307.05770v2",
        "status": "Exact computation of a relaxation; mathematical bridge requires review.",
        "elapsed_seconds": perf_counter() - start, "rows": rows,
    }
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"Elapsed: {result['elapsed_seconds']:.3f}s")


if __name__ == "__main__":
    main()
