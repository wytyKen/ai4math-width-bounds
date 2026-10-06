# R114 — English contributions and project overview

Status: completed, 2026-10-07; parent integration pending. Owner: `english_project_context`; supports R112.

## Scope and progress

The assigned deliverables are `docs/CONTRIBUTIONS.md`, `docs/PROJECT_OVERVIEW.md`, and this report. No other files are owned. This task translates the complete R091 contribution comparison and synthesizes the project history, mathematics, workflow, and limitations into a substantial English reading path. It does not conduct new research, literature searches, builds, Git operations, or authorship decisions. No subagents are used.

Read the recovery records, R114 queue entry, contribution map, project report, retrospective, R058 report, and publication-preparation plan. `scripts/checkpoint.py --check` passed (`queue_valid: true`). `--verify-latest` reported a valid archive with expected concurrent R112–R114 documentation changes, not archive damage. The parent owns checkpoint creation and integration. Source documents remain unchanged.

## Source baseline (SHA-256)

| Source | SHA-256 |
|---|---|
| `research/publication/CONTRIBUTION_MAP.md` | `4b37a1330eed9e4e09ab49f23b9ea0740e24a2d95d5a0f7b8787f4113a23a279` |
| `research/PROJECT_REPORT.md` | `e0ee66c04bd99da690c632f666d1952c5b9fab3b772a2de60bcc87df6700e0cb` |
| `research/PROJECT_RETROSPECTIVE_v0_4.md` | `9d192920eeaa54f134413ad99238ba0c55ab1ff12e986b5fc8c61787fdfc7a77` |
| `research/STATE.md` at task start | `3a6fcad57c7dcf4e59da9067d4dc4c2e7f4386a14607407ab1a4fb7553d3d3e9` |
| `research/HANDOFF.md` at task start | `6a51e014f6c19086a96b00b28ed1f7063a2dbf15f9f027c1cdfe1a36d76bb2a3` |
| `research/tasks/R058_higher_tor_bounds.md` | `956b2e14263bd7e0d81680a16853583510e87a07b701634c5a776cb06ac64599` |
| `research/PUBLICATION_PREPARATION_PLAN.md` | `cbbef7202efbc4cca1d9878817e0069a36b8c042e47815e880bdd61d5b9384df` |

The first three are preservation baselines. STATE/HANDOFF may be updated by the parent during integration; their listed hashes document the inputs read, not a requirement that current state remain frozen.

## Completed deliverables

| File | Content | SHA-256 at handoff |
|---|---|---|
| `docs/CONTRIBUTIONS.md` | Full R091 English counterpart, approximately 3,607 whitespace-delimited words | `07aba8167cd956ebb18061c964c84fc29286fd05d1d3f58fd1023bece2633ae7` |
| `docs/PROJECT_OVERVIEW.md` | Self-contained English synthesis, approximately 5,011 whitespace-delimited words | `1d24db39900a6c81b2333928feed7fbd397c5523b93c8a27506de477ee8c1772` |

The contribution document preserves the full comparison contract; M1–M3 and F1; traditional vs formal conclusions; all 22 distinct external source URLs; CMS's exact range and O(w^(3/2)) comparison; Caviglia–Sammartano v1/v3 numbering; White Complete at fixed q, the separate optimization objectives, free-variable embedding, unbounded original length, truncation at D = 2w + 1, length at most 1 + 2w², and the unfinished encoding/execution obligations; inaccessible dissertation; recent semigroup-source limits; EK, mathlib, AFP and Fel comparisons; and all U1–U5 unresolved items. Its dated editorial note prevents R091's historical “R092 not yet started” text from being mistaken for today's status. No source was newly browsed or newly excluded.

The overview gives the original semigroup problem, complete current lex assumptions, derivations and formalization chain, actual lower ideals and Theta, traditional bridge, chronological milestones, concrete counterexamples, evidence hierarchy, incremental-build limits, persistent workflow, human/AI roles, public-release/privacy history, and reusable interfaces. It explains R093 and R095 remain pending, external review is deferred, no AI efficiency advantage is established, and the full semigroup bridge is not formalized. It does not treat file/task counts, translation, or code volume as mathematical discovery. It explicitly avoids inferring remote visibility/CI from the earlier successful push.

## Checks and limitations

- All three original principal Chinese documents retain exactly the baseline SHA-256 values above. Neither original proof/source nor frozen output was edited.
- External-link comparison found 22 distinct URLs in both the original contribution map and English counterpart, with none missing and none added. This checks citation preservation, not current web availability.
- Final repository-relative link checking passed all 13 local links in `CONTRIBUTIONS.md` and all 17 in `PROJECT_OVERVIEW.md`, including the now-created parent-owned `PUBLICATION_STATUS.md` and `FUTURE_WORK.md`. No local target remains missing.
- Display-math delimiters were paired (18 in the contribution document, 38 in the overview); code fences were paired; neither file contained a Unicode replacement character. This was a source/structure check, not a rendered-browser or PDF visual test.
- At the parent's integration request, replaced all 14 `\operatorname` occurrences across the two documents with `\mathrm`, and all four `\llbracket`/`\rrbracket` pairs with ordinary doubled brackets. No such unsupported macros remain; mathematical objects, assumptions, and conclusions are unchanged. The principal Chinese source hashes were rechecked and remain exact. Output hashes above include this compatibility correction.
- Semantic review retained arbitrary field, actual finite colength, x standard, w ≥ 4, every-degree budget, Tor first A/m / derived second A/I, actual K-action and finiteness, higher IsZero, w ≥ 64 for the explicit two-sided growth estimate, and the prohibition on transferring lex lower bounds backward to semigroups.
- No Lean build, mathematical experiment, new novelty search, Git mutation, publication action, author confirmation, license selection, or subagent delegation occurred. The root `.venv` alone was used for Python checks.

## Handoff and stopping point

The parent should integrate these English documents with R113's proof/map and its own R112 guides, update queue/state/claims, and create the documentation checkpoint. Final link checks and the requested notation-compatibility correction are complete. R114 needs no new mathematical task. After this report, the worker stops; it does not advance R093/R095 or change the scientific baseline.
