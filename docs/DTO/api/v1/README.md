# Functional API values: issue #15 candidate

Status: DRAFT. This is an implementation candidate, not a published API or an
approved migration certificate. The canonical issue tracks completion:
https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/15.

`values.json` contains explicitly authored field definitions and sanitized
references to the frozen API snapshot. It is separate from
`api_contract_proposals.json`, whose inferred example shapes are **not** admitted
contracts. The matrix maps all 183 operations: 182 functional projections and
one justified binary response. Local implementation is distinct from review,
deployed integration and consumer migration.

Import `package:jocaagura_domain_core/jocaagura_domain_api.dart` for implemented
values and codecs. Import `jocaagura_domain_mappers.dart` for explicit conversions
to the legacy-compatible model library. No transport, Flutter, provider,
credential resolution or environment access is performed.

## Wire and ownership contracts

- Required members must be present, even if their declared type permits null.
- Optional request members use `ApiField<T>`. Absent, explicit null and empty
  values are distinct. `ApiField.absent()` never serializes as JSON null.
- Canonical request codecs use the documented/recommended JSON types; they do
  not emulate every tolerant server coercion or alias. A stricter builder is
  not a claim that the server rejects all other representations. The session
  duration union preserves numeric/text/null forms without a new duration parser.
- Factories ignore unknown members unless the operation explicitly rejects
  extras, as the personal-profile patch does. Input/output projections are
  separate when their presence/default/validation rules differ. Documented design
  extensions are preserved through `additionalFields`, which cannot replace a
  declared member. Opaque server metadata is not automatically an editable field.
- Values deeply copy JSON collections, reject cycles/non-JSON/non-finite values,
  expose immutable collection views and return independent mutable JSON copies.
  Object keys are sorted for deterministic encoding, except the explicitly
  ordered `blocksByIndex` maps in functional documents. Their insertion order is
  preserved through nested records and participates in document equality.
  Array order is preserved. Ordinary map equality ignores insertion order.
- Equality/hashing use the released `Utils.deepEqualsDynamic` and
  `Utils.deepHash`; no second generic comparison algorithm is introduced.
- Date strings preserve the exact wire text and server precision. These codecs
  do not reinterpret all timestamps using the core helper's narrower canonical
  Dart-ISO format. Health build-time text can legitimately be `unknown`.
  Fields expressly requiring canonical UTC, including academic intervals, use
  the existing `DateTimeIsoUtils`. No clock fallback is used for these checks.
- `ApiPrice` explicitly models article amount/precision/currency. It is not a
  universal money type for order totals or purchase payment `amountMinor`.
- `ApiEnvelope<T>` validates the common `ok/data/error` envelope and canonical
  ErrorItem wire fields. It carries no HTTP status, retry or authorization policy.
  Binary/redirect responses use their own operation contracts.

Codecs validate canonical shape and the invariants declared in the definitions
and tests. They do not duplicate the entire backend validator. Transport owns
path encoding, repeated query detection, raw-body presence, headers and status
codes; the matrix links each operation to its frozen source contract. No HMAC,
HTTP action executor, automatic retry, polling or credential access is included.
QA action/metric/session projections are data only; reading them never executes
a scenario. A webhook ACK is a separate value, not the common data envelope.

Factories and value checks throw `FormatException` for invalid canonical input.
Accessor `ApiField.value` throws `StateError` when absent. Scalar JSON helpers do
not coerce values; tolerant legacy decoding remains in the existing homologated
`Utils`/model tools. Constructors and generated codec signatures are checked by
the Dart analyzer and the independent functional fixtures/tests.

Regenerate reviewed definitions with `python tool/generate_api_values.py`, then
format the generated Dart file with the standalone Dart SDK. Generation alone
does not establish semantic correctness, consumer integration or certification.
