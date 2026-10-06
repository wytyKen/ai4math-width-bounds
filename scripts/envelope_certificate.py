"""Small, integer-only envelope certificate for CMS Remark 5.2.

Unlike audit_bounds.py this uses independent pointwise necessary conditions,
not dynamic programming. See research/first_pass.md for the mathematical bridge.
"""

from __future__ import annotations

import json
from math import comb
from pathlib import Path


def feasible_alpha(w: int, a: int) -> bool:
    return 2 <= a <= 2 * w + 1 and comb(a + 2, 3) <= 1 + (a - 1) * w


def degree_cap(w: int, a: int, d: int) -> int:
    prefix = comb(a + 2, 3)
    possible = [
        h for h in range(a + 1)
        if 2 * prefix + (d - a + 1) * h * (a + d + 3 - h) <= 2 * (1 + d * w)
    ]
    assert possible and possible[0] == 0
    return max(possible)


def certificate_row(w: int, a: int) -> dict:
    caps = [degree_cap(w, a, d) for d in range(a, 2 * w + 1)]
    length = comb(a + 1, 2) + sum(caps)
    upper = [a + 1 + length, a + 2 * length, length]
    target = [comb(w + 1, 2), 2 * comb(w + 1, 3), 3 * comb(w + 1, 4)]
    return {
        "width": w, "alpha": a, "caps": caps, "length_upper": length,
        "ideal_betti_upper": upper, "ring_betti_targets": target,
        "passes": all(u <= t for u, t in zip(upper, target)),
    }


def main() -> None:
    rows = [
        certificate_row(w, a)
        for w in range(4, 40)
        for a in range(2, 2 * w + 2)
        if feasible_alpha(w, a)
    ]
    assert all(r["passes"] for r in rows)
    summaries = []
    for w in range(4, 40):
        subset = [r for r in rows if r["width"] == w]
        upper = [max(r["ideal_betti_upper"][i] for r in subset) for i in range(3)]
        summary = {"width": w, "max_upper": upper, "targets": subset[0]["ring_betti_targets"]}
        summaries.append(summary)
        print(f"w={w}: upper={upper}, targets={summary['targets']}")
    output = {
        "source": "https://arxiv.org/html/2307.05770v2",
        "status": "Finite arithmetic certificate; see separate mathematical bridge and limitations.",
        "checked_pairs": len(rows), "all_pass": True,
        "summaries": summaries, "rows": rows,
    }
    target = Path(__file__).resolve().parents[1] / "results" / "envelope_certificate.json"
    target.write_text(json.dumps(output, indent=2) + "\n", encoding="utf-8")
    print(f"Checked {len(rows)} admissible (width, alpha) pairs.")


if __name__ == "__main__":
    main()
