# Verification record: issue #15 complete model migration

Status: internally APPROVED documentary certification — implementation, validation,
named review and actual PR/delivery evidence complete. No release is authorized.

- Canonical issue: https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/15.
- Branch: `feature/15-migrate-api-models-dart-only`, based on
  `22746779e26a7ad5ed349421bf887504ff676faf`.
- Signed implementation commit: `546ed330d72f92f8767dc603daf123e3c7bd1fbd`.
  The local SSH signature and GitHub verification were actually checked.
  Subsequent changes only consolidate documentation/evidence.
- Delivery: https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/16 into
  develop. Recorded passing head: `8c557cec7ce27ed0b6ad21176691c7f49a678c01`.
- Public source: jocaagura_domain 1.43.0,
  `56f7eba8a6041160ecf1c1501745c1249e124670`, MIT. Exact public paths, original
  source hashes and historical declaration IDs are in the migration matrix.
- API source: new frozen SRC-B / EV-B-15 evidence, distinct from EV-B-0001/0002.
  Exact repository/commit/path mappings are retained in a durable private file
  outside every public checkout, worktree and package archive. Public records
  expose sanitized evidence IDs, hashes and functional contracts only.
- Consumers: backend applications, Jocaaguraarchetype and jocaagura_domain as a
  future Flutter adapter. No downstream application was modified or built.

## Requirement -> source -> implementation -> test -> evidence -> review

| Requirement | Source/implementation and behavioral evidence |
| --- | --- |
| Complete inventory | 83 public source files/215 declarations; frozen JSON catalog reconciled with 183 route sheets/shared schemas; the stale Markdown count is not completeness evidence |
| Source data migration | lib/src/models; 21 explicit family exports plus jocaagura_domain_models.dart; source characterization, cross-family round trips/composition and regression tests |
| Functional API coverage | 408 typed values in jocaagura_domain_api.dart; all 183 operations mapped to input/query and output contracts, with binary favicon justified N/A; independent API message/rule/presence tests |
| Homologated tools | Utils content equality/hashes and explicit DateTimeIsoUtils canonical-date rules; collection, generic-attribute, collision and timestamp tests |
| SDK boundary | No production package dependencies, Flutter/UI/IO/FFI, server/client, database, environment/credential lookup or inference runtime; analysis and package-boundary tests |
| Adapter handoff | ADAPTER_HANDOFF.md, complete per-source entrypoint mapping, typed nominal composition tests and executable model_migration_example.dart |
| Validation | Actual command results and per-file line counts in evidence/issue-15-validation.json; local logs are separately labeled and not remote CI evidence |
| Review | ISSUE_15_LOCAL_REVIEW.md: named review by Codex of the actual candidate, source/API contract compatibility and resolved findings; no independent accreditation claim |
| Final delivery | Authorized remote push, PR #16 into develop, actual CI URLs and final issue #15 cross-references complete; downstream adoption remains separate coordinated work |

The matrix independently pins both source selection and API operation/document
snapshots. Its zero pending model entries means local implementation coverage,
not deployed integration or issue closure. Authored field definitions are in
docs/DTO/api/v1/values.json; their packaged test copy must be identical.
api_contract_proposals.json remains explicitly unreviewed example-shape inference,
not an admitted contract or proof of semantics.

## Compatibility and errors

The released foundation files, exports, Utils/Unit behavior, historical issue #10
selection and certification evidence remain unchanged. The new public libraries
are additive to this package. Source consumers still require explicit nominal
type/import replacement and assessment of the source migration breaks below;
the Flutter adapter's own versioning is separate. No public version was edited.
Release preparation/promotion continues through the existing minor/major process.

Documented candidate corrections replace collection identity and hash-only
clinical equality, preserve legal attributes, make generic attribute equality
symmetric and restore crossed death-record JSON keys. Regression tests force
hash collisions and verify distinct nested identities/zero-prefixed record IDs.
Vector Offset conversion, menu callbacks/rendering and Flutter icon construction
belong to the adapter. Menu data now has meaningful JSON rather than an empty map.

