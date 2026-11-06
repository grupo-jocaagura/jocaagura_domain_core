/// SDK-only domain models shared by backend and Flutter adapters.
///
/// Legacy wire/ownership semantics are documented in the migration guide.
/// Rendering and framework conversions belong to consumers.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'jocaagura_domain_core.dart';

export 'jocaagura_domain_core.dart';

part 'src/models/address_model.dart';
part 'src/models/ai/model_ai_execution_config.dart';
part 'src/models/ai/model_ai_message.dart';
part 'src/models/ai/model_ai_request.dart';
part 'src/models/ai/model_ai_response.dart';
part 'src/models/apps/model_acl.dart';
part 'src/models/apps/model_acl_plan.dart';
part 'src/models/apps/model_acl_plan_assignment.dart';
part 'src/models/apps/model_acl_policy.dart';
part 'src/models/apps/model_app_version.dart';
part 'src/models/attribute_model.dart';
part 'src/models/calendar/appointment_model.dart';
part 'src/models/calendar/contact_model.dart';
part 'src/models/citizen/signature_model.dart';
part 'src/models/configs/ws_db_config.dart';
part 'src/models/connectivity_model.dart';
part 'src/models/crud/model_crud_log_entry.dart';
part 'src/models/crud/model_crud_metadata.dart';
part 'src/models/death_record_model.dart';
part 'src/models/dentist_app/acceptance_clause_model.dart';
part 'src/models/dentist_app/dental_condition_model.dart';
part 'src/models/dentist_app/diagnosis_model.dart';
part 'src/models/dentist_app/medical_record_model.dart';
part 'src/models/dentist_app/medical_treatment_model.dart';
part 'src/models/dentist_app/treatment_plan_model.dart';
part 'src/models/docs/model_doc_block.dart';
part 'src/models/docs/model_doc_document.dart';
part 'src/models/drive/model_drive_file.dart';
part 'src/models/drive/model_drive_folder.dart';
part 'src/models/drive/model_drive_item.dart';
part 'src/models/education/model_assessment.dart';
part 'src/models/education/model_competency_standard.dart';
part 'src/models/education/model_learning_goal.dart';
part 'src/models/education/model_learning_item.dart';
part 'src/models/education/model_performance_indicator.dart';
part 'src/models/either_flow/model_complete_flow.dart';
part 'src/models/either_flow/model_flow_certificate.dart';
part 'src/models/either_flow/model_flow_step.dart';
part 'src/models/either_flow/model_flow_step_completion.dart';
part 'src/models/financial/financial_movement.dart';
part 'src/models/financial/ledger_model.dart';
part 'src/models/graphics/model_graph.dart';
part 'src/models/graphics/model_graph_axis_spec.dart';
part 'src/models/graphics/model_point.dart';
part 'src/models/groups/model_group.dart';
part 'src/models/groups/model_group_alias.dart';
part 'src/models/groups/model_group_config.dart';
part 'src/models/groups/model_group_dynamic_membership_rule.dart';
part 'src/models/groups/model_group_labels.dart';
part 'src/models/groups/model_group_member.dart';
part 'src/models/groups/model_group_settings.dart';
part 'src/models/groups/model_group_sync_config.dart';
part 'src/models/groups/model_group_sync_job.dart';
part 'src/models/http/http_enums.dart';
part 'src/models/http/model_config_http_request.dart';
part 'src/models/http/request_context.dart';
part 'src/models/json_schema/model_json_schema_document.dart';
part 'src/models/json_schema/model_json_schema_reference.dart';
part 'src/models/legal_id_model.dart';
part 'src/models/medical/medical_diagnosis_tab_model.dart';
part 'src/models/medical/medication_model.dart';
part 'src/models/model_vector.dart';
part 'src/models/obituary_model.dart';
part 'src/models/person_model.dart';
part 'src/models/pet_app/animal_model.dart';
part 'src/models/request_parameters.dart';
part 'src/models/sheets/model_sheet_book.dart';
part 'src/models/sheets/model_sheet_column.dart';
part 'src/models/sheets/model_sheet_row.dart';
part 'src/models/sheets/model_sheet_table.dart';
part 'src/models/states/onboarding_state.dart';
part 'src/models/states/onboarding_step.dart';
part 'src/models/states/session_state.dart';
part 'src/models/states/ws_db_state.dart';
part 'src/models/store/model_category.dart';
part 'src/models/store/model_item.dart';
part 'src/models/store/model_price.dart';
part 'src/models/store_model.dart';
part 'src/models/ui/model_main_menu_model.dart';
part 'src/models/ui/screen_size_config.dart';
part 'src/models/user_model.dart';
part 'src/models/utils/money_utils.dart';
part 'src/models/vehicles/model_vehicle.dart';

/// Legacy unknown-error fallback used by OnboardingState.
const ErrorItem defaultErrorItem = ErrorItem(
  title: 'Unknown Error',
  code: 'ERR_UNKNOWN',
  description: 'An unspecified error has occurred.',
  meta: <String, dynamic>{'severity': 'low'},
);
