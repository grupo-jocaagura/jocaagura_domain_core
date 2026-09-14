// Adapted from EV-B-0108; see docs/migration/CORE_SELECTION.md.
import 'model.dart';
import 'utils.dart';

/// Severity names serialized verbatim by [ErrorItem.toJson].
enum ErrorLevelEnum {
  /// Informational system condition; decoder fallback.
  systemInfo,

  /// Warning condition.
  warning,

  /// Severe condition.
  severe,

  /// Danger condition.
  danger,
}

/// Stable field names used by the ErrorItem wire format.
enum ErrorItemEnum {
  /// Human-readable title field.
  title,

  /// Consumer-defined identifier field.
  code,

  /// Detailed message field.
  description,

  /// Shallow metadata object field.
  meta,

  /// Exact severity name field.
  errorLevel,
}

/// Generic error with tolerant wire decoding and shallow metadata equality.
/// Constructor metadata aliases the caller; copyWith copies its outer map.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// void main() {
///   final ErrorItem error = ErrorItem.fromJson(<String, dynamic>{
///     'code': 'invalid', 'errorLevel': 'unknown',
///   });
///   assert(error.errorLevel == ErrorLevelEnum.systemInfo);
///   final ErrorItem copy = error.copyWith(title: 'Invalid input');
///   assert(copy.toJson()['title'] == 'Invalid input');
/// }
/// ```
class ErrorItem extends Model {
  /// Stores [title], [code], [description], [meta] and [errorLevel] unchanged.
  ///
  /// Metadata aliases the caller map; nested values are not copied or frozen.
  /// The default severity is systemInfo. JSON compatibility of metadata remains
  /// the caller responsibility; this constructor performs no validation.
  const ErrorItem({
    required this.title,
    required this.code,
    required this.description,
    this.meta = const <String, dynamic>{},
    this.errorLevel = ErrorLevelEnum.systemInfo,
  });

  /// Decodes [json] tolerantly with the existing Utils coercion rules.
  ///
  /// Missing/null text becomes empty, invalid metadata becomes an empty map, and
  /// unknown severity names fall back to systemInfo. Existing typed metadata can
  /// remain aliased; this is not a deep copy or a strict schema validator.
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

  /// Short human-readable error title.
  final String title;

  /// Consumer-defined error identifier; no registry is enforced.
  final String code;

  /// Human-readable detail retained exactly as constructed.
  final String description;

  /// Shallow metadata; constructor and wire output may share the caller map.
  ///
  /// Mutating it can change equality/hash. Nested values retain their own equality.
  final Map<String, dynamic> meta;

  /// Severity whose enum name is emitted on the wire.
  final ErrorLevelEnum errorLevel;

  /// Returns all five fields with severity as its exact enum name.
  ///
  /// The outer map is new; [meta] is shared. Non-JSON metadata may fail when a
  /// consumer later encodes this map; this method does not sanitize values.
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    ErrorItemEnum.title.name: title,
    ErrorItemEnum.code.name: code,
    ErrorItemEnum.description.name: description,
    ErrorItemEnum.meta.name: meta,
    ErrorItemEnum.errorLevel.name: errorLevel.name,
  };

  /// Returns a copy replacing non-null [title], [code], [description], [meta]
  /// and [errorLevel]. Null arguments retain the corresponding current values.
  ///
  /// Always copies the selected metadata into an unmodifiable outer map; nested
  /// objects remain shared and may still be mutable.
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

  /// Returns title, code, description, optional metadata and severity for diagnostics.
  @override
  String toString() {
    final String metaString = meta.isNotEmpty ? ' | Meta: $meta' : '';
    return '$title ($code): $description$metaString | Level: ${errorLevel.name}';
  }

  /// Uses exact runtime type, scalar fields and shallow metadata equality.
  ///
  /// Metadata insertion order is ignored by equality and hash; nested values use
  /// their own contracts. Mutable metadata must not change while used as a map key.
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

  /// Uses exact runtime type, scalar fields and shallow metadata equality.
  ///
  /// Metadata insertion order is ignored by equality and hash; nested values use
  /// their own contracts. Mutable metadata must not change while used as a map key.
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

  /// Returns the severity with exact case-sensitive name [level].
  ///
  /// Null and unknown names return [ErrorLevelEnum.systemInfo].
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
