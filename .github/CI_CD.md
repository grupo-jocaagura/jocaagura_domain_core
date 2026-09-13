# CI and releases

## Repository setup

The package is not published. Its canonical GitHub repository is
`grupo-jocaagura/jocaagura_domain_core`, with `develop` as the default branch.
Authenticated API inspection on 2026-09-13 verified `qajocaagura` administrator
access and GitHub verification of both uploaded scaffold commits. See
[the bootstrap review](../docs/BOOTSTRAP_REVIEW.md) and
[issue #1](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/1).
If the owner changes, update the repository constant, pubspec, workflow guards,
tests and documentation before enabling publishing.

Use `master` for release promotions; it currently exists only locally. Actions
and CodeQL for Actions are enabled and have executed. The active `protect branches`
ruleset (`23191367`) rejects deletion and force pushes for the default branch,
`develop` and `master`. It has no bypass actors, required PRs, required checks or
required signatures. No tag ruleset was observed. These are remaining setup
items, not completed protections.

Complete the required PR/check/signature rules, including `CI result` and the
relevant CodeQL checks. Restrict creation of `v*` tags to authorized release
actors, and protect those tags against updates/deletion. Record the actual check
names, permitted tag creators and review policy. Permissions must allow the existing signed
version-preparation workflow without bypassing `master` release protections.
Prove the permitted workflow path before marking that integration complete.

`COVERAGE_MIN` is an Actions repository variable, currently set by the maintainer
to `96`. The workflow uses `${{ vars.COVERAGE_MIN || '95' }}` and validates values
between 95 and 100. Preserve the configured 96% requirement per package and
combined; the 95% fallback is a policy floor, not a measured result.

No PAT, external service, service account or persistent pub.dev credential is used.
Built-in `GITHUB_TOKEN` authorizes GitHub operations such as creating a tag,
dispatching a workflow or recording a GitHub release. GitHub-issued OIDC
authenticates automated publication to pub.dev; `GITHUB_TOKEN` is not a pub.dev
publishing credential. Keep these roles separate when configuring permissions.
The observed default Actions token permission is `write`; token-based approval
of PR reviews is disabled. Review the default against explicit job permissions
as part of issue #1. Verified account permissions do not authorize publication.

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

The initial empty library correctly failed the coverage gate. The first `Utils`
and `Unit` extraction adds real executable behavior and contract tests; measure
its coverage through the unchanged workflow. The boundary test and Python tests
alone do not substitute for that coverage or certify a release.

## Release discipline

The unpublished documentary baseline is `0.0.1`. Keep bootstrap changes under
the single `## Unreleased` heading for a planned `0.0.2` development bump through
`Prepare version`. That workflow requires full CI; the extracted implementation
must pass that gate and be integrated into `develop` before the bump is retried.
Do not lower coverage or change metadata validation to accommodate `0.0.0`.

Prepare development patches with meaningful notes. Before a public release, run
Prepare promotion on develop with an exact from_version and minor/major choice.
For example, 0.0.3 -> 0.1.0 consolidates the recorded development patches. Keep
the source version for retries; a changed branch head requires replanning.
Open develop -> master, pass checks, and merge only the verified candidate.

Release authorization and publication are separate steps. After the official
same-repository release PR is merged, automated publication must run on a
protected, immutable tag pointing to that exact release commit on `master`.
The tag version, `pubspec.yaml` version and `v{{version}}` pattern must agree.
A push to `master` alone cannot publish. The existing publisher supports a
human-pushed tag or `workflow_dispatch` on the tag; branch dispatch is rejected.

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
