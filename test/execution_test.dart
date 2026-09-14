import 'dart:async';
import 'dart:mirrors';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

import 'support/test_time.dart';

// VM-only white-box probe proves the cleanup regression without adding public
// diagnostics, test hooks or dart:mirrors to production code.
int _queueCount(PerKeyFifoExecutor<String> executor) {
  final InstanceMirror mirror = reflect(executor);
  final LibraryMirror library =
      mirror.type.originalDeclaration.owner! as LibraryMirror;
  return (mirror.getField(MirrorSystem.getSymbol('_queues', library)).reflectee
          as Map<Object?, Object?>)
      .length;
}

void main() {
  group('Execution contracts', () {
    test('Given a pending Debouncer When restarted Then only the latest callback runs after the full delay', () {
      withTestTime((TestTime time) {
        final Debouncer debouncer = Debouncer();
        expect(debouncer.milliseconds, 500);
        expect(debouncer.isDisposed, isFalse);
        final List<int> seen = <int>[];
        debouncer(() => seen.add(1));
        time.elapse(const Duration(milliseconds: 499));
        expect(seen, isEmpty);
        debouncer(() => seen.add(2));
        time.elapse(const Duration(milliseconds: 499));
        expect(seen, isEmpty);
        time.elapse(const Duration(milliseconds: 1));
        expect(seen, <int>[2]);
        debouncer(() => seen.add(3));
        time.elapse(const Duration(milliseconds: 500));
        expect(seen, <int>[2, 3]);
        debouncer.dispose();
        expect(time.pendingTimers, isEmpty);
      });
    });

    test('Given invalid delays or repeated disposal When constructing and scheduling Then assertions and permanent cancellation apply', () {
      expect(() => Debouncer(milliseconds: 0), throwsA(isA<AssertionError>()));
      expect(() => Debouncer(milliseconds: -1), throwsA(isA<AssertionError>()));
      withTestTime((TestTime time) {
        final Debouncer debouncer = Debouncer(milliseconds: 10);
        int calls = 0;
        debouncer(() => calls++);
        debouncer.dispose();
        debouncer.dispose();
        debouncer(() => calls++);
        time.elapse(const Duration(days: 1));
        expect(calls, 0);
        expect(debouncer.isDisposed, isTrue);
        expect(time.pendingTimers, isEmpty);
        Debouncer().dispose();
      });
    });

    test('Given a throwing Debouncer callback When its timer fires Then the scheduling zone receives the error and reuse works', () {
      final StateError error = StateError('callback');
      final List<Object> failures = <Object>[];
      withTestTime((TestTime time) {
        final Debouncer debouncer = Debouncer(milliseconds: 1);
        runZonedGuarded<void>(
          () {
            debouncer(() => throw error);
          },
          (Object value, StackTrace stack) {
            failures.add(value);
          },
        );
        time.elapse(const Duration(milliseconds: 1));
        expect(failures, <Object>[error]);
        int calls = 0;
        debouncer(() => calls++);
        time.elapse(const Duration(milliseconds: 1));
        expect(calls, 1);
        debouncer.dispose();
      });
    });

    test('Given queued work on equal and different keys When released Then FIFO independent progress and idle cleanup hold', () async {
      final PerKeyFifoExecutor<String> executor = PerKeyFifoExecutor<String>();
      final Completer<void> release = Completer<void>();
      final Completer<void> started = Completer<void>();
      final List<String> events = <String>[];
      expect(_queueCount(executor), 0);
      final Future<int> first = executor.withLock<int>('a', () async {
        events.add('a1:start');
        started.complete();
        await release.future;
        events.add('a1:end');
        return 1;
      });
      final Future<int> second = executor.withLock<int>('a', () async {
        events.add('a2');
        return 2;
      });
      final Future<int> third = executor.withLock<int>('a', () async {
        events.add('a3');
        return 3;
      });
      await started.future;
      expect(_queueCount(executor), 1);
      expect(
        await executor.withLock<int>('b', () async {
          events.add('b');
          return 9;
        }),
        9,
      );
      expect(events, <String>['a1:start', 'b']);
      expect(_queueCount(executor), 1);
      release.complete();
      expect(await Future.wait<int>(<Future<int>>[first, second, third]), <int>[
        1,
        2,
        3,
      ]);
      expect(events, <String>['a1:start', 'b', 'a1:end', 'a2', 'a3']);
      expect(_queueCount(executor), 0);
      expect(
        await executor.withLock<String>('a', () async => 'reuse'),
        'reuse',
      );
      expect(_queueCount(executor), 0);
      executor.dispose();
    });

    test('Given synchronous and asynchronous failing tasks When followers are queued Then failures propagate and followers continue', () async {
      final PerKeyFifoExecutor<String> executor = PerKeyFifoExecutor<String>();
      final StateError error = StateError('action');
      final Future<int> sync = executor.withLock<int>('a', () => throw error);
      final Future<void> checkSync = expectLater(sync, throwsA(same(error)));
      final Future<int> async = executor.withLock<int>(
        'a',
        () async => throw error,
      );
      final Future<void> checkAsync = expectLater(async, throwsA(same(error)));
      final Future<int> recovered = executor.withLock<int>('a', () async => 42);
      await Future.wait<void>(<Future<void>>[checkSync, checkAsync]);
      expect(await recovered, 42);
      expect(_queueCount(executor), 0);
      executor.dispose();
    });

    test('Given old queued work When disposed and reused Then old work continues without removing the new queue', () async {
      final PerKeyFifoExecutor<String> executor = PerKeyFifoExecutor<String>();
      final Completer<void> oldRelease = Completer<void>();
      final Completer<void> newRelease = Completer<void>();
      final Completer<void> oldStarted = Completer<void>();
      final Completer<void> newStarted = Completer<void>();
      final List<String> events = <String>[];
      final Future<void> old = executor.withLock<void>('a', () async {
        events.add('old');
        oldStarted.complete();
        await oldRelease.future;
      });
      final Future<void> queued = executor.withLock<void>('a', () async {
        events.add('queued');
      });
      await oldStarted.future;
      executor.dispose();
      executor.dispose();
      expect(_queueCount(executor), 0);
      final Future<void> fresh = executor.withLock<void>('a', () async {
        events.add('new');
        newStarted.complete();
        await newRelease.future;
      });
      await newStarted.future;
      expect(events, <String>['old', 'new']);
      oldRelease.complete();
      await Future.wait<void>(<Future<void>>[old, queued]);
      expect(events, <String>['old', 'new', 'queued']);
      expect(
        _queueCount(executor),
        1,
        reason: 'Old completion must not remove the new tail',
      );
      newRelease.complete();
      await fresh;
      expect(_queueCount(executor), 0);
      executor.dispose();
    });

    test('Given different-key nesting or unawaited same-key scheduling When executed Then both can progress', () async {
      final PerKeyFifoExecutor<String> executor = PerKeyFifoExecutor<String>();
      expect(
        await executor.withLock<int>(
          'a',
          () => executor.withLock<int>('b', () async => 8),
        ),
        8,
      );
      late Future<int> nested;
      expect(
        await executor.withLock<int>('a', () async {
          nested = executor.withLock<int>('a', () async => 2);
          return 1;
        }),
        1,
      );
      expect(await nested, 2);
      expect(_queueCount(executor), 0);
      executor.dispose();
    });

    test('Given awaited same-key reentrancy When microtasks run and disposal occurs Then nested work remains blocked', () {
      withTestTime((TestTime time) {
        final PerKeyFifoExecutor<String> executor =
            PerKeyFifoExecutor<String>();
        bool nestedStarted = false;
        bool finished = false;
        unawaited(
          executor.withLock<void>('a', () async {
            await executor.withLock<void>('a', () async {
              nestedStarted = true;
            });
            finished = true;
          }),
        );
        time.flushMicrotasks();
        expect(nestedStarted, isFalse);
        expect(finished, isFalse);
        expect(_queueCount(executor), 1);
        executor.dispose();
        time.flushMicrotasks();
        expect(nestedStarted, isFalse);
        expect(finished, isFalse);
        expect(_queueCount(executor), 0);
        expect(time.pendingTimers, isEmpty);
      });
    });
  });
}
