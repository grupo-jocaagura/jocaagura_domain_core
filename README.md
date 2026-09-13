# Jocaagura Domain Core

[![CI](https://img.shields.io/github/actions/workflow/status/grupo-jocaagura/jocaagura_domain_core/validate_pr.yaml?branch=develop)](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/workflows/validate_pr.yaml)
![Status](https://img.shields.io/badge/status-first%20shared%20helpers-blue)
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

Published `1.0.0` contains `Utils`, `Unit.value` and its `unit` alias, preserving
the already-published signatures and behavior. [Issue #3](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/3)
records the inventory, compatibility review and actual stable release evidence.
Inventory-only candidates have not been migrated. CP-0 verified the real tag-ref
OIDC upload, downloaded archive/hash and pub.dev audit attribution.
See [pubspec.yaml](pubspec.yaml) for the actual version.

All 30 `Utils` helpers retain their signatures and tolerant behavior, including
legacy phone spellings. Production dependencies remain SDK-only. Source
applications have not been migrated. See the [stable API contract](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/migration/STABLE_API.md)
and [official DTO catalog](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/DTO/README.md).

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

These commands validate the package and tooling; they do not constitute full
release CI. The workflow additionally checks GitHub commit verification,
Actions lint and measured coverage.

## Using the extracted helpers

```dart
import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';

final Map<String, dynamic> order = Utils.mapFromDynamic(
  '{"subtotalAmount":"1.234,56 COP","notes":null}',
);
final int subtotal = Utils.getIntegerFromDynamic(order['subtotalAmount']); // 1234
final String notes = Utils.getStringFromDynamic(order['notes']); // ''
final Duration timeout = Utils.durationFromJson('PT1M30S');
const Unit success = Unit.value;
```

Run `dart run example/jocaagura_domain_core_example.dart` for a complete example.

`Utils` retains legacy behavior: typed maps may be returned by reference, numeric
fallbacks are tolerant, JSON encoding failure returns non-JSON error text, and
duration serialization truncates sub-millisecond precision. Deep collection
helpers require acyclic inputs; hashes are not persistent identifiers. ID/token
generators use the clock and/or secure randomness and are not deterministic.
The helpers do not implement credential storage, backend transport or authentication.

`Unit.value` and `unit` expose the same constant success value, with equality by
`Unit` type, hash `0` and string `unit`. No JSON representation is added. Its new
library identity means consumer migration must replace/re-export the original
type consistently across generic APIs; old and new copies are not interchangeable.

## Quality and contributions

Read [AGENTS.md](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/AGENTS.md) before contributing. Work follows an issue, a focused
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

Coverage is measured on the extracted implementation, with characterization
tests and additional null, malformed-input, ownership, serialization, equality
and boundary cases. The original empty-library failure is recorded historically;
it is not an exemption. `Prepare version` requires full CI before preparing the selected checkpoint. Historical results are in the extraction record; current evidence is tracked in issue #3.

Every extraction must trace requirement -> source contract -> implementation ->
test -> evidence -> review. Record reproducible provenance, consumer expectations and migration implications;
private sources use sanitized IDs with an external restricted mapping. Add meaningful tests for
behavior, invariants, failure cases and serialization, with notes under `Unreleased`.

Documentary certification is internal. Its validator checks structure and file
integrity; a successful draft check is not semantic proof or accreditation.
Review follows the issue contract and may be maintainer review or a named review
artifact. It must not introduce extra approvals, agents or lifecycle gates.

## Selected milestones

Actions prepared 0.0.4 and promoted it to 1.0.0. Official develop -> master
PR #7 passed release readiness and required checks. Immutable v1.0.0 points to
its exact merge commit, and controlled run 34788211069 published the real release.
Version 0.0.4 was not uploaded. See the [release verification record](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/certification/ISSUE_3_RELEASE.md).

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
human-pushed tag and `workflow_dispatch` on the tag. This package's completed
CP-0 evidence is recorded; future runs must still recheck release eligibility.
Restrict creation of `v*` tags to authorized release actors and prevent tag
updates/deletion. Verify the permitted automation path as part of that setup.

The first manual pub.dev publication (0.0.2) is complete.
Subsequent automation uses built-in `GITHUB_TOKEN` for GitHub operations and
GitHub-issued OIDC to authenticate publication to pub.dev, without a PAT or
persistent publishing credential. Never move/delete a published tag or reupload
an existing version. See [CI and releases](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/.github/CI_CD.md) for the complete flow.

## Documentation map

- [Working agreement](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/AGENTS.md).
- [Project context and next steps](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/PROJECT_CONTEXT.md).
- [Bootstrap evidence and review handoff](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/BOOTSTRAP_REVIEW.md).
- [Historical scaffold validation](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/LOCAL_VERIFICATION.md).
- [Utils and Unit extraction, provenance and migration](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/certification/UTILS_EXTRACTION.md).
- [Bounded inventory](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/migration/INVENTORY.md), [migration plan](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/migration/PLAN.md) and [DTO catalog](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/DTO/README.md).
- [Certification process](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/certification/README.md) and [record template](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/docs/certification/TEMPLATE.md).
- [CI configuration](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/.github/CI_CD.md) and [completed CP-0 evidence and procedure](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/develop/.github/CP0_AUTOMATED_PUBLISHING.md).
- [Changelog](CHANGELOG.md) and [MIT License](LICENSE).
- [Official repository](https://github.com/grupo-jocaagura/jocaagura_domain_core).

The MIT License applies to this package's source. Source contracts considered
for extraction still require their own provenance and license review.
