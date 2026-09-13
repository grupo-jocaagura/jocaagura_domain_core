# Stable API scope

Issue #3 selects the published 0.0.2 entrypoint
`package:jocaagura_domain_core/jocaagura_domain_core.dart` for 1.0.0.
Inventory entries are plans, not exports. No DTO runtime class, `Either`,
`ErrorItem`, `Model`, `NoParams`, service or adapter is added by this issue.

`Unit` remains an ordinary class with a private const constructor, no fields,
`static const Unit value`, and the top-level `const Unit unit = Unit.value`.
It keeps equality by Unit type, hash 0 and `toString() == 'unit'`. The alias and
static value are identical. No sealed/final modifier or serialization is added.

`Utils` remains an ordinary class with its implicit unnamed constructor and all
30 static helpers. No parameter, generic bound, return type or default is
tightened. Authoritative signatures remain the exported Dartdoc.

The frozen SRC-A comparison (EV-A-0445) does not establish cross-source API
identity. SRC-A `Utils` extends `EntityUtil`; core and SRC-B do not. A future
consumer migration must review subtype assignments and subclasses as well as
static calls. SRC-A `getStringFromDynamic` accepts only the positional input;
core/SRC-B additionally accept named `String defaultValue`, defaulting to `''`.
SRC-A's `_normalizeNumberString` is private, while core preserves its published
public `normalizeNumberString`. The inspected SRC-A class has no
`generatePrefixedId`, `generateSecureToken` or `safeId`; these already exist in
core/SRC-B. These differences require consumer-specific migration checks and
do not justify changing the published core contract.

| Helpers | Preserved contract and risks |
| --- | --- |
| Phone formatting aliases | Corrected and legacy spellings remain; padding and extra/negative-digit behavior stay unchanged. |
| JSON/map/list conversion | Tolerant coercion; typed maps may alias caller data; raw key collisions use iteration order; encoding errors return non-JSON text; custom conversion/iteration exceptions can propagate. |
| Email/URL/string/boolean helpers | Existing defaults and scheme/authority checks remain; these are not security validators. |
| Numeric conversion | Integer fallback applies to null, invalid values become zero; double default is NaN; locale normalization is heuristic and truncation is toward zero. |
| Collection equality and hashes | Existing shallow/deep distinctions and identity fast paths; acyclic data required; hashes are runtime values, not persistent IDs. |
| Duration and enum conversion | Milliseconds and legacy duration forms retain lossy precision; enum matching is case-sensitive with the supplied fallback. |
| IDs and random strings | Existing normalization, clamps and formats; clock and secure randomness are runtime-dependent. No uniqueness or entropy certification. |

The [wire catalog](../DTO/README.md) separates helper serialization from planned
DTO schemas. The [null-safety guide](NULL_SAFETY.md) separates successful completion,
missing data, errors and absent input.

Compatibility validation uses existing characterization/edge tests and
`test/public_signature_test.dart`, compiling constructor use, function tear-offs,
const identity and nullable/generic uses. The production diff is documentation
only. A frozen-source comparison cannot prove arbitrary downstream compatibility.
Future consumers must coordinate imports/re-exports before sharing Unit in
generic signatures. No source application was compiled or migrated.

Release evidence must cover strict analysis, tests and measured coverage, archive
contents, GitHub-verified signatures and the final reviewed commit. The selected
version does not promise APIs that core does not implement.
