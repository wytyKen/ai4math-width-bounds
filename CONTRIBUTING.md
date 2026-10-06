# Contributing and maintaining the research record

Use English for primary documentation, code comments, and issue reports. Optional Chinese translations are welcome. Preserve original-language historical records and link new translations to their source editions. The public English route starts at [docs/README.md](docs/README.md).

## Report a mathematical or implementation issue

Give the exact commit, file, declaration or statement, relevant assumptions, and a counterexample or failing command when available. Distinguish a problem in the mathematical statement from a dependency/download problem, a proof compilation error, or a documentation mismatch.

For a literature overlap, provide the original source, version, theorem/algorithm number, and the precise overlap. A failed search does not establish novelty. Do not use the issue tracker as evidence that a proposed result has been accepted.

Avoid posting credentials or private material. The repository's recent content audit found no actionable sensitive content within its stated scope, but this does not certify future additions. Review staged files before committing. Normal Git name/email may remain public according to the maintainer's stated preference.

## Make a bounded change

- Keep Lean/mathlib at 4.22.0 and preserve the dependency lock unless a separately scoped migration is intended.
- Use the root uv `.venv` for Python tools and keep caches inside the project.
- Do not use `sorry`, `admit`, custom axioms, or `native_decide` in accepted Lean proofs.
- State whether a result is a conjecture, an experiment, a classical proof, a compiled Lean declaration, or a literature comparison. Internal AI review is not human peer review.
- A changed proof needs evidence for that changed source. Do not reuse an old build log as validation of new bytes.
- Preserve frozen TeX/PDF/ZIP versions. Use a new version for new mathematical milestones.
- If a live document is hashed by an older claim, preserve its old bytes and redirect the historical reference before editing. Keep the old hash; register a new claim for the new document if appropriate.

Task ownership, queues, and checkpoints follow [AGENTS](AGENTS.md) and the [protocol](research/PROTOCOL.md). Read the current STATE/HANDOFF before selecting work. Future-work lists do not automatically authorize every branch.

## Commit and public-release hygiene

Review `git status --short` and the actual staged diff. Stage the intended files explicitly. `.gitignore` excludes common credentials, caches, private directories, downloaded full texts, local checkpoints, and old delivery ZIPs. It does not remove already tracked content or old commits.

`.gitattributes` disables automatic line-ending conversion because historical evidence uses exact bytes. Avoid a repository-wide newline rewrite. Private scratch evidence stays under ignored `tmp/`; publish only safe summaries.

There is no need to reinitialize this repository or remove `lean/.git` in a normal Git clone: the initial nested metadata was already backed up during the first import. The maintained branch is `main`. Remote uploads require the applicable user authorization; do not force-push as a routine synchronization step.

## Correcting a released statement

If a substantive error is found, mark the affected statement and evidence, explain the correction, and retain the previous version. Update the English summary and any maintained translation. A manuscript correction is not complete merely because a code file changed, and a corrected informal argument is not a new Lean build.

No contribution to the repository silently supplies a final paper author list, confirms a person's understanding, or settles reuse rights. Project licensing and a formal author/responsibility record remain separate decisions; see [Publication status](docs/PUBLICATION_STATUS.md).
