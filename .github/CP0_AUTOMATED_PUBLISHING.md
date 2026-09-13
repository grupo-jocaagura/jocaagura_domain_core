# CP-0: package-specific automated publishing verification

Status: PASSED for the real 1.0.0 upload on 2026-09-13. The exact official release
commit is eec39c68daef102e2d52009e6bd2f015063ed473, immutable tag v1.0.0, controlled
run 34788211069. The downloaded archive/hash and maintainer-provided pub.dev audit
entry match. See [package-specific evidence](evidence/cp0-1.0.0.json) and the
[release review](../docs/certification/ISSUE_3_RELEASE.md).

The procedure below records the completed experiment and its safeguards. Do not
repeat it with 1.0.0: the existing version must never be uploaded again. Future
ordinary releases require their own deliberate promotion and release provenance.

The source package proved the mechanism, but identity and authorization are
specific to a repository/package. The template expects immutable OIDC subject
claims, using repository and owner IDs supplied by GitHub. Verify the new
repository's actual OIDC subject settings before executing the experiment.
Custom subjects or a required GitHub environment require deliberate adaptation.
Built-in `GITHUB_TOKEN` is used for GitHub operations only; GitHub-issued OIDC
authenticates the upload to pub.dev. Restrict version-tag creation to authorized
release actors and prevent updates/deletion without a broad automation bypass.

## Procedure after the domain is release-ready

1. Verify the earlier manual 0.0.2 publication and that 1.0.0 is absent.
2. Configure GitHub publishing for grupo-jocaagura/jocaagura_domain_core,
   v{{version}}, push and workflow_dispatch. Record the actual admin settings.
3. Prepare the real 1.0.0 promotion in CI and merge develop -> master after checks.
4. Create immutable v1.0.0 on the exact merged release SHA using an authorized
   tag creator. If using prepare-tag on develop, first satisfy the accepted
   supervised maintenance-window policy; its built-in token has no broad bypass.
5. Only with explicit release authorization, dispatch the same workflow on
   v1.0.0 with operation=publish, expected_sha and confirmation
   `publish jocaagura_domain_core 1.0.0`.
6. Inspect full CI, the sanitized OIDC claim summary, actual upload, public API,
   archive contents/hash and pub.dev activity-log attribution. Never record JWTs.
7. Update evidence/cp0-1.0.0.json in a reviewed PR: passed, this package/repository,
   version, actual observed_claims, and audit_log_attribution with matching run_id,
   sha and this package's activity-log URL. Attach settings and service evidence.
8. Integrate through develop -> master and verify already_published without
   touching the existing tag. Observe the next deliberate promotion end to end.

Record issuer, audience, event_name, ref_type, ref, repository/owner names and IDs,
sub, sha, run_id, run_attempt, workflow_ref and environment from the actual run.
If authorization fails, leave CP-0 pending and automatic post-merge publishing
blocked. The fallback is an explicitly human-pushed release tag after checks.
No PAT, service account, external service or alternate credential is permitted.
Never replace or delete a published tag. Synthetic test fixtures are not evidence.
