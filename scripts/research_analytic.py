"""One bounded sanity check for the analytic column-length proof.

The theorem is proved algebraically in research/tasks/R006_analytic.md;
this enumerates only widths 4..8 and is not part of that proof.
Run with the repository's .venv/Scripts/python.exe.
"""

from __future__ import annotations

from itertools import combinations
import json
from math import comb
from pathlib import Path


def check_columns(w: int, columns: tuple[int, ...]) -> dict | None:
    a = len(columns)
    length = sum(columns)
    degree = columns[0] - 1
    hf = [sum(d - i + 1 for i, n in enumerate(columns) if i <= d < i + n)
          for d in range(degree + 1)]
    total = 0
    for d, count in enumerate(hf):
        total += count
        if total > 1 + d * w:
            return None
    triangle_sum = sum(n * (n + 1) // 2 for n in columns)
    assert total == triangle_sum
    assert triangle_sum <= 1 + degree * w
    assert a <= w - 2
    shifted = (2 * columns[0] + 1 - 2 * w,) + tuple(2 * n + 1 for n in columns[1:])
    squared_norm = sum(x * x for x in shifted)
    square_budget = 4 * (w - 1) * (w - 2) + a
    linear = 2 * length + a - 2 * w
    threshold = w * w - w - a - 2
    assert sum(shifted) == linear
    assert squared_norm <= square_budget
    assert linear * linear <= a * squared_norm <= a * square_budget
    difference = threshold * threshold - a * square_budget
    assert difference == (w - 2) * ((w - 2) * (w + 1) ** 2 - 2 * a * (3 * w - 1))
    assert difference >= (w - 2) ** 2 * (w - 1) * (w - 3) > 0
    assert threshold > 0
    assert a + 1 + length <= comb(w + 1, 2) - 1
    assert a + 2 * length <= 2 * comb(w + 1, 3)
    assert length <= 3 * comb(w + 1, 4)
    return {"alpha": a, "columns": list(columns), "length": length,
            "mu": a + 1 + length, "hilbert_function": hf,
            "triangle_sum": triangle_sum}


def main() -> None:
    summaries = []
    for w in range(4, 9):
        admissible_a = [a for a in range(2, 2 * w - 1)
                        if a * a + 4 * a + 6 <= 6 * w]
        checked = accepted = 0
        best = None
        for a in admissible_a:
            for increasing in combinations(range(1, 2 * w - 1), a):
                checked += 1
                columns = tuple(reversed(increasing))
                row = check_columns(w, columns)
                if row is None:
                    continue
                accepted += 1
                if best is None or row["mu"] > best["mu"]:
                    best = row
        assert best is not None
        summaries.append({"width": w, "column_vectors_checked": checked,
                          "column_vectors_satisfying_all_prefix_budgets": accepted,
                          "max_mu": best["mu"], "target": comb(w + 1, 2),
                          "maximizer": best})
    output = {
        "purpose": "Single bounded sanity check; not a proof by enumeration.",
        "scope": "Strictly decreasing positive column lengths, widths 4..8, alpha>=2, exact prefix feasibility.",
        "analytic_result": "For every integer width w>=4, alpha+1+length <= C(w+1,2)-1 under the stated standard-lex and cumulative-budget hypotheses.",
        "all_assertions_pass": True,
        "summaries": summaries,
    }
    target = Path(__file__).resolve().parents[1] / "results" / "research_analytic.json"
    target.write_text(json.dumps(output, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
