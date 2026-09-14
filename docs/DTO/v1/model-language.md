# model-language-v1

Status: **implemented candidate; final issue #10 review pending**.
Source: SRC-A A-0191 / EV-A-0291, frozen commit
`56f7eba8a6041160ecf1c1501745c1249e124670`,
`lib/domain/internationalization/model_language.dart`.
Selection: [CP-1](../../migration/CORE_SELECTION.md), VAL-01.

| Key | Output | Constructor | Missing/null decoder behavior |
| --- | --- | --- | --- |
| languageCode | string | required; nonempty debug assertion | `und` |
| scriptCode | string | defaults to empty string | empty string |
| regionCode | string | defaults to empty string | empty string |

All keys are emitted in this order. Unknown input keys are discarded. The const
constructor preserves its strings; the decoder uses tolerant Utils string coercion,
trims all three fields, lowercases language, title-cases script and uppercases region.
An empty/blank decoded language becomes `und`. This is not BCP-47 validation:
arbitrary strings and numeric/boolean coercions remain accepted. The schema describes
the output **shape**, not stricter normalization than the actual constructor.
No dates, numeric values, omission semantics or nullable output fields are introduced.

Equality/hash compare the three strings; hash is a runtime value. `canonicalTag`
joins nonempty components with `-`; direct/raw values need not round-trip through
the normalizing decoder. The value does not extend Model and has no copyWith.
All key/code/preset constants and their exact values are frozen in CP-1.

[Schema](model-language.schema.json) and [synthetic example](examples/model-language.example.json)
are exercised by [runtime tests](../../../test/localization_test.dart).
Cases include all 27 presets, const identity, each equality field, missing/null,
whitespace/case, coercions, one-character scripts, all-field output and diagnostics
of colliding permissive tags. Invalid canonical shapes include omitted keys, null
fields, non-string fields and extra keys. Invalid empty direct construction asserts
only when assertions are enabled; no new runtime validation is added.
