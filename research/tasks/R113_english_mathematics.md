# R113 — English proof narrative and statement map

Status: complete for root integration, 2026-10-07. Supports R112.

Exclusive files: `docs/PROOF_NARRATIVE.md`, `docs/STATEMENT_MAP.md`, and this report. The task translates the accepted R092 narrative and its R103 portable statement map, with no mathematical changes, Lean edits, builds, experiments, Git mutations, or external research.

Recovery completed: read AGENTS, STATE, HANDOFF and the R113 queue record. `checkpoint.py --check` returned `queue_valid: true`; `--verify-latest` returned `archive_valid: true` for `20261006T191930000679Z-21b077b7`. It separately reported normal ongoing R112 workspace changes. These checks validate recorded bytes, not proofs or compilation.

Completed outputs:

- [English proof narrative](../../docs/PROOF_NARRATIVE.md): 26,731 characters, approximately 4,328 whitespace-delimited words. Complete N0–N9, all 14 lettered subsections and all 27 original numbered equations, with the concluding proof-status and novelty qualifications.
- [English statement map](../../docs/STATEMENT_MAP.md): 42,549 characters, approximately 5,168 whitespace-delimited words. Complete G/Q/C/D contracts, all 53 numbered N0.1–N9.6 entries, every original Lean source link, the Tor-object note, the traditional semigroup bridge, contribution labels, and U1–U5.

Both files say explicitly that they translate the accepted R092 material without new proofs, builds, or novelty certification. They use portable repository-relative links from `docs/`, link to the English contributions document and each other, and retain the Chinese originals as alternatives. Formulas use plain text/code rather than renderer-dependent LaTeX macros. All external URLs were retained exactly.

## Mathematical and evidence scope retained

- Any coefficient field; actual three-variable quotient and homogeneous images; finite colength as a separate assumption; x standard; w ≥ 4 and the budget in every degree. Q's weaker section-only contract remains distinct from C, and D retains its separate `hSpan` and `hI` requirements.
- The initial degree a and its lower and upper bounds; actual complete xy dimension; the cutoff h_d = 0 for d ≥ 2w−2; the redundant three h tail terms versus potentially nonzero floor upper bounds; the positive pointwise denominator and strict integer numerator 2w−1.
- The single terminal budget, potentially negative v_0, signed Cauchy, and positive comparison threshold; strictness only for the first final binomial bound.
- The actual lower ideal, initial degree a = s, all-degree budget, exact nonnegative column lengths and divisor sum; arbitrary nonsquare widths through integer square root; the compiled lower-bound threshold w ≥ 64 and constants 1/16 and 10; attained actual lex maximum versus a claim of an explicit optimizer.
- Concrete exact d1/d2/d3 and injectivity content, post-existence choice of third columns, and the distinction between residue minimality and a complete graded interface.
- Standard `CategoryTheory.Tor` with first factor A/m and derived second factor A/I, actual restriction along `algebraMap K A`, true `Module.Finite K` before dimension, four ranks, and high-degree `IsZero`. No general factor-exchange implementation is invented.
- Existing compiled b1 harmonic endpoint versus paper-level b2/b3 composition; section-maximal `Asymptotics.IsTheta` versus separate Betti or semigroup extrema.
- Traditional semigroup comparison remains outside end-to-end Lean: four minimal generators, Betti numbers over P, the w ≤ m−2 CMS branch, the w ≥ m−1 length branch, separate w = 3 case, index shift from ideal to quotient, and no reverse transfer of the lex lower bound.
- All M1/M2/M3/F1 attribution limits and U1–U5, including White truncation preserving total rather than graded Betti numbers, remain explicit.

## Byte preservation and hashes

SHA-256 values recorded before writing and rechecked after both translations:

| Preserved source | SHA-256 |
|---|---|
| `research/publication/PROOF_NARRATIVE.md` | `bcb09a18172c1a751092420fda56a40188624bbe1a2da6cbc8fdae8e71e0f484` |
| `research/publication/STATEMENT_MAP.md` | `698cfa7bbf56592f3f74580e1eee4d5655f52746daa2f54db85fc63d69ba21cf` |
| `research/publication/STATEMENT_MAP_GITHUB.md` | `21c922344ac21382ff878a3a255703faf706a07c3e383c9d7ad55424c73033d6` |

All three remained byte-identical. Output SHA-256 values at handoff:

| Output | SHA-256 |
|---|---|
| `docs/PROOF_NARRATIVE.md` | `f501675a512cb3e11073847ba3634415519ac108da491168b5166260e14372ad` |
| `docs/STATEMENT_MAP.md` | `69c5c7cada5e746020a9eb62d4239a2dfeec7414bb19838005a502ca1e349035` |

## Checks performed

Read-only validation used only the root `.venv\Scripts\python.exe -B` and PowerShell file reads/hashes. No persistent helper script was added.

- Source and English map have the same ordered sequence of all 53 numbered table entries.
- Source and English map contain exactly the same multiset of 136 Lean file/line links after changing the relative prefix from `../../lean/` to `../lean/`; none are missing or added.
- Every local link in both outputs resolves; every Lean line anchor is within its target file's line range. This is a static file/link check, not a GitHub rendering test.
- The map preserves the exact multiset of external URLs. The narrative preserves the ordered external URL sequence.
- An identifier comparison found no omitted underscore-containing Lean declaration names; remaining textual differences were mathematical LaTeX fragments, equivalent plain-text indices, and the renamed English contributions link.
- The narrative retains N0–N9, all 14 original lettered subsections, and the exact ordered list of 27 numbered equations.
- Every map table row has three columns; fence counts are balanced (86 narrative fence markers, 8 map markers). Both outputs contain zero Chinese characters and no `operatorname` macro.
- Read against the Chinese sources for the semantic boundaries listed above. This is translation checking, not an independent proof audit or new acceptance of the mathematics.

## Limits and next action

Only the three assigned files were written. No Lean/source/original-document edits, compilation, experiments, Git mutations, external literature retrieval, subagents, or new research were performed. External citations and historical build evidence were faithfully carried forward, not independently reverified. The older Chinese audit/task records linked as supporting evidence remain original archival material; the new narrative and map are self-contained English reading documents.

Root should integrate these outputs into R112, update queue/state/claims, and create the final checkpoint. The subagent stops after this handoff; it does not change root-owned state or initiate any subsequent task.
