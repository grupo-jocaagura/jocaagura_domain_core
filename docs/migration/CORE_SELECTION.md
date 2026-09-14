# Frozen transversal core: CP-1 v1

Canonical scope: [issue #10](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/10).
This technical selection precedes implementation. It is not maintainer release
review. `core_selection.json` freezes signatures, constants, modifiers, dependencies,
source evidence, target files and behavior-test obligations. Its `selection_sha256`
is SHA-256 of the object without that field, encoded as sorted-key compact UTF-8
JSON (`ensure_ascii=False`). No top-level API may enter silently after this freeze.

The 20 new public symbols comprise the 15 foundation APIs, two error enums, the
Future Either extension and two localization values. Preserve the three existing
exports `Utils`, `Unit`, `unit` and every member/signature of the released baseline.
`Model` follows SRC-A's abstract JSON/copy/equality/hash contract; it deliberately
does not acquire SRC-B's default JSON diagnostic string. `Either`, its final
branches and async extension follow SRC-B. Public names are exported explicitly
with `show` to prevent accidental admission of source defaults or helpers.

## Source and admission evidence

SRC-A is jocaagura_domain 1.43.0 at
`56f7eba8a6041160ecf1c1501745c1249e124670`. SRC-B is the frozen EV-B-0001
snapshot in the maintainer's external handoff and complete 1,712-record mapping.
EV-B-0002 remains historical. Source Git objects were read into memory; no source
checkout, build, dependency installation or downstream migration is needed.
The sources and their recorded call sites are the entire inspection universe.
Static references support contract inspection, not deployed integration.

SRC-A's MIT notice is preserved by this package's identical LICENSE. The frozen
SRC-B root has no LICENSE file; reuse follows the maintainer's explicit extraction
instruction, as in the preceding extraction. No source license grant or third-party
rights clearance is inferred. Only selected generic code is adapted; source
fixtures, sample/product data and private provenance stay outside public artifacts.

Every selected declaration answers five questions in the companion: independence,
usefulness without business context, transversal semantics/use, simple SDK
adaptation, and equally transversal dependency closure. The target closure is
finite: the named foundation/value symbols, private equality/normalization helpers,
unchanged `Utils`/`Unit` and permitted SDK classes. The SDK provides maps/lists,
dates, `Future`/`FutureOr`/`Completer`/`Timer`, JSON and existing random/math helpers.
There is no consumer, storage, transport, provider, service or business-model
dependency in that closure. Splitting part libraries and removing `@immutable`
avoids Flutter; no replacement framework or production package is introduced.

## Complete architectural inventory

`inventory.json` preserves all original IDs and historical scanner evidence.
`architecture_inventory.json` adds one architectural disposition for every row,
five admission answers, function/reason, counterpart resolution and dependency
evidence. Excluded contracts have no core implementation obligation. In particular,
DOMAIN_VERTICAL is a completed classification result, not hidden migration debt.

The review distinguishes declaration roles and containing contracts: enums and
aliases supporting a business model retain its domain; transport/use-case/adapter
interfaces remain infrastructure even if abstract; presentation values remain UI;
fixtures remain test-only. Evidence is attached to original EV identifiers and
reviewed conditional/foundation decisions. No unexplained auxiliary catch-all
remains. Same names on excluded rows are left as collision candidates rather than
asserted equivalent. Reviewed foundation counterparts explicitly identify their
canonical record and intentional variant differences.

Source dependency data has an explicit precision boundary: the original exact
part/import library closure is conservative, while identifier matches are lexical
candidates (including same-name ambiguity), not analyzer-resolved minimal type
dependencies. Library IDs group original evidence IDs; the existing external map
retains exact private paths, including imports outside the declaration inventory.
This is sufficient to trace excluded contracts without publishing private paths.
Only admitted APIs claim the explicitly reviewed minimal **target** closure in
CP-1. Structural validation does not prove the architectural decisions correct.

## Conditional values and excluded supports

`ModelLanguage` and `ModelLocalizedText` are admitted. Language/script/region
identity and language-keyed text are inherently transversal. Their closure is
`Utils`, SDK collections/strings and private helpers. They do not extend `Model`;
changing that hierarchy just to feed `Mapper` would change the source contract.
All class constants are frozen, including supported language presets. No top-level
default/example values are imported. Decoder normalization is distinct from direct
constructor input. Translation fallback is a stored language value, not an
invented locale-negotiation or text-lookup algorithm.

`AddressModel` is OUT_OF_SCOPE: the shared address record is optional for this
release and has unresolved consumer selection for optional/required id and
diagnostic/hash variants. The eight-field draft wire study remains unimplemented.
Generic attributes, CRUD audits and geographic values are explicitly excluded;
their concrete reasons and source IDs are in CP-1. The graph/point closure reaches
the vector's public Flutter `Offset` conversion. Removing that conversion would
alter the complete contract. Identity/profile/JWT and ordinary vertical families
remain outside core. MoneyUtils, financial movements and ledgers are DOMAIN_VERTICAL.

`ErrorItemEnum` and `ErrorLevelEnum` are required wire support and exported.
`defaultErrorItem`, the public `mapEquals` helper, clock implementations, session
policies and unrelated source defaults are not exports. ErrorItem uses a private
nonnullable specialization of the shallow SDK equality helper; nested metadata
remains shallow, and constructor ownership remains aliased.

## Observable compatibility and test obligations

- Preserve all released Utils behavior and Unit const identity. Existing regression
  and signature tests run unchanged; compare source file hashes to the baseline.
- Either is sealed and Left/Right final: migrate imports/re-exports together and
  remove unsupported SRC-A subclassing. New package identity is nominally distinct.
  Cover both branches, generics/null, equality, synchronous/async callbacks,
  upstream Future errors and branch effects. No callback error is an automatic Left.
- ErrorItem retains five-field tolerant decoding, enums, constructor aliasing,
  copyWith ownership, shallow metadata equality, diagnostics and JSON failures.
- Mapper/ModelUtils preserve decoder exception propagation, generic bounds,
  non-map filtering and malformed-input defaults. Synthetic consumer models stay
  in examples/tests; they are not extra production exports.
- DateUtils has local-clock fallback/Duration addition and local epoch conversion.
  Normalization returns empty for invalid input and UTC for valid dates. Canonical
  ISO parsing is exact, nullable and precision-sensitive. ClockPolicy is explicit;
  it does not intercept legacy DateTime.now calls. Use bracketing for those calls
  and controlled clocks/timers where the public contract supports them.
- Debouncer preserves positive-delay debug assertions and scheduling-zone errors.
  Use controlled time for cancellation/restart/disposal; no sleep-based test gates.
- FIFO cleanup compares the stored chained tail with that same tail. This is a
  bounded correctness repair, not cancellation or a new lifecycle API. Prove
  independent keys, synchronous/asynchronous failure recovery, cleanup and reuse,
  old queued work after dispose and new work that may overlap it. Awaiting a nested
  same-key lock creates a circular wait; same-key fire-and-forget or different-key
  nesting is possible when no circular wait is introduced. Keys need stable equality.

The test files named per symbol and public-entrypoint examples provide in-package
functional evidence. They cannot establish a deployed consumer integration.
Final maintainer review, PR/CI, version preparation and actual 1.1.0 publication
remain separate evidence under #10. This work stops before creating a PR.
