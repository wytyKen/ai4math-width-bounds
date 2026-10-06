"""Generate the paper's table directly from the saved integer certificate."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    data = json.loads((ROOT / "results/envelope_certificate.json").read_text(encoding="utf-8"))
    assert data["checked_pairs"] == 267 and data["all_pass"]
    rows = data["summaries"]
    assert [r["width"] for r in rows] == list(range(4, 40))
    for row in rows:
        matching = [r for r in data["rows"] if r["width"] == row["width"]]
        assert row["max_upper"] == [max(r["ideal_betti_upper"][i] for r in matching) for i in range(3)]
        assert all(x <= y for x, y in zip(row["max_upper"], row["targets"]))
    lines = [
        r"\begin{tabular}{rrrr@{\qquad}rrrr}", r"\toprule",
        r"$w$ & $U_0$ & $U_1$ & $U_2$ & $w$ & $U_0$ & $U_1$ & $U_2$ \\",
        r"\midrule",
    ]
    for left, right in zip(rows[:18], rows[18:]):
        values = [left["width"], *left["max_upper"], right["width"], *right["max_upper"]]
        lines.append(" & ".join(map(str, values)) + r" \\")
    lines += [r"\bottomrule", r"\end{tabular}"]
    target = ROOT / "paper/certificate_table.tex"
    target.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Generated {target.name} from all 267 checked parameter pairs.")


if __name__ == "__main__":
    main()
