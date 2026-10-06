# Public release, publication status, and responsibility

**Assessment date: 7 October 2026.** This note explains the project's release status, disclosure, and responsibility boundaries using the primary policies checked on that date. For mathematical scope, read the [project overview](PROJECT_OVERVIEW.md) and [statement map](STATEMENT_MAP.md); for preparation tasks, continue to [future work](FUTURE_WORK.md). This editorial consolidation adds no new policy assessment.

## Sharing the current work

**The work is appropriate to share as a clearly described research snapshot.** It contains a substantial formally checked lex-model result, a classical proof narrative, literature comparisons, and inspectable evidence. Novelty, human responsibility, and independent clean reproduction remain unresolved or incomplete.

The European Mathematical Society's 2025 code recognizes public preprints before or alongside journal submission and assigns responsibility for correctness, attribution, and disclosure of AI-generated content. This supports early communication with accurate scope. [EMS Code of Practice](https://euromathsoc.org/code-of-practice)

| Milestone | Meaning |
|---|---|
| Public repository | Readers can inspect a specific revision and attempt reproduction. Hosting supplies no scientific acceptance. |
| Archival manuscript or preprint | A coherent manuscript has a stable scholarly record and meets its host's requirements. Preparing and submitting it is a separate decision. |
| Peer-reviewed publication | A journal has evaluated and accepted the manuscript under its policies. Repository availability and build success do not establish this status. |

arXiv distinguishes moderation from peer review. Its AI policy requires disclosure of substantial use, places responsibility on human authors, and excludes AI language tools from the author list. These describe submission requirements, not this repository's approval or submission status. [arXiv moderation and AI policy](https://info.arxiv.org/help/moderation/index.html)

Early sharing need not prevent later journal consideration. Springer Nature's preprint policy, for example, does not treat posting a preprint as prior publication for journal consideration. The actual journal and article type still require checking when a submission is chosen. [Springer Nature preprints policy](https://support.springernature.com/en/support/solutions/articles/6000258807-preprints)

## Project-specific risks

| Risk | Evidence and response |
|---|---|
| Overstating formal coverage | R058 proves actual finite free resolutions and standard Tor for the precise finite-colength lex model. The full numerical-semigroup reduction remains classical. Keep that boundary beside the headline result. |
| Overstating novelty or priority | R091 leaves U1–U5 unresolved, including inaccessible thesis material and algorithmic overlap. Use “candidate contribution” with the [literature comparison](CONTRIBUTIONS.md). A dated commit documents provenance; it cannot prove originality or quality. Others may criticize or develop the public ideas. |
| Mismatched proof evidence | The accepted Lean evidence is an incremental pinned build; R095 clean reproduction is pending. Preserve source/log correspondence and rebuild after proof changes. Documentation edits are not a new build. See [reproducibility](REPRODUCIBILITY.md). |
| Unverified human responsibility | AI did substantial mathematical, coding, writing, and review work. R093 has not recorded the human participant's actual understanding and verification. An upload command cannot supply that evidence. |
| Rights or reuse ambiguity | No project-wide license or final paper author list has been chosen. Clarify rights before licensing or submitting joint work; cite third-party sources and do not redistribute downloaded papers or caches merely because they informed research. |
| Private-content exposure | R109–R111 found no actionable sensitive content in their inspected files/history and four PDFs, and ignore rules were strengthened. Future additions need their own staged-content check; that audit is bounded. |

If a substantive error or missed attribution is found, investigate its effect, correct or withdraw the affected claim, and keep the correction visible. Preserve earlier versions and acceptance history. An old successful build cannot justify concealing a later problem. The distinction between mistake and misconduct depends on the claims and handling of evidence; this is a research-integrity assessment, not a legal ruling.

## AI disclosure and human authorship

Disclosure should name the actual AI tasks: mathematical exploration, proof implementation, literature checking, exposition, and internal review. Describing this as proofreading alone would be inaccurate. Report model versions, time, or cost only when saved records support them; missing facts remain unknown.

A future scholarly author must decide which claims they can understand, explain, and take responsibility for. Lean checking and internal AI review neither supply human consent nor verify every citation or the match between an informal theorem and its formal statement. R093 must separate recorded facts, personal confirmation, and unknowns.

Venue requirements can be stricter than a repository notice. Annals of Formalized Mathematics requires human-authored manuscripts, disclosure of AI use in writing/code, links from main results to formal code, accessible open-source artifacts, and author responsibility for arguments and citations. This project has not been certified to satisfy those requirements. [AFM author instructions](https://afm.episciences.org/page/instructions-for-authors)

## Licensing and legal limits

A public GitHub repository does not automatically receive an open-source license. A deliberate license specifies permitted reuse; platform viewing/forking features do not settle every reuse question. [GitHub licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)

The records do not establish who may license all original code and prose, whether collaborators, employers, institutions, or funders impose conditions, or whether every third-party item may be reused on the intended terms. An email address establishes neither institutional ownership nor permission. A README cannot obtain coauthor consent or waive obligations.

This is general research-practice information, not individualized legal advice or a promise of immunity. Applicable law and agreements matter; an actual ownership, confidentiality, or contractual issue needs advice specific to that release decision.

## Preparation and public wording

The [future-work guide](FUTURE_WORK.md) owns the R093–R096 sequence: factual responsibility, a chosen manuscript route, reproduction, and venue-specific readiness. The v0.4 PDF remains a frozen delivery report. Selecting a venue requires revisiting its current policies, consent, license, disclosures, and artifacts. No submission, author-list declaration, or license grant is authorized by this note. External expert review remains deferred at the user's request, not a new prerequisite for authorized local work.

A concise public description is:

> This repository records human–AI mathematical research with a formally checked finite-colength lex-model component, including a finite free resolution and standard higher Tor bounds. The complete numerical-semigroup reduction remains classical. Novelty is unresolved, and internal AI review is not external human peer review. It is shared as a research snapshot; human responsibility and submission readiness require separate work.

This wording describes the evidence; it does not promise acceptance or replace a chosen venue's requirements.
