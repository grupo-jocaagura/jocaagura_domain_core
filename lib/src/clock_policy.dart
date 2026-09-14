// Adapted from EV-B-0216; see docs/migration/CORE_SELECTION.md.

/// Explicit clock contract. Implementations must return UTC from nowUtc.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// class FixedClock extends ClockPolicy {
///   const FixedClock();
///   @override
///   DateTime nowUtc() => DateTime.utc(2024);
/// }
/// void main() {
///   const ClockPolicy clock = FixedClock();
///   assert(clock.nowUtc().isUtc);
///   assert(clock.nowUtc() == DateTime.utc(2024));
/// }
/// ```
abstract class ClockPolicy {
  /// Initializes a consumer-provided clock policy.
  const ClockPolicy();

  /// Returns the current instant as a UTC [DateTime].
  ///
  /// Implementations supply the clock and must ensure `isUtc` is true. The base
  /// contract performs no conversion, validation or exception handling.
  DateTime nowUtc();
}
