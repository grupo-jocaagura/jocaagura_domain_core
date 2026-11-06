# Consumer and Flutter-adapter handoff: issue #15

Status: DRAFT candidate. No downstream application has been rewritten or
certified by these local package tests. The complete technical mapping lives in
`model_migration.json`; GitHub issue #15 remains the canonical work tracker.

## Dependency and import direction

Backend consumers and the Flutter-facing `jocaagura_domain` package depend on
`jocaagura_domain_core`. This package depends only on the Dart SDK. Flutter stays
in the adapter and its applications. The source package's permissive Dart/Flutter
SDK constraints do not override this package's Dart `^3.13.2` minimum: consumers
must first select a compatible SDK. No consumer SDK upgrade was executed here.

Use `package:jocaagura_domain_core/jocaagura_domain_core.dart` for the unchanged
released foundation types. Use `jocaagura_domain_models.dart` for the migrated
model set, or an explicit `models/<family>.dart` entrypoint for a narrower public
surface. Use `jocaagura_domain_api.dart` for implemented canonical API projections
and `jocaagura_domain_mappers.dart` for explicit source/API conversion boundaries.
The API operation matrix identifies all 183 operations and their local contracts;
inferred example shapes are not admitted contracts. Review and real consumer
adoption remain separate acceptance evidence.

## Transition sequence

1. Replace or re-export foundation types consistently, especially `Model`,
   `Either`, `ErrorItem` and `Unit`. Same-name copies from different libraries
   remain nominally different. The issue #10 Either extensibility migration
   remains applicable; it is not silently redesigned by issue #15.
2. Remove migrated `part` declarations and duplicate classes from the Flutter
   library. Re-export canonical classes and supporting enums/aliases from this
   package. Migrate imports throughout generic signatures together.
3. Keep services, repositories, gateways, controllers, widgets, rendering,
   credentials and transport implementations in consumers/adapters. Their plain
   configuration/state/parameter values can use the canonical data library.
4. Implement explicit Flutter conversions for the splits below. Re-exporting a
   wrapper does not make it the same type as its canonical wrapped value.
5. Adopt functional API DTOs where persisted/source shapes differ; do not decode
   an API response through a superficially similar legacy model.
6. Run real consumer analysis/tests against the actual package revision. Record
   those results separately from this package's synthetic composition examples.

## Flutter data splits

`ModelVector` preserves numerical constructors, JSON and arithmetic. It has no
`Offset` dependency, `offset` getter or `fromOffset` factory. The adapter can
provide an extension getter converting `dx/dy` to a Flutter Offset and an adapter
function accepting an Offset and constructing `ModelVector(offset.dx, offset.dy)`.
Static factory calls must be migrated explicitly; extensions cannot add named
constructors to the canonical class.

`ModelMainMenuModel` now holds only `ModelIconData`, label and description. The
adapter constructs its Flutter IconData from codePoint/fontFamily/fontPackage/
matchTextDirection and owns the click callback. Rendering/font availability is
never resolved by this package. The old callback-bearing wrapper must become a
Flutter wrapper around the canonical data. This is an explicit source migration:
the data value now has meaningful JSON output instead of the old empty map.

`ScreenSizeConfig` retains numeric configuration only. Responsive controllers,
widgets and platform sizing behavior remain in Flutter. No replacement framework
classes or framework imports are introduced into the domain package.

## Equality, hashing and serialization decisions

Per the maintainer's explicit instruction, use the homologated `Utils` tools.
Collection comparisons use `Utils.listEquals` or `Utils.deepEqualsDynamic`;
collection hashes use the matching `Utils.listHash`/`Utils.deepHash`. The source's
identity comparisons for person/legal/user maps, treatment plans, CRUD diffs,
group labels/settings and medical-record lists now compare contents. Do not
persist runtime hash codes or expect their previous numeric values.

Attributes compare name/value content using Utils, symmetrically across generic
specializations. The source's `AttributeModel<String>` versus decoded
`AttributeModel<dynamic>` distinction must not break otherwise equal data.
`LegalIdModel.fromJson` now preserves named attributes rather than dropping them;
this also fixes nested medical-record serialization. These are documented
candidate corrections, not claims that the original source had this behavior.

Clinical acceptance clauses, dental conditions and diagnosis tabs compare their
actual fields through Utils rather than treating a matching hash as equality.
Regression tests force collisions to verify the distinction. Redundant hash
predicates are removed from migrated values. `DeathRecordModel.fromJson` retains
its existing instance-method signature but now reads person/address/recordId from
their declared JSON keys. Consumers relying on the source's swapped decoding
must correct that reliance; no historical core export is modified.

Existing collection ownership is retained where needed for source compatibility.
A final field does not mean its referenced map/list is deeply immutable; mutating
such legacy values can change equality/hash. Canonical API values own deep JSON
copies and have different, explicit ownership contracts. Published core behavior,
including ErrorItem's documented shallow semantics, remains unchanged.

Legacy tolerant conversion, local-clock fallbacks, non-finite numeric defaults
and serializer normalization remain explicit limits. For example, an empty graph
axis/diagnosis input can produce NaN, which JSON encoding rejects; a new item with
an empty ID can serialize a category-derived ID. Validate representability before
using arbitrary legacy values as canonical API payloads. Do not silently rewrite
all amounts, timestamps or identifiers through one universal DTO.

## Explicit API mapping limits

Address conversion preserves all eight fields, including legacy negative postal
codes in output values; `ApiAddressInput` separately validates commercial input.
Personal API attributes are string values, while the legacy person uses named
AttributeModels. A mismatched attribute name or non-string value fails explicit
conversion instead of silently discarding data or stringifying arbitrary values.

Legal identity conversion preserves zero-prefixed document strings and arbitrary
JSON attributes. API document types not present in the legacy enum, including
RUT, fail conversion explicitly; the API DTO itself supports the published string
contract. Article price mapping preserves amount/precision/currency and does not
relabel sales-order totals as the same monetary scale. User/session projections
do not require legacy JWT or persistence fields.

Generated field definitions are authored against frozen contracts before code
generation. Generation and structural validators do not prove deployment, access,
durability, real-provider support or downstream adoption. No version, source
repository, release tag or publisher configuration was changed for this handoff.
