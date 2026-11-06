# Official DTO contract catalog

The table below records the finite issue #10 contracts in the 1.1.0 foundation.
The expanded issue #15 candidate adds the [functional API value catalog](api/v1/README.md)
and [complete source/API mapping](../migration/model_migration.json). Its 408 API
values and migrated source models remain subject to the issue #15 review; they
are not a new publication. Historical studies/exclusions below describe #10.

| ID | Page / schema / example | Status | Runtime / test mapping |
| --- | --- | --- | --- |
| error-item-v1 | [Contract](v1/error-item.md), [schema](v1/error-item.schema.json), [example](v1/examples/error-item.example.json) | Implemented candidate | ErrorItem; test/error_item_test.dart and test/either_test.dart |
| model-language-v1 | [Contract](v1/model-language.md), [schema](v1/model-language.schema.json), [example](v1/examples/model-language.example.json) | Implemented candidate | ModelLanguage; test/localization_test.dart |
| model-localized-text-v1 | [Contract](v1/model-localized-text.md), [schema](v1/model-localized-text.schema.json), [example](v1/examples/model-localized-text.example.json) | Implemented candidate | ModelLocalizedText; test/localization_test.dart and test/public_composition_test.dart |
| address-v1 | [Study](v1/address.md), [schema](v1/address.schema.json), [example](v1/examples/address.example.json) | Historical OUT_OF_SCOPE in CP-1 | Issue #15 separately adds AddressModel, ApiAddress and ApiAddressInput; see the expanded mapping |
| utils-wire-v1 | [Existing helper wire behavior](v1/utils-wire.md) | Released baseline | Existing Utils compatibility/edge tests |

The [frozen selection](../migration/CORE_SELECTION.md) admits only the issue #10
foundation DTOs. Its DOMAIN_VERTICAL decisions remain historical facts; issue #15
explicitly expands the model scope. A schema study is not a shipped or approved API.

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
