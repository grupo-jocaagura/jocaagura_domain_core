import 'dart:async';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

void main() {
  const Either<String, int> left = Left<String, int>('failure');
  const Either<String, int> right = Right<String, int>(7);

  test('constructors, exact generic equality, hash and diagnostics', () {
    expect(left.isLeft, isTrue);
    expect(left.isRight, isFalse);
    expect(right.isRight, isTrue);
    expect(right.isLeft, isFalse);
    expect(left, const Left<String, int>('failure'));
    expect(right, const Right<String, int>(7));
    expect(left, isNot(const Left<String, int>('different')));
    expect(right, isNot(const Right<String, int>(8)));
    expect(left, isNot(right));
    expect(left, isNot(const Left<String, num>('failure')));
    expect(right, isNot(const Right<Object, int>(7)));
    expect(left, isNot('failure'));
    expect(right, isNot(7));
    expect(left.hashCode, 'failure'.hashCode);
    expect(right.hashCode, 7.hashCode);
    expect(left.toString(), 'Left(failure)');
    expect(right.toString(), 'Right(7)');
    final Set<Either<String, int>> values = <Either<String, int>>{left};
    values.add(const Left<String, int>('failure'));
    expect(values, hasLength(1));
  });

  test('nullable branch payloads preserve equality and transforms', () {
    const Left<String?, int?> nilLeft = Left<String?, int?>(null);
    const Right<String?, int?> nilRight = Right<String?, int?>(null);
    expect(nilLeft.value, isNull);
    expect(nilRight.value, isNull);
    expect(nilLeft.hashCode, null.hashCode);
    expect(nilRight.hashCode, null.hashCode);
    expect(
      nilLeft.mapLeft<int>((String? s) => s?.length ?? 9),
      const Left<int, int?>(9),
    );
    expect(nilRight.map<int>((int? i) => i ?? 9), const Right<String?, int>(9));
    expect(nilLeft, const Left<String?, int?>(null));
    expect(nilRight, const Right<String?, int?>(null));
    expect(nilLeft, isNot(nilRight));
  });

  for (final Either<String, int> branch in <Either<String, int>>[left, right]) {
    test('when/match/fold select one callback: $branch', () {
      int calls = 0;
      String onLeft(String value) {
        calls++;
        return value;
      }

      String onRight(int value) {
        calls++;
        return '$value';
      }

      final String expected = branch.isLeft ? 'failure' : '7';
      expect(branch.when(onLeft, onRight), expected);
      expect(branch.match(left: onLeft, right: onRight), expected);
      expect(branch.fold(onLeft, onRight), expected);
      expect(calls, 3);
    });

    test('map/mapLeft/flatMap and effects: $branch', () {
      int successes = 0;
      int failures = 0;
      expect(
        branch.map<String>((int n) => '$n!'),
        branch.isLeft
            ? const Left<String, String>('failure')
            : const Right<String, String>('7!'),
      );
      expect(
        branch.mapLeft<int>((String s) => s.length),
        branch.isLeft ? const Left<int, int>(7) : const Right<int, int>(7),
      );
      expect(
        branch.flatMap<String>((int n) => Left<String, String>('stop$n')),
        Left<String, String>(branch.isLeft ? 'failure' : 'stop7'),
      );
      expect(
        identical(
          branch.onLeft((String _) {
            failures++;
          }),
          branch,
        ),
        isTrue,
      );
      expect(
        identical(
          branch.onRight((int _) {
            successes++;
          }),
          branch,
        ),
        isTrue,
      );
      expect(failures, branch.isLeft ? 1 : 0);
      expect(successes, branch.isRight ? 1 : 0);
    });

    test('async methods accept sync/async transforms: $branch', () async {
      int calls = 0;
      final Either<String, String> expected = branch.isLeft
          ? const Left<String, String>('failure')
          : const Right<String, String>('7');
      expect(
        await branch.mapAsync<String>((int n) {
          calls++;
          return '$n';
        }),
        expected,
      );
      expect(
        await branch.mapAsync<String>((int n) async {
          calls++;
          return '$n';
        }),
        expected,
      );
      expect(
        await branch.flatMapAsync<String>((int n) {
          calls++;
          return Right<String, String>('$n');
        }),
        expected,
      );
      expect(
        await branch.flatMapAsync<String>((int n) async {
          calls++;
          return Right<String, String>('$n');
        }),
        expected,
      );
      expect(calls, branch.isRight ? 4 : 0);
    });

    test('Future extensions compose both branches: $branch', () async {
      final Future<Either<String, int>> future =
          Future<Either<String, int>>.value(branch);
      expect(
        await future.mapAsync<int>((int n) => n + 1),
        branch.isLeft
            ? const Left<String, int>('failure')
            : const Right<String, int>(8),
      );
      expect(
        await future.flatMapAsync<int>(
          (int n) async => Left<String, int>('stop$n'),
        ),
        Left<String, int>(branch.isLeft ? 'failure' : 'stop7'),
      );
    });
  }

  test('all selected synchronous callbacks propagate the original error', () {
    final StateError error = StateError('callback');
    final List<void Function()> operations = <void Function()>[
      () => right.map<int>((int _) => throw error),
      () => left.mapLeft<int>((String _) => throw error),
      () => right.flatMap<int>((int _) => throw error),
      () => left.onLeft((String _) => throw error),
      () => right.onRight((int _) => throw error),
      () => left.when<int>((String _) => throw error, (int n) => n),
      () => right.fold<int>((String _) => 0, (int _) => throw error),
    ];
    for (final void Function() operation in operations) {
      expect(operation, throwsA(same(error)));
    }
  });

  test(
    'async and Future callback/upstream errors are not converted to Left',
    () async {
      final StateError error = StateError('async');
      await expectLater(
        right.mapAsync<int>((int _) => throw error),
        throwsA(same(error)),
      );
      await expectLater(
        right.mapAsync<int>((int _) async => throw error),
        throwsA(same(error)),
      );
      await expectLater(
        right.flatMapAsync<int>((int _) => throw error),
        throwsA(same(error)),
      );
      await expectLater(
        right.flatMapAsync<int>((int _) async => throw error),
        throwsA(same(error)),
      );
      await expectLater(
        Future<Either<String, int>>.value(right)
            .mapAsync<int>((int _) => throw error),
        throwsA(same(error)),
      );
      await expectLater(
        Future<Either<String, int>>.value(right)
            .flatMapAsync<int>((int _) async => throw error),
        throwsA(same(error)),
      );
      await expectLater(
        Future<Either<String, int>>.error(error).mapAsync<int>((int n) => n),
        throwsA(same(error)),
      );
      await expectLater(
        Future<Either<String, int>>.error(error)
            .flatMapAsync<int>((int n) => Right<String, int>(n)),
        throwsA(same(error)),
      );
    },
  );

  test(
    'typed ErrorItem/Unit completion composes through the public entrypoint',
    () async {
      const ErrorItem error = ErrorItem(
        title: 'Missing',
        code: 'missing',
        description: 'Supply input',
      );
      Future<Either<ErrorItem, Unit>> complete(bool valid) async => valid
          ? const Right<ErrorItem, Unit>(unit)
          : const Left<ErrorItem, Unit>(error);
      final Either<ErrorItem, Unit> success = await complete(true)
          .flatMapAsync<Unit>((Unit value) => Right<ErrorItem, Unit>(value));
      expect(
        success.fold<Unit>(
          (ErrorItem _) => throw StateError('unexpected'),
          (Unit value) => value,
        ),
        same(Unit.value),
      );
      expect(
        await complete(false)
            .mapAsync<Unit>((Unit _) => throw StateError('unreachable')),
        const Left<ErrorItem, Unit>(error),
      );
    },
  );
}
