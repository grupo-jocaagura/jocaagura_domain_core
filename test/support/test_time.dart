import 'dart:async';
import 'dart:collection';

// Test-only scheduler for one-shot timers and microtasks. It does not replace
// DateTime.now or model I/O. Periodic timers fail explicitly instead of escaping
// into real time. Each callback retains its scheduling zone and error handler.
void withTestTime(void Function(TestTime time) body) {
  final TestTime time = TestTime();
  runZoned<void>(
    () => body(time),
    zoneSpecification: ZoneSpecification(
      scheduleMicrotask:
          (
            Zone self,
            ZoneDelegate parent,
            Zone zone,
            void Function() callback,
          ) {
            time._microtasks.add(() => zone.runGuarded(callback));
          },
      createTimer:
          (
            Zone self,
            ZoneDelegate parent,
            Zone zone,
            Duration duration,
            void Function() callback,
          ) {
            final _TestTimer timer = _TestTimer(
              time._elapsed + (duration.isNegative ? Duration.zero : duration),
              () => zone.runGuarded(callback),
            );
            time._timers.add(timer);
            return timer;
          },
      createPeriodicTimer:
          (
            Zone self,
            ZoneDelegate parent,
            Zone zone,
            Duration duration,
            void Function(Timer) callback,
          ) {
            throw UnsupportedError('TestTime supports one-shot timers only');
          },
    ),
  );
}

class TestTime {
  final Queue<void Function()> _microtasks = Queue<void Function()>();
  final List<_TestTimer> _timers = <_TestTimer>[];
  Duration _elapsed = Duration.zero;

  Iterable<Timer> get pendingTimers => _timers.where((Timer t) => t.isActive);

  void flushMicrotasks() {
    while (_microtasks.isNotEmpty) {
      _microtasks.removeFirst()();
    }
  }

  void elapse(Duration duration) {
    if (duration.isNegative) {
      throw ArgumentError.value(duration, 'duration', 'Cannot reverse time');
    }
    final Duration target = _elapsed + duration;
    flushMicrotasks();
    while (true) {
      _TestTimer? next;
      for (final _TestTimer timer in _timers) {
        if (timer.isActive &&
            timer.due <= target &&
            (next == null || timer.due < next.due)) {
          next = timer;
        }
      }
      if (next == null) {
        break;
      }
      _elapsed = next.due;
      next.fire();
      flushMicrotasks();
    }
    _elapsed = target;
    _timers.removeWhere((Timer timer) => !timer.isActive);
  }
}

class _TestTimer implements Timer {
  _TestTimer(this.due, this.callback);

  final Duration due;
  final void Function() callback;

  @override
  bool isActive = true;

  @override
  int tick = 0;

  @override
  void cancel() => isActive = false;

  void fire() {
    isActive = false;
    tick = 1;
    callback();
  }
}
