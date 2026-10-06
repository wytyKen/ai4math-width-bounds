# Handoff: documentation consolidation

Updated: 2026-10-07. R116 has consolidated current documentation without changing mathematical content; R117/R118 are accepted and all workers have stopped. [STATE](STATE.md) owns live status; this file owns recovery steps and the invariants needed to resume safely.

## Recovery sequence

1. Read AGENTS, STATE, and queue. Run root `.venv\Scripts\python.exe -B scripts/checkpoint.py --check`; run `--verify-latest` only if local checkpoints exist. Distinguish later workspace edits from damaged archives.
2. For R116, read task reports R116–R118 and `results/r116_documentation_validation.json` when present. Only inspect the document involved in the remaining edit; do not reread the whole archive or rebuild Lean for this editorial task.
3. Check actual Git status/log and the latest applicable ignored receipt before calling work committed or pushed. R112's English edition really reached remote main at `546b21c8823211fd2894d20201f3ba4aec266585`. Do not repeat its old “pending upload” descriptions as current status.
4. R117 owns only PROJECT_OVERVIEW, PUBLICATION_STATUS, and its report. R118 owns its review report. Root owns landing pages, the docs guide, integration, validation and live state. Continue a vanished worker from saved files; do not restart blindly.

## Editorial contract

README is the landing page; docs/README owns reading routes and document responsibilities. PROJECT_OVERVIEW owns the research story, milestones, failed shortcuts and reusable interfaces. Full proofs, declaration mapping, literature comparison, executable commands, publication responsibility and execution plans stay in their respective existing documents.

Keep README.zh-CN consistent with the English landing page. The five edited, previously accepted documents were preserved byte-for-byte under `research/frozen/pre_consolidation_20261007/`; C041 references were relocated with their original hashes. Do not modify these copies. Proof narrative, statement map, contributions, reproducibility, future work, AGENTS, CONTRIBUTING and PROTOCOL are intended to remain unchanged in R116.

## Mathematical boundaries to retain

- Any field; actual finite-colength lex quotient; x standard; w ≥ 4 and cumulative budget in every degree. Finite colength is a separate assumption.
- Standard Tor fixes first A/m and derives second A/I. K action is via the actual algebra map; K-finiteness precedes dimensions, and the high tail is `IsZero`.
- The lex maximum is attained; its explicit lower estimate requires w ≥ 64. It is not a matching semigroup lower bound.
- Actual h-zero tails differ from floor-bound tails; signed v0 is allowed. b1 has an existing harmonic endpoint; displayed b2/b3 harmonic formulas are mathematical compositions, not new named compiled declarations.
- N9 remains classical, with distinct CMS `w ≤ m−2`, complementary length, and width-3 cases. Full semigroup formalization, general Tor balance and graded-shifts interfaces are unfinished.
- U1–U5 and novelty remain unresolved. Translation, editing and internal AI review do not supply external human review, authorship confirmation or a clean R095 reproduction.

Exact hypotheses, declarations and old evidence remain in the unchanged proof/map/source files. The [reproducibility guide](../docs/REPRODUCIBILITY.md) owns environment, build-log and frozen-archive details.

## Finish and stop

The bounded review, intended-edit validation and old-hash checks have passed. Root performs the final stable-checkpoint and normal commit/repository transaction after these source records are written. Its actual outcome is recorded in ignored output/r116_documentation_release.receipt.json and Git state; if interrupted, finish only the remaining transaction, not the completed editing. Never infer a successful push from a prepared tree.

No R093, new mathematics, licensing decision, external contact, or journal submission starts automatically. Preserve privacy rules and normal Git identity. Use only root .venv, Lean/mathlib 4.22.0, and project-local caches; at most two non-recursive subagents including reviewers.
