// Adapted from EV-B-0102; see docs/migration/CORE_SELECTION.md.

/// Exact Dart UTC ISO encoding checks, nullable parsing and system-clock text.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// void main() {
///   const String instant = '2024-02-29T12:00:00.000Z';
///   assert(DateTimeIsoUtils.isCanonicalUtcIso(instant));
///   assert(!DateTimeIsoUtils.isCanonicalUtcIso('2024-02-29T12:00:00Z'));
///   assert(DateTimeIsoUtils.tryParseCanonicalUtc('') == null);
///   assert(DateTimeIsoUtils.isSameOrAfter(instant, instant));
/// }
/// ```
abstract class DateTimeIsoUtils {
  /// Whether [value] exactly equals the Dart UTC ISO encoding of its instant.
  ///
  /// Requires `Z`, no surrounding whitespace and canonical fractional precision.
  /// Rejects missing fractions, offsets and dates normalized by the Dart parser.
  /// Empty, malformed and noncanonical strings return false rather than throwing.
  static bool isCanonicalUtcIso(String value) {
    if (value.isEmpty || value.trim() != value || !value.endsWith('Z')) {
      return false;
    }

    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed == null || !parsed.isUtc) {
      return false;
    }

    return parsed.toUtc().toIso8601String() == value;
  }

  /// Whether [value] is whitespace-only or passes [isCanonicalUtcIso].
  ///
  /// Whitespace is accepted as absence, but is not trimmed around a date.
  static bool isEmptyOrCanonicalUtcIso(String value) {
    return value.trim().isEmpty || isCanonicalUtcIso(value);
  }

  /// Returns the UTC instant for canonical [value], or null for anything else.
  ///
  /// Uses [isCanonicalUtcIso]; absence, offsets and malformed input return null.
  static DateTime? tryParseCanonicalUtc(String value) {
    if (!isCanonicalUtcIso(value)) {
      return null;
    }
    return DateTime.parse(value).toUtc();
  }

  /// Whether canonical [candidateIso] is equal to or later than [referenceIso].
  ///
  /// Returns false if either string is absent, malformed or noncanonical.
  static bool isSameOrAfter(String candidateIso, String referenceIso) {
    final DateTime? candidate = tryParseCanonicalUtc(candidateIso);
    final DateTime? reference = tryParseCanonicalUtc(referenceIso);
    if (candidate == null || reference == null) {
      return false;
    }
    return candidate.isAtSameMomentAs(reference) ||
        candidate.isAfter(reference);
  }

  /// Returns the real system clock instant in canonical UTC ISO form.
  ///
  /// This helper does not use `ClockPolicy`; consumers needing an injected clock
  /// should call their policy directly and serialize its UTC result.
  static String nowUtcIso() {
    return DateTime.now().toUtc().toIso8601String();
  }
}
