# R117: overview and publication guidance consolidation

Status: delivered for root integration and R118 review. Date: 2026-10-07. Supports R116.

## Scope and ownership

Edit only `docs/PROJECT_OVERVIEW.md`, `docs/PUBLICATION_STATUS.md`, and this report. The root preserved the original document bytes under `research/frozen/pre_consolidation_20261007/docs/` before delegation. No mathematical sources, frozen artifacts, other documentation, Git state, or live research records are owned here.

## Initial review

Read AGENTS, STATE, HANDOFF, the current queue, both assigned documents, and the relevant canonical proof/contribution/reproducibility/future-work sections. R117 is registered as running. Checkpoint `--check` passed. `--verify-latest` reported a valid archive; changes to queue/claims and new preserved documents are ordinary later workspace changes, not archive corruption. No Lean build or experiment was run.

The overview repeats the full proof/model, build evidence and operational commands, publication status, and future plan already maintained in dedicated documents. Its distinctive material is the project history, counterexamples and failed shortcuts, evidence hierarchy, human–AI assessment, and reusable interface map. These will remain its primary contents, alongside a compact result statement that links to the complete N0 contract. Publication guidance will retain dated primary-source citations and responsibility/rights boundaries while removing repeated status and roadmap passages.

## Delivered organization

Both assigned documents begin with a short purpose and read-next cue. They remain English-first, use portable relative repository links, and avoid `operatorname`/`llbracket` macro dependencies.

The overview now owns the project story: the original question and a compact current result; significant milestones; six concrete counterexamples/failed shortcuts; implementation difficulties; evidence hierarchy; human–AI assessment; and the reusable interface inventory. It retains the complete inventory of named modules from the original interface table. Chronology is grouped into ten meaningful stages instead of reproducing each task as a separate row. The original Chinese report and retrospective remain linked for the complete archival history.

Detailed repeated material is replaced with links to documents that already own it:

| Original overview content | Canonical home and retained overview cue |
|---|---|
| Full finite-colength model and elementary definitions | `PROOF_NARRATIVE.md` N0 and `STATEMENT_MAP.md` contracts; overview retains every final theorem assumption and actual-object meaning. |
| Terminal budget, signed Cauchy, harmonic derivation, actual lower ideal formula, detailed resolution proof | N1–N8 and the statement map; overview retains the result, scientific milestones, whole-kernel/injectivity requirements, dimensions, Tor order, and bounds. |
| Full classical transfer | N9; overview keeps CMS's width range, complementary length argument with degree-zero check, separate width-three branch, and missing end-to-end formalization. |
| Exact hashes, pinned mathlib commit, audit counts, build/archive checkpoints and recovery commands | `REPRODUCIBILITY.md`; overview keeps the evidence distinctions, pinned Lean/mathlib version, incremental-build status, standard axioms, archive omissions, and pending R095. |
| Repeated publication and privacy qualifications | `PUBLICATION_STATUS.md`; overview keeps the bounded privacy audit, pending human confirmation, and absence of human peer review. |
| Full R060–R067 and R093–R096 roadmap | `FUTURE_WORK.md`; overview keeps reusable interfaces, the open semigroup boundary, and the requirement for a chosen authorized scope. |

The publication note retains the dated assessment and all five primary policy citations. It consolidates status and risk explanations, places actual AI roles beside human responsibility, retains concrete rights/coauthor/legal limits, and links the preparation sequence instead of duplicating the roadmap. It still distinguishes public repository, preprint/manuscript, and peer-reviewed publication; does not grant a license, establish authorship, or authorize submission; and preserves the user's deferred-expert-review decision.

## Validation

Counts use Python `str.split()` on the UTF-8 source files, including tables, headings, code, and math syntax. The command used only the root `.venv` and wrote no additional files.

| Document | Preserved original | Edited | Reduction |
|---|---:|---:|---:|
| `docs/PROJECT_OVERVIEW.md` | 5,011 words | 2,450 words | 51.1% |
| `docs/PUBLICATION_STATUS.md` | 1,340 words | 1,019 words | 24.0% |

The local Markdown-link check resolved all file targets and explicit heading anchors in both edited documents, with zero errors. It checked the N0, contracts, and N9 anchors against the actual destination headings. Neither edited document contains the excluded macros.

The publication note's external URL set is unchanged: EMS `https://euromathsoc.org/code-of-practice`, arXiv `https://info.arxiv.org/help/moderation/index.html`, Springer Nature `https://support.springernature.com/en/support/solutions/articles/6000258807-preprints`, AFM `https://afm.episciences.org/page/instructions-for-authors`, and GitHub `https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository`. No policy page was re-fetched, and no policy conclusion was added; the note explicitly dates the existing assessment. The overview's direct repository URL was removed because current repository navigation belongs to the landing page. It added no external URL.

Manual scope comparison retained: arbitrary K; actual lex monomial ideal and actual quotient; separate finite-colength condition; x standard; w ≥ 4; cumulative budget for every natural degree; full xy subspace; exact standard Tor order and actual K-action; K-finiteness before dimensions; actual higher zero objects; strict first bound; attained maximum from w = 4 and explicit lower estimate from w = 64; no semigroup lower-bound inference; no optimal constants/exact extremizer/cross-field theorem; no newly compiled b2/b3 harmonic endpoints; no complete semigroup/graded/factor-interchange formalization; unresolved novelty and AI-review limitations; pending R093 and R095.

## Limits and handoff

This is an editorial task. No Lean source, scripts, proof/map/contribution document, mathematical evidence, or frozen artifact was edited. No build, experiment, literature/policy search, Git operation, remote check, or external message was performed. Checks establish local link consistency and retention of documented meaning; they are not online rendering QA or renewed scientific/legal validation.

R118's returned content comparison found no material defect: it confirmed the unique overview material, model/Tor/extremal qualifications, N9 branches, five policy sources, and authorship/license boundaries. Root owns acceptance, any integration edits, live STATE/HANDOFF/queue/claims updates, checkpointing, and any repository transaction. This worker stops after delivery; it does not reopen research or the preparation plan.
