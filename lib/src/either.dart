// Adapted from EV-B-0109; see docs/migration/CORE_SELECTION.md.
import 'dart:async';

/// Typed failure or success. Callback exceptions propagate unchanged.
sealed class Either<L, R> {
  const Either();

  T when<T>(T Function(L) left, T Function(R) right) {
    return match<T>(left: left, right: right);
  }

  bool get isLeft => this is Left<L, R>;

  bool get isRight => this is Right<L, R>;

  T match<T>({
    required T Function(L left) left,
    required T Function(R right) right,
  }) => switch (this) {
    Left<L, R>(value: final L value) => left(value),
    Right<L, R>(value: final R value) => right(value),
  };

  Either<L, T> map<T>(T Function(R right) transform) {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => Right<L, T>(transform(value)),
    };
  }

  Either<T, R> mapLeft<T>(T Function(L left) transform) {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<T, R>(transform(value)),
      Right<L, R>(value: final R value) => Right<T, R>(value),
    };
  }

  Either<L, T> flatMap<T>(Either<L, T> Function(R right) transform) {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => transform(value),
    };
  }

  Future<Either<L, T>> mapAsync<T>(
    FutureOr<T> Function(R right) transform,
  ) async {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => Right<L, T>(await transform(value)),
    };
  }

  Future<Either<L, T>> flatMapAsync<T>(
    FutureOr<Either<L, T>> Function(R right) transform,
  ) async {
    return switch (this) {
      Left<L, R>(value: final L value) => Left<L, T>(value),
      Right<L, R>(value: final R value) => await transform(value),
    };
  }

  Either<L, R> onLeft(void Function(L left) action) {
    switch (this) {
      case Left<L, R>(value: final L value):
        action(value);
      case Right<L, R>():
    }
    return this;
  }

  Either<L, R> onRight(void Function(R right) action) {
    switch (this) {
      case Left<L, R>():
        break;
      case Right<L, R>(value: final R value):
        action(value);
    }
    return this;
  }

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    return match<T>(left: onLeft, right: onRight);
  }
}

final class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is Left<L, R> &&
        runtimeType == other.runtimeType &&
        value == other.value;
  }

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

final class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is Right<L, R> &&
        runtimeType == other.runtimeType &&
        value == other.value;
  }

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}

extension FutureEitherExtensions<L, R> on Future<Either<L, R>> {
  Future<Either<L, T>> mapAsync<T>(
    FutureOr<T> Function(R right) transform,
  ) async {
    final Either<L, R> result = await this;
    return result.mapAsync<T>(transform);
  }

  Future<Either<L, T>> flatMapAsync<T>(
    FutureOr<Either<L, T>> Function(R right) transform,
  ) async {
    final Either<L, R> result = await this;
    return result.flatMapAsync<T>(transform);
  }
}
