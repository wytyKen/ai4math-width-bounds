# English documentation

English is the primary language for the active project. This directory provides a complete English route through the current mathematical results, their evidence, limitations, and maintenance. The Lean sources, Python tools, and manuscript text were already English before this documentation edition.

## Reading order

1. [Project overview](PROJECT_OVERVIEW.md): purpose, development history, current result, and what remains open.
2. [Proof narrative](PROOF_NARRATIVE.md): the full N0–N9 argument, including the classical semigroup layer and its formalization limits.
3. [Statement map](STATEMENT_MAP.md): exact assumptions and links to the Lean declarations supporting each step.
4. [Contributions](CONTRIBUTIONS.md): literature-known ingredients, candidate mathematical increments, implementation contributions, and unresolved comparisons.
5. [Reproducibility](REPRODUCIBILITY.md): pinned environment, source builds, archive checks, and their different meanings.
6. [Publication status and responsibility](PUBLICATION_STATUS.md): why the repository is a research snapshot, how to communicate its status, and what formal submission still requires.
7. [Future work](FUTURE_WORK.md): finite next steps and optional extensions; none is started automatically.

For development, read [CONTRIBUTING](../CONTRIBUTING.md), [AGENTS](../AGENTS.md), the [protocol](../research/PROTOCOL.md), and the live [state](../research/STATE.md) / [handoff](../research/HANDOFF.md).

## Chinese alternatives and historical evidence

[README.zh-CN.md](../README.zh-CN.md) is the Chinese project overview. The original Chinese proof narrative, contribution map, and older task records remain under `research/`. The [archive guide](../research/README.md) identifies them. They are optional historical material, not a language prerequisite for the English reading path.

The English proof narrative, statement map, and contribution analysis identify their accepted source editions. Other English guides synthesize the existing record and clearly distinguish current status from old milestones. Translation does not add a proof, a successful build, a novelty certificate, or a human review.

Historical files and old claim text are not retroactively translated in place: their recorded hashes and dated scope matter. Current state, protocol, task reports, and future primary documentation use English. When translations disagree, check the exact hypotheses and Lean declarations and report the discrepancy; English presentation cannot silently change a formal statement.
