# Official DTO contract catalog

This is core's single public contract-documentation directory. Versioned pages
describe wire behavior separately from runtime implementation and certification.
The stable package exports Utils and Unit only; none of the draft DTOs below is
implemented by core. No duplicate runtime DTO was created for this catalog.

| ID | Page / schema / example | Status | Runtime / test mapping |
| --- | --- | --- | --- |
| address-v1 | [Contract](v1/address.md), [schema](v1/address.schema.json), [synthetic example](v1/examples/address.example.json) | Draft; retained SRC-A/SRC-B study | No core model. Future constructor and serializer goldens described in the page. |
| error-item-v1 | [Contract](v1/error-item.md), [schema](v1/error-item.schema.json), [synthetic example](v1/examples/error-item.example.json) | Draft; retained SRC-A/SRC-B study | No core model. Future equality, decode and public-signature tests described in the page. |
| utils-wire-v1 | [Existing helper wire behavior](v1/utils-wire.md) | Implemented in Utils; no DTO class | Existing utils compatibility/edge tests. |

Only AddressModel and ErrorItem are retained serializable candidates in proposed
wave 1. Every other serializable inventory candidate is unselected/deferred or
excluded; selection requires its own indexed field/schema/example page before
implementation. This catalog does not advertise those families as migrated.

Unit/value/alias, Model, Either/Left/Right, EntityUtil, NoParams, clocks, mapper,
model-conversion and scheduling utilities have **no independent canonical wire
representation (N/A)**. Their documentation belongs in the migration plan;
serializable values passed through them retain the relevant DTO contract.

Schemas describe canonical JSON output shape of the retained study, not the full
set of inputs tolerated by Dart. Differences from inspected source schemas are
explicit on each draft page; they are unresolved migration decisions, not silent
changes to the sources. Examples are synthetic and contain no private data.

Use [TEMPLATE](TEMPLATE.md) for additions. Keep `vN/name.md`, `name.schema.json`
and `examples/name.example.json` aligned. Relative references must resolve within
this directory; no product URLs, remote schema fetches or competing contracts.
Run `python tool/verify_dto_docs.py` after installing the existing tooling
requirements. It validates schema structure, fixtures, local links and catalog
coverage; it cannot certify source semantics or unimplemented runtime behavior.
