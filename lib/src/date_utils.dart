// Adapted from EV-A-0102; see docs/migration/CORE_SELECTION.md.
import 'utils.dart';

typedef JocaDateUtils = DateUtils;

/// Legacy date conversion with local-clock fallback; normalization uses empty/UTC.
class DateUtils {
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

  static String dateTimeToString(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

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
