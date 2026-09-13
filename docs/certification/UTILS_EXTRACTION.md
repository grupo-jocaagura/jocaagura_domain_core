# Verification record: Utils and Unit extraction in bootstrap #1

Status: DRAFT. Date: 2026-09-13. This records scoped implementation evidence,
not external accreditation, a completed backend migration or publication approval.

## Issue and accepted requirement

[GitHub issue #1](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/1)
is the canonical work tracker; [PR #2](https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/2)
contains the implementation. The maintainer explicitly extended bootstrap to
extract `lib/core/utils.dart`, then `lib/core/unit.dart`, with unit tests and no
new issue. The source repository must remain read-only.

Requirement `EXT-001`: preserve all 30 public `Utils` static helpers and
`Unit`/`unit` through the package entrypoint, with SDK-only production dependencies,
real behavior/compatibility tests and measured coverage meeting the configured 96%.
Broader inventory, application migration and release review remain separate.

## Source repository, commit, paths and license

Source repository: `https://github.com/grupo-jocaagura/backend_bienvenido`.
Inspected local HEAD: `993b2d10d804d5715c6719d08c2ef64d4837d1bb`.
Source package name/version: `backend_dart` / `0.0.107`.
The working files below matched that HEAD. This local checkout was 31 commits
behind its remote-tracking branch; the extraction intentionally follows the
specific local files requested, without fetching or altering the source.

| Source | SHA-256 of the inspected working file |
| --- | --- |
| `lib/core/utils.dart` | `f16c4e948cf315fe1d6a7ed1200d6e219c64632aceca17c6dcf95c9680bfa303` |
| `lib/core/unit.dart` | `fd5b099c99c877968f5951af73a856d4803494b674081553b99c5e618de9f99c` |

Source characterization cases were adapted from `test/core/utils_test.dart` at
the same commit. Duplicate ID cases and probabilistic uniqueness assertions were
omitted. Additional tests verify output format/decoded byte length rather than
claiming randomness quality or global uniqueness.

No tracked LICENSE/COPYING file was found in that source checkout. Reuse is at
the maintainer's explicit direction; no source license grant, third-party rights
clearance or source certification is inferred from that absence. This package's
existing MIT license is unchanged.

## Inspected consumers and interoperability needs

All backend paths below refer to the exact source commit above.

| Consumer | Source path and expectation | Migration status |
| --- | --- | --- |
| Order models | `lib/src/features/orders/domain/models/model_order.dart`: integer decoding for totals, string/null defaults, enum fallbacks, equality and hashing for attributes. | Inspected; backend imports remain unchanged. |
| Onboarding templates | `lib/src/features/onboardings/domain/models/model_onboarding_template.dart`: string/boolean decoding and recursive attribute equality/hash behavior. | Inspected; backend imports remain unchanged. |
| Cache deletion | `lib/src/features/cache_manager/domain/usecases/delete_cache_snapshot_usecase.dart`: successful deletion returns `Either<ErrorItem, Unit>`. | Inspected; no cache implementation extracted. |
| Inventory deletion | `lib/src/features/inventory/data/repositories/inventory_repository.dart`: `deleteInventory` returns `Future<Either<ErrorItem, Unit>>`. | Inspected; no repository implementation extracted. |

A second repository, `grupo-jocaagura/jocaagura_domain` at local HEAD
`2f19af8b84ce312ea582ed51320c230291711159`, also uses `Utils` conversions in
`lib/domain/address_model.dart` (postal-code and text decoding). It is an inspected
candidate for later interoperability work, not an implemented consumer of this
new package. No claim is made that two applications have migrated.

## Implementation and compatibility

Implementation commit: `186876e840191c6f9fb1b18bf957fc28f53f885d`, signed by
`qajocaagura`; GitHub verification returned `verified=true`, `reason=valid`.
File hashes below identify the exact validated implementation.

| File | SHA-256 |
| --- | --- |
| `lib/src/utils.dart` | `4ac004520f1ade784c0c61611d1b8b8871bc44f0abf2d1deff657caa04435f6f` |
| `lib/src/unit.dart` | `4504741a5b0236cc609f94f29c07f104cf08db952be933b9756522496f838341` |
| `test/utils_compatibility_test.dart` | `5e9d3d14cc27331cbb4d8a070a3a19f2aee3f6272339677bb0a7ab86f1c97747` |
| `test/utils_edge_cases_test.dart` | `2a5c1db1a800e4e404eb968a77c1e1e6ac2be56e8266a75d31c1881ac0db3002` |
| `test/unit_test.dart` | `1ddf11f0455dc7982ef4cb7d61af28de08d2ac3bddac3d2186c8f60908fd3e60` |

The public entrypoint `lib/jocaagura_domain_core.dart` exports both files.
`Utils` imports only `dart:convert` and `dart:math`; `Unit` imports nothing.
The source/extraction Dart token streams matched (3,807 Utils tokens and 61 Unit
tokens), excluding comments and normalizing optional trailing argument commas
removed by the formatter. No algorithm, public signature or return/error behavior
was changed. Documentation corrects overbroad source claims without changing code.

`Unit` is immutable by construction: no fields and a private const constructor.
Its equality/hash overrides retain the source contract. Two narrowly scoped
`avoid_equals_and_hash_code_on_mutable_classes` suppressions explain why a `meta`
annotation/dependency is not introduced into this SDK-only package. Global
analysis options and every CI gate remain unchanged.

### Requirement -> contract -> implementation -> test -> evidence

| Contract | Implementation | Tests and observed evidence |
| --- | --- | --- |
| Tolerant JSON/map/list/text/boolean conversion | `Utils.mapFromDynamic`, `listFromDynamic`, `getJsonEncode`, `mapToString`, string/list/bool helpers | Source characterization plus `conversion ownership and errors`: aliases, key collisions, malformed JSON, error text and round trips. |
| Numeric coercion and normalization | `getIntegerFromDynamic`, `getDouble`, `normalizeNumberString` | Source numeric cases plus `numeric compatibility boundaries`: null-specific integer fallback, invalid values, infinities, NaN, separators, exponents and signed zero. |
| Formatting and validation | Phone aliases, email/URL helpers, `safeId` | Source formatting/slug cases plus `validation and formatting compatibility`: padding, extra digits, scheme/authority checks and retained whitespace behavior. |
| Collection equality and hashing | Shallow list and deep map/list helpers | Source equality/hash cases plus `equality and hash contracts`: order, length/keys, aliases, null, NaN and equal-value hash consistency. |
| Duration and enum conversion | `durationToJson`, `durationFromJson`, `enumFromJson` | Source cases plus `duration and enum boundaries`: millisecond precision loss, invalid inputs, accepted legacy formats, exact enum names and fallbacks. |
| IDs and opaque random strings | `generatePrefixedId`, `generateSecureToken` | Source format cases plus `nondeterministic helper output contracts`: prefix normalization, length clamps, base36 shape and base64url byte lengths. |
| Typed completion without payload | `Unit`, `Unit.value`, `unit` | `test/unit_test.dart`: constant identity, equality/inequality, hash/set/map behavior, diagnostic string, JSON rejection and async typed completion. |
| Infrastructure boundary | Public entrypoint and SDK-only imports | `test/package_boundary_test.dart` and strict Dart analysis passed. |

### Preserved limits and migration implications

- `mapFromDynamic` returns typed maps by reference. Raw keys are stringified and
  collisions retain the last encountered value. These are not immutable snapshots.
- `getIntegerFromDynamic` uses its custom fallback only for null; invalid and
  non-finite inputs still return zero. Locale parsing is heuristic, not strict
  money validation. `getDouble` defaults to NaN. Callers must retain these semantics.
- JSON encoding failures return a non-JSON error string. Custom iteration or
  `toString` errors can propagate through some converters. Never treat these
  helpers as an input-validation or security boundary.
- Collection comparisons/hashes require acyclic inputs and respect identity fast
  paths. Hash values are not persistent serialization IDs or cryptographic digests.
- `durationToJson` discards sub-millisecond precision. The legacy duration parser
  accepts `P`/`PT` as zero; this extraction deliberately does not tighten its grammar.
- ID generation uses the system clock and secure randomness. Token generation
  uses SDK `Random.secure`, whose availability depends on the runtime. Tests
  validate output contracts on the tested platforms, not entropy certification.
- `Unit` has a new library identity. Importing the new type alongside the backend's
  old type does not make them interchangeable in `Either`/`Future` signatures.
  A future consumer migration should depend on this package and replace the old
  files with coordinated re-exports (or update all imports), then compile and test
  the whole consumer. Neither `Either` nor `ErrorItem` is part of this extraction.
- `Utils` keeps all original method names, including the legacy phone spellings.
  The import path changes; direct backend file paths are not new public entrypoints.

## Validation environment and results

Local environment: Windows x64, Dart 3.13.2, Python 3.13. Commands ran only in the
`jocaagura_domain_core` issue worktree. The backend was read, not executed or edited.

| Command/check | Result |
| --- | --- |
| `dart format lib test example` | Passed; final invocation changed zero files. |
| `dart analyze --fatal-infos --fatal-warnings .` | Passed, no issues. |
| `dart test --coverage=coverage/final --reporter=json` | 183 tests passed, no skipped/failed tests. |
| `dart run coverage:format_coverage --lcov --in=coverage/final --out=coverage/final.info --report-on=lib` | Utils 268/268 lines; Unit 5/5; package and combined 273/273 = 100%. This is line coverage, not branch coverage. |
| Public-entrypoint example | `order-1: subtotal=1234, notes=""`; `Timeout milliseconds: 90250`; `Completion: unit`. No backend call occurred. |
| Source/extraction token comparison | Equal after comment/optional-comma normalization; source logic preserved. |
| Source preservation | Both source SHA-256 values above were unchanged after extraction; selected source Git diffs were empty. |

Local LCOV SHA-256:
`b49dd8ef0efd8b077ebe1ee5853d7904081cf8c0a401fa9ae6800abed05669a4`.
Raw test/coverage output stays in ignored local build directories. Reproduce
coverage with the commands above; paths in LCOV can change its hash across hosts.
Remote validation of that implementation on Ubuntu / Dart 3.13.2:

- [Dart CI 34781104798](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34781104798)
  passed: 183/183 tests and 100.00% line coverage against the configured 96%.
  Signature checks, strict analysis, formatting and automation checks passed.
- [CodeQL 34781104711](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34781104711)
  passed for Actions analysis.
- [Documentary validation 34781104691](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34781104691)
  passed draft structure validation; it does not grant semantic approval.
- Local `dart pub publish --dry-run` on the clean implementation commit passed
  with zero warnings. Nothing was uploaded.

Final PR integration and subsequent version-preparation results are tracked in
canonical issue #1. No previous package's results are reused.

## Review and pending work

Author review checked the actual extraction diff, source usage, test cases and
preserved behavior. Maintainer authorization selected this bounded extraction
under issue #1; it is not a completed review of broader domain certification.
The manifest remains draft with broader requirements pending. No new reviewer,
agent or lifecycle gate is required beyond the issue contract.

Pending: actual backend migration; broader inventory; package/release review;
pub.dev configuration and
CP-0. The prior empty-library coverage failure is historical evidence, not a
remaining local coverage failure or an exemption from future CI.
