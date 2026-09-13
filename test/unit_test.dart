import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('Unit public contract', () {
    test('both public constants expose the same instance', () {
      const Unit constant = unit;
      expect(identical(Unit.value, unit), isTrue);
      expect(identical(constant, Unit.value), isTrue);
    });

    test('equality accepts the success value and rejects other values', () {
      final Object other = Future<Unit>.value(unit);
      expect(unit == Unit.value, isTrue);
      expect(unit == other, isFalse);
      expect(unit, isNot(equals('unit')));
      expect(unit, isNot(equals(0)));
      expect(unit, isNot(equals(null)));
      expect(unit, isNot(equals(Object())));
    });

    test('equal success values behave as one collection key', () {
      final Set<Unit> values = <Unit>{};
      values.add(Unit.value);
      values.add(unit);
      final Map<Unit, String> labels = <Unit, String>{Unit.value: 'completed'};
      expect(unit.hashCode, 0);
      expect(values, hasLength(1));
      expect(labels[unit], 'completed');
    });

    test('diagnostic string is stable and is not automatic JSON encoding', () {
      expect(unit.toString(), 'unit');
      expect(
        () => jsonEncode(unit),
        throwsA(isA<JsonUnsupportedObjectError>()),
      );
    });

    test('typed async completion carries the success value', () async {
      final Future<Unit> completed = Future<Unit>.value(unit);
      final Unit result = await completed;
      expect(identical(result, Unit.value), isTrue);
    });
  });
}
