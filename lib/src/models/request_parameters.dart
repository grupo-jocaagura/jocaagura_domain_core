// Adapted from jocaagura_domain 1.43.0 (MIT), 56f7eba8a6041160ecf1c1501745c1249e124670.
// Source: lib/domain/usecases/databases_crud/databases_crud_usecases.dart; see docs/migration/MODEL_MIGRATION.md.
part of '../../jocaagura_domain_models.dart';

/// Parameters for read-like operations (single document).
///
/// Contracts:
/// - [docId] must be a non-empty string.
///
/// Example:
/// ```dart
/// void main() {
///   const ReadParams p = ReadParams('u1');
///   print(p.docId);
/// }
/// ```
class ReadParams {
  const ReadParams(this.docId);
  final String docId;
}

/// Parameters for write (upsert) operations.
///
/// Contracts:
/// - [docId] must be a non-empty string.
/// - [entity] must be a valid domain model (server-side validation may apply).
///
/// Example:
/// ```dart
/// void main() {
///   final WriteParams<UserModel> p = WriteParams<UserModel>('u1', defaultUser);
///   print('${p.docId} -> ${p.entity}');
/// }
/// ```
class WriteParams<T extends Model> {
  const WriteParams(this.docId, this.entity);
  final String docId;
  final T entity;
}

/// Parameters for delete operations.
///
/// Contracts:
/// - [docId] must be a non-empty string.
///
/// Example:
/// ```dart
/// void main() {
///   const DeleteParams p = DeleteParams('u1');
///   print(p.docId);
/// }
/// ```
class DeleteParams {
  const DeleteParams(this.docId);
  final String docId;
}

/// Parameters for watch (real-time) operations on a single document.
///
/// Contracts:
/// - [docId] must be a non-empty string.
/// - The caller is responsible for stream cancellation and for calling
///   `repo.detachWatch(docId)` after **all** subscriptions are canceled.
///
/// Example:
/// ```dart
/// void main() {
///   const WatchParams p = WatchParams('u1');
///   print(p.docId);
/// }
/// ```
class WatchParams {
  const WatchParams(this.docId);
  final String docId;
}

/// Parameters for read–modify–write mutations (pure transformation).
///
/// Contracts:
/// - [docId] must be a non-empty string.
/// - [transform] must be a **pure** function: no side effects, deterministic.
///
/// Example:
/// ```dart
/// void main() {
///   final MutateParams<UserModel> p = MutateParams<UserModel>(
///     'u1',
///     (u) => u.copyWith(displayName: 'Alice'),
///   );
///   print(p.docId);
/// }
/// ```
class MutateParams<T extends Model> {
  const MutateParams(this.docId, this.transform);
  final String docId;

  /// Pure function that transforms the current entity into a new one.
  final T Function(T current) transform;
}

/// Parameters for JSON patch operations (partial merge).
///
/// Contracts:
/// - [docId] must be a non-empty string.
/// - [patch] keys must match the entity JSON schema expected by `fromJson`.
///
/// Example:
/// ```dart
/// void main() {
///   const PatchParams p = PatchParams('u1', <String, dynamic>{'displayName': 'Alice'});
///   print('${p.docId} -> ${p.patch}');
/// }
/// ```
class PatchParams {
  const PatchParams(this.docId, this.patch);
  final String docId;

  /// Partial JSON to merge into the current entity's JSON representation.
  final Map<String, dynamic> patch;
}

/// Parameters for ensuring a document exists (optionally updating if present).
///
/// Semantics:
/// - Creates a new entity with [create] if the document is missing.
/// - If it exists and [updateIfExists] is provided, updates it and returns the new value.
/// - Otherwise, returns the current value.
///
/// Contracts:
/// - [docId] non-empty.
/// - [create] returns a valid `T`.
/// - If provided, [updateIfExists] must be pure and deterministic.
///
/// Example:
/// ```dart
/// void main() {
///   final EnsureParams<UserModel> p = EnsureParams<UserModel>(
///     docId: 'u1',
///     create: () => defaultUser,
///     updateIfExists: (u) => u.copyWith(flag: true),
///   );
///   print(p.docId);
/// }
/// ```
class EnsureParams<T extends Model> {
  const EnsureParams({
    required this.docId,
    required this.create,
    this.updateIfExists,
  });

  final String docId;

  /// Factory used when the document does not exist.
  final T Function() create;

  /// Optional transformation to apply when the document exists.
  final T Function(T current)? updateIfExists;
}

/// Parameters for multi-read operations (by ids).
///
/// Contracts:
/// - [ids] must not be empty; each id must be a non-empty string.
///
/// Example:
/// ```dart
/// void main() {
///   const ReadManyParams p = ReadManyParams(<String>['u1','u2']);
///   print(p.ids.length);
/// }
/// ```
class ReadManyParams {
  const ReadManyParams(this.ids);
  final List<String> ids;
}

/// Parameters for multi-write (upsert) operations.
///
/// Semantics:
/// - Keys are document ids; values are the entities to upsert.
/// - Execution order may matter for deterministic tests; see use case docs.
///
/// Contracts:
/// - [entries] must not be empty; keys must be non-empty.
///
/// Example:
/// ```dart
/// void main() {
///   final WriteManyParams<UserModel> p = WriteManyParams<UserModel>(
///     <String, UserModel>{'u1': defaultUser},
///   );
///   print(p.entries.keys.first);
/// }
/// ```
class WriteManyParams<T extends Model> {
  const WriteManyParams(this.entries);

  /// Map of docId -> entity
  final Map<String, T> entries;
}

/// Parameters for multi-delete operations.
///
/// Contracts:
/// - [ids] must not be empty; each id must be a non-empty string.
///
/// Example:
/// ```dart
/// void main() {
///   const DeleteManyParams p = DeleteManyParams(<String>['u1','u2']);
///   print(p.ids);
/// }
/// ```
class DeleteManyParams {
  const DeleteManyParams(this.ids);
  final List<String> ids;
}
