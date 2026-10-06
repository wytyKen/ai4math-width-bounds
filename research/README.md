# Research records and archive

The project's primary documentation is now in [English](../docs/README.md). Start with the [project overview](../docs/PROJECT_OVERVIEW.md), [proof narrative](../docs/PROOF_NARRATIVE.md), [statement map](../docs/STATEMENT_MAP.md), and [contribution analysis](../docs/CONTRIBUTIONS.md).

## Current operational records

| Record | Purpose |
|---|---|
| [STATE](STATE.md) | Current accepted result, scope, and next action |
| [HANDOFF](HANDOFF.md) | Recovery after an interruption |
| [PROTOCOL](PROTOCOL.md) | Task, evidence, and checkpoint rules |
| [queue.json](queue.json) | Machine-readable task states and ownership |
| [claims.json](claims.json) | Claim categories and exact evidence hashes |

New primary descriptions are written in English. Older entries inside the queue and claims registry retain their original Chinese wording. They are historical records; the English documentation explains the current result without requiring readers to translate them.

## Historical Chinese documents

| Original record | Current English reading route |
|---|---|
| [PROJECT_REPORT](PROJECT_REPORT.md), including the v0.4 continuation | [Project overview](../docs/PROJECT_OVERVIEW.md) |
| [PROJECT_RETROSPECTIVE_v0_4](PROJECT_RETROSPECTIVE_v0_4.md) | [Overview](../docs/PROJECT_OVERVIEW.md), [publication note](../docs/PUBLICATION_STATUS.md) |
| [PROOF_NARRATIVE](publication/PROOF_NARRATIVE.md) | [English proof narrative](../docs/PROOF_NARRATIVE.md) |
| [STATEMENT_MAP_GITHUB](publication/STATEMENT_MAP_GITHUB.md) | [English statement map](../docs/STATEMENT_MAP.md) |
| [CONTRIBUTION_MAP](publication/CONTRIBUTION_MAP.md) | [English contribution analysis](../docs/CONTRIBUTIONS.md) |
| [PUBLICATION_PREPARATION_PLAN](PUBLICATION_PREPARATION_PLAN.md), [NEXT_STAGE_PLAN](NEXT_STAGE_PLAN.md) | [Future work](../docs/FUTURE_WORK.md) |
| [DELIVERY](DELIVERY.md), [DELIVERY_v0_4](DELIVERY_v0_4.md), old upload guide | [Reproducibility](../docs/REPRODUCIBILITY.md), [CONTRIBUTING](../CONTRIBUTING.md) |

`tasks/` preserves the detailed chronology, including unsuccessful approaches and internal AI reviews. An old report describes the state at its date; its “next task” is not necessarily today's next task. The English overview groups the substantive milestones and points to evidence when needed.

`frozen/` holds byte-preserved historical documents whose live counterparts changed. Some copies retain links relative to their original delivery location; their role is evidence preservation, not a new navigation tree. Do not rewrite them to fix presentation or translate them in place.

`checkpoints/`, complete local delivery ZIPs, runtime caches, and private audit intermediates are intentionally absent from the public Git checkout. A source checkout can build Lean without those archives. The full archive's integrity checks and a fresh proof build answer different questions; see the reproducibility guide.
