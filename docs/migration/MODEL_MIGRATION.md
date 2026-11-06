# Complete SDK-only model migration: issue #15

Canonical tracker: https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/15.
Branch: `feature/15-migrate-api-models-dart-only`. Status: internally approved
certification; implementation, review and actual delivery CI recorded separately.
Delivery: https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/16 into develop.

This issue expands the package's model scope beyond the finite 1.1.0 transversal
selection. `CORE_SELECTION.md`, its hashes and historical exclusions remain
unchanged. Vertical models are now required by the explicitly expanded issue.
The stable core entrypoint remains intact; model families have separate explicit
entrypoints and use the same released nominal `Model`, `Either` and `ErrorItem`.

## Sources and completeness

The public source remains jocaagura_domain 1.43.0 at
`56f7eba8a6041160ecf1c1501745c1249e124670` (MIT). Read Git objects in memory;
do not build, check out or modify source applications. API evidence is a new
SRC-B snapshot, EV-B-15; exact repository/commit/path and per-document mappings
are retained in a fresh external restricted file. The public matrix contains
document hashes and functional HTTP contracts, never private provenance paths.

`model_migration.json` records the selected source model files/declarations and
all catalog operations. Selection is not implementation. Every source value,
including abstract animal contracts, state/configuration values and CRUD
parameter data, needs a target and tests. Controllers, services and transport
execution remain consumer responsibilities. Flutter-coupled domain data is split,
not silently excluded. Undocumented API internals are not canonical domain fields.

## Contract decisions before implementation

- Preserve released core contracts and source constructor/wire behavior wherever
  possible. Do not make legacy parsers strict to satisfy a request validation rule.
- Separate API input/output projections from legacy persisted/source models.
  Differences in field names, nullability, defaults and money scales need explicit
  DTOs or mappers. Do not substitute a same-name class as proof of compatibility.
- Retain documented shallow/deep collection semantics and sentinel-based clearing;
  explain legacy mutability rather than falsely promising deep immutability.
- Remove Flutter annotations/logging. ModelVector retains numerical semantics;
  Offset conversion belongs to the Flutter adapter. Menu icon data must become a
  plain value; callbacks/rendering stay in the adapter. Document migration breaks.
- Keep production dependencies SDK-only, including all transitive model imports.
  SDK-only configuration/parameter values do not execute infrastructure.
- Add only models needed by source or published functional API contracts. API
  snapshots, synthetic examples and local tests do not demonstrate deployment,
  real payment support or downstream migration.

## Delivery and evidence

Freeze the expanded matrix before substantive implementation. Implement source
families in dependency order, then operation-specific API projections and missing
contracts. Track each implementation and meaningful behavioral tests in the new
matrix. Preserve historical evidence and maintain issue-specific certification.
Provide import/re-export/conversion guidance for jocaagura_domain,
Jocaaguraarchetype and backend consumers. Downstream changes/publication are
separate coordinated work, not an implicit completion claim.

Run the Dart toolchain, existing validators, workflow/release-script checks and
actual coverage gate. Record exact results, measured coverage and remaining
limits. Do not mark the issue or certification complete with pending models or
unverified acceptance items. Version preparation/promotion and release provenance
remain governed by the existing CI process; no public version is edited here.
