# Verification record: issue #10 transversal core candidate

Status: VERIFIED. The maintainer accepted the candidate; integration and actual
1.1.0 publication are recorded in [release evidence](ISSUE_10_RELEASE.md).
No independent accreditation is claimed. The validation table below preserves
the historical local candidate results and its original validation timestamp.

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
| CORE-CP1 | CORE_SELECTION.md, core_selection.json; freeze commit above | 20 exact new public symbols plus Utils/Unit/unit; explicit show exports, five admission answers, full target dependency closure and signatures; independently pinned validator rejects signature drift even after self-hash recomputation; checks the deliberate architecture v1 / hash amendment v1.1 relation and missing records. |
| CORE-BASE | Existing Utils/Unit and 1.0.0 signatures | Files unchanged; existing tests preserved; normalized UTF-8 baseline hashes checked. |
| CORE-RESULT | MIG-01..07, SUP-01..03; EV-A-0418/0401 and EV-B-0103/0106..0112 | Model/EntityUtil/NoParams, sealed Either/final branches/async extension, ErrorItem/enums; tests cover signatures, both/null branches, errors, equality, aliases and wire output. |
| CORE-MAP | MIG-08/09, EV-B-0113/0116 | Mapper/ModelUtils use original tolerant Utils; actual-list filtering and callback errors tested. Encoded arrays remain empty rather than silently acquiring decoding. |
| CORE-TIME | MIG-10..13; EV-B-0102/0216, EV-A-0101/0102 | Canonical UTC, nullable parsing, explicit clock policy and legacy local-clock/date behavior; offsets/precision/whitespace/overflow/range tested. |
| CORE-EXEC | MIG-15/17, EV-A-0171/0419 | Controlled timers, scheduling-zone failures, FIFO keys/recovery, idle cleanup, disposal overlap and reentrancy limits. A test-only VM mirror reads queue count; production has no reflection or test hooks. |
| CORE-VALUES | VAL-01/02, EV-A-0291/0292 | Language/localized text constructors, constants, normalization, ownership, equality/hash and goldens. Fallback is metadata; raw tag collision limits documented. |
| CORE-PROOF | Public entrypoint; synthetic consumer model | Runnable transversal_core_example.dart plus public_composition/core_public_signature tests; all DTOs indexed with synthetic schemas/examples. |
| CORE-QA | Actual candidate commands and results below | Strict analysis, format, Dart tests/coverage, unchanged SDK boundary, release/documentary tests, workflow lint, dry-run/archive/privacy inspection. |
| CORE-REVIEW / CORE-REL | Actual maintainer acceptance and explicit release authorization | ISSUE_10_REVIEW.md and ISSUE_10_RELEASE.md record review, integration, final CI, immutable tag, actual OIDC upload and downloaded archive verification. |

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
an instrumented branch percentage or deployed-backend evidence. The explicit
[critical branch matrix](ISSUE_10_BRANCHES.md) maps each critical alternative to
its passing Given-When-Then assertion block.

## Historical local validation environment and results

Validation uses the standalone Dart 3.13.2 SDK and Python 3.13 on Windows x64 in
the isolated issue worktree. No Flutter command or source build is used. The validated implementation commit is
`8d6e4fccb0457da5e7b80a32355b4533e319c534` (original implementation in
`39ca79d`, packaged fixtures in `bb3478a`, review corrections in `8d6e4fc`). The final documentation-only evidence commit does
not change the validated archive inputs. Machine-readable results and archive
file hashes are in [issue_10_checks.json](issue_10_checks.json).
Machine record SHA-256: `2a89058d7df9ed7fbec3ac4961302cbd7309aae6a003a8f4a794dc5264e76205`.

