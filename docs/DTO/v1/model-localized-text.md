# model-localized-text-v1

Status: **implemented candidate; final issue #10 review pending**.
Source: SRC-A A-0192 / EV-A-0292, frozen commit
`56f7eba8a6041160ecf1c1501745c1249e124670`,
`lib/domain/internationalization/model_localized_text.dart`.
Selection: [CP-1](../../migration/CORE_SELECTION.md), VAL-02.

| Key | Output | Constructor | Missing/null decoder behavior |
| --- | --- | --- | --- |
| translations | array of `{language, text}` objects | required language-to-string map, copied and unmodifiable | empty array/map |
| fallbackLanguage | complete model-language-v1 object | ModelLanguage.undetermined | undetermined language |
| translations[].language | complete model-language-v1 object | map entry key | undetermined language |
| translations[].text | string | map entry value | empty string |

Output always includes both top-level keys and both keys per translation. Unknown
fields are discarded. Decoder translations must be an actual List: non-list values,
including JSON-encoded array strings, produce an empty map. Non-map elements are
discarded. Raw map keys are coerced by Utils. Language/fallback values use tolerant
map conversion followed by [language normalization](model-language.md); text uses
tolerant string conversion. Normalized duplicate languages keep the last text.

The constructor copies the map; callers cannot mutate the exposed translations.
Language and text values are scalar/immutable. Equality and unordered hashing use
all language/text pairs and fallback language, independently of insertion order.
Serialization sorts entries by canonicalTag. With distinct tags, equal maps emit
the same order. Permissive raw language components can form identical tags for
unequal language values; tie order is not a cross-input canonicalization guarantee.
No language validation or collision policy is invented to change this source limit.
The schema describes shape; sorting, duplicate resolution and ownership are runtime
contracts covered by tests, not assertions made by the JSON schema.

Fallback is stored metadata and may refer to a language absent from the map.
There is no automatic lookup, language negotiation or fallback text algorithm.
The class does not extend Model and does not add copyWith. No dates, numeric
precision, null output or omission semantics exist for this DTO.

[Schema](model-localized-text.schema.json) and [synthetic example](examples/model-localized-text.example.json)
are tested by [runtime goldens and behavioral tests](../../../test/localization_test.dart)
and the [public composition example](../../../example/transversal_core_example.dart).
Tests cover defensive ownership, fallback absence, malformed input, non-map filtering,
duplicates, coercion, equality fields, unordered hash, sorted output and tag collisions.
Invalid canonical shapes include missing/null top-level fields, a translation without
language or text, non-string text, incomplete language objects and unknown keys.
