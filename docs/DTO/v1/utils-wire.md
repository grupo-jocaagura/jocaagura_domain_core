# utils-wire-v1: implemented helper serialization

Utils is a utility, not a DTO; Unit has no wire representation. No general
object schema is meaningful for the 30 unrelated helper methods.

| Method family | Wire/legacy behavior | Existing tests |
| --- | --- | --- |
| durationToJson | Integer milliseconds; sub-millisecond precision discarded | utils_compatibility_test.dart; duration and enum boundaries in utils_edge_cases_test.dart |
| durationFromJson | Legacy accepted dynamic inputs and duration text; `P`/`PT` zero behavior retained | Same tests; no stricter grammar introduced |
| enumFromJson | Exact enum name lookup with caller fallback | Enum case, missing/invalid/fallback characterization |
| getJsonEncode / mapToString | JSON string on success; non-JSON diagnostic string on failure | Conversion ownership/errors and existing JSON cases |
| mapFromDynamic / listFromDynamic | Tolerant decoding; typed map aliases, raw-key stringification, invalid defaults | Malformed JSON, key collisions, aliases and custom conversion failures |
| convertJsonToList | Items are stringified; null/invalid input becomes empty list | Scalar/list/null characterization |

Canonical JSON examples: `{"enabled":true,"note":null}` is an object with
legitimate null data, not a Unit completion. A duration of 1501 microseconds
encodes to `1` millisecond. Encoding an unsupported object can return error text
that is not JSON; consumers requiring strict JSON must handle this contract.
Helpers do not certify arbitrary DTO shape, timezone correctness or semantic
round-trip preservation. The [stable API](../../migration/STABLE_API.md) and
exported signatures define the implementation boundary.
