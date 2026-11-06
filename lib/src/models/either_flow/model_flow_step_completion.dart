// Adapted from jocaagura_domain 1.43.0 (MIT), 56f7eba8a6041160ecf1c1501745c1249e124670.
// Source: lib/domain/either_flow/model_flow_step_completion.dart; see docs/migration/MODEL_MIGRATION.md.
part of '../../../jocaagura_domain_models.dart';

/// Stable JSON keys used by [ModelFlowStepCompletion].
enum ModelFlowStepCompletionEnum { stepIndex, completedAt, evidenceUrl, notes }

/// Minimal auditable evidence that a linear flow step was completed.
class ModelFlowStepCompletion extends Model {
  const ModelFlowStepCompletion({
    required this.stepIndex,
    required this.completedAt,
    this.evidenceUrl,
    this.notes,
  });

  factory ModelFlowStepCompletion.fromJson(Map<String, dynamic> json) {
    return ModelFlowStepCompletion(
      stepIndex: Utils.getIntegerFromDynamic(
        json[ModelFlowStepCompletionEnum.stepIndex.name],
      ),
      completedAt: DateUtils.dateTimeFromDynamic(
        json[ModelFlowStepCompletionEnum.completedAt.name],
      ),
      evidenceUrl:
          json.containsKey(ModelFlowStepCompletionEnum.evidenceUrl.name)
          ? _flowCertificateNullableUrlFromDynamic(
              json[ModelFlowStepCompletionEnum.evidenceUrl.name],
            )
          : null,
      notes: json.containsKey(ModelFlowStepCompletionEnum.notes.name)
          ? _flowCertificateNullableStringFromDynamic(
              json[ModelFlowStepCompletionEnum.notes.name],
            )
          : null,
    );
  }

  final int stepIndex;
  final DateTime completedAt;
  final String? evidenceUrl;
  final String? notes;

  @override
  ModelFlowStepCompletion copyWith({
    int? stepIndex,
    DateTime? completedAt,
    Object? evidenceUrl = _flowCertificateUnset,
    Object? notes = _flowCertificateUnset,
  }) {
    return ModelFlowStepCompletion(
      stepIndex: stepIndex ?? this.stepIndex,
      completedAt: completedAt ?? this.completedAt,
      evidenceUrl: identical(evidenceUrl, _flowCertificateUnset)
          ? this.evidenceUrl
          : evidenceUrl as String?,
      notes: identical(notes, _flowCertificateUnset)
          ? this.notes
          : notes as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      ModelFlowStepCompletionEnum.stepIndex.name: stepIndex,
      ModelFlowStepCompletionEnum.completedAt.name: DateUtils.dateTimeToString(
        completedAt,
      ),
    };
    if (evidenceUrl != null) {
      json[ModelFlowStepCompletionEnum.evidenceUrl.name] = evidenceUrl;
    }
    if (notes != null) {
      json[ModelFlowStepCompletionEnum.notes.name] = notes;
    }
    return json;
  }

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelFlowStepCompletion &&
          runtimeType == other.runtimeType &&
          stepIndex == other.stepIndex &&
          completedAt == other.completedAt &&
          evidenceUrl == other.evidenceUrl &&
          notes == other.notes;

  @override
  // SDK-only value contract; no external annotation dependency.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(stepIndex, completedAt, evidenceUrl, notes);

  @override
  String toString() => 'ModelFlowStepCompletion(${toJson()})';
}
