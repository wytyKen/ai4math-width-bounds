# Future work and decision points

Current scientific baseline: R058 / v0.4. R091 contribution analysis and R092 proof exposition are complete. Later repository, privacy, and English-documentation tasks do not advance the mathematical claim. The following is an English maintenance guide to the existing plan, not permission to execute every item.

## Near-term research-preparation sequence

| Task | Question and required output | Current status |
|---|---|---|
| R091 | What is known, what is a candidate contribution, and what literature overlap remains unresolved? | Complete; see [Contributions](CONTRIBUTIONS.md). U1–U5 remain unresolved, not disproved. |
| R092 | Can the current argument be read independently and traced to exact formal declarations or classical sources? | Complete; see [Proof narrative](PROOF_NARRATIVE.md) and [Statement map](STATEMENT_MAP.md). English translations add no proof. |
| R093 | What did the human participant actually contribute, understand, and check, and what responsibility can be accepted? | Next planned preparation task, still parked until instructed. |
| R094 | Which single manuscript route is justified, and can a coherent candidate be written for that route? | Parked; depends on the preparation material and a route decision. |
| R095 | Can an independent clean environment reproduce the exact declared source, with a usable distribution and evidence record? | Parked. Existing incremental builds and Git uploads do not complete this task. |
| R096 | Is there a specific internally reviewed candidate and a concrete submission/release plan meeting the chosen venue's requirements? | Parked; a finite stopping point, not automatic submission. |

### R093: facts and responsibility

Start from saved records, then ask the human participant for information only they can provide. Separate log-supported facts, the person's own confirmation, and unknowns. Record actual roles and understanding rather than assigning honorary authorship or claiming that the person independently verified mathematics they have not checked. Do not invent model identifiers, costs, time, or causal efficiency estimates.

Unknown facts may remain explicitly unknown in an internal record. They must not be converted into a completed authorship statement simply because a deadline or a public repository exists.

### Decision A: choose the main contribution

Possible outcomes are a mathematical paper, a formalization paper with a substantive implementation/design insight, or a useful technical report. Choose one primary route based on the evidence. Do not begin two overlapping papers merely to increase publication opportunities. The human–AI process can be documented as a method or case study, but the project is not a controlled experiment establishing efficiency gains.

### R094 and R095: manuscript and reproduction

Once the route is selected, manuscript work and an independently scoped reproduction can proceed in parallel if actually authorized. The manuscript needs a complete statement, a readable argument, exact sources, and a candid account of the formalization boundary. Reproduction needs pinned versions, a clean setup record, actual command results, and a precise correspondence between claims, source, and successful logs.

Preserve v0.4. If proof source changes, keep a new version and rebuild the affected evidence. Diagnose missing downloads/caches separately from proof errors. Do not upgrade dependencies just to hide a mismatch or run unlimited installation attempts without a bounded plan.

### Decision B and R096

Assess mathematical scope, novelty wording, human responsibility, artifact reproducibility, licensing/citation status, and the chosen venue's current requirements separately. One generic “passed” label must not hide a missing element. Prepare reversible local work before asking the user to decide on a concrete external action.

R096 ends with an internal candidate and a specific readiness assessment. A finished preparation package may still say that a particular fact or decision is missing. A journal submission, arXiv deposit, author-list declaration, license grant, or external message requires its own applicable authorization. Repository publication has already happened; it is not journal acceptance.

## Optional full-semigroup formalization branch

R060–R067 remain an alternative technical branch, preserved in the [historical detailed plan](../research/NEXT_STAGE_PLAN.md). They are not needed simply to acknowledge the existing lex-model result, and they do not start because this list is present.

The next technical step, if this branch is chosen, is R060: write an exact interface contract for actual numerical-semigroup objects and the reduction. Subsequent work must supply the real semigroup algebra and local/graded comparisons, transfer the cumulative dimension budget in its correct cases, and connect the resulting Betti statements to standard Tor with the required conventions. General Tor balance and graded infrastructure are substantial interfaces, not notation changes.

The classical semigroup narrative in N9 distinguishes the CMS range `w ≤ m_Γ−2` from the larger-width branch using length `m_Γ`, and treats width 3 separately. A future formalization must preserve those cases. It cannot reuse a lex upper comparison in reverse to obtain semigroup lower bounds. See the exact assumptions and classical references in the English statement map.

Before undertaking large infrastructure items such as the originally planned R064/R065 stages, reassess their expected benefit and cost. A technically open branch does not have to be completed merely because its task numbers exist.

## Valid stopping outcomes

The project can finish with a useful technical report and reproducible formal artifact even if a candidate novelty claim is covered by existing literature or no paper route is selected. If a proof gap is found, mark and repair the affected claim; more AI review votes do not close the gap. If a human or licensing fact is missing, preserve the work without fabricating confirmation.

The [publication note](PUBLICATION_STATUS.md) discusses responsibilities and current policies. The [project overview](PROJECT_OVERVIEW.md) explains what the existing work already contributes. Future work should be driven by a clear question and finite acceptance criteria, not by a need to keep the queue growing.
