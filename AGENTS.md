# Working agreement for jocaagura_domain_core

## Purpose and scope

Build a pure Dart domain shared by Jocaagura backend applications. Read
`docs/PROJECT_CONTEXT.md`, `.github/CI_CD.md`, and `docs/certification/README.md`
before changing the relevant area. Existing user instructions take precedence.
Use Spanish with the maintainer and clear English for code and repository docs.

Keep production dependencies SDK-only. No Flutter, servers, HTTP clients,
databases, credentials, environment access, `dart:io`, `dart:ffi`, or inference
runtimes in `lib/`. Infrastructure belongs to consumers and adapters. Extract
semantics from evidence in actual applications; do not invent a universal model.
Prefer immutable values, explicit contracts, deterministic serialization and
documented errors. Assess compatibility before moving existing public APIs.

## Work by issue

1. Inspect repository state, existing issues and relevant consumers first. Reuse
   an issue when it already describes the work; avoid duplicate issues.
2. For substantive work, capture the concrete problem, scope, exclusions,
   acceptance criteria, risks, evidence and validation in an issue before coding.
   Until the maintainer uploads the repository, use `docs/issues/` locally.
3. Use one focused branch/worktree based on current `develop`, named after the
   issue and intent. Keep the main checkout and unrelated user changes intact.
   Small fixes that belong to an existing issue do not need another issue.
4. Implement the accepted scope, update changelog/docs and add meaningful tests
   for behavior, invariants, failure cases, serialization and compatibility.
5. Validate the actual diff and record results and limits. A plan or a mocked
   service response is not evidence of a completed real integration.
6. Open a focused PR into `develop`, linked to the issue, with problem, resulting
   behavior and validation. Fix its relevant CI failures. Do not bypass checks.
7. Close acceptance items only when supported by evidence. Cross-reference the
   final PR, commit and certification record. Leave outstanding work explicit.

Proceed autonomously with authorized implementation, reversible local changes,
inspection and validation. Do not repeatedly ask for already-given permission.
Ask only when a missing decision materially changes scope or an irreversible
external action is not authorized. This file introduces no extra approval flow.
The maintainer will create/upload this repository to GitHub; do not create a
remote, push, publish, grant access or modify GitHub settings without that scope.

## Quality and releases

Preserve `analysis_options.yaml`, strict analysis, commit signature checks,
workflow lint, release-script tests and coverage >=95% per package and combined.
Never claim coverage for the empty scaffold. Do not fabricate code/tests to
make a metric green. Do not commit overrides, tokens, private data or build output.

Work lands in `develop`. Only an official same-repository `develop -> master`
PR may authorize a release. Development patches record progress; CI prepares an
explicit minor/major promotion and consolidates notes before the release PR.
Do not hand-edit a public version to evade that discipline.

First pub.dev publication is manual. Every package requires its own publishing
configuration and CP-0 evidence. Use built-in GITHUB_TOKEN and OIDC only; no PAT,
service account, external publishing service or persistent pub.dev credential.
Unknown eligibility fails closed. Never move/delete a published tag or reupload
an existing version. Preserve the prepared commit and recheck provenance.

## Documentary certification

Every extraction issue must trace requirement -> source contract -> implementation
-> test -> evidence -> review. Record source repository/commit/path, consumer
expectations and migration implications. Keep assumptions distinct from facts.
Use `docs/certification/TEMPLATE.md`; store the certification matrix and evidence
references in `docs/certification/manifest.json`.

Certification is internal. A successful documentation validator checks structure
and file integrity, not correctness or independent accreditation. A draft must
remain draft until its acceptance evidence and named review are complete.
Never copy another package's passed certificate, scores, audit logs or run IDs.

## Completion report

Report what changed, the issue/PR, checks actually run and any unresolved limits.
Keep updates concise during sustained work. Leave the next task a reproducible
handoff instead of relying on conversation history. No new task or agent is
required for ordinary work; stay in the current task unless asked otherwise.
