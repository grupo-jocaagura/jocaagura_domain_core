# Transversal core migration and compatibility

Canonical work: [issue #10](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/10).
The [issue #3 plan](https://github.com/grupo-jocaagura/jocaagura_domain_core/blob/729acf7d657ca5a4d675e720235b28f62b2c2234/docs/migration/PLAN.md)
is historical. Its proposed MoneyUtils expansion is superseded by DOMAIN_VERTICAL;
no financial model is needed by this release.

[CP-1](CORE_SELECTION.md) freezes the finite target. The original
[inventory](inventory.json) preserves IDs and scanner evidence;
[architectural decisions](architecture_inventory.json) classify all 1,712 rows.
Exclusion is a completed result, not a promise of migration into core. No source
application is changed, built or migrated.

| Increment | Candidate implementation | Behavior tests |
| --- | --- | --- |
| Baseline | Utils, Unit.value/unit unchanged | Existing signature/compatibility/edge tests and frozen hashes |
| Foundations | Model, EntityUtil, Either/Left/Right/extensions, NoParams, ErrorItem/enums | either/error_item/model_mapping tests |
| Mapping/dates | ModelUtils, Mapper, DateTimeIsoUtils, ClockPolicy, DateUtils/JocaDateUtils | model_mapping/dates tests |
| Execution | Debouncer, corrected PerKeyFifoExecutor | Controlled execution and queue cleanup regression |
| Admitted values | ModelLanguage, ModelLocalizedText | localization tests and wire goldens |
| Consumer proof | Public-entrypoint example with a synthetic Model | example/transversal_core_example.dart and public_composition_test.dart |

## Migration decisions

Coordinate consumer imports or re-export original names from core before sharing
generic values. Identically named source/core types are nominally distinct.
No automated downstream rewrite is included.

- Model follows SRC-A's const abstract JSON/copy/equality/hash contract. SRC-B's
  inherited Object equality and default JSON toString are not added. Consumer
  subclasses implement the selected abstraction explicitly.
- Either follows sealed SRC-B with final branches and FutureOr async support.
  SRC-A clients extending/implementing the hierarchy cannot migrate unchanged.
  Callback exceptions remain errors rather than becoming Left.
- ErrorItem retains shallow metadata equality and constructor/toJson aliases.
  copyWith owns an unmodifiable outer map but not nested values. Deep equality,
  deep freezing or stricter canonical-input validation would change the contract.
- Mapper/ModelUtils preserve Utils behavior. Map conversion can parse JSON text;
  list conversion accepts only an actual List and filters non-maps. An encoded
  array string yields an empty list. Invalid maps become empty maps, after which
  decoder exceptions may propagate. Missing input never becomes Unit.
- DateUtils fallback uses the local DateTime.now clock; integer epochs are local
  DateTime values and Duration adds to now. normalizeIsoOrEmpty trims and converts
  valid values to UTC; invalid values become empty. Dart overflow date normalization
  and timestamp range errors remain. Canonical ISO helpers require exact UTC
  encoding, whitespace and precision. ClockPolicy controls only callers that use it.
- Debouncer preserves default 500 ms and the debug-only positive-delay assertion.
  Restart cancels pending work; dispose is idempotent and ignores future calls.
  Callback exceptions reach the scheduling zone.
- FIFO compares the stored chained tail with itself during cleanup. Dispose clears
  bookkeeping, not actions: old queued/running tasks continue and new same-key work
  can overlap them. Awaiting same-key nested work deadlocks. Keys must be stable
  and waits acyclic. No cancellation or disposal flag is added.
- Localization values keep their hierarchy (neither extends Model), decoder
  normalization, class constants and owned translation map. Fallback is metadata,
  not lookup. Permissive language values can collide in canonicalTag; cross-input
  canonical ordering is guaranteed only for distinct tags.

AddressModel, attributes, CRUD audit metadata, geographic values and graph/vector
families have explicit decisions in CP-1. Required-id, DateTime/nullability,
JWT/profile and Flutter Offset differences are not silently redesigned. Vertical
models, use cases, services, gateways, repositories, providers, UI, fake adapters
and external runtimes remain outside the production closure.

## Review and release handoff

Stop before PR creation at the maintainer's request. The certification record
identifies actual local implementation/tests and limits; it remains draft until
the required candidate review and release evidence exist. After separately
authorized integration into develop, use existing Actions for the actual
development checkpoint and minor promotion to 1.1.0. Do not hand-edit the version.
Preserve completed 1.0.0/CP-0 reports and immutable tag; no publication or CP-0
retry is part of this local handoff.
