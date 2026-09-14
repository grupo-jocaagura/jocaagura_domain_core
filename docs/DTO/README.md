# Official DTO contract catalog

Issue #10 implements these DTOs in the local candidate. Published 1.0.0 contains
only Utils/Unit. Final candidate review and publication remain pending.

| ID | Page / schema / example | Status | Runtime / test mapping |
| --- | --- | --- | --- |
| error-item-v1 | [Contract](v1/error-item.md), [schema](v1/error-item.schema.json), [example](v1/examples/error-item.example.json) | Implemented candidate | ErrorItem; test/error_item_test.dart and test/either_test.dart |
| model-language-v1 | [Contract](v1/model-language.md), [schema](v1/model-language.schema.json), [example](v1/examples/model-language.example.json) | Implemented candidate | ModelLanguage; test/localization_test.dart |
| model-localized-text-v1 | [Contract](v1/model-localized-text.md), [schema](v1/model-localized-text.schema.json), [example](v1/examples/model-localized-text.example.json) | Implemented candidate | ModelLocalizedText; test/localization_test.dart and test/public_composition_test.dart |
| address-v1 | [Study](v1/address.md), [schema](v1/address.schema.json), [example](v1/examples/address.example.json) | Unimplemented, OUT_OF_SCOPE | No runtime class; completed conditional exclusion in CP-1 |
| utils-wire-v1 | [Existing helper wire behavior](v1/utils-wire.md) | Released baseline | Existing Utils compatibility/edge tests |

The [frozen selection](../migration/CORE_SELECTION.md) admits only these runtime
DTOs. DOMAIN_VERTICAL and other exclusions have no implementation debt under this
issue. A schema study is not a shipped or approved API.

Unit/value/alias, Model, Either/Left/Right/extensions, EntityUtil, NoParams, clocks,
mapping and execution helpers have **no independent canonical wire representation
(N/A)**. Their payloads retain their own DTO semantics; Unit success is not JSON
null and NoParams is input absence.

Schemas describe complete output shape, not all tolerated legacy inputs. Runtime
tests distinguish missing/null/defaults, coercion, ownership, equality, exceptions
and ordering. Examples are synthetic. Hashes are runtime values, not wire IDs;
arbitrary metadata is not automatically JSON-safe. Localization normalization is
performed by decoders, not direct constructors.

Use [TEMPLATE](TEMPLATE.md) for additions. Keep versioned pages, schemas and examples
aligned. No implicit remote schema resolution is allowed. Run
`python tool/verify_dto_docs.py` and the actual Dart tests; structural fixture
validation cannot replace behavioral evidence or final maintainer review.

Runtime golden fixtures are included under `test/fixtures` so packaged tests can
run without the excluded docs directory. The validator enforces equality with
the indexed examples above; they must not evolve into separate wire contracts.
