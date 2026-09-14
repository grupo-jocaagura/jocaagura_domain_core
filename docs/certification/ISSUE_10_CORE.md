# Verification record: issue #10 transversal core candidate

Status: DRAFT. Internal author validation; final maintainer candidate review and
release evidence are pending. No independent accreditation is claimed.

- Issue: [#10](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/10).
- Base: develop `729acf7d657ca5a4d675e720235b28f62b2c2234`; source freeze is unchanged.
- Pre-implementation selection: signed local commit `be23eb7`; CP-1 v1.1 records
  a UTF-8 baseline-hash correction without changing any selected API.
- Source: SRC-A jocaagura_domain 1.43.0 at
  `56f7eba8a6041160ecf1c1501745c1249e124670`; SRC-B EV-B-0001. Exact private
  source/commit/path mappings remain solely in the existing external handoff/map.
  EV-B-0002 and issue #3 reports remain historical evidence.
- Rights: SRC-A MIT attribution matches the preserved package LICENSE. SRC-B has
  no root LICENSE; reuse follows the maintainer's explicit scoped direction,
  not an inferred license grant or third-party clearance. No private fixtures copied.
- Consumers: only the two frozen sources; functional probes use the actual public
  core entrypoint and synthetic examples. No source build, migration or deployed
  integration is claimed.

## Requirement -> source -> selection -> implementation -> tests

| Requirement | Source/selection | Implementation and evidence |
| --- | --- | --- |
| CORE-INV | All original IDs; architectural companion and conditional decisions | 1,712 rows, eight dispositions; library closures and lexical dependency precision explicitly labeled. Canonical target closures are individually frozen; excluded contracts have no implementation debt. |
| CORE-CP1 | CORE_SELECTION.md, core_selection.json; freeze commit above | 20 exact new public symbols plus Utils/Unit/unit; explicit show exports, five admission answers, full target dependency closure and signatures; integrity validator rejects drift/missing records. |
| CORE-BASE | Existing Utils/Unit and 1.0.0 signatures | Files unchanged; existing tests preserved; normalized UTF-8 baseline hashes checked. |
| CORE-RESULT | MIG-01..07, SUP-01..03; EV-A-0418/0401 and EV-B-0103/0106..0112 | Model/EntityUtil/NoParams, sealed Either/final branches/async extension, ErrorItem/enums; tests cover signatures, both/null branches, errors, equality, aliases and wire output. |
| CORE-MAP | MIG-08/09, EV-B-0113/0116 | Mapper/ModelUtils use original tolerant Utils; actual-list filtering and callback errors tested. Encoded arrays remain empty rather than silently acquiring decoding. |
| CORE-TIME | MIG-10..13; EV-B-0102/0216, EV-A-0101/0102 | Canonical UTC, nullable parsing, explicit clock policy and legacy local-clock/date behavior; offsets/precision/whitespace/overflow/range tested. |
| CORE-EXEC | MIG-15/17, EV-A-0171/0419 | Controlled timers, scheduling-zone failures, FIFO keys/recovery, idle cleanup, disposal overlap and reentrancy limits. A test-only VM mirror reads queue count; production has no reflection or test hooks. |
| CORE-VALUES | VAL-01/02, EV-A-0291/0292 | Language/localized text constructors, constants, normalization, ownership, equality/hash and goldens. Fallback is metadata; raw tag collision limits documented. |
| CORE-PROOF | Public entrypoint; synthetic consumer model | Runnable transversal_core_example.dart plus public_composition/core_public_signature tests; all DTOs indexed with synthetic schemas/examples. |
| CORE-QA | Actual candidate commands and results below | Strict analysis, format, Dart tests/coverage, unchanged SDK boundary, release/documentary tests, workflow lint, dry-run/archive/privacy inspection. |
| CORE-REVIEW / CORE-REL | Maintainer instruction: stop before PR | Final candidate review, remote CI/signature verification, integration/version promotion/release/1.1.0 upload remain pending. No PR, push, tag or publication performed. |

## Compatibility and preserved limits

See [migration plan](../migration/PLAN.md) and [CP-1](../migration/CORE_SELECTION.md).
New package identity requires coordinated imports; SRC-A Either subclassing and
SRC-B's weaker Model implementation contract are not promised compatible. ErrorItem
metadata is shallow and can alias. DateUtils uses real local time for legacy fallback;
tests bracket these calls rather than claim a replaceable clock. Debouncer validates
positive delay by assertions only. FIFO dispose is non-cancelling and same-key
awaited reentrancy can deadlock. Localization direct strings remain permissive.

Source library dependency lists are conservative and token matches are not resolved
minimal type closures. This is recorded per row, not hidden behind admission.
Structural validators check integrity/completeness; the maintainer's final review
must assess semantics and the complete candidate. Coverage is line coverage, not
branch coverage or deployed-backend evidence.

## Validation environment and results

Validation uses the standalone Dart 3.13.2 SDK and Python 3.13 on Windows x64 in
the isolated issue worktree. No Flutter command or source build is used. The validated implementation commit is
`bb3478a37cfb18b073382d07120b287437b89825` (implementation in `39ca79d`,
packaged fixtures in `bb3478a`). The final documentation-only evidence commit does
not change the validated archive inputs. Machine-readable results and archive
file hashes are in [issue_10_checks.json](issue_10_checks.json).

| Actual check | Result |
| --- | --- |
| dart pub get | Passed; production SDK-only, fake_async dev-only |
| dart format --output=none --set-exit-if-changed . | 32 files, zero changes |
| dart analyze --fatal-infos --fatal-warnings . | No issues |
| dart test --coverage=coverage/review-issue-10 --reporter=json | 236 passed; no failures/skips |
| coverage:format_coverage | 540/541 lines = 99.815157% (99.82% rounded); configured 96% met for the package and combined |
| python -m unittest discover -s .github/scripts/tests -v | 70 passed, including executed Bash release guards and CP-1/DTO checks |
| actionlint 1.7.12, -shellcheck= -pyflakes= | Passed; workflow configuration unchanged |
| release_policy.py --metadata-only | Existing package/version 1.0.0 valid |
| CP-1 / DTO / documentary validators | Passed; 1,712 original IDs, 20 selected symbols, 4 schemas/examples; certification remains draft |
| verify_documentation.py --require-approved | Rejected the draft as intended; this is not a release approval |
| git diff --check develop | Passed |
| git verify-commit be23eb7 39ca79d bb3478a | All three local signatures valid; GitHub verification/remote CI not run |
| Frozen-source token comparison | All 14 new files match after documented part/import/annotation/default/helper/FIFO adaptations |
| dart pub publish --dry-run | Passed on the clean candidate with zero warnings; no upload |
| dart pub publish --to-archive=.local/issue-10-review.tar.gz | Dart generated the real local publishable archive; no upload |
| Actual archive inspection | 41 files, 17 library files, 52,092 bytes; every entry byte-matches the validated checkout; no excluded docs/tooling/local build material |
| Actual archive test run | Extracted safely locally; pub get --offline then dart test: all 236 passed |
| Private provenance scan | No exact SRC-B identity/root/frozen-revision matches in public candidate files or actual archive; both source worktrees clean |

The only uncovered executable line is the private ModelUtils constructor; no
artificial test was added to instantiate an inaccessible utility. The public
entrypoint example ran successfully and is also tested with controlled timers.

Archive SHA-256:
`dad219ec7d7d16e846d7c7df1b93bd4b058c94628801005b37ad85cdc539dd42`.
The archive is a local unpublished candidate retaining the prepared 1.0.0 metadata;
this is not an upload, a new release or permission to reupload 1.0.0. Future Actions
must prepare the actual minor release. Source-of-truth archive creation uses Dart's
[local archive branch](https://github.com/dart-lang/pub/blob/master/lib/src/command/lish.dart),
not a manually reconstructed tarball.

Initial environment-only cache/network restrictions and test/format issues were
resolved before the final successful runs. The automatic permission review first
misclassified dry-run as upload; the direct command was allowed after checking its
no-upload control flow. No alternate credential, skipped check or bypass was used.
The Python suite's mocked release messages are test fixtures, not publication
results. Historical 1.0.0/CP-0 scores were not reused as new-code evidence.

## Pending review and reproducible handoff

The user requested a temporary diff before creating a PR. Review the complete
local branch against the recorded develop base. Reproduce with:

```sh
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings .
dart test --coverage=coverage/issue-10 --reporter=json
dart run coverage:format_coverage --lcov --in=coverage/issue-10 --out=coverage/issue-10.info --report-on=lib
dart run example/transversal_core_example.dart
python -m unittest discover -s .github/scripts/tests -v
python tool/verify_core_selection.py
python tool/verify_dto_docs.py
python tool/verify_documentation.py
dart pub publish --dry-run
```

After review, recheck current develop and effective repository rules before any
separately authorized push/PR. Preserve all protections/signature/CI gates. Only
the existing Actions may prepare a checkpoint and minor promotion to 1.1.0; keep
1.0.0/CP-0 immutable. Do not close #10 until its actual final review/release evidence
exists. Reviewer: Codex author validation only; maintainer review not yet performed.
