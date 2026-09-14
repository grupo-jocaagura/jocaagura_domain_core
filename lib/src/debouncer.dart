// Adapted from EV-A-0171; see docs/migration/CORE_SELECTION.md.
import 'dart:async';

/// Runs the latest delayed callback; dispose cancels pending work and ignores calls.
/// Positive milliseconds are asserted in debug mode. Errors reach the scheduling zone.
///
/// ```dart
/// import 'dart:async';
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// Future<void> main() async {
///   final Debouncer debouncer = Debouncer(milliseconds: 1);
///   final Completer<void> completed = Completer<void>();
///   int calls = 0;
///   debouncer(() => calls++);
///   debouncer(() {
///     calls++;
///     completed.complete();
///   });
///   await completed.future;
///   assert(calls == 1);
///   debouncer.dispose();
///   assert(debouncer.isDisposed);
/// }
/// ```
class Debouncer {
  /// Creates a debouncer with delay [milliseconds], defaulting to 500.
  ///
  /// Asserts a positive delay when assertions are enabled. Release mode retains
  /// Timer semantics for zero/negative durations; there is no runtime validation.
  Debouncer({this.milliseconds = 500})
    : assert(milliseconds > 0, 'milliseconds must be > 0');

  /// Delay before the most recently scheduled callback may run.
  final int milliseconds;

  Timer? _timer;

  bool _isDisposed = false;

  /// Whether [dispose] has permanently disabled scheduling on this instance.
  bool get isDisposed => _isDisposed;

  /// Schedules [action] after [milliseconds], cancelling any pending callback.
  ///
  /// Calls after [dispose] are ignored. Callback exceptions reach the scheduling
  /// zone error handler; this method does not await, catch or convert them.
  void call(void Function() action) {
    if (!_isDisposed) {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: milliseconds), action);
    }
  }

  /// Cancels the pending timer and permanently ignores subsequent calls.
  ///
  /// Repeated disposal is harmless. It cannot undo a callback already executed.
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _timer?.cancel();
      _timer = null;
    }
  }
}
