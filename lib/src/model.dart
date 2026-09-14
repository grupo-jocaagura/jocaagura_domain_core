// Adapted from EV-A-0418; see docs/migration/CORE_SELECTION.md.

/// Shared model contract. Implement JSON, copying, equality and hash explicitly.
abstract class Model {
  const Model();

  Map<String, dynamic> toJson();

  Model copyWith();

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other);

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode;
}
