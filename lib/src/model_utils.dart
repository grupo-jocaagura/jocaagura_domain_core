// Adapted from EV-B-0116; see docs/migration/CORE_SELECTION.md.
import 'model.dart';
import 'utils.dart';

/// Tolerant map/list conversion and generic model decoding via caller callbacks.
class ModelUtils {
  const ModelUtils._();

  static Map<String, dynamic> jsonFromDynamic(dynamic value) {
    return Utils.mapFromDynamic(value);
  }

  static List<Map<String, dynamic>> jsonListFromDynamic(dynamic value) {
    return Utils.listFromDynamic(value);
  }

  static T modelFromDynamic<T extends Model>({
    required dynamic value,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    return fromJson(Utils.mapFromDynamic(value));
  }

  static List<T> modelListFromDynamic<T extends Model>({
    required dynamic value,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    final List<Map<String, dynamic>> items = Utils.listFromDynamic(value);

    return items.map(fromJson).toList();
  }
}
