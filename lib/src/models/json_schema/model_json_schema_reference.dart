// Adapted from jocaagura_domain 1.43.0 (MIT), 56f7eba8a6041160ecf1c1501745c1249e124670.
// Source: lib/domain/json_schema/model_json_schema_reference.dart; see docs/migration/MODEL_MIGRATION.md.
part of '../../../jocaagura_domain_models.dart';

/// Stable JSON keys used by [ModelJsonSchemaReference].
enum ModelJsonSchemaReferenceEnum {
  id,
  sourceSchemaId,
  targetSchemaId,
  referenceType,
  path,
  referenceDescription,
}

/// Canonical reference kinds between schema documents.
enum JsonSchemaReferenceTypeEnum { ref, allOf, anyOf, oneOf, items, property }

/// Immutable reference between two JSON Schema documents.
///
/// This model allows the domain to represent schema dependencies explicitly,
/// which is useful for registries, dependency graphs and tooling.
class ModelJsonSchemaReference extends Model {
  const ModelJsonSchemaReference({
    required this.id,
    required this.sourceSchemaId,
    required this.targetSchemaId,
    required this.referenceType,
    required this.path,
    required this.referenceDescription,
  });

  /// Rebuilds a [ModelJsonSchemaReference] from JSON.
  factory ModelJsonSchemaReference.fromJson(Map<String, dynamic> json) {
    return ModelJsonSchemaReference(
      id: Utils.getStringFromDynamic(
        json[ModelJsonSchemaReferenceEnum.id.name],
      ),
      sourceSchemaId: Utils.getStringFromDynamic(
        json[ModelJsonSchemaReferenceEnum.sourceSchemaId.name],
      ),
      targetSchemaId: Utils.getStringFromDynamic(
        json[ModelJsonSchemaReferenceEnum.targetSchemaId.name],
      ),
      referenceType: _referenceTypeFromString(
        Utils.getStringFromDynamic(
          json[ModelJsonSchemaReferenceEnum.referenceType.name],
        ),
      ),
      path: Utils.getStringFromDynamic(
        json[ModelJsonSchemaReferenceEnum.path.name],
      ),
      referenceDescription: Utils.getStringFromDynamic(
        json[ModelJsonSchemaReferenceEnum.referenceDescription.name],
      ),
    );
  }

  /// Internal identifier of the relationship record.
  final String id;

  /// Origin schema identifier.
  final String sourceSchemaId;

  /// Target schema identifier.
  final String targetSchemaId;

  /// Reference kind used in the relationship.
  final JsonSchemaReferenceTypeEnum referenceType;

  /// Path inside the source document where the relation appears.
  final String path;

  /// Functional explanation of the dependency.
  final String referenceDescription;

  @override
  ModelJsonSchemaReference copyWith({
    String? id,
    String? sourceSchemaId,
    String? targetSchemaId,
    JsonSchemaReferenceTypeEnum? referenceType,
    String? path,
    String? referenceDescription,
  }) {
    return ModelJsonSchemaReference(
      id: id ?? this.id,
      sourceSchemaId: sourceSchemaId ?? this.sourceSchemaId,
      targetSchemaId: targetSchemaId ?? this.targetSchemaId,
      referenceType: referenceType ?? this.referenceType,
      path: path ?? this.path,
      referenceDescription: referenceDescription ?? this.referenceDescription,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ModelJsonSchemaReferenceEnum.id.name: id,
      ModelJsonSchemaReferenceEnum.sourceSchemaId.name: sourceSchemaId,
      ModelJsonSchemaReferenceEnum.targetSchemaId.name: targetSchemaId,
      ModelJsonSchemaReferenceEnum.referenceType.name: referenceType.name,
      ModelJsonSchemaReferenceEnum.path.name: path,
      ModelJsonSchemaReferenceEnum.referenceDescription.name:
          referenceDescription,
    };
  }

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelJsonSchemaReference &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sourceSchemaId == other.sourceSchemaId &&
          targetSchemaId == other.targetSchemaId &&
          referenceType == other.referenceType &&
          path == other.path &&
          referenceDescription == other.referenceDescription;

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(
    id,
    sourceSchemaId,
    targetSchemaId,
    referenceType,
    path,
    referenceDescription,
  );

  @override
  String toString() => 'ModelJsonSchemaReference(${toJson()})';

  static JsonSchemaReferenceTypeEnum _referenceTypeFromString(String? value) {
    return JsonSchemaReferenceTypeEnum.values.firstWhere(
      (JsonSchemaReferenceTypeEnum e) => e.name == value,
      orElse: () => JsonSchemaReferenceTypeEnum.ref,
    );
  }
}
