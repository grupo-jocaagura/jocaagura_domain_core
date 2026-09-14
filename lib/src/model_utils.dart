// Adapted from EV-B-0116; see docs/migration/CORE_SELECTION.md.
import 'model.dart';
import 'utils.dart';

/// Tolerant map/list conversion and generic model decoding via caller callbacks.
class ModelUtils {
  const ModelUtils._();

  /// Returns [value] as a string-keyed map using [Utils.mapFromDynamic].
  ///
  /// Accepts maps and encoded JSON objects. Invalid/non-map input becomes empty;
  /// keys are coerced by the existing Utils contract, not schema validation.
  static Map<String, dynamic> jsonFromDynamic(dynamic value) {
    return Utils.mapFromDynamic(value);
  }

  /// Returns retained map entries from an actual list [value], preserving order.
  ///
  /// Non-map entries are discarded; non-lists, including encoded arrays, yield
  /// an empty list. Map conversion follows [Utils.listFromDynamic].
  static List<Map<String, dynamic>> jsonListFromDynamic(dynamic value) {
    return Utils.listFromDynamic(value);
  }

  /// Converts [value] to a map and returns [fromJson] applied to it.
  ///
  /// Malformed input becomes an empty map. Callback errors propagate unchanged.
  static T modelFromDynamic<T extends Model>({
    required dynamic value,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    return fromJson(Utils.mapFromDynamic(value));
  }

  /// Converts an actual list [value] and decodes retained maps with [fromJson].
  ///
  /// Returns a growable list in input order; non-maps are discarded and non-lists
  /// yield empty lists. A callback error stops decoding and propagates unchanged.
  static List<T> modelListFromDynamic<T extends Model>({
    required dynamic value,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    final List<Map<String, dynamic>> items = Utils.listFromDynamic(value);

    return items.map(fromJson).toList();
  }
}
