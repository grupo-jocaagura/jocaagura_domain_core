# Issue #10 release evidence

Status: PASSED; actual 1.1.0 publication and archive verified. This supplements the reviewed
[implementation certificate](ISSUE_10_CORE.md) and [maintainer review](ISSUE_10_REVIEW.md).
This is internal documentary certification, not independent accreditation.

Implementation PR #11 merged into develop at `3cd69ef1a51938a456180a40088fd858423a39de`.
Required [Dart CI](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34859412339),
CodeQL and documentary checks passed before the merge. The reviewed product
implementation remains `8d6e4fc`; subsequent changes are evidence, merge history
and Action-prepared version/changelog metadata only.

| Preparation | Exact source | Signed result | Actual Action |
| --- | --- | --- | --- |
| Checkpoint 1.0.1 | `3cd69ef1a51938a456180a40088fd858423a39de` | `acc149b8c8adede37c51761ccdb7b6ac6e42f00d` | [34861251550](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34861251550) |
| Minor promotion 1.1.0 | `acc149b8c8adede37c51761ccdb7b6ac6e42f00d` | `4ef4c0ad9404ffd754b662e37c54a84a2a691300` | [34861540597](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34861540597) |

Both existing Actions passed their actual signatures, analysis, tests and coverage
before creating a GitHub-verified commit changing only pubspec.yaml and CHANGELOG.md.
No public version was hand-edited; no workflow or runtime change was introduced.

The maintainer explicitly authorized two supervised develop windows. A temporary
rule retained required signatures and deletion/non-fast-forward protection while
the shared PR/status requirements applied to master. After each Action, the
original shared rules were restored, the overlay removed, and effective develop,
master and both tag rulesets compared with the original snapshots. All comparisons
passed. No bypass actor was added; tag creation/update/deletion rules never changed.
The initial invalid condition attempt also restored cleanly before any dispatch.

Machine evidence: [issue_10_release_checks.json](issue_10_release_checks.json).
SHA-256: `f699691b9a22693c84b1b4478525b6885c2293965f3bcbce0128abad4d417cfa`.

The release candidate also incorporates the existing master history through a
signed merge and ordinary PR into develop, preserving strict current-base checks.
No product diff is introduced by that history synchronization.

## Actual reviewed release and publication

The maintainer explicitly authorized the release merge, immutable tag and OIDC
publication on 2026-09-14, after reviewing the complete corrected candidate.
[Official PR #13](https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/13)
merged develop into master at `942c4bb3bc68c22c5087e0e65f050456b71fc63c`.
Final-head [CI and release readiness](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34862372969),
[CodeQL](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34862372346)
and [documentation](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34862372219)
passed. Library and test files still match reviewed implementation `8d6e4fc`.

Signed annotated tag `v1.1.0`, object `5f9a35ee0ea55751fc1266f3b4570bdb84129512`,
points to that exact release merge. User qajocaagura pushed it using the existing
authorized administrator creation exemption. No actor or rule was added; tag
update/deletion protection was unchanged. All original effective branch and tag
protections were checked again after publication and matched the saved snapshots.

[Ordinary OIDC publisher run 34863152318](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34863152318)
completed successfully for the tag push. Its actual
[upload job](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34863152318/job/104040963755)
ran `dart pub publish -f` and received the pub.dev upload confirmation.
The existing reusable publisher also provisioned a Flutter SDK; the package's
validation and upload commands used Dart, with no Flutter package dependency or
workflow change. [Follow-up dispatch 34863352678](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34863352678)
detected the published version and skipped upload. No version was uploaded twice.

| Actual published artifact check | Result |
| --- | --- |
| pub.dev version metadata | 1.1.0, published 2026-09-14T15:38:51.509317Z |
| Downloaded archive | 43 files, 59,603 bytes; SHA-256 matches pub.dev metadata |
| File integrity | Every archive file byte-matches immutable release commit `942c4bb` |
| Boundary and privacy | SDK-only runtime; intended exports; no restricted source identity/root/revision match or excluded tooling/build files |
| Tests from downloaded archive | Offline pub get and all 239 Dart tests passed; no failures/skips |
| Protection restoration | Original effective develop/master and both tag rulesets match; temporary overlays absent |

Archive SHA-256:
`f40eb1218bc333900f426605cba2d6b71e21d0e0bad84ae1a681ec5553c1b4bb`.
The machine record preserves actual verification/test timestamps and per-file
hashes. Published package: [pub.dev 1.1.0](https://pub.dev/packages/jocaagura_domain_core/versions/1.1.0).
GitHub release: [v1.1.0](https://github.com/grupo-jocaagura/jocaagura_domain_core/releases/tag/v1.1.0).

Attribution is the successful GitHub OIDC upload job correlated with the exact
immutable tag/commit and pub.dev metadata/archive. The private pub.dev activity-log
UI required a signed-in session and was not independently read; no private audit
entry is claimed. Historical 1.0.0 CP-0 evidence remains unchanged and is not
relabeled as 1.1.0 evidence. CORE-REL is now supported by actual release facts.
