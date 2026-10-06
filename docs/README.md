# Documentation guide

Use this page to choose a reading route and locate the document responsible for a topic. English is the primary project language; the [Chinese overview](../README.zh-CN.md) is optional.

## Choose a route

| Goal | Route |
|---|---|
| Get oriented | [Repository README](../README.md) → [Project overview](PROJECT_OVERVIEW.md) |
| Check the mathematics | [Proof narrative](PROOF_NARRATIVE.md) → [Statement map](STATEMENT_MAP.md); use [Contributions](CONTRIBUTIONS.md) to assess novelty |
| Reproduce a result | [Reproducibility](REPRODUCIBILITY.md) → the specified source, command, and evidence record |
| Evaluate a public or scholarly release | [Publication status](PUBLICATION_STATUS.md) → [Contributions](CONTRIBUTIONS.md) → [Future work](FUTURE_WORK.md) |
| Maintain or resume the project | [Current state](../research/STATE.md) → [Handoff](../research/HANDOFF.md) → [AGENTS](../AGENTS.md) and [protocol](../research/PROTOCOL.md) |

## Document responsibilities

| Document | It owns | Go elsewhere for |
|---|---|---|
| [Project overview](PROJECT_OVERVIEW.md) | Purpose, milestones, important failed approaches, evidence lessons, human–AI assessment, and extension interfaces | Complete proofs, setup commands, and current task status |
| [Proof narrative](PROOF_NARRATIVE.md) | The complete mathematical argument N0–N9, hypotheses, notation, and the classical/formal boundary | Exact declaration locations |
| [Statement map](STATEMENT_MAP.md) | G/Q/C/D contracts, Lean declarations and line links, compiled versus paper-level statements | The explanatory proof |
| [Contributions](CONTRIBUTIONS.md) | M1–M3/F1 comparisons, known ingredients, sources and versions, unresolved U1–U5 | General publication policy |
| [Reproducibility](REPRODUCIBILITY.md) | Pinned environment, executable commands, build evidence, archive checks, PDF-reproduction limits | Research-history narrative |
| [Publication status](PUBLICATION_STATUS.md) | Release terminology, AI disclosure, human responsibility, rights, and dated policy guidance | The execution plan |
| [Future work](FUTURE_WORK.md) | Planned tasks, decision gates, optional branches, and stopping conditions | Live authorization and completion status |
| [Current state](../research/STATE.md) | Latest accepted milestone, outstanding scope, verified repository state, and next authorized action | Historical chronology |
| [Handoff](../research/HANDOFF.md) | Minimal recovery sequence and invariants that must survive interruption | A second copy of every report |

[CONTRIBUTING](../CONTRIBUTING.md) is the guide for contributors. [AGENTS](../AGENTS.md) is the agent's startup contract; the [protocol](../research/PROTOCOL.md) contains detailed task, evidence, and checkpoint rules. The [manuscript index](../paper/README.md) owns the list of frozen TeX/PDF versions. The [research archive guide](../research/README.md) owns the route into historical documents and task reports.

## Current, dated, and frozen material

The mathematical baseline is R058 / v0.4. A later documentation or repository milestone does not establish a new theorem. Consult STATE and the queue for live work status; a future-work list or an old report's “next task” is not authorization to execute it.

Proof, statement-map, and contribution documents identify their accepted source editions. The publication note identifies the date of its policy assessment. Frozen manuscripts and historical reports retain their original claims, language, and evidence hashes. Original Chinese material remains available through the archive guide, but is not required for the English reading routes above.

## Keep the documentation coherent

Put a substantial explanation or command sequence in its owning document and link to it elsewhere. Short local summaries may repeat a boundary when needed to prevent a mathematical overclaim; do not remove necessary hypotheses just to reduce repetition.

Update English and Chinese landing pages together. Preserve N0–N9 and M/U labels used for cross-reference. Before changing a document registered as historical evidence, preserve its accepted bytes under the protocol and keep the old hash. If accounts disagree, check the exact declaration and record a correction rather than silently changing the mathematics.
