import 'dart:async';

import 'package:test/test.dart';

import 'support/test_time.dart';

void main() {
  group('SDK test scheduler', () {
    test('Given nested timers and microtasks When time advances Then deadlines and scheduling order are respected', () {
      withTestTime((TestTime time) {
        final List<String> events = <String>[];
        late Timer first;
        first = Timer(const Duration(milliseconds: 2), () {
          expect(first.isActive, isFalse);
          expect(first.tick, 1);
          events.add('first');
          scheduleMicrotask(() => events.add('after first'));
          Timer(const Duration(milliseconds: 1), () => events.add('nested'));
        });
        expect(first.tick, 0);
        Timer(const Duration(milliseconds: 2), () => events.add('second'));
        scheduleMicrotask(() {
          events.add('microtask');
          scheduleMicrotask(() => events.add('nested microtask'));
        });
        Timer(const Duration(milliseconds: -1), () => events.add('zero'));
        time.elapse(const Duration(milliseconds: 2));
        expect(events, <String>[
          'microtask',
          'nested microtask',
          'zero',
          'first',
          'after first',
          'second',
        ]);
        expect(time.pendingTimers, hasLength(1));
        time.elapse(const Duration(milliseconds: 1));
        expect(events.last, 'nested');
        expect(time.pendingTimers, isEmpty);
      });
    });

    test('Given cancelled timers and a guarded zone When callbacks run Then cancellation and error routing are retained', () {
      withTestTime((TestTime time) {
        final Timer cancelled = Timer(Duration.zero, () => fail('cancelled'));
        cancelled.cancel();
        cancelled.cancel();
        expect(cancelled.isActive, isFalse);
        expect(cancelled.tick, 0);
        final StateError error = StateError('zone error');
        final List<Object> errors = <Object>[];
        runZonedGuarded<void>(
          () {
            Timer(Duration.zero, () {
              expect(Zone.current[#scope], 'child');
              throw error;
            });
            scheduleMicrotask(() => throw error);
          },
          (Object value, StackTrace stack) => errors.add(value),
          zoneValues: <Object?, Object?>{#scope: 'child'},
        );
        time.elapse(Duration.zero);
        expect(errors, <Object>[error, error]);
        expect(time.pendingTimers, isEmpty);
      });
    });

    test('Given unsupported time operations When requested Then the scheduler fails explicitly', () {
      withTestTime((TestTime time) {
        expect(
          () => time.elapse(const Duration(microseconds: -1)),
          throwsArgumentError,
        );
        expect(
          () => Timer.periodic(Duration.zero, (_) {}),
          throwsUnsupportedError,
        );
        expect(time.pendingTimers, isEmpty);
      });
    });
  });
}
