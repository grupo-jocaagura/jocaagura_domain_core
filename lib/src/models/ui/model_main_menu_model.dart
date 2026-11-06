// SDK-only data split from SRC-A ModelMainMenuModel; see MODEL_MIGRATION.md.
part of '../../../jocaagura_domain_models.dart';

/// Serializable icon identity. Resolving a font/glyph belongs to the UI adapter.
///
/// This carries data only: it imports no rendering library, resolves no fonts
/// and does not guarantee that a glyph is available on a target platform.
class ModelIconData extends Model {
  /// Stores the identity used by a Flutter adapter to construct its icon.
  const ModelIconData({
    required this.codePoint,
    this.fontFamily,
    this.fontPackage,
    this.matchTextDirection = false,
  });

  /// Decodes exact field types. Invalid field types raise a [TypeError].
  factory ModelIconData.fromJson(Map<String, dynamic> json) => ModelIconData(
    codePoint: json['codePoint'] as int,
    fontFamily: json['fontFamily'] as String?,
    fontPackage: json['fontPackage'] as String?,
    matchTextDirection: (json['matchTextDirection'] as bool?) ?? false,
  );

  /// Character code; no platform glyph validation is performed.
  final int codePoint;

  /// Optional font family. Null and empty are distinct values.
  final String? fontFamily;

  /// Optional consumer package owning the font.
  final String? fontPackage;

  /// Whether the renderer should mirror the icon for text direction.
  final bool matchTextDirection;

  @override
  ModelIconData copyWith({
    int? codePoint,
    Object? fontFamily = unit,
    Object? fontPackage = unit,
    bool? matchTextDirection,
  }) => ModelIconData(
    codePoint: codePoint ?? this.codePoint,
    fontFamily: identical(fontFamily, unit)
        ? this.fontFamily
        : fontFamily as String?,
    fontPackage: identical(fontPackage, unit)
        ? this.fontPackage
        : fontPackage as String?,
    matchTextDirection: matchTextDirection ?? this.matchTextDirection,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'codePoint': codePoint,
    'fontFamily': fontFamily,
    'fontPackage': fontPackage,
    'matchTextDirection': matchTextDirection,
  };

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ModelIconData &&
      other.codePoint == codePoint &&
      other.fontFamily == fontFamily &&
      other.fontPackage == fontPackage &&
      other.matchTextDirection == matchTextDirection;

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      Object.hash(codePoint, fontFamily, fontPackage, matchTextDirection);
}

/// Data portion of a menu item. The adapter owns actions and rendering.
///
/// Unlike the legacy Flutter wrapper, this value has no callback and serializes
/// its complete data. The migration guide documents the explicit adapter split.
class ModelMainMenuModel extends Model {
  /// Creates a menu description without executing any action.
  const ModelMainMenuModel({
    required this.iconData,
    required this.label,
    this.description = '',
  });

  factory ModelMainMenuModel.fromJson(Map<String, dynamic> json) =>
      ModelMainMenuModel(
        iconData: ModelIconData.fromJson(
          json['iconData'] as Map<String, dynamic>,
        ),
        label: json['label'] as String,
        description: (json['description'] as String?) ?? '',
      );

  final ModelIconData iconData;
  final String label;
  final String description;

  @override
  ModelMainMenuModel copyWith({
    ModelIconData? iconData,
    String? label,
    String? description,
  }) => ModelMainMenuModel(
    iconData: iconData ?? this.iconData,
    label: label ?? this.label,
    description: description ?? this.description,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'iconData': iconData.toJson(),
    'label': label,
    'description': description,
  };

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ModelMainMenuModel &&
      other.iconData == iconData &&
      other.label == label &&
      other.description == description;

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(iconData, label, description);
}
