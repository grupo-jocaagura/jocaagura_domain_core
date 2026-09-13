# Null-safety priorities

Prefer `return Unit.value` after successful completion without payload.
`unit` remains a compatible alias; no second Unit is introduced.

```dart
Future<Unit> complete(Future<void> Function() operation) async {
  await operation();
  return Unit.value;
}
```

Exceptions still propagate. A consumer already using `Either<ErrorItem, Unit>`
may return its own `Right(Unit.value)` after coordinated imports; core does not
export Either or ErrorItem. Changing an existing Future<void>, nullable result
or generic result is a signature migration, not an internal edit.

| Observation | Evidence | Priority / decision |
| --- | --- | --- |
| SRC-A typed Unit.value completion in onboarding and database disposal | Frozen `lib/domain/blocs/bloc_onboarding.dart:351`; `lib/domain/usecases/databases_crud/databases_crud_usecases.dart:851,889,932` | P0: preserve const identity and generics; source writes excluded. |
| SRC-B uses unit in typed successful completion | EV-B-0117, EV-B-0109, EV-B-0111; restricted call-site log | P0: Unit.value preferred; alias stays valid. |
| Model conversion delegates to tolerant Utils and generic decoder callbacks | EV-B-0116 | P1: preserve Model identity and exception propagation; invalid maps can become empty maps while callbacks still throw. |
| Canonical UTC parsing may return null; empty-or-canonical accepts whitespace-only input | EV-B-0102 | P1: missing/invalid time differs from completion; retain clock semantics. |
| SRC-A AI optional parameters use sentinels and nullable casts | Frozen `lib/domain/ai/model_ai_execution_config.dart:91-96` | Defer: null is meaningful; preserve absent vs explicit-null copyWith. |
| Either implementations cast/subtype-match branches; SRC-B adds async transforms | EV-A-0211/0212/0213, EV-B-0109/0110/0111/0112 | P1: maintainer prioritizes SRC-B; preserve documented modifier incompatibility. |
| NoParams is a const input marker accepted by disposal | Frozen `lib/domain/usecases/no_params.dart` and disposal use case above | Input absence is not successful output; do not replace with Unit. |
| Integer/double/string conversions have distinct null and invalid fallbacks | Existing characterization and edge tests; EV-B-0118 | P0: preserve published behavior, not a universal fallback. |

The bounded scan also finds `as` and `!` syntax in models and orchestration.
A match is not proof of an unsafe unwrap: `!=`, `is!`, checked casts and guarded
branches exist. Representative cases above were reviewed; unresolved call-site
safety and dynamic/external usage remain unknown. No mass rewrite is planned.
