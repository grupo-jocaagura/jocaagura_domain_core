// Adapted from jocaagura_domain 1.43.0 (MIT), 56f7eba8a6041160ecf1c1501745c1249e124670.
// Source: lib/domain/docs/model_doc_document.dart; see docs/migration/MODEL_MIGRATION.md.
part of '../../../jocaagura_domain_models.dart';

/// Stable JSON keys used by [ModelDocDocument].
enum ModelDocDocumentEnum { id, title, blocksByIndex }

/// Portable document composed of indexed blocks.
class ModelDocDocument extends Model {
  const ModelDocDocument({
    required this.id,
    required this.title,
    required this.blocksByIndex,
  });

  factory ModelDocDocument.fromJson(Map<String, dynamic> json) {
    final Map<int, ModelDocBlock> tmp = <int, ModelDocBlock>{};
    final dynamic rawBlocks = json[ModelDocDocumentEnum.blocksByIndex.name];

    if (rawBlocks is Map) {
      for (final MapEntry<dynamic, dynamic> entry in rawBlocks.entries) {
        final int indexKey = Utils.getIntegerFromDynamic(entry.key);
        if (indexKey < 0) {
          continue;
        }
        final Map<String, dynamic> blockJson = Utils.mapFromDynamic(
          entry.value,
        );
        tmp[indexKey] = ModelDocBlock.fromJson(blockJson);
      }
    }

    return ModelDocDocument(
      id: Utils.getStringFromDynamic(json[ModelDocDocumentEnum.id.name]),
      title: Utils.getStringFromDynamic(json[ModelDocDocumentEnum.title.name]),
      blocksByIndex: Map<int, ModelDocBlock>.unmodifiable(tmp),
    );
  }

  final String id;
  final String title;
  final Map<int, ModelDocBlock> blocksByIndex;

  @override
  ModelDocDocument copyWith({
    String? id,
    String? title,
    Map<int, ModelDocBlock>? blocksByIndex,
  }) {
    return ModelDocDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      blocksByIndex: blocksByIndex ?? this.blocksByIndex,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final List<int> keys = blocksByIndex.keys.toList(growable: false)..sort();
    final Map<String, dynamic> byIndex = <String, dynamic>{};

    for (final int key in keys) {
      final ModelDocBlock? block = blocksByIndex[key];
      if (block != null) {
        byIndex[key.toString()] = block.toJson();
      }
    }

    return <String, dynamic>{
      ModelDocDocumentEnum.id.name: id,
      ModelDocDocumentEnum.title.name: title,
      ModelDocDocumentEnum.blocksByIndex.name: byIndex,
    };
  }

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelDocDocument &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          Utils.deepEqualsDynamic(blocksByIndex, other.blocksByIndex);

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(id, title, Utils.deepHash(blocksByIndex));

  @override
  String toString() => 'ModelDocDocument(${toJson()})';
}
