# address-v1

Status: **DRAFT; not implemented in core**. Retained study: SRC-A A-0003,
`56f7eba8a6041160ecf1c1501745c1249e124670`, `lib/domain/address_model.dart`;
SRC-B B-0022 / EV-B-0122. Same wire keys; different constructor requirements.

| Key | JSON output | Constructor | Missing/null decode |
| --- | --- | --- | --- |
| id | string | SRC-A optional `''`; SRC-B required | `''` |
| postalCode | integer | optional `0` in both | `0` |
| country | string | required | `''` |
| administrativeArea | string | required | `''` |
| city | string | required | `''` |
| locality | string | required | `''` |
| address | string | required | `''` |
| notes | string | optional `''` | `''` |

Both const constructors and `fromJson(Map<String, dynamic>)` exist. `copyWith`
uses nullable named parameters; null means retain current value, not clear it.
Every field is emitted by toJson in table order. No nested DTO, enum, timestamp
or timezone is present. JSON object order is not an interoperability requirement;
do not reorder an existing encoded-string golden without evidence.

String decoding uses Utils coercion, not strict string validation. Integer
decoding truncates doubles and tolerates numeric text; negative ints are accepted.
Missing/null inputs therefore do not round-trip to omission/null. Unknown keys
are discarded. Very large numbers need consumer/platform precision checks;
postal codes with leading zeros lose them when represented as an integer.

[Schema](address.schema.json) describes complete serializer-output shape;
[example](examples/address.example.json) is synthetic. No source example is copied.
Wrong string types, null fields and extra keys fail the canonical output schema,
even when a source decoder tolerates or drops those inputs.

**Recorded discrepancy:** inspected SRC-B reference material names its address
schema inconsistently with its embedded ID and example naming. Its schema
requires only five address strings and constrains postalCode >= 0. Both current
serializers emit eight fields and can emit negative postalCode. This draft
explicitly models actual full output and permits negative integers. Selecting
strict canonical input validation versus historical output needs a future
contract decision; this issue does not change either source or its decoder.

Both extend Model. SRC-A shares Flutter part-library coupling; SRC-B uses local
SDK-only Model/Utils imports. Equality compares fields in both; hash algorithms
and diagnostic toString differ. SRC-A's optional id cannot be tightened without
breaking source calls. Library identity changes also affect nominal typing.

Future tests: both constructor call patterns, const/copyWith signatures, empty
and explicit-null input, negative/fractional/text postal codes, unknown fields,
all-field output goldens and distinct toString/hash expectations. Current
`verify_dto_docs.py` checks only synthetic JSON/schema consistency. No runtime
model characterization is claimed. Incompatible wire decisions need a new
contract version; an extraction must preserve the explicitly selected legacy
behavior rather than merge these variants into a universal DTO.
