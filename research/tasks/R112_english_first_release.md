# R112 English-first documentation and responsible publication guidance

Date: 2026-10-07. Status: accepted; R113/R114 deliveries and R115 integration review are complete. This is a documentation and public-research communication milestone, not new mathematics, a clean proof rebuild, a license grant, or a paper submission.

## User objective and implementation

The user requested an English-first project, with optional Chinese versions, and asked whether publishing this mathematical work is appropriate and normal and what risks or responsibilities arise. The Lean/Python sources and manuscript bodies were already English. The work therefore provides a complete English primary reading route, maintains current operational documentation in English, and leaves original-language historical evidence intact.

The root README is now English. README.zh-CN is the optional Chinese overview. The eight documents under docs/ cover navigation, a substantial project overview, the complete N0–N9 proof narrative, the complete G/Q/C/D statement map, the full R091 contribution analysis, reproducibility, publication/responsibility, and future work. CONTRIBUTING, AGENTS, PROTOCOL, STATE, HANDOFF, the manuscript index, and the research archive guide are English. New task/claim descriptions are English; historical entries and frozen Chinese records are retained and labeled as archives.

This is more than a translated landing page: an English reader can understand the mathematical argument, code correspondence, literature positioning, scientific history, execution steps, and remaining decisions without relying on the Chinese documents. Historical raw task logs have not been rewritten merely to remove Chinese characters.

## Delegation and acceptance

- R113 produced docs/PROOF_NARRATIVE.md and docs/STATEMENT_MAP.md. It retained all N0–N9 sections, 14 lettered subsections, 27 numbered equations, 53 numbered statement-map entries, and 136 Lean file/line links, together with the exact contracts and evidence-status distinctions.
- R114 produced the complete English contribution analysis and a substantial project overview. M1–M3/F1, U1–U5, White Complete's fixed-q scope and finite-tail applicability argument, historical source versions, the actual resolution/Tor endpoint, and human–AI limitations remain explicit. Its later compatibility edit replaced renderer-problematic operator-name and double-bracket macros without changing mathematics.
- R115 performed a bounded integration review across the English primary route, high-risk assumptions/constants/Tor conventions, classical semigroup branches, novelty boundaries, and publication/responsibility wording. It found no material integration defect. This was an internal AI documentation review, not external human review or a new proof audit.

No more than two subagents were active at once; no worker spawned another. Each wrote only its assigned documents and task report. Original Chinese proof, mapping, contribution, project-report, and retrospective files were not edited.

## Historical evidence preservation

Before changing the live README, AGENTS, PROTOCOL, or manuscript index, root copied their exact original bytes under research/frozen/pre_english_20261007/, preserving their original relative paths. C039's README and C024's AGENTS/PROTOCOL references now point to these copies, retain their old hashes, and record the original delivery paths. The old paper index had no direct claim evidence but was preserved as historical context.

All 742 pre-existing evidence references still match their files. All 64 Lean project files, 14 scripts, 13 existing output artifacts, frozen TeX sources, and the earlier manuscript guide remain unchanged. No Lean compilation, mathematical experiment, PDF regeneration, or dependency migration was performed.

## Structural checks

Root checked 16 primary documentation files: all are English apart from the explicit Chinese language-switch label in README. The 287 local links resolve; line anchors remain within their source files. None of these primary files retains the previously rejected operator-name macro or the double-bracket macro dependencies. Five PowerShell blocks were statically parsed without running builds. The optional Chinese overview is separate, not counted as an English document.

The primary docs describe the existing successful integrated incremental R058 build, including cache replay, and leave R095 clean-environment validation pending. The code-build instructions are not represented as a newly executed build. Historical archive checks are kept distinct from public-clone source builds.

The large initial batched shell write was rejected by automatic approval review with the stated reason “blocked by policy”; it wrote none of its proposed files. Root completed the same authorized documentation work using explicit file-by-file patch edits, which succeeded. No approval request or blocked deliverable remains.

## Publication assessment and sources

The project-specific judgment is that an accurately scoped work-in-progress research repository is appropriate. A repository upload is not journal acceptance, a novelty certificate, or a completed human responsibility record. Current risks concern overstatement of the semigroup formalization, unresolved literature overlap, evidence/version mismatches, responsibility for substantial AI participation, rights/licensing uncertainty, and future private-content additions.

Primary sources read on 2026-10-07 and used in docs/PUBLICATION_STATUS.md:

- [EMS Code of Practice](https://euromathsoc.org/code-of-practice), approved 2025-03-19: mathematical dissemination, attribution, public preprints, AI disclosure, and author responsibility.
- [arXiv moderation / AI policy](https://info.arxiv.org/help/moderation/index.html): moderation is not peer review; significant AI use and human author responsibility.
- [AFM author instructions](https://afm.episciences.org/page/instructions-for-authors): human-authored manuscripts, AI disclosure, formal-code correspondence, and submission/artifact conditions.
- [Springer Nature preprints policy](https://support.springernature.com/en/support/solutions/articles/6000258807-preprints): a concrete publisher's preprint policy, not a guarantee for every venue.
- [GitHub licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository): public availability and an explicit reuse license are distinct.

The AMS ethics page could not be fetched (403), so no conclusion depends on its unread full text. Search results outside authoritative primary sources were not used for policy assertions. In particular, this work does not repeat unverified claims about new arXiv sanctions or treat another field's author rules as binding mathematics policy.

No institutional affiliation, employer/funder obligation, coauthor consent, human understanding, or license authority is inferred from an email address or Git identity. The publication note is general information, not individualized legal clearance. R093 and R095 remain pending. Deferred external expert review was not turned into a prerequisite for this authorized local documentation work.

## Completion transaction and stopping point

The repository was already public-facing and the last verified pushed revision was f8a5eddbc039129a3d3a30dc0b2f22d7e30134e7. Root will record this accepted English documentation in a stable checkpoint and normal Git commit. Any subsequent repository push must be verified against the same origin and remote main; its actual outcome belongs in Git state and an ignored external receipt, not in a self-referential final commit hash inside this tree.

No R093, R094–R096, R060–R067, external contact, DOI registration, license selection, or journal submission is started by R112. Future primary documents should be English, with original-language archives preserved for auditability.
