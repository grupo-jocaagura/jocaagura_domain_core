// Adapted from jocaagura_domain 1.43.0 (MIT), 56f7eba8a6041160ecf1c1501745c1249e124670.
// Source: lib/domain/ai/model_ai_message.dart; see docs/migration/MODEL_MIGRATION.md.
part of '../../../jocaagura_domain_models.dart';

/// Stable JSON keys used by [ModelAiMessage].
enum ModelAiMessageEnum { role, content }

/// Canonical conversational roles supported in the agnostic AI contract.
enum ModelAiMessageRoleEnum { user, assistant }

/// Minimal conversational message for AI interactions.
class ModelAiMessage extends Model {
  const ModelAiMessage({required this.role, required this.content});

  factory ModelAiMessage.fromJson(Map<String, dynamic> json) {
    return ModelAiMessage(
      role: Utils.enumFromJson<ModelAiMessageRoleEnum>(
        ModelAiMessageRoleEnum.values,
        Utils.getStringFromDynamic(json[ModelAiMessageEnum.role.name]),
        ModelAiMessageRoleEnum.user,
      ),
      content: Utils.getStringFromDynamic(
        json[ModelAiMessageEnum.content.name],
      ),
    );
  }

  final ModelAiMessageRoleEnum role;
  final String content;

  @override
  ModelAiMessage copyWith({ModelAiMessageRoleEnum? role, String? content}) {
    return ModelAiMessage(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    ModelAiMessageEnum.role.name: role.name,
    ModelAiMessageEnum.content.name: content,
  };

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelAiMessage &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          content == other.content;

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(role, content);

  @override
  String toString() => 'ModelAiMessage(${toJson()})';
}
