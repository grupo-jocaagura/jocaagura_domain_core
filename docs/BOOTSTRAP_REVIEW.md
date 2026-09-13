# Bootstrap review and reproducible handoff

Date: 2026-09-13. Status: maintainer reviewed the documentation diff and requested
four final clarifications before authorizing commit, push, a PR into `develop`
and the `0.0.2` Actions bump attempt. Issue #1 tracks execution and remains open.
This is a repository setup record, not an approved
domain certification or completed release.

Issue: [#1 — Bootstrap](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/1).
Base commit: `821137db2ed450aec33d38e37254dc34f15043d7` on `origin/develop`.
Implementation commit, PR and subsequent workflow results: recorded in canonical
GitHub issue #1 at submission. This document records the reviewed scope and
local validation; it does not maintain a second issue state.

## Review workspace and accepted scope

Branch: `jocaagura/issue-1-bootstrap`.
Worktree: `C:\flutter apps\jocaagura_domain_core\.local\worktrees\issue-1-bootstrap`.
The main checkout's existing README, changelog and version edits were left intact.
The worktree retains the accepted `0.0.1` documentary baseline; `Unreleased`
records the improvements intended for a later `0.0.2` development bump.

From this worktree, use `git status --short`, `git diff --check` and `git diff`
to inspect any remaining local changes, and use the PR diff for committed work.
No changes were made to production code, tests, workflows,
release validation, analysis options or the certification manifest.

README structure and changelog conventions were inspected in the local
`C:\flutter apps\jocaagura_ia\README.md` and `CHANGELOG.md`, whose checkout HEAD
was `b11787080b5424ec07adeadf9ac3854868f58bf6`. This identifies the inspected
checkout; it does not certify that its working files are byte-identical to HEAD.
The source API, platform claims, coverage results and passed CP-0 were not copied.

## Verified repository state

Read-only queries used GitHub CLI authenticated as `qajocaagura` against
`grupo-jocaagura/jocaagura_domain_core`. No credentials are included in this record.

| Check | Observation |
| --- | --- |
| Identity and access | Authenticated `qajocaagura`; collaborator permission `admin`, with push/pull rights. Issue #1 was created successfully by this account. |
| Repository | Public; default branch `develop`; HTTPS origin matches the canonical repository. |
| Uploaded signatures | GitHub reports `verified=true`, `reason=valid` for `2577f1186ebd8d0bd56c2ea915952199d0e5b84c` and the base commit above. |
| Local signing | Earlier in this bootstrap investigation, before the no-commit review instruction, a fresh signed commit in a separate temporary diagnostic repository passed `git verify-commit`. Nothing from that probe was pushed or added to project history. |
| Coverage variable | `COVERAGE_MIN=96`, updated `2026-09-13T17:06:38Z`; the workflow policy floor/fallback remains 95. |
| Branch ruleset | [23191367, protect branches](https://github.com/grupo-jocaagura/jocaagura_domain_core/rules/23191367), active; targets default branch, `develop` and `master`; deletion and non-fast-forward rules only; no bypass actors. |
| Remaining branch settings | No required PR, required checks or signature rule in the observed ruleset. `develop` reports protected; remote `master` does not yet exist. |
| Tag rulesets | None observed. |
| Actions | Enabled, allowed actions `all`; default workflow permission `write`; token approval of PR reviews disabled. |

Reproduce the remote inspection with `gh api user`,
`gh api repos/grupo-jocaagura/jocaagura_domain_core/collaborators/qajocaagura/permission`,
`gh api repos/grupo-jocaagura/jocaagura_domain_core/branches`,
`gh api repos/grupo-jocaagura/jocaagura_domain_core/rulesets/23191367`, and
`gh variable list --repo grupo-jocaagura/jocaagura_domain_core`.
On this host GitHub CLI is installed at `C:\Program Files\GitHub CLI\gh.exe`.
Re-query before changing settings; this table is a dated observation.

## Remote CI evidence at the base commit

- [Dart CI 34769742500](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34769742500):
  base validation passed, including signatures, automation tests, workflow lint,
  formatting and strict analysis. Tests passed; coverage enforcement and
  `CI result` failed. This run predates the variable update and used 95.
- [CodeQL 34769742211](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34769742211):
  passed for Actions analysis, not Dart security analysis.
- [Documentary certification 34769742245](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34769742245):
  passed draft structure validation. The domain manifest is still draft.

These runs cover the uploaded base, not the subsequent documentation changes.
[LOCAL_VERIFICATION.md](LOCAL_VERIFICATION.md) preserves the earlier local record.

## Release and review decisions

The maintainer retained `0.0.1` to avoid changing the validator's rejection of
`0.0.0`. The planned `0.0.2` bump is not executed: `Prepare version` requires full
CI, and coverage remains unmeasurable for an empty library. Only a meaningful
accepted domain implementation can satisfy that dependency; bootstrap must not
fabricate executable code, lower the threshold or bypass required checks.

An official same-repository `develop -> master` PR authorizes a release.
Automated publication must run on a protected, immutable version tag pointing
to the exact release commit. Tag, pubspec version and publishing pattern must
match. Keep both tag push and `workflow_dispatch` on a tag; configure and verify
dispatch for this package later. Restrict version-tag creation to authorized
release actors as well as preventing updates/deletion. `GITHUB_TOKEN` authorizes
GitHub operations; GitHub-issued OIDC authenticates pub.dev uploads.
The [pub.dev maintainer discussion](https://github.com/dart-lang/pub-dev/issues/8507)
confirms support for dispatch, and the source package records that mechanism.
Neither source replaces this package's pending CP-0 evidence.

Certification review is the review required by the issue. Maintainer review or
a named review artifact can satisfy that contract; the existing reviewer/date
fields record who actually reviewed it. No additional approval, agent or gate
is introduced. The domain manifest must remain draft until its own evidence
and review are complete.

## Local validation of this documentation diff

Environment: Windows x64, Dart 3.13.2, Python 3.13. Git Bash executes the existing
workflow-script tests. Commands below ran from the review worktree.

| Command/check | Result |
| --- | --- |
| `python .github/scripts/release_policy.py --metadata-only` | Passed; package identity and documentary version `0.0.1` accepted. |
| `python tool/verify_documentation.py` | Passed; status remains `draft`. |
| `python -m unittest discover -s .github/scripts/tests -q` | 59 tests passed, including release/version tooling, coverage boundaries and documentary validation. Synthetic service fixtures are not real publication evidence. |
| `dart pub get --offline` | Passed using cached dependencies. |
| `dart format --output=none --set-exit-if-changed .` | Passed; 2 Dart files checked, none changed. |
| `dart analyze --fatal-infos --fatal-warnings .` | Passed; no issues. |
| `dart test` | 1 boundary test passed. |
| Local Markdown links and changelog headings | No broken local links in changed documents; one `Unreleased`, one `0.0.1` baseline and no `0.0.2` version heading. |
| `git diff --check` | Passed. |
| Scope comparison against the base | Pubspec remains `0.0.1`; production code, tests, workflows, validation scripts, analysis options and certification manifest are unchanged. |

The initial sandboxed Python run failed because Windows denied Git Bash signal
pipes/shared memory and temporary-file operations. Dart dependency resolution
completed, but writing SDK telemetry state was also denied. Repeating with the
necessary execution permissions passed the checks above without repository
code or test changes. Actionlint was not rerun for this documentation-only diff;
its earlier remote result is linked above. No new full CI, coverage measurement,
protected PR integration or real publishing run is claimed.

The final review reran metadata/draft validation and the 59 automation tests.
A pre-commit `dart pub publish --dry-run` inspected the package without uploading;
it reported the expected warning for modified README/changelog files. Repeat
that command from the clean signed commit and record its outcome on issue #1.

## Outstanding work and owners

- Bootstrap submission: apply the four reviewed clarifications (tag creation,
  OIDC/token roles, canonical GitHub Issues and Dart-only tooling), then execute
  the authorized signed commit, push, PR and version-preparation attempt. Record
  actual outcomes on issue #1; never claim a successful bump from dispatch alone.
- Bootstrap implementation, tracked in issue #1: establish remote `master`,
  complete required PR/check/signature and tag creation/update/deletion rules,
  and resolve the least-
  privilege Actions/version-preparation path with real evidence. Administrator
  access or a plausible configuration is not proof of a successful protected PR.
- Domain inventory/extraction work: continue
  [the local inventory proposal](issues/0001-domain-inventory.md), identify actual
  consumers and implement a bounded contract with meaningful tests and coverage.
- Later release work: choose a release-ready first manual publication, configure
  this package's pub.dev/OIDC settings, and execute CP-0 with actual service
  evidence before enabling automated dispatch publication.

Issue #1 cannot be closed as fully integrated while those required acceptance
items remain unresolved. Publication and domain certification remain separate.
