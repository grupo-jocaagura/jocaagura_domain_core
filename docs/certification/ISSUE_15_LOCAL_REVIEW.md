# Issue #15 local implementation review

Reviewer: Codex. Date: 2026-11-06. Outcome: model implementation and recorded
delivery evidence reviewed; internal documentary approval granted. This is a named engineering
review artifact under issue #15, not independent accreditation or a maintainer's
release approval. See ISSUE_15_MODELS.md for the exact remote head and runs.

## Review basis

Reviewed the actual implementation, frozen public source declarations and the
homologated functional API documents, with their separate EV-B-15 evidence.
The JSON catalog was reconciled against all operation sheets and shared schemas;
the stale Markdown catalog count was not used as completeness proof. Exact
private provenance remains outside every public checkout and package archive.

The finite matrix covers 83 public source files/215 declarations, 408 API value
contracts and 183 operations. One operation returns binary favicon data and has
a justified non-model mapping. Source dependency closure, public family exports,
API-only projections, CRUD parameter values and Flutter data splits are included.
Historical selection and released foundation files remain unchanged.

## Findings resolved in the candidate

| Finding | Result and evidence |
| --- | --- |
| Collection identity comparisons made independently decoded values unequal | Homologated Utils content comparisons and matching hashes; source characterization, round-trip registry and explicit mapper tests |
| Generic attribute specialization broke symmetric value equality | AttributeModel compares name/value content across specializations; typed-to-decoded composition tests |
| Legal identity decoding discarded attributes | Named arbitrary JSON attributes survive decoding and nested records; mapper and round-trip tests |
| Three clinical models equated matching hashes | Actual fields are compared through Utils; deliberate colliding-hash subclasses remain unequal in migration_regressions_test.dart |
| Death-record decoder read person/address/recordId from crossed keys | Declared keys restored while preserving the instance-method signature; distinct nested IDs and zero-prefixed record regression |
| Generic object sorting changed functional document block order | Ordered document blocks survive nested DTOs, JSON and success envelopes; their order participates in typed equality |
| Minimal request fixtures missed optional collection semantics | Fully populated independent requests, defensive ownership, explicit-null clearing and absence/preservation tests in api_optional_messages_test.dart |

## Boundary and compatibility assessment

Production imports and dependencies are SDK-only. There is no Flutter/UI/IO/FFI,
HTTP client/server, database, environment/credential lookup or inference runtime.
Opaque session/token fields represent documented data; no provider is executed.
Menu icon identity is plain data; click callbacks, rendering and Offset conversion
belong to the Flutter adapter. Canonical models reuse the same nominal foundation.

API and legacy persisted/source shapes remain separate. Explicit mappings cover
address, person string attributes, legal documents and article prices, rejecting
unsupported/lossy conversions. Required-null, optional-absent and empty-object
bodies remain distinct. Dates requiring canonical UTC use DateTimeIsoUtils; other
wire dates retain their text. Monetary scales are operation-specific. Academic
passed flags are supplied data, not inferred from scores. QA instructions are
values, not a local execution runtime. A provider webhook ACK is not a data envelope.

Canonical API codecs deliberately use recommended types rather than all tolerant
server coercions/aliases. They do not duplicate every backend validator. Transport
owns path/query encoding, repeated parameters, raw-body presence and HTTP policy.
Authorization, ownership, quota, acquisition, payment/provider state and durable
effects require the actual server. Codec tests cannot establish those outcomes.

Source-compatible constructors retain documented shallow ownership, clock
fallbacks, invalid non-finite defaults and serializer normalization where
applicable. The handoff explicitly describes these limits and the intentional
equality/decoder corrections. No blanket deep-immutability or legacy wire-input
compatibility claim is made. The public version is unchanged; promotion remains
governed by the existing release process.

## Delivery limits

No downstream repository was changed or built. No deployed integration, real
payment, publication, tag or GitHub protection change is claimed. The authorized
push and PR #16 into develop are complete. GitHub reports successful applicable
checks on head 8c557cec7ce27ed0b6ad21176691c7f49a678c01; release readiness was
intentionally skipped for this feature PR. The actual validation record is
ISSUE_15_MODELS.md and its referenced evidence. Issue #15 links the PR, commits,
check results and outstanding consumer adoption. Later documentation commits
require fresh passing CI; these runs are not relabeled as newer-head evidence.
This review introduces no additional agent or approval gate.
