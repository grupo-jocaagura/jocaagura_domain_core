# Project handoff

Created on 2026-09-13 at the maintainer's request. Package and planned repository:
`jocaagura_domain_core`; intended owner: `grupo-jocaagura` (confirm after upload).
Workspace: `C:\flutter apps\jocaagura_domain_core`.

## Origin and decisions

Automation and analysis options were adapted from
`grupo-jocaagura/jocaagura_ia` at `7c86891918c921f4385ec005e7c4e17d48fa9776` (PR #18).
That project's `jocaagura_ai` 0.1.0 release proved tag-ref dispatch with OIDC.
Its post-merge workflow also proved the already-published no-op. These are source
references only; they do not certify this new package or its future repository.

The maintainer requested a separate pure Dart domain package to interoperate
between future Jocaagura server apps, reuse the established CI/release discipline,
and introduce documentary certification. The immediate task creates the scaffold
and local Git. The maintainer creates/uploads GitHub and may later grant
qajocaagura admin access; that permission has not been verified or exercised.

## Current boundary

No backend/domain contracts have been extracted yet. `lib/` contains only the
documented library entrypoint. There is no server, Flutter app, runtime dependency,
remote, tag or published version. Version 0.0.1 is a development starting point.
The full CI intentionally cannot pass its executable-code coverage gate until
the first accepted domain implementation exists.

Potential source repositories exist locally under `C:\flutter apps`, including
`jocaagura_domain`, `backend_bienvenido`, and `jocaagura_ia`; their relevance and
actual source contracts must be inspected in the first extraction issue.

## Next task

1. Maintainer uploads the existing Git history, without adding a separate remote
   README/license initialization. Follow `.github/CI_CD.md` for settings.
2. Continue the local issue in `docs/issues/0001-domain-inventory.md` as a GitHub
   issue. Inspect actual shared semantics and propose a bounded first extraction.
3. Implement and test that extraction through develop, with documentation and
   evidence. Create consumer examples and a compatibility/migration plan.
4. Complete internal review and the release checklist before the first manual
   pub.dev publication. A possible bootstrap is 0.0.1; the controlled CP-0 helper
   targets a subsequent, deliberate 0.1.0 promotion. Do not publish the scaffold.
5. Verify this repository's immutable OIDC subject, package settings and actual
   tag-dispatch upload; record real evidence before enabling the post-merge path.

Open this folder as its own Codex project and start with AGENTS.md plus this file.
The original repository remains an independent source, not a workspace to mutate
as part of ordinary work on this package.
