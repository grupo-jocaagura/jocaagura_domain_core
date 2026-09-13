# Jocaagura Domain Core

[![CI](https://img.shields.io/github/actions/workflow/status/grupo-jocaagura/jocaagura_domain_core/validate_pr.yaml?branch=develop)](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/workflows/validate_pr.yaml)
![Status](https://img.shields.io/badge/status-unpublished%20scaffold-blue)
![Coverage policy floor](https://img.shields.io/badge/coverage_policy_floor-95%25-blue)

Pure Dart shared domain for interoperability between Jocaagura backend applications.

## Description

`jocaagura_domain_core` will provide shared contracts and immutable values whose
semantics are demonstrated by actual Jocaagura applications. Consumers should be
able to share domain meaning without importing another application's server,
transport, persistence or framework implementation.

The approach includes:

- Extracting the smallest useful contract from source code and consumer needs.
- Keeping production dependencies limited to the Dart SDK.
- Defining invariants, errors and deterministic serialization explicitly.
- Evaluating API and serialization compatibility before moving public contracts.
- Recording source provenance, tests, consumer impact and review with each extraction.

Matching model names alone do not establish shared semantics. The source
inventory must justify each abstraction before implementation.

## Project status

**Unpublished development scaffold; no domain contracts have been extracted yet.**

Version `0.0.1` is the documentary baseline. See [pubspec.yaml](pubspec.yaml) for
the current version and [CHANGELOG.md](CHANGELOG.md) for its history. Bootstrap
improvements accumulate under `Unreleased` for a planned `0.0.2` development bump
through Actions after its CI prerequisites pass. Neither version denotes a
public release or completed certification.

The repository is available on GitHub. [Bootstrap issue #1](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/1)
tracks the remaining configuration and contribution checks. Repository access
and the uploaded commit signatures have been verified; publication configuration
and CP-0 are still pending for this package.

The library entrypoint currently declares only the library. There are no runtime
dependencies, executable domain APIs or consumer usage examples yet. Full CI is
blocked by the empty-library coverage gate, even though the boundary test can pass.

## Architecture and boundaries

Intended dependency direction, to be exercised by future extractions:

```text
Backend applications and infrastructure adapters
                       |
                       | depend on
                       v
              jocaagura_domain_core
                       |
                       | depends on
                       v
                   Dart SDK
```

| Area | Responsibility |
| --- | --- |
| Shared domain | Evidence-backed contracts, immutable values, invariants, errors and serialization semantics. |
| Applications | Use cases, orchestration and application-specific business decisions. |
| Adapters | HTTP, storage, authentication providers, environment configuration and external integrations. |

The core must not import Flutter, `dart:io`, `dart:ffi`, servers, HTTP clients,
databases or inference runtimes. Credentials and environment access belong to
consumers and adapters. Existing Jocaagura packages are sources to inspect;
their APIs, dependencies and certifications are not automatically inherited.

## Local development

Requirements: Dart SDK `>=3.13.2 <4.0.0`, Git, and Python 3 for the repository's
automation and documentation checks. Flutter is not required for the package.

From the repository root:

```sh
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings .
dart test
python -m pip install -r .github/scripts/requirements.txt
python -m unittest discover -s .github/scripts/tests -v
python tool/verify_documentation.py
```

These commands validate the scaffold and tooling; they do not constitute full
release CI. The workflow additionally checks GitHub commit verification,
Actions lint and measured coverage. No installation or API example is provided
until an accepted domain implementation exists.

## Quality and contributions

Read [AGENTS.md](AGENTS.md) before contributing. Work follows an issue, a focused
branch/worktree based on current `develop`, and a PR into `develop`.
GitHub Issues is the canonical work tracker. Files under `docs/issues/` are
proposals until promoted; afterwards they link to the GitHub issue instead of
maintaining a second issue state.

CI preserves formatting, strict analysis, verified commit signatures, workflow
lint, release-script tests and coverage checks per package and combined.
`COVERAGE_MIN` is a GitHub Actions **repository variable**, not a secret. It
defaults to `95` when absent and accepts values from `95` to `100`. The maintainer
configured `96` on 2026-09-13; that is the observed repository threshold.
The badge above describes the policy floor, not measured coverage.

There are no executable library lines, so coverage is currently not measurable.
The boundary test does not substitute for real contract tests. Do not add dummy
functions or relax thresholds to make the scaffold green. `Prepare version`
also requires full CI; the planned `0.0.2` bump remains blocked until that
prerequisite is satisfied.

Every extraction must trace requirement -> source contract -> implementation ->
test -> evidence -> review. Record exact source repositories, commits and paths,
consumer expectations and migration implications. Add meaningful tests for
behavior, invariants, failure cases and serialization, with notes under `Unreleased`.

Documentary certification is internal. Its validator checks structure and file
integrity; a successful draft check is not semantic proof or accreditation.
Review follows the issue contract and may be maintainer review or a named review
artifact. It must not introduce extra approvals, agents or lifecycle gates.

## Next milestones

1. Review the bootstrap documentation and complete repository configuration,
   with evidence for each item in issue #1.
2. Continue the [domain inventory proposal](docs/issues/0001-domain-inventory.md):
   inspect actual contracts, identify at least two intended consumers and define
   a bounded first extraction with explicit compatibility decisions.
3. Implement that extraction with real tests, measurable coverage, examples and
   consumer migration evidence. Resolve the CI prerequisite for version preparation.
4. Complete the issue-required review and release readiness before the first
   manual publication. Configure and verify this package's automated publishing
   separately; do not publish the scaffold.

## Release and publication

```text
feature -> PR to develop -> release PR -> master -> version tag -> pub.dev
```

Development patch versions record progress on `develop`. Before an automated
public release, CI prepares an explicit minor/major promotion and consolidates
notes. Only the official same-repository `develop -> master` PR authorizes the
release; changing `master` alone is not publication authorization.

Automated publication must run on a protected, immutable version tag pointing
to that exact release commit. The tag version, `pubspec.yaml` version and the
configured `v{{version}}` pattern must agree. Supported entry points are a
human-pushed tag and `workflow_dispatch` on the tag. Dispatch activation remains
pending this package's configuration and CP-0 evidence.
Restrict creation of `v*` tags to authorized release actors and prevent tag
updates/deletion. Verify the permitted automation path as part of that setup.

The first pub.dev publication is manual and requires a release-ready package.
Subsequent automation uses built-in `GITHUB_TOKEN` for GitHub operations and
GitHub-issued OIDC to authenticate publication to pub.dev, without a PAT or
persistent publishing credential. Never move/delete a published tag or reupload
an existing version. See [CI and releases](.github/CI_CD.md) for the complete flow.

## Documentation map

- [Working agreement](AGENTS.md).
- [Project context and next steps](docs/PROJECT_CONTEXT.md).
- [Bootstrap evidence and review handoff](docs/BOOTSTRAP_REVIEW.md).
- [Historical scaffold validation](docs/LOCAL_VERIFICATION.md).
- [Source inventory proposal](docs/issues/0001-domain-inventory.md).
- [Certification process](docs/certification/README.md) and [record template](docs/certification/TEMPLATE.md).
- [CI configuration](.github/CI_CD.md) and [pending CP-0 procedure](.github/CP0_AUTOMATED_PUBLISHING.md).
- [Changelog](CHANGELOG.md) and [MIT License](LICENSE).
- [Official repository](https://github.com/grupo-jocaagura/jocaagura_domain_core).

The MIT License applies to this package's source. Source contracts considered
for extraction still require their own provenance and license review.
