# ai4math: restore state before continuing research

This mathematical project has persistent research records. The user chose a research-delivery closeout on 2026-09-29 and later authorized specific additional stages. Do not depend on chat history as the only memory or treat compaction as permission to select a new problem. Current authorization is recorded in `research/STATE.md`, `research/HANDOFF.md`, and `research/queue.json`.

## At startup or after compaction

1. Read `research/STATE.md`, `research/HANDOFF.md`, and `research/queue.json` first.
2. Run the root `.venv\Scripts\python.exe -B scripts/checkpoint.py --check`. If local checkpoints exist, also run `--verify-latest`. Distinguish archive corruption from ordinary later workspace changes. Public Git clones intentionally omit local checkpoints and some frozen binaries.
3. Read only the source and reports relevant to the current task; do not reread every paper, old chat, or cache.
4. Continue only the highest-priority ready task whose dependencies are complete and whose scope the user has authorized. Stop if the phase is closed and no tasks are ready/running. Future directions are not automatic TODOs. If an old running worker no longer exists, inspect its report and saved files before resuming; do not delete or restart its work blindly.

## Current scope and project language

- English is the primary language for current project documentation, code, task reports, and new state/claim descriptions. Optional Chinese translations are permitted. Preserve original-language historical records and frozen evidence; label them clearly and provide an English primary reading path through `README.md` and `docs/README.md`.
- The long-term English entry point is `docs/PROJECT_OVERVIEW.md`. `research/PROJECT_REPORT.md` and the old delivery guides remain historical records. Further mathematical extensions need a separately chosen scope.
- The user has deferred external expert review. Do not repeatedly make it a prerequisite for authorized local work. External messages, uploads, and submissions require applicable explicit authorization; do not infer journal-submission permission from a repository release.
- Use Python only through the root uv `.venv`. Lean is under `lean/`, pinned to Lean/mathlib 4.22.0; keep caches inside this project.
- Do not create application chats or background scheduled tasks to replace this workflow unless the user asks.
- Normal Git name/email may remain public, as the user explicitly clarified. Prevent accidental inclusion of credentials, private files, or other sensitive content; do not treat every ordinary local path as a secret without examining its context.

## Delegation and acceptance

- The root agent owns queue management, integration, validation, state, and the wording of conclusions. At most **two subagents** may be active at once, including reviewers. Subagents must not spawn further agents.
- Prefer empty-history workers. Every delegation must specify file paths, an exact objective, exclusive owned files, acceptance criteria, and a stopping condition.
- Register tasks and file ownership in `queue.json` before execution. Workers edit only assigned files. Root imports, dependency configuration, and live state are integrated by the root agent.
- Each task records detailed results in `research/tasks/<taskID>_*.md`. Messages return only a short conclusion, evidence location, limits, and next action. Save important intermediate results promptly.
- Distinguish conjecture, experimental support, internally reviewed classical proof, successfully compiled Lean statements, literature-known results, and unresolved novelty. Compiling a finite proposition does not establish that an entire mathematical argument is formalized. AI-agent review is not external human peer review.
- Lean must not use `sorry`, `admit`, custom axioms, or `native_decide`. Record standard logical axioms and mathematical assumptions explicitly.

## Checkpoint discipline

- At each accepted milestone, route change, or end of a work round, update STATE, HANDOFF, queue, and claims, then run `scripts/checkpoint.py --reason "short reason"`.
- For long tasks, save a working checkpoint about every 30 minutes. It must be marked WIP and must not be presented as a stable build.
- Before expected compaction or handoff, have workers save progress and then checkpoint. After unexpected compaction, restore from disk rather than asking the user to repeat the project history.
- `research/claims.json` records conclusions and source/log hashes. Old logs do not validate newly modified proofs. If a hashed historical document must change, first preserve its old bytes and redirect the historical evidence to that copy with the original hash.
- Accepted v0.1/v0.2 and delivered v0.3/v0.4 artifacts are frozen. Do not overwrite their PDFs, TeX, ZIPs, or acceptance records. New milestones use new versions. English documentation may be maintained separately without changing historical mathematical evidence.

The full workflow is in `research/PROTOCOL.md`. This protocol supports recovery, auditability, and reduced repeated work; it does not guarantee new mathematical discoveries.
