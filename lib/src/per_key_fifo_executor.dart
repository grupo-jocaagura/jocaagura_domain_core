// Adapted from EV-A-0419; see docs/migration/CORE_SELECTION.md.
import 'dart:async';

/// FIFO asynchronous work per stable key. Awaiting nested same-key work deadlocks.
/// Dispose clears bookkeeping without cancellation; new work may overlap old work.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// Future<void> main() async {
///   final PerKeyFifoExecutor<String> executor = PerKeyFifoExecutor<String>();
///   final List<int> events = <int>[];
///   final Future<void> first = executor.withLock<void>('key', () async {
///     events.add(1);
///   });
///   final Future<void> second = executor.withLock<void>('key', () async {
///     events.add(2);
///   });
///   await Future.wait<void>(<Future<void>>[first, second]);
///   assert(events.join(',') == '1,2');
///   executor.dispose();
/// }
/// ```
class PerKeyFifoExecutor<K extends Object> {
  final Map<K, Future<void>> _queues = <K, Future<void>>{};

  /// Enqueues [action] after earlier work for equal [key] values finishes.
  ///
  /// Returns its result or original synchronous/asynchronous error. Either outcome
  /// releases followers and removes the idle queue. Other keys can progress
  /// independently. Keys must keep stable equality and hash codes while queued.
  ///
  /// Awaiting another action on the same key from inside [action] deadlocks.
  /// Different-key nesting and scheduling same-key work without awaiting it inside
  /// the current action are supported. See [dispose] for its non-cancelling limits.
  Future<R> withLock<R>(K key, Future<R> Function() action) async {
    final Future<void> previous = _queues[key] ?? Future<void>.value();
    final Completer<void> gate = Completer<void>();
    final Future<void> tail = previous.then((_) => gate.future);
    _queues[key] = tail;

    try {
      await previous;
      final R result = await action();
      return result;
    } finally {
      if (!gate.isCompleted) {
        gate.complete();
      }
      if (identical(_queues[key], tail)) {
        _queues.remove(key);
      }
    }
  }

  /// Clears queue bookkeeping without cancelling queued or running actions.
  ///
  /// Repeated calls are allowed. The executor remains usable: new work may overlap
  /// old work for the same key. Completion of an old queue cannot remove a new one.
  void dispose() => _queues.clear();
}
