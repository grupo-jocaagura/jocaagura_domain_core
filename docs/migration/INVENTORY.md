# Architectural inventory: issue #10

The [architectural companion](architecture_inventory.json) gives one disposition
for every original row: CORE 22, DUPLICATE_COUNTERPART 10, DOMAIN_VERTICAL 879,
INFRASTRUCTURE 638, UI 36, TEST_FAKE 91, EXTERNAL_RUNTIME 7, OUT_OF_SCOPE 29.
The original [inventory.json](inventory.json) and all 1,712 IDs remain unchanged.
CORE contains two baseline declarations and 20 new symbols. The top-level unit
alias was not a declaration row; it is preserved explicitly in CP-1.

See [selection](CORE_SELECTION.md) for admission, exact signatures/dependencies,
conditional decisions and source-closure precision limits. DOMAIN_VERTICAL and
other exclusions are valid completed decisions, not implementation obligations.
Original coarse decisions below are historical scanner labels; the companion
supersedes them for current admission. They are not duplicate issue state.

# Historical frozen scanner inventory

Canonical tracker: [issue #3](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/3).
Inspection is not implementation. Stable exports are limited to Utils, Unit.value
and unit. See [plan](PLAN.md), [stable API](STABLE_API.md), [null safety](NULL_SAFETY.md)
and [DTO catalog](../DTO/README.md).

## Universe and reproducibility

SRC-A: jocaagura_domain 1.43.0 at intentionally frozen
56f7eba8a6041160ecf1c1501745c1249e124670, selected after the maintainer update.
SRC-B: EV-B-0001. Exact identity, revision, paths and call-site lines exist only
in the maintainer's external restricted evidence. EV-B-0002 is historical and
is not relabeled as the new snapshot. Additional consumer repositories: none.

Read Git objects with `git archive <frozen-revision>` into memory. Never extract
source archives into this repository, run source code, fetch, switch source
branches or install source dependencies. `tool/inventory_sources.py` takes
privately supplied roots/revisions and a new restricted output path outside
all Git checkouts. It refuses a restricted output inside a Git worktree.

Enumeration roots: every tracked Dart declaration in SRC-A lib; SRC-B core,
top-level domain, all feature/app domain subtrees, utility/helper Dart files and utility/helper
directories (including two auxiliary declarations appended without changing
existing evidence IDs).
The exact SRC-B roots are restricted; public rows cite stable EV-B identifiers.
This includes feature models, enums, typedefs, mixins and extensions, plus
excluded runtime/orchestration declarations. Private names without an explicitly
retained/common contract are represented by neutral candidate labels.

Reference search: all tracked Dart and Markdown files in both frozen snapshots.
Production reference counts cover lib/bin; test/example roots are separate;
other text references are documentary. The query is a whole identifier token
matching the enumerated declaration name, with Dart comments removed. Declaration
lines are excluded, but self references, quoted identifiers and name collisions
can remain. Counts are static references, not call counts, proven import binding,
unsafe-null counts or production execution. Zero means not observed in these
roots; dynamic/external usage remains unknown. No additional repository search
is needed to eliminate those unknowns.

Imports/exports/part directives are resolved into a local dependency graph.
The transitive closure includes bidirectional part-library coupling. Non-SDK
imports in SRC-B are reported generically; exact URIs remain restricted.
Inheritance can reach symbols through the containing library's imports/parts;
these conservative library closures must not be called minimal type closures.
Unresolved local directives remain explicit. Same-name counterparts are collision
candidates, not asserted equivalent APIs. Renamed counterparts need semantic
review; the selected AddressModel and Either differences are documented in PLAN.

The search ends after enumerating the declared set, recording token matches and
library closures, and reviewing the relevant retained contracts/call sites.
Unselected candidates retain static evidence and unresolved semantics. No attempt
is made to infer business meaning or certify every private class from its name.
The restricted companion records every declaration and match by frozen path/line;
public SRC-A rows also include exact public path/line. No private mapping is stored
in this checkout, even under ignored directories.

## Results and decisions

| Source | Selected Dart files | All Dart files searched | Candidates |
| --- | --- | --- | --- |
| SRC-A | 174 | 328 | 345 |
| SRC-B | 583 | 1511 | 1367 |

The [machine-readable inventory](inventory.json) is the complete per-declaration
catalog: stable ID, source, category, API or sanitized label, DTO/N/A reason,
dependency closure, counterpart IDs, usage categories, intended consumer, risks,
decision, priority, wave and evidence. No declarations are silently omitted from
the stated enumeration merely because they are excluded from core.

Decision terminology: `extract` means already extracted Utils/Unit, not new code;
`adapt` means retained for a future scoped contract migration; `defer` means
unselected (no promised wire contract or migration wave); `exclude` means runtime
or dependency boundary outside core. The complete JSON preserves each decision.

## Retained candidates

| ID | Source API | DTO | Counterpart IDs | References prod / test-example / docs | Evidence |
| --- | --- | --- | --- | --- | --- |
| A-0001 | JocaDateUtils | N/A: no independent DTO | not observed | 0 / 0 / 5 | EV-A-0101 |
| A-0002 | DateUtils | N/A: no independent DTO | not observed | 77 / 129 / 17 | EV-A-0102 |
| A-0003 | AddressModel | address-v1 | B-0022 | 21 / 18 / 13 | EV-A-0103 |
| A-0071 | Debouncer | N/A: no independent DTO | not observed | 9 / 17 / 14 | EV-A-0171 |
| A-0111 | Either | N/A: no independent DTO | B-0009 | 331 / 537 / 83 | EV-A-0211 |
| A-0112 | Left | N/A: no independent DTO | B-0010 | 86 / 215 / 38 | EV-A-0212 |
| A-0113 | Right | N/A: no independent DTO | B-0011 | 56 / 369 / 35 | EV-A-0213 |
| A-0127 | EntityUtil | N/A: no independent DTO | B-0003 | 3 / 1 / 4 | EV-A-0227 |
| A-0130 | ErrorItem | error-item-v1 | B-0008 | 589 / 1099 / 94 | EV-A-0230 |
| A-0301 | NoParams | N/A: no independent DTO | not observed | 4 / 0 / 0 | EV-A-0401 |
| A-0315 | MoneyUtils | N/A: no independent DTO | not observed | 4 / 17 / 3 | EV-A-0415 |
| A-0318 | Model | N/A: no independent DTO | B-0015 | 103 / 11 / 20 | EV-A-0418 |
| A-0319 | PerKeyFifoExecutor | N/A: no independent DTO | not observed | 0 / 17 / 15 | EV-A-0419 |
| A-0344 | Unit | N/A: no independent DTO | B-0017 | 51 / 105 / 39 | EV-A-0444 |
| A-0345 | Utils | N/A: no independent DTO | B-0018 | 532 / 322 / 35 | EV-A-0445 |
| B-0002 | DateTimeIsoUtils | N/A: no independent DTO | not observed | 101 / 29 / 19 | EV-B-0102 |
| B-0003 | EntityUtil | N/A: no independent DTO | A-0127 | 1 / 0 / 0 | EV-B-0103 |
| B-0008 | ErrorItem | error-item-v1 | A-0130 | 16638 / 8650 / 698 | EV-B-0108 |
| B-0009 | Either | N/A: no independent DTO | A-0111 | 5590 / 4097 / 548 | EV-B-0109 |
| B-0010 | Left | N/A: no independent DTO | A-0112 | 6016 / 1867 / 805 | EV-B-0110 |
| B-0011 | Right | N/A: no independent DTO | A-0113 | 3194 / 2308 / 503 | EV-B-0111 |
| B-0013 | Mapper | N/A: no independent DTO | not observed | 2 / 0 / 9 | EV-B-0113 |
| B-0015 | Model | N/A: no independent DTO | A-0318 | 344 / 0 / 18 | EV-B-0115 |
| B-0016 | ModelUtils | N/A: no independent DTO | not observed | 37 / 0 / 1 | EV-B-0116 |
| B-0017 | Unit | N/A: no independent DTO | A-0344 | 832 / 374 / 11 | EV-B-0117 |
| B-0018 | Utils | N/A: no independent DTO | A-0345 | 2175 / 145 / 3 | EV-B-0118 |
| B-0022 | AddressModel | address-v1 | A-0003 | 87 / 72 / 49 | EV-B-0122 |
| B-0116 | ClockPolicy | N/A: no independent DTO | not observed | 7 / 7 / 0 | EV-B-0216 |

Full family decisions and compatibility limits are in PLAN. Address/error schemas
are draft studies. Model and typed-result foundations have no independent DTO.
NoParams is retained as an input marker despite residing in a use-case directory.
CryptoUtils is excluded due to a non-SDK crypto dependency; it is not rewritten.
For SRC-A, all part-linked candidates inherit Flutter coupling, including types
with no direct Flutter identifier in their own file. Source-B helpers with only
SDK imports still need their constructor and generic contracts preserved.

Representative production-reference reviews: the exact Unit.value disposal and
onboarding call sites are in NULL_SAFETY; SRC-B alias-based result completion,
model conversion callbacks and canonical UTC validation are mapped to their
restricted evidence IDs. PerKeyFifoExecutor had no observed production reference
outside its declaration; its tests/docs do not prove production adoption.