Legacy tolerant decoders, shallow ownership, clock fallbacks, non-finite defaults
and source normalization remain explicit limits. API values separately own JSON
and validate canonical types/invariants with FormatException; absent ApiField.value
throws StateError. Required-null, absent and empty bodies are distinct. Document
block order survives nested values and success envelopes. Numeric scales and
date representations remain operation-specific. No new generic coercion,
comparison, retry, polling, HTTP mapping or money-scale policy replaces Utils.

## Actual final validation

Environment: Windows; standalone Dart SDK 3.13.7 compatible with ^3.13.2;
Python 3.13; official pinned actionlint 1.7.12. Source applications were not run.

| Check | Actual result |
| --- | --- |
| dart pub get | Passed |
| dart format --output=none --set-exit-if-changed . | Passed, zero changes |
| dart analyze --fatal-infos --fatal-warnings . | Passed, no issues |
| Full dart test with fresh coverage | 1,470 test cases passed; 100 hidden load events excluded from that count |
| Measured lib line coverage | 26,595 / 27,053 = 98.3070269471%; one package, per-package and combined >=96% |
| dart pub publish --dry-run on clean signed implementation | Passed, zero warnings, 477 KB compressed candidate; no upload |
| Workflow/release-script Python suite | 81 tests passed using Git Bash on process PATH outside the MSYS-restricting sandbox |
| Documentation, historical core and DTO validators | Passed; structural validation alone is not documentary approval |
| Complete model/API matrix validator | Passed: 83 source files, 183 operations, 408 API values, zero pending model entries |
| Generator --check | Passed: 408 codecs and packaged fixtures reproduce without writes |
| actionlint | Passed, including the new generation/matrix validation steps |
| Executable examples | Ten foundation DartDoc programs and the new assertion-enabled model composition example passed |
| Diff/signature | No whitespace errors; actual local SSH implementation signature verified |

The earlier 91.17% and 95.24% measurements were failed intermediate candidates;
neither is relabeled as final evidence. The new measurement comes from a fresh
full suite on the final production/test code. Repository text artifact hashes
normalize newlines to LF/UTF-8 for cross-platform integrity; original frozen
source-document and raw local-log hashes retain their original bytes.

No source-project coverage, certificates, audit scores, run IDs or CI attribution
are inherited. Synthetic fixtures, codec tests and structural checks cannot
establish a deployed backend, real-provider payment or downstream migration.

## Remote delivery and review

GitHub public REST reports all applicable checks successful for the exact head
`8c557cec7ce27ed0b6ad21176691c7f49a678c01` on PR #16. The full check IDs and
URLs are retained in evidence/issue-15-remote-ci.json:

- [Dart CI](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/42296053358):
  base validation, tests/coverage and CI result passed. Base validation includes
  GitHub-verified commit signatures, formatting, strict analysis and automation tests.
- [Documentary certification](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/42296053255):
  documentation and migration verification passed for the then-draft record.
- [CodeQL](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/42296053203):
  Actions analysis passed; this is not a Dart security analysis claim.
- Release readiness was intentionally skipped because this feature PR is not a
  release PR. No gate was bypassed and no protection was changed.

These are historical results for their exact head, not evidence for a subsequent
documentation commit. Each later head must pass its own CI before delivery is
reported complete. Final latest-head outcomes are linked from issue #15 and PR #16
without recursively changing this record to include its own future commit hash.

Named review: Codex, 2026-11-06; recorded in ISSUE_15_LOCAL_REVIEW.md. This fulfills
the issue's named-artifact review option without inventing another agent or human
approval requirement. The actual remote delivery evidence and canonical issue
cross-references were reviewed on the same date; the manifest records internal
approval. This does not authorize merge, publication or release.

The authorized push and focused PR into develop are complete; issue #15 links
the implementation, actual CI, certification record and outstanding consumer work.
All delivery acceptance items have evidence. The issue remains open for PR
integration. No tag, publication, remote protection change or downstream edit has
been performed. Historical issue #10 approval is preserved
byte-for-byte in ISSUE_10_APPROVED_MANIFEST.json and does not approve this issue.
