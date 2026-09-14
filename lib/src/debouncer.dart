// Adapted from EV-A-0171; see docs/migration/CORE_SELECTION.md.
import 'dart:async';

/// Runs the latest delayed callback; dispose cancels pending work and ignores calls.
/// Positive milliseconds are asserted in debug mode. Errors reach the scheduling zone.
class Debouncer {
  Debouncer({this.milliseconds = 500})
    : assert(milliseconds > 0, 'milliseconds must be > 0');

  final int milliseconds;

  Timer? _timer;

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  void call(void Function() action) {
    if (!_isDisposed) {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: milliseconds), action);
    }
  }

  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _timer?.cancel();
      _timer = null;
    }
  }
}
