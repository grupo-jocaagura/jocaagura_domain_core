// Adapted from EV-A-0419; see docs/migration/CORE_SELECTION.md.
import 'dart:async';

/// FIFO asynchronous work per stable key. Awaiting nested same-key work deadlocks.
/// Dispose clears bookkeeping without cancellation; new work may overlap old work.
class PerKeyFifoExecutor<K extends Object> {
  final Map<K, Future<void>> _queues = <K, Future<void>>{};

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

  void dispose() => _queues.clear();
}
