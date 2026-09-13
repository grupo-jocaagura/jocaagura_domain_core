# Migration plan and compatibility decisions

Canonical tracker: [issue #3](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/3).
These are contract decisions, not duplicate issue completion state.

| Wave | Retained scope | Requirement -> source -> contract -> implementation/test |
| --- | --- | --- |
| 0, this release | Existing Utils and Unit/value/alias | DOM-002/QA-001 -> EV-A-0444/0445 and EV-B-0117/0118 -> STABLE_API/NULL_SAFETY -> existing exports, characterization, signature tests and measured coverage. |
| 1, proposed foundations | Model, EntityUtil, Either/Left/Right, NoParams, ErrorItem | DOM-001/002 -> inventory evidence -> constructor/generic/modifier comparison and error-item-v1 draft -> future subclass/implementation probes, both result branches, thrown transforms, equality and metadata alias tests. |
| 1, proposed utilities | DateUtils/JocaDateUtils, ModelUtils, DateTimeIsoUtils, ClockPolicy, Mapper, MoneyUtils, Debouncer, PerKeyFifoExecutor | DOM-001 -> inventory evidence -> explicit clocks, parsing, rounding, cancellation, disposal and errors -> separate scoped extraction with deterministic and scheduling-failure tests. |
| 1, retained DTO study | AddressModel | DOM-001/002 -> EV-A-0103, EV-B-0122 -> address-v1 draft -> resolve required id and diagnostic/hash differences; omission/null/negative-postal-code goldens; compile both constructor patterns. |
| Unselected | Other identity, CRUD, finance, groups, calendar, education, geometry, AI, document and feature models | Enumerated as deferred; not retained for a migration wave or wire catalog. Select a coherent dependency closure and document fields before implementation. |
| Excluded | Runtime services, transports, UI/blocs, orchestration, fake adapters and crypto-dependent helpers | Boundary, source references and dependency closure are recorded. Consumer infrastructure owns these; no rewritten crypto or imported runtimes. |

Future selected wire contracts require indexed schemas, field matrices, synthetic
examples, decode/encode/error goldens and public-signature compilation tests
before extraction. Never tighten a tolerant decoder merely to satisfy a schema.

Concrete reviewed differences:

- SRC-A part files share a barrel importing Flutter foundation/material.
  Pure-looking leaves are not standalone SDK-only libraries. Untangling their
  annotations/equality/imports requires a scoped extraction.
- **Either reference decision:** the maintainer prioritizes SRC-B, including
  async methods/extensions. It is sealed with final Left/Right; SRC-A's abstract
  Either and extensible Left/Right permit client subtyping. A future migration
  must check that incompatibility explicitly. This decision does not publish
  Either in the current stable API or claim drop-in compatibility.
- AddressModel has the same wire fields but requires `id` only in SRC-B.
  toString and hashing differ. Shared names/JSON do not imply source equivalence.
- ErrorItem has the same five fields; SRC-A resolves shallow map equality through
  Flutter while SRC-B provides a local helper. Constructor meta can be mutable;
  copyWith wraps an unmodifiable map. Deep equality is not a safe substitute.
- SRC-B schema material mixes canonical schemas and legacy parsing. Address
  schema filenames/IDs disagree and impose nonnegative postal codes while
  constructors accept negative ints. Error schemas require full fields while
  parsers tolerate missing/null fields. Draft pages retain those distinctions.
- Source documentation warns of user-token object vs encoded-string and person
  attribute-map differences. Those families are unselected; these documentary
  warnings are not certified current runtime equivalence findings.

Additional retained utility findings from the frozen code:

- DateUtils returns the current local clock for invalid dynamic input and adds
  Duration to now. Its normalizeIsoOrEmpty instead returns empty text on invalid
  input and normalizes valid input to UTC. These policies must not be merged.
- MoneyUtils depends on FinancialMovementModel; getLatestMovement sorts the
  caller list in place, while sortByDate copies it. Date ranges are inclusive;
  decimal totals use doubles without a new rounding/currency policy. A future
  extraction must first retain/document that DTO dependency, currently unselected.
- Debouncer cancels the prior Timer, ignores calls after dispose and uses an
  assertion for a positive delay. Callback exceptions are not converted to
  ErrorItem. Dispose is idempotent; it does not retroactively undo a callback.
- PerKeyFifoExecutor propagates action failures through try/finally and releases
  its gate. Its cleanup compares the stored chained Future with gate.future,
  which are distinct objects; dispose clears bookkeeping without cancellation.
  A future extraction needs a focused correctness decision and failure/disposal
  tests before adoption. No production use was observed in the frozen sources.
- SRC-B Mapper<T extends Model> delegates to fromJson; exceptions propagate.
  ClockPolicy is an abstract const policy with DateTime nowUtc(), not an installed
  clock runtime. ModelUtils discards non-map list elements through Utils.

No additional consumers, downstream migration, source builds or production
runtime verification are claimed. Proposed waves need their own implementation
evidence. Source revisions and private mappings remain frozen and restricted.
