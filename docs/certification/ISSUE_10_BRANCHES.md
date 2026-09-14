# Issue #10 critical branch evidence

Date: 2026-09-14. Candidate revision: review corrections after `d76ec17`.

This matrix records explicit assertions in the real SDK + package:test suite.
Every selector below matched a successful test in the 239-test run. It is a
manual contract/branch justification, not an instrumented branch percentage.
LCOV separately measures 540/541 executable lines (99.82%); the inaccessible
private ModelUtils constructor remains uncovered. Source semantics and limits
are unchanged. No deployed consumer integration or independent approval is claimed.

Reproduce: `dart test --reporter=expanded`. Descriptors are exact test selectors;
`$branch` expands to the Left and Right test variants. Source links locate each
assertion block. Existing Utils/Unit tests remain unchanged.

| Contract alternatives/assertions | Test and successful selector |
| --- | --- |
| Left/Right; equal/different payload and generic runtime type; diagnostics and matching hash | [either_test.dart:11](../../test/either_test.dart#L11) — `Given const branches When comparing payloads and generic types Then equality hash and diagnostics agree` |
| Nullable Left/Right payloads and nullable transform results | [either_test.dart:34](../../test/either_test.dart#L34) — `Given nullable payloads When comparing and transforming Then null remains a valid branch value` |
| Left and Right dispatch; selected callback runs, other callback does not | [either_test.dart:58](../../test/either_test.dart#L58) — `Given $branch When dispatching with when match or fold Then exactly one callback runs` |
| map/mapLeft/flatMap; selected/skipped transforms and identity-preserving effects | [either_test.dart:80](../../test/either_test.dart#L80) — `Given $branch When mapping chaining or applying effects Then only the selected callback runs` |
| Left/Right with synchronous values and future transforms | [either_test.dart:122](../../test/either_test.dart#L122) — `Given $branch When using synchronous or asynchronous transforms Then async methods retain the branch` |
| Future extension Left/Right paths | [either_test.dart:161](../../test/either_test.dart#L161) — `Given future $branch When composing extensions Then the selected branch is retained` |
| Throwing when/match/fold/map/mapLeft/flatMap/onLeft/onRight callbacks | [either_test.dart:182](../../test/either_test.dart#L182) — `Given throwing synchronous callbacks When each selected operation runs Then the original error propagates` |
| Synchronous/async transform errors and failed upstream futures; original error retained | [either_test.dart:198](../../test/either_test.dart#L198) — `Given callback or upstream failures When async composition runs Then errors propagate without becoming Left` |
| Missing/null/coerced scalar fields and absent/invalid metadata | [error_item_test.dart:40](../../test/error_item_test.dart#L40) — `Given absent null or coerced fields When decoding Then legacy defaults are preserved` |
| All four severity names versus unknown/mismatched/null names | [error_item_test.dart:84](../../test/error_item_test.dart#L84) — `Given every severity and unknown text When decoding Then known values round trip and unknown values use systemInfo` |
| Constructor/decoder/encoder alias versus copy outer ownership; nested mutation | [error_item_test.dart:107](../../test/error_item_test.dart#L107) — `Given mutable metadata When constructing decoding encoding and copying Then only copyWith owns the outer map` |
| Every override versus null retention | [error_item_test.dart:135](../../test/error_item_test.dart#L135) — `Given field overrides or null When copying Then replacements apply and null retains values` |
| Identity; other type/subtype; scalar differences; same/reordered/length/key/value-different maps; shallow nested values | [error_item_test.dart:163](../../test/error_item_test.dart#L163) — `Given equal or different metadata When comparing errors Then shallow equality and order-independent hashing agree` |
| Canonical JSON versus non-encodable metadata | [error_item_test.dart:207](../../test/error_item_test.dart#L207) — `Given canonical and non-JSON metadata When encoding Then the fixture matches and unsupported values fail` |
| Typed/raw maps, encoded objects, null and malformed/non-map input | [model_mapping_test.dart:39](../../test/model_mapping_test.dart#L39) — `Given maps encoded objects null or invalid input When converting Then legacy map coercions apply` |
| Actual list versus encoded/non-list; retained maps versus skipped non-maps; stable order | [model_mapping_test.dart:73](../../test/model_mapping_test.dart#L73) — `Given mixed lists or non-lists When decoding Then only maps survive in original order` |
| Decoder success until synchronous failure; subsequent records not called | [model_mapping_test.dart:116](../../test/model_mapping_test.dart#L116) — `Given a failing decoder When processing retained records Then the original error stops decoding` |
| Empty/whitespace; missing Z/offset; malformed/overflow; fraction precision; canonical UTC | [dates_test.dart:16](../../test/dates_test.dart#L16) — `Given canonical and noncanonical timestamps When validating Then exact UTC whitespace and precision rules apply` |
| Empty versus whitespace-only versus malformed versus valid nullable parse | [dates_test.dart:55](../../test/dates_test.dart#L55) — `Given absent malformed or canonical text When checking absence and parsing Then the distinct results are retained` |
| Invalid candidate/reference; earlier/equal/later valid instants | [dates_test.dart:68](../../test/dates_test.dart#L68) — `Given earlier equal later or invalid instants When comparing Then only valid same-or-after values pass` |
| Injected fixed UTC policy versus bracketed real-clock helper | [dates_test.dart:77](../../test/dates_test.dart#L77) — `Given a clock policy and the system helper When reading time Then controlled and real UTC contracts remain distinct` |
| DateTime identity; string/epoch/local conversion; alias signatures | [dates_test.dart:93](../../test/dates_test.dart#L93) — `Given DateUtils and its alias When constructing and converting Then public signatures remain compatible` |
| Invalid/unsupported fallback and positive/negative Duration around local now | [dates_test.dart:112](../../test/dates_test.dart#L112) — `Given invalid input or a Duration When converting Then the current local clock supplies the fallback` |
| Null/empty/invalid versus UTC/local DateTime/epoch/trimmed offset text; range errors | [dates_test.dart:132](../../test/dates_test.dart#L132) — `Given null dates epochs offset text or invalid text When normalizing Then the result is empty or UTC` |
| Debouncer before deadline/at deadline; replacement versus subsequent scheduling | [execution_test.dart:22](../../test/execution_test.dart#L22) — `Given a pending Debouncer When restarted Then only the latest callback runs after the full delay` |
| Zero/negative assertions; active/no timer disposal; repeat disposal; calls after disposal | [execution_test.dart:44](../../test/execution_test.dart#L44) — `Given invalid delays or repeated disposal When constructing and scheduling Then assertions and permanent cancellation apply` |
| Throwing callback reaches originating zone; subsequent scheduling still works | [execution_test.dart:62](../../test/execution_test.dart#L62) — `Given a throwing Debouncer callback When its timer fires Then the scheduling zone receives the error and reuse works` |
| No predecessor/queued predecessor; same-key FIFO/different-key independence; idle cleanup and reuse | [execution_test.dart:85](../../test/execution_test.dart#L85) — `Given queued work on equal and different keys When released Then FIFO independent progress and idle cleanup hold` |
| Synchronous throw/failed future/success follower; original errors and cleanup | [execution_test.dart:133](../../test/execution_test.dart#L133) — `Given synchronous and asynchronous failing tasks When followers are queued Then failures propagate and followers continue` |
| Dispose with running/queued actions; new work overlaps; old tail cannot remove new tail | [execution_test.dart:150](../../test/execution_test.dart#L150) — `Given old queued work When disposed and reused Then old work continues without removing the new queue` |
| Different-key awaited nesting versus same-key work awaited only after outer completion | [execution_test.dart:190](../../test/execution_test.dart#L190) — `Given different-key nesting or unawaited same-key scheduling When executed Then both can progress` |
| Awaited same-key circular wait stays blocked before/after disposal; no cancellation claim | [execution_test.dart:212](../../test/execution_test.dart#L212) — `Given awaited same-key reentrancy When microtasks run and disposal occurs Then nested work remains blocked` |
| Empty language assertion versus permissive raw components; decoder default and case/trim normalization | [localization_test.dart:69](../../test/localization_test.dart#L69) — `Given raw or decoded components When constructing languages Then only decoding normalizes and empty construction asserts` |
| Identity/type/language/script/region differences and three-key output | [localization_test.dart:127](../../test/localization_test.dart#L127) — `Given language component differences When comparing and serializing Then all fields participate` |
| Owned unmodifiable translation map; fallback present only as metadata | [localization_test.dart:182](../../test/localization_test.dart#L182) — `Given mutable translations and missing fallback text When constructing Then the map is owned and fallback stays metadata` |
| Non-list/invalid records; normalization collisions with last-record wins | [localization_test.dart:207](../../test/localization_test.dart#L207) — `Given malformed or duplicate translations When decoding Then normalized duplicates use the last record` |
| Identity/length/key/text/fallback differences versus reordered equivalent maps; consistent hash | [localization_test.dart:261](../../test/localization_test.dart#L261) — `Given reordered or changed translations When comparing Then equality and hash include entries and fallback` |
| Unequal permissive languages sharing a tag; no invented tie-order normalization | [localization_test.dart:322](../../test/localization_test.dart#L322) — `Given permissive components with colliding tags When sorting Then distinct language identities remain distinct` |
| Canonical language and sorted translation DTO fixtures | [localization_test.dart:342](../../test/localization_test.dart#L342) — `Given canonical synthetic localization fixtures When encoding Then actual wire output matches` |
| Real public composition across success/error/date/localization/timer/FIFO paths | [public_composition_test.dart:12](../../test/public_composition_test.dart#L12) — `Given the runnable consumer example When controlled timers advance Then all public contracts compose successfully` |
| Static generic and date function signatures | [core_public_signature_test.dart:8](../../test/core_public_signature_test.dart#L8) — `Given CP-1 static conversion and date signatures When assigning entrypoint tear-offs Then all types compile` |
| Both result branches and FutureOr generic callback signatures | [core_public_signature_test.dart:59](../../test/core_public_signature_test.dart#L59) — `Given CP-1 result callbacks and FutureOr signatures When assigning generic tear-offs Then all types compile` |

## Validation infrastructure

- `test/test_time_test.dart`: deadline order, nested timers/microtasks, cancellation,
  tick/isActive lifecycle and original zone/error routing. Negative elapsed time and
  periodic timers fail explicitly. The helper does not replace DateTime.now or I/O.
- `.github/scripts/tests/test_core_selection.py`: signature drift with unchanged
  and recomputed self-hashes, recomputed amendment tampering, mismatched architecture
  revision, missing/duplicate/reassigned evidence and invalid dependencies/admission.
  All eight CP-1 tests passed within the 73-test Python suite.
- `tool/verify_dartdoc_examples.py`: ten complete DartDoc programs compile and run
  with assertions enabled. These are separate from the 239 package tests.

The FIFO same-key deadlock probe intentionally observes lack of progress using
drained microtasks, not elapsed wall time or a timeout. Queue cleanup uses a
VM-only SDK mirror without production hooks. No synthetic branch execution was
added to inflate coverage.
