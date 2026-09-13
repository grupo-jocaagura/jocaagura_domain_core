# CP-0: package-specific automated publishing verification

Status: PENDING. Repository access and uploaded commit signatures have been
verified, but GitHub OIDC and pub.dev publishing configuration have not been
verified for `jocaagura_domain_core`. The evidence JSON must remain pending until
this package's real service behavior and maintainer audit attribution are recorded.

The source package proved the mechanism, but identity and authorization are
specific to a repository/package. The template expects immutable OIDC subject
claims, using repository and owner IDs supplied by GitHub. Verify the new
repository's actual OIDC subject settings before executing the experiment.
Custom subjects or a required GitHub environment require deliberate adaptation.
Built-in `GITHUB_TOKEN` is used for GitHub operations only; GitHub-issued OIDC
authenticates the upload to pub.dev. Restrict version-tag creation to authorized
release actors and prevent updates/deletion without a broad automation bypass.

## Procedure after the domain is release-ready

1. Complete the first manual pub.dev publication; do not upload this scaffold.
2. Configure GitHub publishing for grupo-jocaagura/jocaagura_domain_core,
   v{{version}}, push and workflow_dispatch. Record the actual admin settings.
3. Prepare the real 0.1.0 promotion in CI and merge develop -> master after checks.
4. Manually run CP-0 controlled publication on develop with prepare-tag and the
   exact merged SHA. Its built-in token creates an immutable v0.1.0; no upload.
5. Only with explicit release authorization, dispatch the same workflow on
   v0.1.0 with operation=publish, expected_sha and confirmation
   `publish jocaagura_domain_core 0.1.0`.
6. Inspect full CI, the sanitized OIDC claim summary, actual upload, public API,
   archive contents/hash and pub.dev activity-log attribution. Never record JWTs.
7. Update evidence/cp0-0.1.0.json in a reviewed PR: passed, this package/repository,
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
