// Adapted from EV-B-0109; see docs/migration/CORE_SELECTION.md.
import 'dart:async';

/// Typed failure or success. Callback exceptions propagate unchanged.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// Future<void> main() async {
///   const Either<String, int> value = Right<String, int>(2);
///   final Either<String, int> result = await value.mapAsync<int>((int n) => n * 3);
///   assert(result == const Right<String, int>(6));
///   assert(result.fold<String>((String e) => e, (int n) => '$n') == '6');
/// }
/// ```
sealed class Either<L, R> {
  /// Initializes the common base for [Left] and [Right].
  const Either();

  /// Calls exactly one of [left] or [right] with the stored payload.
  ///
  /// Returns that callback result; callback exceptions propagate. See [match].
  T when<T>(T Function(L) left, T Function(R) right) {
    return match<T>(left: left, right: right);
  }

  /// Whether this value contains the failure branch, even when its payload is null.
  bool get isLeft => this is Left<L, R>;

  /// Whether this value contains the success branch, even when its payload is null.
  bool get isRight => this is Right<L, R>;

  /// Dispatches to [left] on failure or [right] on success and returns its result.
  ///
  /// The other callback is never called. Exceptions are not converted to failures.
  T match<T>({
    required T Function(L left) left,
    required T Function(R right) right,
  }) => switch (this) {
    Left<L, R>(value: final L value) => left(value),
    Right<L, R>(value: final R value) => right(value),
  };

  /// Transforms a success with [transform], preserving a failure without calling it.
  ///
  /// Returns the new branch. Synchronous callback errors propagate unchanged.
  Either<L, T> map<T>(T Function(R right) transform) {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => Right<L, T>(transform(value)),
    };
  }

  /// Transforms a failure with [transform], preserving a success without calling it.
  ///
  /// Returns the new branch. Synchronous callback errors propagate unchanged.
  Either<T, R> mapLeft<T>(T Function(L left) transform) {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<T, R>(transform(value)),
      Right<L, R>(value: final R value) => Right<T, R>(value),
    };
  }

  /// Chains a success through [transform], returning its branch without wrapping it.
  ///
  /// A failure skips [transform]. Callback exceptions propagate unchanged.
  Either<L, T> flatMap<T>(Either<L, T> Function(R right) transform) {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => transform(value),
    };
  }

  /// Awaits [transform] on a success and wraps its result in [Right].
  ///
  /// Failures skip the callback. Synchronous values and futures are accepted.
  /// The returned future preserves upstream and callback errors; errors do not
  /// become [Left] values.
  Future<Either<L, T>> mapAsync<T>(
    FutureOr<T> Function(R right) transform,
  ) async {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => Right<L, T>(await transform(value)),
    };
  }

  /// Awaits [transform] on a success and returns its branch without wrapping it.
  ///
  /// Failures skip the callback. Both direct branches and futures are accepted.
  /// The returned future preserves upstream and callback errors unchanged.
  Future<Either<L, T>> flatMapAsync<T>(
    FutureOr<Either<L, T>> Function(R right) transform,
  ) async {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => await transform(value),
    };
  }

  /// Runs [action] only on failure and returns this same instance.
  ///
  /// Errors thrown by [action] propagate to the caller.
  Either<L, R> onLeft(void Function(L left) action) {
    switch (this) {
      case Left<L, R>(value: final L value):
        action(value);
      case Right<L, R>():
    }
    return this;
  }

  /// Runs [action] only on success and returns this same instance.
  ///
  /// Errors thrown by [action] propagate to the caller.
  Either<L, R> onRight(void Function(R right) action) {
    switch (this) {
      case Left<L, R>():
        break;
      case Right<L, R>(value: final R value):
        action(value);
    }
    return this;
  }

  /// Returns [onLeft] or [onRight] applied to its corresponding payload.
  ///
  /// Alias for positional [when]; only the selected callback runs. Errors propagate.
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    return match<T>(left: onLeft, right: onRight);
  }
}

/// Failure branch of [Either], carrying [L] and retaining the success type [R].
final class Left<L, R> extends Either<L, R> {
  /// Stores [value] unchanged; no copying or validation is performed.
  const Left(this.value);

  /// The failure payload; its own equality and mutability semantics are retained.
  final L value;

  /// Uses the payload equality/hash contract and exact instantiated branch type.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is Left<L, R> &&
        runtimeType == other.runtimeType &&
        value == other.value;
  }

  /// Uses the payload equality/hash contract and exact instantiated branch type.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => value.hashCode;

  /// Returns a branch label and payload for diagnostics, not a wire encoding.
  @override
  String toString() => 'Left($value)';
}

/// Success branch of [Either], carrying [R] and retaining the failure type [L].
final class Right<L, R> extends Either<L, R> {
  /// Stores [value] unchanged; no copying or validation is performed.
  const Right(this.value);

  /// The success payload; its own equality and mutability semantics are retained.
  final R value;

  /// Uses the payload equality/hash contract and exact instantiated branch type.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is Right<L, R> &&
        runtimeType == other.runtimeType &&
        value == other.value;
  }

  /// Uses the payload equality/hash contract and exact instantiated branch type.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => value.hashCode;

  /// Returns a branch label and payload for diagnostics, not a wire encoding.
  @override
  String toString() => 'Right($value)';
}

/// Async composition on a future result. Upstream errors bypass transforms.
///
/// Each method awaits the receiver before delegating to [Either]; it does not
/// catch exceptions or treat a failed future as a domain failure.
extension FutureEitherExtensions<L, R> on Future<Either<L, R>> {
  /// Awaits [transform] on a success and wraps its result in [Right].
  ///
  /// Failures skip the callback. Synchronous values and futures are accepted.
  /// The returned future preserves upstream and callback errors; errors do not
  /// become [Left] values.
  Future<Either<L, T>> mapAsync<T>(
    FutureOr<T> Function(R right) transform,
  ) async {
    final Either<L, R> result = await this;
    return result.mapAsync<T>(transform);
  }

  /// Awaits [transform] on a success and returns its branch without wrapping it.
  ///
  /// Failures skip the callback. Both direct branches and futures are accepted.
  /// The returned future preserves upstream and callback errors unchanged.
  Future<Either<L, T>> flatMapAsync<T>(
    FutureOr<Either<L, T>> Function(R right) transform,
  ) async {
    final Either<L, R> result = await this;
    return result.flatMapAsync<T>(transform);
  }
}
