part of '../../jocaagura_domain_api.dart';

/// Deeply owned JSON object with finite numbers and string keys.
///
/// Construction rejects cycles, non-JSON values, invalid keys and non-finite
/// numbers with [FormatException]. Shared acyclic subobjects are allowed and
/// copied. This does not impose business meaning on opaque metadata.
class ApiJsonObject {
  ApiJsonObject(Map<String, Object?> fields)
    : _fields =
          _freezeApiJson(fields, HashSet<Object>.identity(), r'$')!
              as Map<String, Object?>;

  ApiJsonObject._ordered(Map<String, Object?> fields)
    : _fields =
          _freezeApiJson(
                fields,
                HashSet<Object>.identity(),
                r'$',
                documentOrder: true,
              )!
              as Map<String, Object?>;

  final Map<String, Object?> _fields;

  /// An independent, recursively mutable JSON copy. Mutations cannot change this value.
  Map<String, dynamic> toJson() =>
      _copyApiJson(_fields)! as Map<String, dynamic>;

  /// Returns an owned immutable JSON value. Missing and null can be distinguished
  /// with [containsKey]; this accessor returns null for either case.
  Object? operator [](String key) => _fields[key];

  bool containsKey(String key) => _fields.containsKey(key);

  @override
  // SDK-only immutable value; no annotation package is needed.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ApiJsonObject &&
      runtimeType == other.runtimeType &&
      Utils.deepEqualsDynamic(_fields, other._fields);

  @override
  // SDK-only immutable value; no annotation package is needed.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(runtimeType, Utils.deepHash(_fields));
}

Object? _freezeApiJson(
  Object? value,
  Set<Object> ancestors,
  String path, {
  bool documentOrder = false,
}) {
  if (value == null || value is String || value is bool || value is int) {
    return value;
  }
  if (value is double) {
    if (!value.isFinite) {
      throw FormatException('Expected a finite JSON number at $path.');
    }
    return value;
  }
  if (value is Map || value is List) {
    if (!ancestors.add(value)) {
      throw FormatException('Cyclic JSON value at $path.');
    }
    try {
      if (value is Map) {
        // Functional document blocks are the explicit wire-order exception.
        // Opaque JSON and all other contract objects retain sorted keys.
        final bool orderedBlocks =
            documentOrder && path.endsWith('.blocksByIndex');
        final Map<String, Object?> result = orderedBlocks
            ? <String, Object?>{}
            : SplayTreeMap<String, Object?>();
        for (final MapEntry<Object?, Object?> entry in value.entries) {
          if (entry.key is! String) {
            throw FormatException('Expected a string JSON key at $path.');
          }
          final String key = entry.key! as String;
          result[key] = _freezeApiJson(
            entry.value,
            ancestors,
            '$path.$key',
            documentOrder: documentOrder,
          );
        }
        return Map<String, Object?>.unmodifiable(result);
      }
      final List<Object?> list = value as List<Object?>;
      return List<Object?>.unmodifiable(<Object?>[
        for (int i = 0; i < list.length; i++)
          _freezeApiJson(
            list[i],
            ancestors,
            '$path[$i]',
            documentOrder: documentOrder,
          ),
      ]);
    } finally {
      ancestors.remove(value);
    }
  }
  throw FormatException('Expected a JSON value at $path.');
}

Object? _copyApiJson(Object? value) {
  if (value is Map<String, Object?>) {
    return <String, dynamic>{
      for (final MapEntry<String, Object?> entry in value.entries)
        entry.key: _copyApiJson(entry.value),
    };
  }
  if (value is List<Object?>) {
    return <Object?>[for (final Object? item in value) _copyApiJson(item)];
  }
  return value;
}

/// Read helpers for canonical wire types. They do not coerce legacy input.
abstract final class ApiJson {
  static num number(Map<String, Object?> json, String key) {
    final Object? value = json[key];
    if (value is! num || !value.isFinite) {
      throw FormatException('Expected finite number at $key.');
    }
    return value;
  }

  static String string(Map<String, Object?> json, String key) {
    final Object? value = json[key];
    if (value is! String) {
      throw FormatException('Expected string at $key.');
    }
    return value;
  }

  static int integer(Map<String, Object?> json, String key) {
    final Object? value = json[key];
    if (value is! int) {
      throw FormatException('Expected integer at $key.');
    }
    return value;
  }

  static bool boolean(Map<String, Object?> json, String key) {
    final Object? value = json[key];
    if (value is! bool) {
      throw FormatException('Expected boolean at $key.');
    }
    return value;
  }

  static Map<String, Object?> object(Object? value, String path) {
    if (value is! Map<String, Object?>) {
      throw FormatException('Expected object at $path.');
    }
    return value;
  }

  static List<Object?> array(Object? value, String path) {
    if (value is! List<Object?>) {
      throw FormatException('Expected array at $path.');
    }
    return value;
  }
}