| Actual check | Result |
| --- | --- |
| dart pub get | Passed; production SDK-only; no added external test dependencies; fake_async removed |
| dart format --output=none --set-exit-if-changed . | 34 files, zero changes |
| dart analyze --fatal-infos --fatal-warnings . | No issues |
| dart test --coverage=coverage/review-issue-10-r2 --reporter=json | 239 passed; no failures/skips |
| coverage:format_coverage | 540/541 lines = 99.815157% (99.82% rounded); configured 96% met for the package and combined |
| python -m unittest discover -s .github/scripts/tests -v | 73 passed, including executed Bash release guards and CP-1/DTO checks |
| python tool/verify_dartdoc_examples.py --dart <SDK executable> | All 10 complete DartDoc programs compiled and passed assertions |
| actionlint 1.7.12, -shellcheck= -pyflakes= | Passed; workflow configuration unchanged |
| release_policy.py --metadata-only | Existing package/version 1.0.0 valid |
| CP-1 / DTO / documentary validators | Passed; 1,712 original IDs, 20 selected symbols, 4 schemas/examples; certification remains draft |
| verify_documentation.py --require-approved | Rejected the draft as intended; this is not a release approval |
| git diff --check develop | Passed |
| git verify-commit be23eb7 39ca79d bb3478a d76ec17 8d6e4fc | All five local signatures valid; GitHub verification/remote CI not run |
| Frozen-source token comparison | All 14 new files match after documented part/import/annotation/default/helper/FIFO adaptations |
| dart pub publish --dry-run | Passed on the clean candidate with zero warnings; no upload |
| dart pub publish --to-archive=.local/issue-10-review-r2.tar.gz | Dart generated the real local publishable archive; no upload |
| Actual archive inspection | 43 files, 17 library files, 59,071 bytes; every entry byte-matches the validated checkout; no excluded docs/tooling/local build material |
| Actual archive test run | Extracted safely locally; pub get --offline then dart test: all 239 passed |
| Private provenance scan | No exact SRC-B identity/root/frozen-revision matches in public candidate files or actual archive; both source worktrees clean |

The only uncovered executable line is the private ModelUtils constructor; no
artificial test was added to instantiate an inaccessible utility. The public
entrypoint example ran successfully and is also tested with controlled timers.

Archive SHA-256:
`5372e3edf25a2cd691e3b02ac8fe8cde439e16a64a325b9ec7ab2e5b118cc6b0`.
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

## Historical pre-PR handoff and reproducible validation

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
python tool/verify_dartdoc_examples.py
python tool/verify_documentation.py
dart pub publish --dry-run
```

After review, recheck current develop and effective repository rules before any
separately authorized push/PR. Preserve all protections/signature/CI gates. Only
the existing Actions may prepare a checkpoint and minor promotion to 1.1.0; keep
1.0.0/CP-0 immutable. Do not close #10 until its actual final review/release evidence
exists. Review evidence: the maintainer supplied a `CHANGES_REQUIRED` review of the
previous candidate. This revision addresses the four requests below; final
maintainer re-review is pending. Codex validation is author validation, not approval.


## Review disposition (2026-09-14)

1. CP-1 self-hash gap: fixed by independently pinned original/amended digests in
   the validator. Tampering with signatures or the amendment while recomputing
   the self-hash fails. The architecture retains semantic revision v1 and the
   explicit v1.1 UTF-8-only relation is checked. Pin edits remain reviewable policy
   changes; this is not tamper resistance against editing the validator itself.
2. External test dependency: removed the added fake_async dependency. Existing
   coverage/lints/test tooling is unchanged. The local one-shot timer/microtask
   scheduler uses dart:async and dart:collection; three tests validate its timing,
   cancellation, zone/error routing and unsupported operations. No production
   test hooks or lifecycle redesign were introduced.
3. Public DartDoc: constructors/factories, methods, fields, enums and constants
   now document contracts, ownership, defaults, returns and error behavior in
   English. Ten complete inline programs compile and run with assertions through
   the reproducible DartDoc verifier; the original public consumer example remains.
4. Test format and branch evidence: new issue tests use group() and Given-When-Then
   names. ISSUE_10_BRANCHES.md records exact successful selectors and the critical
   alternatives asserted. This supplements LCOV without claiming a branch metric.

All 20 selected symbols and the 14 implementation token streams remain unchanged
from the reviewed runtime after the already documented extraction adaptations.
At this historical pre-PR checkpoint the manifest remained draft and no remote
action had occurred. The completed acceptance and release records below supersede
that stopping point without relabeling the local validation results.


## Accepted review and current integration scope

The maintainer accepted the reviewed candidate `712507b` and authorized cleanup
and issue closure after the necessary commit/PR. This supersedes the historical
pre-PR stopping point described above. See [the actual review record](ISSUE_10_REVIEW.md).
The product implementation and its recorded validation remain unchanged. The
CORE-INV through CORE-REVIEW requirements are supported by the existing source,
behavior, validation and maintainer review evidence. CORE-REL is verified by the
[actual release record](ISSUE_10_RELEASE.md): PR #13, exact immutable v1.1.0,
successful OIDC upload and the downloaded package with all 239 tests passing.
The manifest is approved as internal documentary certification.
