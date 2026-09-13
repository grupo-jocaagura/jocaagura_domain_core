# error-item-v1

Status: **DRAFT; not implemented in core**. SRC-A A-0130,
`56f7eba8a6041160ecf1c1501745c1249e124670`, `lib/domain/error_item_model.dart`;
SRC-B B-0008 / EV-B-0108. This study retains the observed common wire shape.

| Key | JSON output | Constructor | Missing/null decoder behavior |
| --- | --- | --- | --- |
| title | string | required | empty string |
| code | string | required | empty string |
| description | string | required | empty string |
| meta | object with open JSON values | optional const empty map | empty map |
| errorLevel | string enum | optional systemInfo | systemInfo |

Enum values are exactly `systemInfo`, `warning`, `severe`, `danger`; unknown or
case-mismatched text decodes to systemInfo. All five keys are emitted in table
order. Unknown input fields are discarded. Strings use tolerant Utils conversion.
Meta uses map conversion, including JSON-string maps and raw-key coercion; a
typed map may be retained by reference. No dates, timezone or numeric precision
policy is added; numeric values inside meta retain JSON/runtime limitations.

Both variants extend Model and have the same const constructor, fromJson factory,
typed copyWith, getErrorLevelFromString(String?) and field types. copyWith null
means preserve; it wraps meta in an unmodifiable map. Constructor meta can be
mutable, and nested values are not deeply frozen. Equality uses shallow map
value equality, not recursive deep equality; hash combines unordered entry
hashes. SRC-A gets mapEquals via Flutter; SRC-B supplies an SDK-only helper.
Changing modifiers, nominal Model identity or deep equality requires separate
compatibility review. Default error constants are not new core exports.

[Schema](error-item.schema.json) and [synthetic example](examples/error-item.example.json)
describe complete JSON output. The source schema requires all fields and exact
types/enum while the parser accepts absent/null fields and broader coercions.
That is a documented schema/decoder difference, not permission to tighten the
decoder. Non-encodable meta objects can make JSON encoding fail; a Map-returning
toJson is not proof that all values are JSON-safe.

Invalid canonical cases: omitted title, null meta, unknown errorLevel, extra keys.
Legacy decoder edge cases: `{}` produces defaults; `{"errorLevel":"SEVERE"}`
uses systemInfo; `{"meta":"{\"count\":1}"}` may decode to a map. They must not
be advertised as canonical wire payloads or lossless round trips.

Future runtime tests: const and named parameters, enum fallback, malformed/raw
meta, aliases versus copyWith ownership, nested shallow equality, exception
propagation, all-field output goldens and public generic result signatures.
The fixture validator currently checks schema/examples only. No implementation,
migration or certification is claimed. Keep v1 wire behavior fixed when selected;
breaking field/enum/default changes need an explicit versioned contract decision.
