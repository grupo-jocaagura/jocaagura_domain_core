// Adapted from EV-B-0216; see docs/migration/CORE_SELECTION.md.

/// Explicit clock contract. Implementations must return UTC from nowUtc.
abstract class ClockPolicy {
  const ClockPolicy();

  DateTime nowUtc();
}
