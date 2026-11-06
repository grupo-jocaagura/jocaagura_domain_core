// Adapted from jocaagura_domain 1.43.0 (MIT), 56f7eba8a6041160ecf1c1501745c1249e124670.
// Source: lib/domain/sheets/model_sheet_book.dart; see docs/migration/MODEL_MIGRATION.md.
part of '../../../jocaagura_domain_models.dart';

/// Stable JSON keys used by [ModelSheetBook].
enum ModelSheetBookEnum { id, name, tables }

/// Logical book that groups normalized tables.
class ModelSheetBook extends Model {
  const ModelSheetBook({
    required this.id,
    required this.name,
    required this.tables,
  });

  factory ModelSheetBook.fromJson(Map<String, dynamic> json) {
    return ModelSheetBook(
      id: Utils.getStringFromDynamic(json[ModelSheetBookEnum.id.name]),
      name: Utils.getStringFromDynamic(json[ModelSheetBookEnum.name.name]),
      tables: Utils.listFromDynamic(json[ModelSheetBookEnum.tables.name])
          .map((Map<String, dynamic> e) => ModelSheetTable.fromJson(e))
          .toList(),
    );
  }

  final String id;
  final String name;
  final List<ModelSheetTable> tables;

  @override
  ModelSheetBook copyWith({
    String? id,
    String? name,
    List<ModelSheetTable>? tables,
  }) {
    return ModelSheetBook(
      id: id ?? this.id,
      name: name ?? this.name,
      tables: tables ?? this.tables,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    ModelSheetBookEnum.id.name: id,
    ModelSheetBookEnum.name.name: name,
    ModelSheetBookEnum.tables.name: tables
        .map((ModelSheetTable e) => e.toJson())
        .toList(),
  };

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelSheetBook &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          Utils.listEquals(tables, other.tables);

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(id, name, Utils.listHash(tables));

  @override
  String toString() => 'ModelSheetBook(${toJson()})';
}
