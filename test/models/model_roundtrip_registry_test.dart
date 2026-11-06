// Cross-family serialization/equality contracts, independent of source implementation details.
import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_models.dart';
import 'package:test/test.dart';

void main() {
  test('AddressModel preserves canonical wire, copying and equality/hash consistency', () {
    const AddressModel value = defaultAddressModel;
    final AddressModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final AddressModel decoded = AddressModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAiExecutionConfig preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAiExecutionConfig value = ModelAiExecutionConfig.fromJson(
      <String, dynamic>{},
    );
    final ModelAiExecutionConfig copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAiExecutionConfig decoded = ModelAiExecutionConfig.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAiMessage preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAiMessage value = ModelAiMessage.fromJson(<String, dynamic>{});
    final ModelAiMessage copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAiMessage decoded = ModelAiMessage.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAiRequest preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAiRequest value = ModelAiRequest.fromJson(<String, dynamic>{});
    final ModelAiRequest copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAiRequest decoded = ModelAiRequest.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAiResponse preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAiResponse value = ModelAiResponse.fromJson(<String, dynamic>{});
    final ModelAiResponse copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAiResponse decoded = ModelAiResponse.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test(
    'ModelAcl preserves canonical wire, copying and equality/hash consistency',
    () {
      final ModelAcl value = ModelAcl.fromJson(<String, dynamic>{});
      final ModelAcl copy = value.copyWith();
      expect(copy, value);
      expect(copy.hashCode, value.hashCode);
      final Map<String, dynamic> encoded =
          jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
      final ModelAcl decoded = ModelAcl.fromJson(encoded);
      expect(decoded.toJson(), encoded);
      expect(decoded, value);
      expect(decoded.hashCode, value.hashCode);
      expect(value == Object(), isFalse);
    },
  );
  test('ModelAclPlan preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAclPlan value = ModelAclPlan.fromJson(<String, dynamic>{});
    final ModelAclPlan copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAclPlan decoded = ModelAclPlan.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAclPlanAssignment preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAclPlanAssignment value = ModelAclPlanAssignment.fromJson(
      <String, dynamic>{},
    );
    final ModelAclPlanAssignment copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAclPlanAssignment decoded = ModelAclPlanAssignment.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAclPolicy preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAclPolicy value = ModelAclPolicy.fromJson(<String, dynamic>{});
    final ModelAclPolicy copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAclPolicy decoded = ModelAclPolicy.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAppVersion preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAppVersion value = ModelAppVersion.fromJson(<String, dynamic>{});
    final ModelAppVersion copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAppVersion decoded = ModelAppVersion.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('AppointmentModel preserves canonical wire, copying and equality/hash consistency', () {
    final AppointmentModel value = defaultAppointmentModel;
    final AppointmentModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final AppointmentModel decoded = AppointmentModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ContactModel preserves canonical wire, copying and equality/hash consistency', () {
    const ContactModel value = defaultContactModel;
    final ContactModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ContactModel decoded = ContactModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('SignatureModel preserves canonical wire, copying and equality/hash consistency', () {
    final SignatureModel value = defaultSignatureModel;
    final SignatureModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final SignatureModel decoded = SignatureModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('WsDbConfig preserves canonical wire, copying and equality/hash consistency', () {
    const WsDbConfig value = defaultWsDbConfig;
    final WsDbConfig copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final WsDbConfig decoded = WsDbConfig.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ConnectivityModel preserves canonical wire, copying and equality/hash consistency', () {
    const ConnectivityModel value = defaultConnectivityModel;
    final ConnectivityModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ConnectivityModel decoded = ConnectivityModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelCrudLogEntry preserves canonical wire, copying and equality/hash consistency', () {
    final ModelCrudLogEntry value = ModelCrudLogEntry.fromJson(
      <String, dynamic>{},
    );
    final ModelCrudLogEntry copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelCrudLogEntry decoded = ModelCrudLogEntry.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelCrudMetadata preserves canonical wire, copying and equality/hash consistency', () {
    final ModelCrudMetadata value = ModelCrudMetadata.fromJson(
      <String, dynamic>{},
    );
    final ModelCrudMetadata copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelCrudMetadata decoded = ModelCrudMetadata.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('AcceptanceClauseModel preserves canonical wire, copying and equality/hash consistency', () {
    final AcceptanceClauseModel value = defaultAcceptanceClauseModel;
    final AcceptanceClauseModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final AcceptanceClauseModel decoded = AcceptanceClauseModel.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('DentalConditionModel preserves canonical wire, copying and equality/hash consistency', () {
    final DentalConditionModel value = dentalConditionModelDefault;
    final DentalConditionModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final DentalConditionModel decoded = DentalConditionModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('DiagnosisModel preserves canonical wire, copying and equality/hash consistency', () {
    const DiagnosisModel value = defaultDiagnosisModel;
    final DiagnosisModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final DiagnosisModel decoded = DiagnosisModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('MedicalRecordModel preserves attributes across serialization with homologated equality', () {
    final MedicalRecordModel value = defaultMedicalRecordModel;
    final MedicalRecordModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final MedicalRecordModel decoded = MedicalRecordModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('MedicalTreatmentModel preserves canonical wire, copying and equality/hash consistency', () {
    final MedicalTreatmentModel value = defaultMedicalTreatmentModel;
    final MedicalTreatmentModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final MedicalTreatmentModel decoded = MedicalTreatmentModel.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('TreatmentPlanModel retains its documented legacy serialization and equality limits', () {
    final TreatmentPlanModel value = TreatmentPlanModel.fromJson(
      <String, dynamic>{},
    );
    final TreatmentPlanModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final TreatmentPlanModel decoded = TreatmentPlanModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    // Homologated Utils equality/hash compare collection content.
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelDocBlock preserves canonical wire, copying and equality/hash consistency', () {
    final ModelDocBlock value = ModelDocBlock.fromJson(<String, dynamic>{});
    final ModelDocBlock copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelDocBlock decoded = ModelDocBlock.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelDocDocument preserves canonical wire, copying and equality/hash consistency', () {
    final ModelDocDocument value = ModelDocDocument.fromJson(
      <String, dynamic>{},
    );
    final ModelDocDocument copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelDocDocument decoded = ModelDocDocument.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelDriveFile preserves canonical wire, copying and equality/hash consistency', () {
    final ModelDriveFile value = ModelDriveFile.fromJson(<String, dynamic>{});
    final ModelDriveFile copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelDriveFile decoded = ModelDriveFile.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelDriveFolder preserves canonical wire, copying and equality/hash consistency', () {
    final ModelDriveFolder value = ModelDriveFolder.fromJson(
      <String, dynamic>{},
    );
    final ModelDriveFolder copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelDriveFolder decoded = ModelDriveFolder.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelDriveItem preserves canonical wire, copying and equality/hash consistency', () {
    final ModelDriveItem value = ModelDriveItem.fromJson(<String, dynamic>{});
    final ModelDriveItem copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelDriveItem decoded = ModelDriveItem.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelAssessment preserves canonical wire, copying and equality/hash consistency', () {
    final ModelAssessment value = defaultModelAssessment;
    final ModelAssessment copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelAssessment decoded = ModelAssessment.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelCompetencyStandard preserves canonical wire, copying and equality/hash consistency', () {
    const ModelCompetencyStandard value = defaultCompetencyStandard;
    final ModelCompetencyStandard copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelCompetencyStandard decoded = ModelCompetencyStandard.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelLearningGoal preserves canonical wire, copying and equality/hash consistency', () {
    const ModelLearningGoal value = defaultLearningGoal;
    final ModelLearningGoal copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelLearningGoal decoded = ModelLearningGoal.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelLearningItem preserves canonical wire, copying and equality/hash consistency', () {
    final ModelLearningItem value = defaultModelLearningItem;
    final ModelLearningItem copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelLearningItem decoded = ModelLearningItem.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelPerformanceIndicator preserves canonical wire, copying and equality/hash consistency', () {
    final ModelPerformanceIndicator value = ModelPerformanceIndicator.fromJson(
      <String, dynamic>{},
    );
    final ModelPerformanceIndicator copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelPerformanceIndicator decoded =
        ModelPerformanceIndicator.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelCompleteFlow preserves canonical wire, copying and equality/hash consistency', () {
    const ModelCompleteFlow value = defaultModelCompleteFlow;
    final ModelCompleteFlow copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelCompleteFlow decoded = ModelCompleteFlow.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelFlowCertificate preserves canonical wire, copying and equality/hash consistency', () {
    final ModelFlowCertificate value = ModelFlowCertificate.fromJson(
      <String, dynamic>{},
    );
    final ModelFlowCertificate copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelFlowCertificate decoded = ModelFlowCertificate.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelFlowStep preserves canonical wire, copying and equality/hash consistency', () {
    const ModelFlowStep value = defaultModelFlowStepModel;
    final ModelFlowStep copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelFlowStep decoded = ModelFlowStep.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelFlowStepCompletion preserves canonical wire, copying and equality/hash consistency', () {
    final ModelFlowStepCompletion value = ModelFlowStepCompletion.fromJson(
      <String, dynamic>{},
    );
    final ModelFlowStepCompletion copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelFlowStepCompletion decoded = ModelFlowStepCompletion.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('FinancialMovementModel preserves canonical wire, copying and equality/hash consistency', () {
    final FinancialMovementModel value = defaultMovement;
    final FinancialMovementModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final FinancialMovementModel decoded = FinancialMovementModel.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('LedgerModel preserves canonical wire, copying and equality/hash consistency', () {
    final LedgerModel value = LedgerModel.fromJson(<String, dynamic>{});
    final LedgerModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final LedgerModel decoded = LedgerModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGraph preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGraph value = defaultModelGraph();
    final ModelGraph copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGraph decoded = ModelGraph.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGraphAxisSpec preserves canonical wire, copying and equality/hash consistency', () {
    const ModelGraphAxisSpec value = defaultXAxisSpec;
    final ModelGraphAxisSpec copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGraphAxisSpec decoded = ModelGraphAxisSpec.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelPoint preserves canonical wire, copying and equality/hash consistency', () {
    const ModelPoint value = defaultModelPoint;
    final ModelPoint copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelPoint decoded = ModelPoint.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroup preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGroup value = ModelGroup.fromJson(<String, dynamic>{});
    final ModelGroup copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroup decoded = ModelGroup.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupAlias preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGroupAlias value = ModelGroupAlias.fromJson(<String, dynamic>{});
    final ModelGroupAlias copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupAlias decoded = ModelGroupAlias.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupConfig preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGroupConfig value = ModelGroupConfig.fromJson(
      <String, dynamic>{},
    );
    final ModelGroupConfig copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupConfig decoded = ModelGroupConfig.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupDynamicMembershipRule preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGroupDynamicMembershipRule value =
        ModelGroupDynamicMembershipRule.fromJson(<String, dynamic>{});
    final ModelGroupDynamicMembershipRule copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupDynamicMembershipRule decoded =
        ModelGroupDynamicMembershipRule.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupLabels retains its documented legacy serialization and equality limits', () {
    final ModelGroupLabels value = ModelGroupLabels.fromJson(
      <String, dynamic>{},
    );
    final ModelGroupLabels copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupLabels decoded = ModelGroupLabels.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    // Homologated Utils equality/hash compare collection content.
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupMember preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGroupMember value = ModelGroupMember.fromJson(
      <String, dynamic>{},
    );
    final ModelGroupMember copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupMember decoded = ModelGroupMember.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupSettings retains its documented legacy serialization and equality limits', () {
    final ModelGroupSettings value = ModelGroupSettings.fromJson(
      <String, dynamic>{},
    );
    final ModelGroupSettings copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupSettings decoded = ModelGroupSettings.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    // Homologated Utils equality/hash compare collection content.
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupSyncConfig preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGroupSyncConfig value = ModelGroupSyncConfig.fromJson(
      <String, dynamic>{},
    );
    final ModelGroupSyncConfig copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupSyncConfig decoded = ModelGroupSyncConfig.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelGroupSyncJob preserves canonical wire, copying and equality/hash consistency', () {
    final ModelGroupSyncJob value = ModelGroupSyncJob.fromJson(
      <String, dynamic>{},
    );
    final ModelGroupSyncJob copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelGroupSyncJob decoded = ModelGroupSyncJob.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelConfigHttpRequest preserves canonical wire, copying and equality/hash consistency', () {
    final ModelConfigHttpRequest value = ModelConfigHttpRequest.fromJson(
      <String, dynamic>{},
    );
    final ModelConfigHttpRequest copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelConfigHttpRequest decoded = ModelConfigHttpRequest.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelJsonSchemaDocument preserves canonical wire, copying and equality/hash consistency', () {
    final ModelJsonSchemaDocument value = ModelJsonSchemaDocument.fromJson(
      <String, dynamic>{},
    );
    final ModelJsonSchemaDocument copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelJsonSchemaDocument decoded = ModelJsonSchemaDocument.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelJsonSchemaReference preserves canonical wire, copying and equality/hash consistency', () {
    final ModelJsonSchemaReference value = ModelJsonSchemaReference.fromJson(
      <String, dynamic>{},
    );
    final ModelJsonSchemaReference copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelJsonSchemaReference decoded = ModelJsonSchemaReference.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('LegalIdModel preserves attributes across serialization with homologated equality', () {
    const LegalIdModel value = defaultLegalIdModel;
    final LegalIdModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final LegalIdModel decoded = LegalIdModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('MedicalDiagnosisTabModel preserves canonical wire, copying and equality/hash consistency', () {
    final MedicalDiagnosisTabModel value = MedicalDiagnosisTabModel(
      id: 'diagnosis-1',
      condition: 'Synthetic',
      observation: '',
      quantity: 0.5,
      dateTimeOfRecord: DateTime.utc(2024),
    );
    final MedicalDiagnosisTabModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final MedicalDiagnosisTabModel decoded = MedicalDiagnosisTabModel.fromJson(
      encoded,
    );
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('MedicationModel preserves canonical wire, copying and equality/hash consistency', () {
    final MedicationModel value = defaultMedicationModel;
    final MedicationModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final MedicationModel decoded = MedicationModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelVector preserves canonical wire, copying and equality/hash consistency', () {
    const ModelVector value = defaultModelVector;
    final ModelVector copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelVector decoded = ModelVector.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ObituaryModel preserves canonical wire, copying and equality/hash consistency', () {
    final ObituaryModel value = defaultObituary;
    final ObituaryModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ObituaryModel decoded = ObituaryModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('PersonModel preserves canonical wire, copying and equality/hash consistency', () {
    const PersonModel value = defaultPersonModel;
    final PersonModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final PersonModel decoded = PersonModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelSheetBook preserves canonical wire, copying and equality/hash consistency', () {
    final ModelSheetBook value = ModelSheetBook.fromJson(<String, dynamic>{});
    final ModelSheetBook copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelSheetBook decoded = ModelSheetBook.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelSheetColumn preserves canonical wire, copying and equality/hash consistency', () {
    final ModelSheetColumn value = ModelSheetColumn.fromJson(
      <String, dynamic>{},
    );
    final ModelSheetColumn copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelSheetColumn decoded = ModelSheetColumn.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelSheetRow preserves canonical wire, copying and equality/hash consistency', () {
    final ModelSheetRow value = ModelSheetRow.fromJson(<String, dynamic>{});
    final ModelSheetRow copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelSheetRow decoded = ModelSheetRow.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelSheetTable preserves canonical wire, copying and equality/hash consistency', () {
    final ModelSheetTable value = ModelSheetTable.fromJson(<String, dynamic>{});
    final ModelSheetTable copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelSheetTable decoded = ModelSheetTable.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('OnboardingState preserves canonical wire, copying and equality/hash consistency', () {
    final OnboardingState value = OnboardingState.fromJson(<String, dynamic>{});
    final OnboardingState copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final OnboardingState decoded = OnboardingState.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelCategory preserves canonical wire, copying and equality/hash consistency', () {
    const ModelCategory value = defaultModelCategory;
    final ModelCategory copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelCategory decoded = ModelCategory.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test(
    'ModelItem retains its documented legacy serialization and equality limits',
    () {
      final ModelItem value = defaultModelItem;
      final ModelItem copy = value.copyWith();
      expect(copy, value);
      expect(copy.hashCode, value.hashCode);
      final Map<String, dynamic> encoded =
          jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
      final ModelItem decoded = ModelItem.fromJson(encoded);
      expect(decoded.toJson(), encoded);
      // Recorded source behavior: wire normalization or map identity prevents value equality.
      expect(decoded.id, encoded['id']);
      expect(decoded, isNot(value));
      expect(value == Object(), isFalse);
    },
  );
  test('ModelPrice preserves canonical wire, copying and equality/hash consistency', () {
    const ModelPrice value = defaultModelPrice;
    final ModelPrice copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelPrice decoded = ModelPrice.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('StoreModel preserves canonical wire, copying and equality/hash consistency', () {
    const StoreModel value = defaultStoreModel;
    final StoreModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final StoreModel decoded = StoreModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test('ModelMainMenuModel preserves canonical wire, copying and equality/hash consistency', () {
    const ModelMainMenuModel value = ModelMainMenuModel(
      iconData: ModelIconData(codePoint: 1),
      label: 'Menu',
    );
    final ModelMainMenuModel copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelMainMenuModel decoded = ModelMainMenuModel.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
  test(
    'UserModel retains its documented legacy serialization and equality limits',
    () {
      const UserModel value = defaultUserModel;
      final UserModel copy = value.copyWith();
      expect(copy, value);
      expect(copy.hashCode, value.hashCode);
      final Map<String, dynamic> encoded =
          jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
      final UserModel decoded = UserModel.fromJson(encoded);
      expect(decoded.toJson(), encoded);
      // Homologated Utils equality/hash compare collection content.
      expect(decoded, value);
      expect(decoded.hashCode, value.hashCode);
      expect(value == Object(), isFalse);
    },
  );
  test('ModelVehicle preserves canonical wire, copying and equality/hash consistency', () {
    const ModelVehicle value = defaultModelVehicle;
    final ModelVehicle copy = value.copyWith();
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    final Map<String, dynamic> encoded =
        jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>;
    final ModelVehicle decoded = ModelVehicle.fromJson(encoded);
    expect(decoded.toJson(), encoded);
    expect(decoded, value);
    expect(decoded.hashCode, value.hashCode);
    expect(value == Object(), isFalse);
  });
}
