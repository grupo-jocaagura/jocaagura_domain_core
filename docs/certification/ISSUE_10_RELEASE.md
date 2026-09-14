# Issue #10 release evidence

Status: PREPARED; publication evidence pending. This supplements the reviewed
[implementation certificate](ISSUE_10_CORE.md) and [maintainer review](ISSUE_10_REVIEW.md).
It does not claim an upload, final release tag or completed issue.

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
SHA-256: `aa24e5cf5de9998fa004b05ecb13fd14a21e5b4dd8883bf28f6eb073aff1e3b9`.

The release candidate also incorporates the existing master history through a
signed merge and ordinary PR into develop, preserving strict current-base checks.
No product diff is introduced by that history synchronization.

Pending evidence: official reviewed develop-to-master release PR and final checks,
exact immutable v1.1.0 tag, actual ordinary OIDC publication, downloaded archive
integrity/privacy and publication attribution. CORE-REL remains pending until
those facts exist. The successful 1.0.0 CP-0 evidence is preserved as its own
historical record and is not copied as new-release success.
