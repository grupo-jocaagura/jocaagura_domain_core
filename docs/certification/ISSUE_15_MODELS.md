# Verification record: issue #15 complete model migration

Status: DRAFT — implementation in progress, not certified or released.

- Canonical issue: https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/15.
- Base implementation commit: `22746779e26a7ad5ed349421bf887504ff676faf`.
  The new implementation is currently a local working-tree candidate; this base
  is not presented as a verified implementation commit.
- Public source: jocaagura_domain 1.43.0,
  `56f7eba8a6041160ecf1c1501745c1249e124670`, MIT; paths, source hashes and original
  declaration IDs are in `docs/migration/model_migration.json`.
- API source: new frozen SRC-B / EV-B-15 evidence, distinct from historical
  EV-B-0001/0002. Exact repository/commit/path mappings are retained externally,
  outside all public checkouts/worktrees/package archives. Public records expose
  sanitized evidence identifiers, document hashes and functional contracts only.
- Consumers: backend applications, jocaagura_domain as a future Flutter adapter,
  and Jocaaguraarchetype. No downstream repository was modified, built or migrated.

## Requirement and implementation trace

The issue-specific matrix selects 83 public-source files, including model
families, state/configuration values, abstract animal contracts, supporting enums,
and CRUD parameter data. It inventories 183 API operations from the frozen JSON
catalog. The source selection is independently pinned by
`tool/verify_model_migration.py`; the issue #10 selection, sources and released
foundation exports remain unchanged.

Implementation lives in `lib/src/models`, with explicit family exports under
`lib/models` and the full data entrypoint `jocaagura_domain_models.dart`. Functional
API values/codecs are separately exposed through `jocaagura_domain_api.dart`;
explicit conversion boundaries use `jocaagura_domain_mappers.dart`.

`docs/DTO/api/v1/values.json` is the authored field-definition source, with
sanitized source evidence. Its packaged test copy must remain identical.
`api_contract_proposals.json` contains unreviewed example-shape inference only;
it is not implementation, completeness evidence or an admitted schema.

## Compatibility and boundary decisions

The maintainer requires homologated Utils comparisons/hashes. Source collection
identity comparisons are replaced by matching Utils content comparisons/hashes;
generic attributes compare symmetrically. Legal identity decoding preserves
attributes rather than losing them. The adapter handoff records these explicit
candidate corrections and remaining tolerant-decoder/ownership limits.

Flutter imports/annotations/logging are removed. Vector Offset conversion stays
in the adapter. Menu data uses a plain icon identity; callbacks/rendering stay in
Flutter. Production code has no external package dependency, server/client,
database, credentials/environment access or inference runtime. A session token is
opaque functional data; no provider authentication or transmission is executed.

See `docs/migration/ADAPTER_HANDOFF.md` for complete mapping expectations and
`docs/DTO/api/v1/README.md` for presence/null, ownership, deterministic JSON, strict
canonical API types, date text and flow-specific monetary semantics.

## Actual validation so far

Environment: Windows, standalone Dart SDK 3.13.7 (compatible with the declared
`^3.13.2` minimum), Python 3.13. Source applications were not executed.

- `dart pub get`: passed for this package's development dependencies.
- Baseline `dart test`: 239 existing tests passed before source extraction.
- Source characterization, independent cross-family fixtures and API codec tests
  have passed locally during implementation. Exact final counts/results will be
  recorded after the complete candidate is validated.
- Strict `dart analyze --fatal-infos --fatal-warnings .` passed for the preceding
  candidate; rerun after subsequent contract additions before recording final evidence.
- An early actual coverage measurement was 4587/5031 lines, 91.17%, below the
  requirement. It is historical progress, not passing coverage for the current
  candidate. Additional real contract tests have since been added; final coverage
  remains to be measured and must meet the configured threshold.

No source-project coverage, scores, certificates, CI runs or audit attribution are
inherited. Schema/codec consistency and structural validator success cannot prove
that the authored contracts match a deployed backend. No live integration,
real-provider payment, publication, new tag or downstream adoption is claimed.

## Pending acceptance and review

- Complete and review all remaining API contract families and operation mappings.
- Finish independent behavioral/failure/serialization evidence and adapter examples.
- Run final format, strict analysis, full Dart tests, actual coverage, package dry
  run, documentary validators, workflow/release-script tests and relevant lint.
- Record the exact implementation commit, final PR/CI references where available,
  artifact hashes and actual review outcome.
- Keep `manifest.json` draft until all issue acceptance evidence and the review
  required by the issue are complete. Historical issue #10 approval is preserved
  unchanged in `ISSUE_10_APPROVED_MANIFEST.json` and does not approve this candidate.

Reviewer/date/outcome: pending. No extra human/agent approval gate is introduced.
