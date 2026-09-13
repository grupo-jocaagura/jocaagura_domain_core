# Release verification record: issue #3

This record supplements ISSUE_3_REVIEW.md with actual version and release evidence.
The stable runtime scope is Utils (30 helpers), Unit.value and unit. The inventory
and draft DTO studies do not add runtime classes or certify future migrations.

## Actions preparation and official release

| Operation | Exact source | Verified result | Action |
| --- | --- | --- | --- |
| Prepare version 0.0.4 | d0dfdb10e43859559068a233341452b1a19360c3 | 0a49cba51aafbd6c20d61d3ffd2b512f68b17561 | [34787086695](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34787086695) |
| Prepare promotion, from_version=0.0.4, bump=major | 0891a6e956a14b8a0ba0edcc1dfd854004a25089 | 25ea5285dd3da2ab1bc7215c67d136004fbb05dd (1.0.0) | [34787549047](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34787549047) |

Both Actions generated GitHub-verified commits and substantive changelog notes.
The historical baseline note format was corrected through [PR #5](https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/5)
before promotion. Source compatibility was supplemented in [PR #6](https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/6).
Neither preparation uploaded 0.0.4 or hand-edited the public version.

Both supervised branch windows retained signature, deletion and non-fast-forward
rules on develop and all existing master/tag protections. They temporarily scoped
the shared PR/status rules to master, then restored the original shared rules,
removed the temporary develop overlay and compared all branch/tag/Actions settings
with the captured originals. Restoration passed in both cases. No bypass actor or
Actions PR-approval permission was added. The earlier rejected GitHub API request
started no Action and also restored the original settings.

Official same-repository [release PR #7](https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/7)
merged develop `4408ba42d50d78e34a7573950ea1ed2f46155dab` into master at
`eec39c68daef102e2d52009e6bd2f015063ed473` on 2026-09-13T22:53:04Z.
Its [Dart CI and release readiness](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788002578),
[Actions analysis](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788002325)
and [documentary integrity](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788002319)
passed. The 1.0.0 dry-run had zero warnings, 15 intended files and a 31 KB archive.

The exact merge passed [Dart CI](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788087627),
[Actions analysis](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788087629)
and [documentary integrity](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788087614).
The ordinary [post-merge dispatcher](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788087854)
failed closed because completed package-specific CP-0 evidence was required. Its
check was preserved; the authorized controlled experiment handles this first
OIDC publication.

## Controlled publication

[Tag preparation run 34788164489](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788164489)
created `v1.0.0` at `eec39c68daef102e2d52009e6bd2f015063ed473` using the built-in
GitHub token. The supervised window excluded only this exact tag from the creation
rule. The separate immutable-tag rule remained active with no bypass throughout.
All three original rulesets were restored and compared successfully afterward.
The tag-preparation Action requested no upload and dispatched no publisher.

[Controlled publication run 34788211069](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34788211069)
was dispatched on `v1.0.0` with the exact release SHA and explicit real-publication
confirmation. It passed full CI, validated the sanitized OIDC claims, rechecked
unpublished eligibility immediately before upload and published successfully.
The service timestamp is 2026-09-13T22:57:43.326233Z. No persistent pub.dev
credential, PAT or service account authenticated the upload.

The observed issuer is GitHub Actions, audience https://pub.dev, event
workflow_dispatch, ref refs/tags/v1.0.0, run attempt 1, owner ID 193098028 and
repository ID 1368617594. The immutable subject binds those IDs and the tag; no
environment claim is present. Exact allowlisted claims and service metadata are
in [.github/evidence/cp0-1.0.0.json](../../.github/evidence/cp0-1.0.0.json).

The independently downloaded public archive is 32,391 bytes. Its SHA-256 matches
the pub.dev API and the workflow service summary:
`2ca5cdd1f237e3699f13348b924f023cef5ef3615d3e245d96634973b2dacd28`.
All 15 expected files match Git objects from the release commit after newline
normalization. The exact file list is in the evidence JSON. The archive contains
no inventory/tooling/local evidence directories; production dependencies remain
SDK-only. Its vetted public text contains no restricted source identifiers.

The maintainer copied the real [pub.dev activity-log](https://pub.dev/packages/jocaagura_domain_core/activity-log)
entry into this task on 2026-09-13. It attributes jocaagura_domain_core 1.0.0,
owned by publisher jocaagura.com, to GitHub Actions run 34788211069 and revision
eec39c68daef102e2d52009e6bd2f015063ed473 in the official repository. This is
maintainer-supplied service evidence, not a claim that Codex's browser had admin
access. The service summary says "triggered by pushing revision"; the actual
validated OIDC event is workflow_dispatch. The run and SHA agree.

## Review and completion boundary

Codex author review on 2026-09-13 compared the actual tag, merged PR, successful
workflow, allowlisted claims, public metadata, downloaded archive and maintainer's
audit entry. CP-0 is passed for this package and this actual upload. Documentary
approval remains internal and limited to implemented Utils/Unit, the inventory
and the reviewed migration plan. Address/ErrorItem contracts remain draft;
Either and other candidates remain unimplemented, with SRC-B Either prioritized.

The evidence follow-up must integrate through ordinary protected PRs. Any
already-published recovery must perform no upload and leave v1.0.0 unchanged.
The next deliberate promotion is separate work; no second upload of 1.0.0 is
permitted. Future automated tag creation must still satisfy the active creation
policy; this controlled experiment grants no permanent broad automation bypass.
