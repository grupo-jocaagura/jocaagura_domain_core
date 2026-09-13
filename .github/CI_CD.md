# CI and releases

## Repository setup

Manual 0.0.2 publication is complete. Canonical repository:
`grupo-jocaagura/jocaagura_domain_core`; default branch develop. Bootstrap #1 is
closed; issue #3 owns the selected 0.0.4 checkpoint and 1.0.0 real CP-0 test.
Both develop and master exist remotely. Historical bootstrap inspection remains
in the dated reports, not as current configuration instructions.

At issue #3 start, rulesets 23191367 (branches), 23211846 (authorized version-tag
creation) and 23211845 (immutable tags) are active. The accepted branch policy
requires PRs, signatures, current base and CI result / Analyze GitHub Actions /
documentation. No broad bypass is authorized. Reinspect full effective rules
before each operation; a list of active rulesets alone is not proof of all rules.

`COVERAGE_MIN` is an Actions repository variable, currently set by the maintainer
to `96`. The workflow uses `${{ vars.COVERAGE_MIN || '95' }}` and validates values
between 95 and 100. Preserve the configured 96% requirement per package and
combined; the 95% fallback is a policy floor, not a measured result.

No PAT, external service, service account or persistent pub.dev credential is used.
Built-in `GITHUB_TOKEN` authorizes GitHub operations such as creating a tag,
dispatching a workflow or recording a GitHub release. GitHub-issued OIDC
authenticates automated publication to pub.dev; `GITHUB_TOKEN` is not a pub.dev
publishing credential. Keep these roles separate when configuring permissions.
The observed default Actions token permission is `read`; token-based approval
of PR reviews is disabled. Review the default against explicit job permissions
before release operations. Do not enable coupled Actions PR creation/approval;
the environment rejected that change. Verified access alone is not authorization.

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
- CP-0 controlled publication: manually authorized real 1.0.0 experiment after
  an earlier manual bootstrap; no placeholder/test version is uploaded.
- Documentary certification: validates the draft or approved evidence manifest.

The initial empty library correctly failed the coverage gate. The first `Utils`
and `Unit` extraction adds real executable behavior and contract tests; measure
its coverage through the unchanged workflow. The boundary test and Python tests
alone do not substitute for that coverage or certify a release.

## Release discipline

Keep one Unreleased section with substantive notes. After ordinary PR integration
and full CI, use Prepare version to materialize the selected 0.0.4 directly; an
artificial 0.0.3 release is unnecessary. Do not upload 0.0.4. Then use Prepare
promotion with from_version=0.0.4 and bump=major to compute 1.0.0 and consolidate
notes. Do not hand-edit pubspec to bypass preparation. Open the official
same-repository develop -> master PR, pass checks and merge the verified candidate.

Version preparation writes directly to develop. Where protected rules conflict,
use only the maintainer-authorized supervised window: validate exact head/version
and passing CI; snapshot rules; change only indispensable develop restrictions;
retain signatures and all master protections; run the existing Action; restore
rules on success/failure and verify effective state. Never disable a shared rule
or bypass failing CI. Environment rejection requires maintainer intervention.

Release authorization and publication are separate steps. After the official
same-repository release PR is merged, automated publication must run on a
protected, immutable tag pointing to that exact release commit on `master`.
The tag version, `pubspec.yaml` version and `v{{version}}` pattern must agree.
A push to `master` alone cannot publish. The existing publisher supports a
human-pushed tag or `workflow_dispatch` on the tag; branch dispatch is rejected.

The first manual publication (0.0.2) is complete. Verify pub.dev GitHub publishing for this repository, tag pattern
`v{{version}}`, push and workflow_dispatch, and no environment requirement for
the current workflow design. Verify settings rather than copying old evidence.

CP-0 passed for the actual 1.0.0 OIDC upload; see CP0_AUTOMATED_PUBLISHING.md
and evidence/cp0-1.0.0.json. The post-merge planner still fails closed without
valid package-specific evidence. The controlled 1.0.0 experiment is complete
and must not upload that version again. Active tag-creation rules still apply
to future releases; no permanent automation bypass was introduced.

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
