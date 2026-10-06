# R116 Documentation consolidation

Date: 2026-10-07. Status: complete. R117 editorial delivery and R118 bounded integration review are accepted; root structural and historical-evidence checks passed. This is an editorial task requested by the user, with English remaining the primary project language.

## Problems addressed

The English edition provided complete information but repeated detailed results, build instructions, future-work decisions, and publication qualifications across the homepage and several guides. The live STATE/HANDOFF also retained pre-transaction wording even though the English edition had actually been pushed and read back at commit 546b21c8823211fd2894d20201f3ba4aec266585.

The consolidation gives each document a clear responsibility and replaces avoidable repetition with links. It does not aim to remove every repeated hypothesis: a short result summary must retain enough context to prevent an overclaim.

## Document roles

| Document | Editorial role |
|---|---|
| README and README.zh-CN | Synchronized landing pages: project, status, compact exact result, and routes into the subject documents |
| docs/README | Reading routes and the document-responsibility table; maintenance rules for coherent documentation |
| PROJECT_OVERVIEW | Research history, milestones, failed shortcuts, evidence lessons, human–AI assessment, and extension interfaces |
| PROOF_NARRATIVE / STATEMENT_MAP / CONTRIBUTIONS | Full proof, exact formal contracts/declarations, and detailed literature comparison; unchanged in this task |
| REPRODUCIBILITY / PUBLICATION_STATUS / FUTURE_WORK | Executable procedures, public/research responsibility, and planned decisions respectively |
| STATE | Current accepted milestone, actual repository state, pending scope, and next action |
| HANDOFF | Recovery sequence, ownership, and invariants needed after interruption |

CONTRIBUTING, AGENTS, PROTOCOL, the manuscript index and research archive guide keep their existing audience-specific roles. Original Chinese/historical material is retained at its existing paths. The directory structure is not shuffled and mathematical source links are not renamed.

## Root edits and preservation

The English homepage is reduced from 1,287 to 600 whitespace-delimited words. Its full build-command block now has one maintained home in REPRODUCIBILITY. The Chinese page follows the same sections, results and references rather than sending readers primarily into old records. The docs guide adds purpose-specific routes and explicit content ownership.

STATE and HANDOFF are shortened and their stale R112 upload descriptions corrected using the existing push receipt and matching local HEAD/origin-main records. STATE retains a compact baseline and status table; HANDOFF retains recovery rules and mathematical pitfalls without reproducing every prior report or tool diagnostic.

Before editing the five C041 documents, root saved their original bytes at research/frozen/pre_consolidation_20261007/ under the original relative paths. Historical evidence references move to those copies without changing hashes or the old acceptance records. Current operational state files are not frozen evidence entries.

All 762 prior evidence references were verified before changes and remain matched after preservation. The 64 Lean project files, 14 scripts, manuscript directory files, existing output files, and eight designated unchanged core/maintenance documents remain byte-identical. No mathematical experiment, Lean build, manuscript/PDF rebuild, policy search, or licensing/authorship action is performed.

## Delegated editing and review

R117 owns PROJECT_OVERVIEW, PUBLICATION_STATUS and its task report. It must retain unique history, concrete counterexamples and interfaces while directing full proof and execution details to their canonical documents. The publication note retains its dated sources and exact responsibility/rights boundaries without becoming another execution plan.

R118 owns only its bounded review report. It compares final edited documents to the preserved originals, checks the English/Chinese landing-page scope and retained scientific qualifiers, and confirms that the new reading routes are coherent. Neither worker may spawn agents or modify Git/source files.

R117 reduced the overview from 5,011 to 2,450 words and the publication note from 1,340 to 1,019 words while retaining unique content and all five dated policy sources. R118 found no material content or navigation defect. Root checked all 327 local links across 16 English primary documents and the Chinese landing page, including 136 Lean line targets and three heading anchors. All fences are balanced; the previously rejected macros are absent. Full proof/map/contributions/reproduction/future-work documents remain byte-identical.

## Scope and finish

Scientific status remains R058/C031 and v0.4. Novelty U1–U5, human responsibility R093, clean reproduction R095, and the full semigroup formalization have not advanced. The final documentation validation is recorded in results/r116_documentation_validation.json.

After review, root updates records, creates a stable checkpoint, and commits/synchronizes the intended documentation through the existing repository workflow. The actual Git result is recorded separately; source preparation alone is not reported as a successful push. No subsequent research task starts automatically.

The final validation also confirms all 762 prior evidence references, 64 Lean files, 14 scripts, 7 manuscript-directory files, 14 existing output artifacts, and 8 unchanged core/maintenance documents. No source rebuild or online-rendering claim is made. The final commit/push result is recorded separately in ignored output/r116_documentation_release.receipt.json so that the final commit hash is not embedded in its own tree.
