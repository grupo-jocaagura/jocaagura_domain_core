# CI and releases

## Local scaffold and GitHub setup

The package is not published and this repository has no remote configured.
The maintainer will upload it as `grupo-jocaagura/jocaagura_domain_core`.
If the owner changes, update the repository constant, pubspec, workflow guards,
tests and documentation before enabling publishing.

Use `develop` as the default branch and `master` for release promotions. Both
local branches start at the initial scaffold commit. Enable Actions and CodeQL
for Actions, set COVERAGE_MIN=95 (the checked default), and require `CI result`
and the relevant CodeQL checks on PRs. Require verified commits, reject force
pushes, and protect `v*` tags against updates/deletion. Add the signing public key
to the committer's GitHub account if needed; local signing does not guarantee
GitHub Verified. Branch/ruleset permissions must allow the existing signed
version-preparation workflow without bypassing master release protections.

No PAT, external service, service account or persistent pub.dev credential is used.
The maintainer's planned admin grant to qajocaagura is not assumed to exist yet.

## Workflows

- Dart CI: PRs targeting develop/master and pushes to those branches; manual and
  reusable execution retained. Feature push duplication is avoided. A push to
  develop with an open release PR can still validate both branch and integration.
- Base validation: GitHub verified commit signatures, SDK-only metadata, workflow
  tests/lint, Dart format and strict analysis.
- CodeQL: security analysis of Actions YAML, not Dart code; PR, protected branch
  push, manual and weekly execution.
- Prepare version: atomic signed version/changelog preparation on develop with
  expected-head protection and deterministic retries.
- Prepare promotion: explicit minor/major bump and consolidated patch history.
- Release after master merge: exact official merged PR, CP-0 evidence, public
  version eligibility, dry run/full CI, immutable tag and tag-ref dispatch.
- Publish package: human tag push fallback or CP-0-approved dispatch; rechecks
  provenance and full CI, uses Dart OIDC, then records a GitHub release.
- CP-0 controlled publication: manually authorized real 0.1.0 experiment after
  an earlier manual bootstrap; no placeholder/test version is uploaded.
- Documentary certification: validates the draft or approved evidence manifest.

The empty library has no executable lines. The inherited >=95% coverage gate
remains intact and therefore blocks full CI until real tested domain code exists.
The boundary test and Python workflow tests may pass without certifying a release.

## Release discipline

Prepare development patches with meaningful notes. Before a public release, run
Prepare promotion on develop with an exact from_version and minor/major choice.
For example, 0.0.3 -> 0.1.0 consolidates the recorded development patches. Keep
the source version for retries; a changed branch head requires replanning.
Open develop -> master, pass checks, and merge only the verified candidate.

The first publication must be manual after the real API and documentation are
ready. Configure pub.dev GitHub publishing for this repository, tag pattern
`v{{version}}`, push and workflow_dispatch, and no environment requirement for
the current workflow design. Verify settings rather than copying old evidence.

CP-0 starts pending. See CP0_AUTOMATED_PUBLISHING.md. The post-merge planner
fails closed until package-specific evidence is passed; this is intentional.
The controlled experiment targets unpublished 0.1.0 after manual bootstrap.

Already-published eligible minor/major versions skip upload and leave the tag
unchanged. API/authentication errors, regressions, conflicting tags, stale master
or invalid provenance block publication. Never move tags to recover a failure.
Retry a dispatch with its matching immutable tag; inspect the actual publisher
before declaring success. A successful API dispatch is not an uploaded package.
If only GitHub Release creation fails after pub.dev success, recover that step
without uploading again.

A merge made with GITHUB_TOKEN may not trigger push workflows; use the existing
manual Release after master merge dispatch on current master when necessary.
Do not introduce alternate credentials to trigger it.
