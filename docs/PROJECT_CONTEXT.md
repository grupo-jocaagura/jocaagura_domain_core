# Project handoff

Created on 2026-09-13 at the maintainer's request. Package:
`jocaagura_domain_core`; verified repository: `grupo-jocaagura/jocaagura_domain_core`.
Workspace: `C:\flutter apps\jocaagura_domain_core`.

## Origin and decisions

Automation and analysis options were adapted from
`grupo-jocaagura/jocaagura_ia` at `7c86891918c921f4385ec005e7c4e17d48fa9776` (PR #18).
That project's `jocaagura_ai` 0.1.0 release proved tag-ref dispatch with OIDC.
Its post-merge workflow also proved the already-published no-op. These are source
references only; they do not certify this package or its repository configuration.

The maintainer requested a separate pure Dart domain package to interoperate
between future Jocaagura server apps, reuse the established CI/release discipline,
and introduce documentary certification. The maintainer uploaded the scaffold;
authenticated GitHub inspection verified `qajocaagura` admin access and valid
signatures on both uploaded commits. [Bootstrap issue #1](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/1)
now tracks configuration and documentation. The issue was created by that account.

The maintainer chose `0.0.1` as the unpublished documentary baseline, with
bootstrap changes under `Unreleased` for a later `0.0.2` action-driven development
bump. Keep existing validation and coverage policy intact. README and changelog
structure follow the local `jocaagura_ia` references, without copying its APIs or
certification claims. Certification review follows the issue contract; maintainer
review or a named review artifact can satisfy it without additional gates.

## Current boundary

The maintainer added `Utils` and `Unit`/`unit` from the local `backend_bienvenido`
checkout to bootstrap issue #1. They are exported by the public entrypoint, with
characterization and edge-case tests. There is no server, Flutter app or runtime dependency.
Version 0.0.1 is a development starting point, not a published release.
The first bump attempt failed on the original empty-library coverage gate.
The extraction adds real measurable behavior while preserving that gate.
`Prepare version` still requires passing full CI on integrated `develop`.
See [the extraction record](certification/UTILS_EXTRACTION.md) for provenance,
results, compatibility and pending migration; GitHub issue #1 tracks run/PR state.

At the documentation-stage inspection, remote `master` was missing and the
empty-library CI failed coverage despite passing base validation, CodeQL and
draft documentation checks. The maintainer configured `COVERAGE_MIN=96` and a branch ruleset that
prevents deletion and force pushes. Required PRs, checks, signatures and tag
protection remain pending. See [the dated bootstrap review](BOOTSTRAP_REVIEW.md)
for exact evidence and the review workspace.

Potential source repositories exist locally under `C:\flutter apps`, including
`jocaagura_domain`, `backend_bienvenido`, and `jocaagura_ia`; their relevance and
actual source contracts must be inspected in the first extraction issue.

## Next task

1. The maintainer reviewed the bootstrap diff and authorized commit, push, a PR
   into `develop`, and an attempt to prepare `0.0.2` through Actions. Track the
   resulting commit, PR and workflow outcome in canonical GitHub issue #1; leave
   it open while configuration or integration acceptance items are pending.
   Follow `.github/CI_CD.md` and `docs/BOOTSTRAP_REVIEW.md` for remaining settings.
2. Continue the separate local proposal in `docs/issues/0001-domain-inventory.md`
   as a GitHub issue. Inspect actual shared semantics and propose a bounded first
   extraction. Once promoted, link that issue from the proposal and maintain
   issue state only on GitHub; its local filename does not refer to bootstrap #1.
3. The source repository is read-only for this extraction. No branches, source
   files or dependencies in `backend_bienvenido` may be changed. Future migration
   must handle the nominal identity of `Unit` and shared imports consistently.
4. After the extracted helpers pass full CI and integrate, prepare the planned development bump
   through Actions. Complete the issue-required review and release checklist
   before the first manual pub.dev publication; select that version deliberately
   when the package is ready. The controlled CP-0 helper targets a subsequent,
   deliberate 0.1.0 promotion. Do not publish the scaffold.
5. Verify this repository's immutable OIDC subject, package settings and actual
   tag-dispatch upload; record real evidence before enabling the post-merge path.

Open this folder as its own Codex project and start with AGENTS.md plus this file.
The original repository remains an independent source, not a workspace to mutate
as part of ordinary work on this package.
