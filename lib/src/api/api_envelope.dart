part of '../../jocaagura_domain_api.dart';

/// Functional JSON envelope. It has no HTTP status, headers or retry policy.
///
/// Parsing validates canonical envelope/ErrorItem field types and severity names.
/// It preserves opaque JSON error metadata and ignores extra envelope fields.
/// Binary/redirect/non-envelope operations must use their own contracts.
sealed class ApiEnvelope<T> {
  const ApiEnvelope();

  factory ApiEnvelope.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, Object?> data) decode,
  ) {
    if (ApiJson.boolean(json, 'ok')) {
      return ApiSuccess<T>(decode(ApiJson.object(json['data'], 'data')));
    }
    final Map<String, Object?> error = ApiJson.object(json['error'], 'error');
    final String level = ApiJson.string(error, 'errorLevel');
    if (!ErrorLevelEnum.values.any(
      (ErrorLevelEnum candidate) => candidate.name == level,
    )) {
      throw const FormatException('Unknown ErrorItem.errorLevel.');
    }
    return ApiFailure<T>(
      ErrorItem(
        title: ApiJson.string(error, 'title'),
        code: ApiJson.string(error, 'code'),
        description: ApiJson.string(error, 'description'),
        meta: ApiJsonObject(ApiJson.object(error['meta'], 'error.meta'))
            ._fields,
        errorLevel: ErrorItem.getErrorLevelFromString(level),
      ),
    );
  }

  bool get isSuccess;

  /// Serializes data through [encode]. Its result must be a JSON object.
  Map<String, dynamic> toJson(Map<String, Object?> Function(T value) encode);
}

final class ApiSuccess<T> extends ApiEnvelope<T> {
  const ApiSuccess(this.data);
  final T data;

  @override
  bool get isSuccess => true;

  @override
  Map<String, dynamic> toJson(Map<String, Object?> Function(T value) encode) =>
      <String, dynamic>{
        'ok': true,
        'data': ApiJsonObject._ordered(encode(data)).toJson(),
      };
}

final class ApiFailure<T> extends ApiEnvelope<T> {
  /// Copies and validates metadata rather than retaining a mutable ErrorItem alias.
  ApiFailure(ErrorItem error)
    : error = ErrorItem(
        title: error.title,
        code: error.code,
        description: error.description,
        meta: ApiJsonObject(error.meta)._fields,
        errorLevel: error.errorLevel,
      );

  final ErrorItem error;

  @override
  bool get isSuccess => false;

  @override
  Map<String, dynamic> toJson(Map<String, Object?> Function(T value) encode) =>
      <String, dynamic>{
        'ok': false,
        'error': ApiJsonObject(error.toJson()).toJson(),
      };
}
