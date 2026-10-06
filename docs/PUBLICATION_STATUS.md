# Public release, publication status, and responsibility

Assessment date: **7 October 2026**. This note addresses this project's current evidence and public repository. It does not select authors, grant a license, submit a paper, or certify mathematical novelty.

## Is sharing this work appropriate?

**Yes, as a clearly described research snapshot.** The repository already contains a substantial formalized lex-model result, a classical proof narrative, explicit literature comparisons, and evidence that readers can inspect. It also has material unfinished work. Public wording should make both visible.

Sharing work before journal acceptance is a normal part of mathematical communication. The European Mathematical Society's 2025 code explicitly recognizes public preprints before or alongside journal submission; it also assigns responsibility for correctness, attribution, and disclosure of AI-generated content. This supports early communication with accurate scope, not unsupported claims of completion. [EMS Code of Practice](https://euromathsoc.org/code-of-practice)

For this project, “public research snapshot with a formally checked lex-model component” is an appropriate description. “The original problem has been completely formalized,” “a new theorem has been certified as original,” or “the paper has passed peer review” would exceed the present evidence.

## Three different milestones

| Milestone | Meaning for this project |
|---|---|
| Public repository | Source and research records are available at a specific Git revision. Readers can inspect and attempt to reproduce them. Hosting itself performs no scientific acceptance. |
| Archival research manuscript / preprint | A coherent manuscript has a stable scholarly record and satisfies its host's requirements. This is a separate preparation and submission decision. |
| Peer-reviewed publication | A journal has evaluated and accepted a manuscript under its own policies. Neither a GitHub repository nor a build log establishes this status. |

arXiv explicitly distinguishes moderation from peer review. Its AI policy requires disclosure of substantial use, places responsibility for the paper on its human authors, and excludes AI language tools from the author list. These are requirements for arXiv submission, not a claim that this repository has been submitted or approved. [arXiv moderation and AI policy](https://info.arxiv.org/help/moderation/index.html)

Early sharing also does not automatically prevent later journal consideration. For example, Springer Nature's published preprint policy says that posting a preprint is not prior publication for its journal-consideration policy. The actual target journal and article type still need checking when a submission is chosen. [Springer Nature preprints policy](https://support.springernature.com/en/support/solutions/articles/6000258807-preprints)

## The risks that matter here

The following is a project-specific assessment, not a probability estimate or a guarantee.

| Risk | Current evidence and practical response |
|---|---|
| Overstating formal coverage | R058 reaches actual finite free resolutions and standard Tor for a precise finite-colength lex model. The full numerical-semigroup reduction remains classical. Keep that boundary next to the headline result. |
| Overstating novelty | R091 leaves U1–U5 unresolved, including a relevant inaccessible thesis and algorithmic overlap. Use “candidate contribution” and cite the exact known ingredients. A successful build cannot settle priority. |
| Mismatched proof evidence | Existing Lean evidence is an incremental pinned build. R095 clean reproduction is pending. Preserve source/log hashes and rebuild after actual proof changes; do not describe this documentation work as a new successful build. |
| Unverified human responsibility | AI did substantial mathematical, coding, and writing work. R093 has not recorded the human participant's actual understanding and verification. Do not fill that gap with a fabricated author statement or treat an upload command as proof of understanding. |
| Rights and reuse ambiguity | No project-wide license or final paper author list has been chosen. Clarify rights before granting a license or submitting a jointly authored paper. Cite third-party sources; do not redistribute downloaded papers or caches merely because they were used during research. |
| Accidental private-content exposure | R109–R111 checked the then-current files/history and four PDFs and found no actionable sensitive content within scope. Ignore rules were strengthened. Future additions still need a staged-content check; the audit is not a permanent guarantee. |
| Premature claims of priority or quality | A dated commit helps document provenance but cannot prove originality or scientific acceptance. Others may read, criticize, or develop the public ideas. Cite exact revisions and keep corrections visible. |

An honest mathematical mistake is a reason to investigate, correct, or withdraw the affected claim; it should not be concealed behind an old successful build. The distinction between a mistake and misconduct depends on what was claimed and how the evidence and corrections were handled. This is a practical research-integrity assessment, not a legal ruling about a hypothetical case.

## AI disclosure and human authorship

The current disclosure should describe actual tasks: mathematical exploration, proof implementation, literature checking, exposition, and internal review. “AI was used only for proofreading” would not accurately describe this record. Exact model versions, time, or cost should be reported only when supported by saved records; missing information must remain unknown.

The maintainer can share an exploratory repository while honestly stating its limits. A future scholarly author must separately decide which claims they can understand, explain, and take responsibility for. Internal AI review and successful Lean checking are useful evidence, but neither supplies human consent, verifies every citation, or settles whether the informal theorem is the intended formal statement.

Venue requirements can be stricter than the repository's status notice. For example, Annals of Formalized Mathematics currently requires human-authored manuscripts, disclosure of AI use in writing/code, explicit links from main results to formal code, and accessible open-source artifacts. It also requires authors to take responsibility for the argument and citations. The current repository has not been certified to satisfy those submission requirements. [AFM author instructions](https://afm.episciences.org/page/instructions-for-authors)

## Licensing and legal responsibility

GitHub explains that making a repository public does not itself supply an open-source license. A deliberate license is needed to specify permitted reuse; platform viewing/forking features do not resolve all reuse questions. [GitHub licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)

For this project, the unresolved questions are concrete: who has authority to license the original code and prose; whether any collaborator, employer, institution, or funder has applicable conditions; and whether third-party material is included on appropriate terms. The records do not establish answers to those personal/legal questions. Do not infer institutional ownership or permission merely from an email address.

This note is general research-practice information, not individualized legal advice or a promise of immunity. Applicable law and agreements matter. A README status statement cannot establish ownership, obtain a coauthor's consent, or waive every legal obligation. If an actual ownership, confidentiality, or contractual issue exists, obtain advice specific to it before that release decision.

## What to do next

1. Maintain the public repository as work in progress, with the exact formal scope, AI disclosure, and unresolved novelty visible.
2. Complete R093 from real evidence and the human participant's own account: contributions, understanding, verification, and responsibility. Do not invent missing history.
3. Choose one manuscript route and complete its focused exposition and reproducibility work under R094/R095. The current v0.4 PDF remains a frozen delivery report.
4. When a venue is actually selected, revisit its current policy, author consent, license, disclosure, and artifact requirements before R096 submission preparation.
5. If a substantive error or missed attribution is found, record its effect on the affected statements and issue a visible correction. Preserve previous versions rather than silently rewriting their acceptance history.

External expert review remains deferred at the user's request; this note does not make it a new prerequisite for authorized local work. No publication date, acceptance chance, or legal outcome is promised.

## Suggested public description

> This repository records an ongoing human–AI mathematical research project. Its Lean development verifies a specified finite-colength lex-ideal model, including an actual finite free resolution and standard higher Tor bounds. The complete numerical-semigroup reduction is not formalized end to end. Novelty remains unresolved, and internal AI-assisted review is not external human peer review. The project is shared as a research snapshot; author responsibility and submission readiness require separate work.

The English [README](../README.md), [contribution analysis](CONTRIBUTIONS.md), and [statement map](STATEMENT_MAP.md) implement this description. These scope statements inform readers; they are not substitutes for checking the mathematics or meeting a chosen venue's rules.
