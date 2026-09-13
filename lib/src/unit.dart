// Extracted from grupo-jocaagura/backend_bienvenido at
// 993b2d10d804d5715c6719d08c2ef64d4837d1bb, lib/core/unit.dart.
// Provenance and migration: docs/certification/UTILS_EXTRACTION.md.

/// Represents the absence of a meaningful value in a type-safe way.
///
/// Use this when an operation succeeds but has nothing to return.
/// It behaves like a "void value" that can be used in generics (e.g. Either).
///
/// ### Example
///
/// ```dart
/// Future<Unit> completedCommand() async {
///   // Perform the consumer-owned operation, then signal success.
///   return unit;
/// }
/// ```
///
/// Any `Unit` compares equal to another `Unit`. [value] and [unit] expose the
/// same constant instance. This type has no JSON representation of its own.
class Unit {
  const Unit._();

  /// The single instance to use across the codebase.
  static const Unit value = Unit._();

  @override
  String toString() => 'unit';

  @override
  // Immutable by construction: no fields and only a private const constructor.
  // Keep the legacy equality contract without a runtime dependency on meta.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is Unit;

  @override
  // Same immutable value contract; see the equality rationale above.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => 0;
}

/// Shorthand constant for the single [Unit] value.
/// Prefer returning `unit` on success in commands with no payload.
const Unit unit = Unit.value;
