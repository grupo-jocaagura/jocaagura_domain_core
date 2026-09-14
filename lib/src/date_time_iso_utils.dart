// Adapted from EV-B-0102; see docs/migration/CORE_SELECTION.md.

/// Exact Dart UTC ISO encoding checks, nullable parsing and system-clock text.
abstract class DateTimeIsoUtils {
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

  static bool isEmptyOrCanonicalUtcIso(String value) {
    return value.trim().isEmpty || isCanonicalUtcIso(value);
  }

  static DateTime? tryParseCanonicalUtc(String value) {
    if (!isCanonicalUtcIso(value)) {
      return null;
    }
    return DateTime.parse(value).toUtc();
  }

  static bool isSameOrAfter(String candidateIso, String referenceIso) {
    final DateTime? candidate = tryParseCanonicalUtc(candidateIso);
    final DateTime? reference = tryParseCanonicalUtc(referenceIso);
    if (candidate == null || reference == null) {
      return false;
    }
    return candidate.isAtSameMomentAs(reference) ||
        candidate.isAfter(reference);
  }

  static String nowUtcIso() {
    return DateTime.now().toUtc().toIso8601String();
  }
}
