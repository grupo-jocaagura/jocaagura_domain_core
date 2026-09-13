# Contract ID and version

Status: draft / implemented. Source IDs and evidence: public path/commit for
public sources; SRC-B / EV-B-#### only for private sources. Core export: name or
explicitly not implemented. Review and implementation evidence must be real.

## Field matrix

Record key/casing, JSON type, required/omitted/null distinctions, constructor vs
decoder defaults, enum spelling/fallbacks, numbers/precision, date format/zone,
nested relationships, ownership and contractual ordering.

## Schemas and synthetic examples

Link the canonical local schema, a synthetic valid example, invalid cases and
edge cases. State whether the schema describes input, output or both. Record
code/schema/example/test discrepancies without tightening legacy behavior.

## Signatures and compatibility

Compare constructors, named/optional parameters, const support, generics, return
types, extension/implementation modifiers and nominal identity. State safe
internal changes, fixed wire behavior, versioning policy and unresolved choices.

## Test and evidence mapping

Link implemented tests or label future tests explicitly. Cover encoding, decoding,
error behavior, defaults, aliasing, precision and historical compatibility. A
passing fixture validator is not execution of an unimplemented source model.
