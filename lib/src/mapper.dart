// Adapted from EV-B-0113; see docs/migration/CORE_SELECTION.md.
import 'model.dart';
import 'utils.dart';

/// Generic model decoder. Tolerant conversions delegate to Utils; errors propagate.
abstract class Mapper<T extends Model> {
  const Mapper();

  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(T value) {
    return value.toJson();
  }

  T fromDynamic(dynamic value) {
    return fromJson(Utils.mapFromDynamic(value));
  }

  List<T> fromDynamicList(dynamic value) {
    final List<Map<String, dynamic>> items = Utils.listFromDynamic(value);
    return items.map(fromJson).toList();
  }
}
