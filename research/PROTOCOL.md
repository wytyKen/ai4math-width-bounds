# Research execution and handoff protocol

Original protocol: 2026-09-23; delivery-closeout amendment: 2026-09-29. English maintenance edition: 2026-10-07. The original Chinese bytes are preserved under `frozen/pre_english_20261007/` for historical claims.

The project relies on recoverable files, explicit tasks, and inspectable evidence. A closed research stage does not authorize further mathematics. Current user instructions and STATE/HANDOFF determine which limited scope may resume. At most two subagents may be active, including reviewers, and they must not spawn further agents.

## Persistent records

| File | Purpose | Owner |
|---|---|---|
| `../AGENTS.md` | Short startup and working rules | Root |
| `STATE.md` | Scientific state, boundaries, and next action | Root |
| `HANDOFF.md` | Recovery without the old chat | Root |
| `queue.json` | Tasks, dependencies, ownership, acceptance | Root |
| `claims.json` | Claim types, evidence paths, SHA-256 | Root |
| `tasks/Rxxx_*.md` | Derivations, implementation, experiments, failed routes | Assigned worker |
| `checkpoints/` | Immutable source snapshots and an atomic latest pointer | Checkpoint tool |
| `../docs/` | English primary research and maintenance documentation | Assigned task owner / root integration |

Use English for new primary documents and live descriptions. Historical task and claim entries may retain Chinese to preserve the original research record. Translations must identify their source and must not silently replace original evidence.

Chat communicates progress and decisions. Long tool output, source material, and trial history belong in files. Root imports only the summaries and proof details needed for integration.

## One authorized research cycle

1. Select an authorized task whose dependencies are done, and record a concrete acceptance target, task ID, and owned files.
2. Delegate a bounded implementation or review. Usually one worker and one reviewer are enough; the two-subagent limit includes both. Save a plan first and update it after meaningful progress.
3. Reports state status, exact propositions and hypotheses, files, commands and outcomes, failed approaches, unproved parts, and one concrete next action.
4. Root checks mathematical meaning, not just successful compilation. Validate ownership, run appropriate bounded checks, and integrate imports/configuration only after acceptance.
5. Update claims, STATE, queue, and HANDOFF. Experiments cannot be promoted to general theorems; an AI review cannot be promoted to human peer review.
6. Create a checkpoint. Continue only within the authorized scope; an accepted checkpoint is not permission to start the next task.

A round without mathematical progress must still record what it ruled out. Do not keep repeating an unproductive approach merely because a task number remains open.

## Task states

| State | Meaning |
|---|---|
| `ready` | Dependencies done; waiting to be assigned within authorized scope |
| `running` | Work in progress; files may be incomplete |
| `review` | Delivered by the worker, awaiting root acceptance |
| `done` | Accepted and evidence registered |
| `parked` | Deferred by the user or current priorities; state the resume condition |
| `rejected` | A route or candidate was disproved or rejected; retain the evidence |

Workers do not declare other tasks complete. Report interface changes before another worker depends on them. Root-owned paths must not be duplicated as active task-owned paths; use a root-integration field when appropriate.

## Checkpoints and integrity

Create a checkpoint at accepted milestones, route changes, and the end of each round. Save WIP about every 30 minutes during long work. A file present in a snapshot is not automatically compiled or accepted.

The tool writes a source ZIP and manifest before atomically advancing the latest pointer. Every archived file has a size and SHA-256. Runtime caches, Git objects, temporary files, and output binaries are excluded from source selection. The archive is an exact source snapshot, not a complete offline runtime or binary backup.

Claims may mark a frozen external/binary reference `archive_required: false`; its current hash is still checked. Missing or mismatched required evidence makes the snapshot WIP. If a hashed document needs a new edition, preserve the old bytes and move the historical evidence pointer rather than rewriting its old hash as if the prior acceptance covered the new content.

Archive verification reports archive integrity separately from later workspace changes. It does not rerun Lean, reproduce commands, or prove mathematics. Stable snapshots are created after workers stop writing and root acceptance is complete. Working snapshots may span files written at different times and do not pretend to be atomic research transactions.

A public Git clone intentionally lacks local checkpoints and some historical binaries. Run `--verify-latest` only when the corresponding checkpoint exists; use the English reproducibility guide to distinguish Git-source builds from complete-delivery verification.

## Scientific priorities and stopping

Do not make deferred external expert review a prerequisite for other authorized work. Prioritize useful proof simplifications or precisely scoped formalization gaps over repeated paper formatting, broad unbounded enumeration, or unlimited model voting.

Each task has a finite output and a stop condition. After two substantive attempts yield no new constraint or interface, record the obstacle and let root reassess scope. Do not expand the queue simply to keep work moving. Public uploads and journal submissions are separate actions governed by the user's authorization.

This workflow cannot guarantee a new theorem or preservation of every unsaved step after a sudden interruption. It reduces lost context, repeated effort, and unsupported claims of completion. After compaction, restore from disk and continue the authorized task.
