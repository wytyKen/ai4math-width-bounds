# R115 — English primary documentation integration review

Status: complete for root acceptance, 2026-10-07. Supports R112. Exclusive owned file: this report.

## Conclusion

No material integration defect was found in the reviewed English documentation. The primary reading path is usable without translating historical Chinese records. The high-risk assumptions, numerical constants, formal-object conventions, and proof/novelty/publication boundaries agree with the accepted source documents. R112 can proceed to root acceptance, final state/claim updates, and its documentation checkpoint. This review does not complete R093 or R095 or authorize a mathematical extension.

## Scope and recovery

Read AGENTS, STATE, HANDOFF and the relevant R112–R115 queue contracts before reviewing. The root `.venv` command `scripts/checkpoint.py --check` returned `queue_valid: true`. `--verify-latest` returned `archive_valid: true` for `20261006T195515230937Z-eba1c4a6`; it was explicitly a WIP snapshot because running/review tasks remained. At that check, its selected workspace bytes matched. Later root integration edits are normal workspace evolution, not archive corruption. These commands check records and bytes, not proofs.

Reviewed the English README, CONTRIBUTING, AGENTS, research/PROTOCOL, research/README, paper/README, docs/README, and all seven substantive English guides: PROJECT_OVERVIEW, PROOF_NARRATIVE, STATEMENT_MAP, CONTRIBUTIONS, REPRODUCIBILITY, PUBLICATION_STATUS and FUTURE_WORK. Read the final compatibility-corrected R114 documents and the newly English STATE/HANDOFF. Used the accepted Chinese narrative, statement map and contribution map for focused semantic comparisons, together with the R113/R114 handoff reports. This was a bounded integration review, not a new independent proof or literature audit.

## Mathematical qualifications checked

| Area | Finding |
|---|---|
| Main model | Arbitrary coefficient field, actual three-variable lex monomial ideal, separate finite-colength assumption, x standard, w ≥ 4, and actual cumulative homogeneous-image budget in every degree are retained. The weaker G/Q contracts and the concrete D contract remain distinct from C; `hSpan` and `hI` are not silently discarded. |
| Counting and bounds | The complete xy dimension is distinguished from a truncated definition. The cutoff, redundant actual zero tail versus possibly nonzero floor bounds, positive denominator, strict numerator 2w−1, single terminal budget, signed v0, and strictness only of the first final binomial inequality remain explicit. |
| Extremal result | The actual feasible ideal family and every-degree budget, initial exponent a = s, nonsquare-width argument, attained lex maximum, constants 1/16 and 10, and compiled threshold w ≥ 64 are preserved. Attainment is not advertised as an explicit optimal ideal or a matching semigroup lower bound. |
| Resolution and Tor | The concrete complete-kernel and injectivity claims are distinguished from merely packaging supplied exactness. Standard Tor fixes first A/m and derives second A/I. Restriction along the actual K → A, true K-finiteness, dimensions 1,a+1+ell,a+2ell,ell, and higher `IsZero` are retained. No general factor-exchange or full graded-shifts interface is invented. |
| Harmonic conclusions | The existing b1 harmonic endpoint is distinguished from direct mathematical compositions for b2/b3. The standard Theta endpoint remains the section maximum, not separately formalized extrema for every Betti number. |
| Classical application | Betti numbers are over the minimal presenting ring P. The CMS budget branch w ≤ m−2, complementary length branch w ≥ m−1 with degree zero checked separately, and width-3 branch remain distinct. Traditional Tor symmetry is not described as implemented local factor balance; lex lower bounds are not transferred backward. |
| Contribution comparison | M1–M3/F1 remain candidate attribution labels. CMS's O(w^(3/2)) baseline, White Complete at a fixed homological q, the q=2 ideal-Betti to b3=ell shift, distinct optimization objectives, truncation at 2w+1, length bound 1+2w², and lack of executed optimization are retained. All U1–U5 remain unresolved. |

## English path and public wording

The README and docs index supply English entry points for mathematics, exact code mapping, contribution comparison, history, reproduction, future work and publication status. The proof narrative supplies the mathematical explanation in English; Chinese task/audit links serve as historical evidence rather than a language prerequisite. Source editions and translation dates are labeled. Older queue/claim text and frozen documents are deliberately preserved instead of silently translated in place.

The publication note supports sharing an accurately described research snapshot while separating repository availability, preprint preparation, and peer-reviewed publication. It does not imply certified novelty, completed external human review, confirmed human understanding, a selected author list, an open-source license, or legal immunity. AI participation is described as substantial, not merely proofreading. R093's factual responsibility record and R095's independent clean reproduction remain pending. External expert review remains deferred and is not made a new prerequisite for authorized local work.

The policy statements are attached to the primary sources already browsed by root: EMS, arXiv, AFM, Springer Nature and GitHub. This reviewer checked their use and qualifications in the note, but did not re-browse or independently certify current venue/legal requirements. The advice is explicitly dated and does not promise acceptance or a legal outcome.

## Preservation and limits

Read-only SHA-256 checks matched the preservation values recorded by R113/R114 for all six principal originals: `research/publication/PROOF_NARRATIVE.md`, `STATEMENT_MAP.md`, `STATEMENT_MAP_GITHUB.md`, `CONTRIBUTION_MAP.md`, `research/PROJECT_REPORT.md`, and `research/PROJECT_RETROSPECTIVE_v0_4.md`. A read-only Git changed-path listing showed the expected live entrypoint/state changes and no changes to those originals. Root separately owns exhaustive evidence hashes, local links, source anchors, script-block syntax and the final Git/checkpoint transaction.

No finding requires a source correction from this bounded review. No Lean build, mathematical experiment, external search, Git mutation, authorship decision, licensing action, or further delegation was performed. Only this assigned report was written. Static reading does not establish browser rendering, fresh compilation, or independent human peer review.

The worker stops here. Root should integrate the report, record acceptance, and finish R112 within its existing authorization.
