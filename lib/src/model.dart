// Adapted from EV-A-0418; see docs/migration/CORE_SELECTION.md.

/// Shared model contract. Implement JSON, copying, equality and hash explicitly.
abstract class Model {
  /// Allows const construction by model subclasses.
  const Model();

  /// Returns the model wire representation.
  ///
  /// Implementations define fields, ownership and serialization errors explicitly.
  Map<String, dynamic> toJson();

  /// Returns a copy under the concrete model contract.
  ///
  /// Subclasses may add optional named overrides and a covariant result type.
  Model copyWith();

  /// Requires concrete models to implement consistent value equality and hashing.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other);

  /// Requires concrete models to implement consistent value equality and hashing.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode;
}
