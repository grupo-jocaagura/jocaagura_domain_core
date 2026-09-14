// Adapted from EV-B-0108; see docs/migration/CORE_SELECTION.md.
import 'model.dart';
import 'utils.dart';

enum ErrorLevelEnum { systemInfo, warning, severe, danger }

enum ErrorItemEnum { title, code, description, meta, errorLevel }

/// Generic error with tolerant wire decoding and shallow metadata equality.
/// Constructor metadata aliases the caller; copyWith copies its outer map.
class ErrorItem extends Model {
  const ErrorItem({
    required this.title,
    required this.code,
    required this.description,
    this.meta = const <String, dynamic>{},
    this.errorLevel = ErrorLevelEnum.systemInfo,
  });

  factory ErrorItem.fromJson(Map<String, dynamic> json) {
    return ErrorItem(
      title: Utils.getStringFromDynamic(json[ErrorItemEnum.title.name]),
      code: Utils.getStringFromDynamic(json[ErrorItemEnum.code.name]),
      description: Utils.getStringFromDynamic(
        json[ErrorItemEnum.description.name],
      ),
      meta: Utils.mapFromDynamic(
        json[ErrorItemEnum.meta.name] ?? <String, dynamic>{},
      ),
      errorLevel: getErrorLevelFromString(
        Utils.getStringFromDynamic(json[ErrorItemEnum.errorLevel.name]),
      ),
    );
  }

  final String title;

  final String code;

  final String description;

  final Map<String, dynamic> meta;

  final ErrorLevelEnum errorLevel;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    ErrorItemEnum.title.name: title,
    ErrorItemEnum.code.name: code,
    ErrorItemEnum.description.name: description,
    ErrorItemEnum.meta.name: meta,
    ErrorItemEnum.errorLevel.name: errorLevel.name,
  };

  @override
  ErrorItem copyWith({
    String? title,
    String? code,
    String? description,
    Map<String, dynamic>? meta,
    ErrorLevelEnum? errorLevel,
  }) {
    return ErrorItem(
      title: title ?? this.title,
      code: code ?? this.code,
      description: description ?? this.description,
      meta: Map<String, dynamic>.unmodifiable(meta ?? this.meta),
      errorLevel: errorLevel ?? this.errorLevel,
    );
  }

  @override
  String toString() {
    final String metaString = meta.isNotEmpty ? ' | Meta: $meta' : '';
    return '$title ($code): $description$metaString | Level: ${errorLevel.name}';
  }

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          code == other.code &&
          description == other.description &&
          _shallowMapEquals(meta, other.meta) &&
          errorLevel == other.errorLevel;

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final Iterable<int> metaEntryHashes = meta.entries.map(
      (MapEntry<String, dynamic> e) => Object.hash(e.key, e.value),
    );
    return Object.hash(
      title,
      code,
      description,
      Object.hashAllUnordered(metaEntryHashes),
      errorLevel,
    );
  }

  static ErrorLevelEnum getErrorLevelFromString(String? level) {
    return ErrorLevelEnum.values.firstWhere(
      (ErrorLevelEnum e) => e.name == level,
      orElse: () => ErrorLevelEnum.systemInfo,
    );
  }
}

// Metadata is shallow by contract. Nonnullable specialization of EV-B-0115.
bool _shallowMapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (final String key in a.keys) {
    if (!b.containsKey(key) || b[key] != a[key]) {
      return false;
    }
  }
  return true;
}
