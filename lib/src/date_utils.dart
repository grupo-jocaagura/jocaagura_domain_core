// Adapted from EV-A-0102; see docs/migration/CORE_SELECTION.md.
import 'utils.dart';

/// Alias for [DateUtils], including its legacy local-clock behavior.
typedef JocaDateUtils = DateUtils;

/// Legacy date conversion with local-clock fallback; normalization uses empty/UTC.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// void main() {
///   assert(DateUtils.normalizeIsoOrEmpty(null).isEmpty);
///   assert(JocaDateUtils.normalizeIsoOrEmpty('invalid').isEmpty);
///   assert(DateUtils.normalizeIsoOrEmpty('2024-01-01T02:00:00+02:00') ==
///       '2024-01-01T00:00:00.000Z');
/// }
/// ```
class DateUtils {
  /// Converts [value] using the legacy local-time contract.
  ///
  /// Returns DateTime input unchanged, parses strings, treats integers as epoch
  /// milliseconds in local time, and adds Duration input to the current clock.
  /// Invalid strings and unsupported input fall back to local `DateTime.now()`.
  /// Out-of-range epoch values or duration arithmetic retain SDK errors.
  static DateTime dateTimeFromDynamic(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is Duration) {
      return DateTime.now().add(value);
    }

    return DateTime.now();
  }

  /// Returns [dateTime] in Dart ISO form, retaining its UTC/local distinction.
  ///
  /// This does not normalize a local value to UTC.
  static String dateTimeToString(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// Returns [value] as UTC ISO text, or empty text for absent/unparseable input.
  ///
  /// Accepts DateTime, epoch milliseconds and trimmed text via Utils coercion.
  /// Unlike [dateTimeFromDynamic], invalid text never falls back to the clock.
  /// Local/offset dates convert to UTC; out-of-range epoch values retain SDK errors.
  static String normalizeIsoOrEmpty(Object? value) {
    if (value == null) {
      return '';
    }

    if (value is DateTime) {
      final DateTime utc = value.isUtc ? value : value.toUtc();
      return DateUtils.dateTimeToString(utc);
    }

    if (value is int) {
      final DateTime utc = DateTime.fromMillisecondsSinceEpoch(value).toUtc();
      return DateUtils.dateTimeToString(utc);
    }

    final String s = Utils.getStringFromDynamic(value).trim();
    if (s.isEmpty) {
      return '';
    }

    final DateTime? parsed = DateTime.tryParse(s);
    if (parsed == null) {
      return '';
    }

    final DateTime utc = parsed.isUtc ? parsed : parsed.toUtc();
    return DateUtils.dateTimeToString(utc);
  }
}
