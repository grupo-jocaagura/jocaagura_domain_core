part of '../../jocaagura_domain_api.dart';

/// Presence of a JSON field, independently of whether its value is null.
///
/// Use `ApiField<String?>.present(null)` to clear a nullable property and
/// `ApiField<String?>.absent()` to preserve it in a partial update. A missing
/// field is not represented by a sentinel string or by JSON null.
sealed class ApiField<T> {
  const ApiField._();

  const factory ApiField.absent() = _ApiAbsent<T>;
  const factory ApiField.present(T value) = _ApiPresent<T>;

  /// Whether the JSON member was explicitly supplied.
  bool get isPresent;

  /// Supplied value. Throws [StateError] when this field is absent.
  T get value;

  /// Decodes only if [key] is present, including explicit null values.
  static ApiField<R> fromJson<R>(
    Map<String, Object?> json,
    String key,
    R Function(Object? value) decode,
  ) => json.containsKey(key)
      ? ApiField<R>.present(decode(json[key]))
      : ApiField<R>.absent();

  /// Adds the member only when present. Serialization does not alter absence.
  void writeTo(
    Map<String, Object?> json,
    String key,
    Object? Function(T value) encode,
  ) {
    if (isPresent) {
      json[key] = encode(value);
    }
  }

  /// Transforms a supplied value while preserving missing fields.
  ApiField<R> map<R>(R Function(T value) transform) =>
      isPresent ? ApiField<R>.present(transform(value)) : ApiField<R>.absent();
}

final class _ApiAbsent<T> extends ApiField<T> {
  const _ApiAbsent() : super._();

  @override
  bool get isPresent => false;

  @override
  T get value => throw StateError('The API field is absent.');
}

final class _ApiPresent<T> extends ApiField<T> {
  const _ApiPresent(this.value) : super._();

  @override
  bool get isPresent => true;

  @override
  final T value;
}
