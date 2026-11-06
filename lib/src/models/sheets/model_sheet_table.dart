// Adapted from jocaagura_domain 1.43.0 (MIT), 56f7eba8a6041160ecf1c1501745c1249e124670.
// Source: lib/domain/sheets/model_sheet_table.dart; see docs/migration/MODEL_MIGRATION.md.
part of '../../../jocaagura_domain_models.dart';

/// Stable JSON keys used by [ModelSheetTable].
enum ModelSheetTableEnum { id, name, primaryKeyColumn, columns, rowsCount }

/// Structural definition of a normalized sheet table.
class ModelSheetTable extends Model {
  const ModelSheetTable({
    required this.id,
    required this.name,
    required this.primaryKeyColumn,
    required this.columns,
    this.rowsCount,
  });

  factory ModelSheetTable.fromJson(Map<String, dynamic> json) {
    return ModelSheetTable(
      id: Utils.getStringFromDynamic(json[ModelSheetTableEnum.id.name]),
      name: Utils.getStringFromDynamic(json[ModelSheetTableEnum.name.name]),
      primaryKeyColumn: Utils.getStringFromDynamic(
        json[ModelSheetTableEnum.primaryKeyColumn.name],
      ),
      columns: Utils.listFromDynamic(json[ModelSheetTableEnum.columns.name])
          .map((Map<String, dynamic> e) => ModelSheetColumn.fromJson(e))
          .toList(),
      rowsCount: json.containsKey(ModelSheetTableEnum.rowsCount.name)
          ? Utils.getIntegerFromDynamic(
              json[ModelSheetTableEnum.rowsCount.name],
            )
          : null,
    );
  }

  final String id;
  final String name;
  final String primaryKeyColumn;
  final List<ModelSheetColumn> columns;
  final int? rowsCount;

  @override
  ModelSheetTable copyWith({
    String? id,
    String? name,
    String? primaryKeyColumn,
    List<ModelSheetColumn>? columns,
    Object? rowsCount = _sheetUnset,
  }) {
    return ModelSheetTable(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryKeyColumn: primaryKeyColumn ?? this.primaryKeyColumn,
      columns: columns ?? this.columns,
      rowsCount: identical(rowsCount, _sheetUnset)
          ? this.rowsCount
          : rowsCount as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      ModelSheetTableEnum.id.name: id,
      ModelSheetTableEnum.name.name: name,
      ModelSheetTableEnum.primaryKeyColumn.name: primaryKeyColumn,
      ModelSheetTableEnum.columns.name: columns
          .map((ModelSheetColumn e) => e.toJson())
          .toList(),
    };
    if (rowsCount != null) {
      json[ModelSheetTableEnum.rowsCount.name] = rowsCount;
    }
    return json;
  }

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelSheetTable &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          primaryKeyColumn == other.primaryKeyColumn &&
          Utils.listEquals(columns, other.columns) &&
          rowsCount == other.rowsCount;

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(
    id,
    name,
    primaryKeyColumn,
    Utils.listHash(columns),
    rowsCount,
  );

  @override
  String toString() => 'ModelSheetTable(${toJson()})';
}
