import 'dart:convert';
import 'dart:io';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

import 'support/api_contract_checks.dart';

void main() {
  final Map<String, dynamic> fixtures = jsonDecode(
    File('test/fixtures/additional-api-messages.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  Map<String, Object?> wire(String name) =>
      Map<String, Object?>.from(fixtures['Api$name'] as Map<String, dynamic>);
  const String start = '2026-11-06T13:00:00.000Z';
  const String end = '2026-11-06T14:00:00.000Z';
  const Map<String, Object?> attributes = <String, Object?>{
    'client.label': 'Example',
    'client.details': <String, Object?>{
      'nested': <Object?>[1, null, true],
    },
  };
  const Map<String, Object?> labels = <String, Object?>{
    'client.label': 'Example',
  };
  const Map<String, Object?> category = <String, Object?>{
    'category': 'example',
    'description': 'Example category',
  };
  const Map<String, Object?> price = <String, Object?>{
    'amount': 1250,
    'mathPrecision': 2,
    'currency': 'COP',
  };
  const Map<String, Object?> attributeList = <String, Object?>{
    'name': 'client.label',
    'value': 'Example',
  };
  const Map<String, Object?> item = <String, Object?>{
    'id': 'item-1',
    'name': 'Example item',
    'description': 'Example',
    'type': category,
    'price': price,
    'attributes': <Object?>[attributeList],
  };
  const Map<String, Object?> line = <String, Object?>{
    'itemId': 'item-1',
    'label': 'Example item',
    'quantity': 1,
    'unitAmount': 1250,
    'attributes': labels,
  };
  const Map<String, Object?> group = <String, Object?>{
    'groupKey': 'cohort-a',
    'name': 'Example group',
    'academicGroupKind': 'cohort',
    'description': 'Example',
    'status': 'draft',
    'attributes': attributes,
  };
  const Map<String, Object?> member = <String, Object?>{
    'memberType': 'customerSnapshot',
    'memberId': 'student-1',
    'academicRoleKey': 'student',
    'roleDisplayName': 'Student',
    'startsAtIso': start,
    'endsAtIso': end,
    'description': 'Example',
    'attributes': attributes,
  };
  const Map<String, Object?> academy = <String, Object?>{
    'refType': 'assessment',
    'refId': 'assessment-1',
    'order': 0,
    'code': 'A1',
    'label': 'Example assessment',
    'category': 'example',
    'cineLevel': 2,
  };
  const Map<String, Object?> unit = <String, Object?>{
    'unitKey': 'unit-1',
    'title': 'Example unit',
    'order': 0,
    'description': 'Example',
    'academyRefs': <Object?>[academy],
    'attributes': attributes,
  };
  const Map<String, Object?> employee = <String, Object?>{
    'displayName': 'Example teacher',
    'legalIdRef': <String, Object?>{
      'legalIdType': 'CC',
      'legalIdDocumentId': '000123',
      'countryCode': 'CO',
      'maskedValue': '***123',
    },
    'email': 'teacher@example.invalid',
    'phone': '000',
    'attributes': attributes,
  };
  const Map<String, Object?> position = <String, Object?>{
    'positionKey': 'teacher',
    'displayName': 'Teacher',
    'description': 'Example position',
    'attributes': attributes,
  };
  const Map<String, Object?> agreement = <String, Object?>{
    'agreementType': 'volunteer',
    'startsAtIso': start,
    'endsAtIso': end,
    'notes': 'Example agreement',
    'attributes': attributes,
  };
  const Map<String, Object?> compensation = <String, Object?>{
    'amount': 0,
    'frequency': 'monthly',
    'concept': 'Example',
    'category': 'example',
    'currency': 'COP',
    'notes': 'Example compensation',
    'attributes': attributes,
  };
  const Map<String, Object?> policy = <String, Object?>{
    'expectedHoursPerWeek': 20,
    'workMode': 'onsite',
    'notes': 'Example policy',
    'attributes': attributes,
  };
  const Map<String, Object?> gradeContext = <String, Object?>{
    'academicGroupId': 'group-1',
    'scheduleEventId': 'event-1',
    'programId': 'program-1',
    'programUnitKey': 'unit-1',
    'periodKey': '2026-11',
    'flowDefinitionId': 'flow-1',
    'evaluatedAtIso': start,
  };
  const Map<String, Object?> observationContext = <String, Object?>{
    'academicGroupId': 'group-1',
    'scheduleEventId': 'event-1',
    'programId': 'program-1',
    'programUnitKey': 'unit-1',
    'attendanceRecordId': 'attendance-1',
    'occurredAtIso': start,
  };
  final Map<String, Map<String, Object?>> messages =
      <String, Map<String, Object?>>{
        'ApiCustomerInput': <String, Object?>{
          'displayName': 'Example customer',
          'email': 'customer@example.invalid',
          'phoneNumber': '000',
          'documentLabel': 'Example',
          'notes': 'Example',
          'attributes': labels,
        },
        'ApiSalesOrderLineInput': line,
        'ApiSalesOrderLinePatchInput': line,
        'ApiSalesOrderInput': <String, Object?>{
          'customerSnapshotId': 'customer-1',
          'currencyCode': 'COP',
          'lines': <Object?>[line],
          'notes': 'Example order',
          'attributes': labels,
        },
        'ApiSalesOrderPatch': <String, Object?>{
          'customerSnapshotId': 'customer-1',
          'currencyCode': 'COP',
          'lines': <Object?>[line],
          'notes': 'Example edit',
          'attributes': labels,
        },
        'ApiItemInput': item,
        'ApiArticleUpsertRequest': <String, Object?>{
          'item': item,
          'quantity': 5,
          'minimumQuantity': 1,
          'maximumQuantity': 10,
          'tags': <Object?>['example'],
          'inventoryAttributes': labels,
        },
        'ApiItemPatch': <String, Object?>{
          'name': 'Example',
          'description': 'Example',
          'type': category,
          'price': price,
          'attributes': <Object?>[attributeList],
        },
        'ApiInventoryMetadataPatch': <String, Object?>{
          'minimumQuantity': 1,
          'maximumQuantity': 10,
          'tags': <Object?>['example'],
          'inventoryAttributes': labels,
        },
        'ApiAcademicGroupInput': group,
        'ApiAcademicGroupDetailsInput': <String, Object?>{
          'name': 'Example group',
          'description': 'Example',
          'attributes': attributes,
        },
        'ApiAcademicMemberInput': member,
        'ApiAcademicRoleInput': <String, Object?>{
          'academicRoleKey': 'student',
          'roleDisplayName': 'Student',
          'description': 'Example',
          'attributes': attributes,
        },
        'ApiSchoolActorInput': <String, Object?>{
          'displayName': 'Example student',
          'educationalRole': 'student',
          'email': 'student@example.invalid',
          'phoneNumber': '000',
          'documentLabel': 'Example',
          'notes': 'Example',
          'attributes': labels,
        },
        'ApiAcademyReferenceInput': academy,
        'ApiProgramUnitInput': unit,
        'ApiSchoolProgramInput': <String, Object?>{
          'programKey': 'example',
          'name': 'Example course',
          'programType': 'course',
          'description': 'Example',
          'cineLevel': 2,
          'units': <Object?>[unit],
          'academicGroupIds': <Object?>['group-1'],
          'status': null,
          'attributes': attributes,
        },
        'ApiProgramDetailsInput': <String, Object?>{
          'name': 'Example course',
          'description': 'Example',
          'attributes': attributes,
        },
        'ApiStaffEmployeeInput': employee,
        'ApiStaffPositionInput': position,
        'ApiStaffAgreementInput': agreement,
        'ApiStaffCompensationInput': compensation,
        'ApiStaffWorkPolicyInput': policy,
        'ApiStaffInput': <String, Object?>{
          'employee': employee,
          'position': position,
          'agreement': agreement,
          'compensation': compensation,
          'workPolicy': policy,
          'attributes': attributes,
        },
        'ApiGradeContextInput': gradeContext,
        'ApiObservationContextInput': observationContext,
        'ApiGradeInput': <String, Object?>{
          'gradeKind': 'milestone',
          'evaluationRef': <String, Object?>{
            'refType': 'manualMilestone',
            'label': 'Example milestone',
          },
          'result': <String, Object?>{'passed': false},
          'feedback': 'Example feedback',
          'context': gradeContext,
          'attributes': attributes,
        },
        'ApiObservationInput': <String, Object?>{
          'observationKind': 'academic',
          'severity': 'low',
          'visibility': 'internal',
          'title': 'Example title',
          'body': 'Example body',
          'context': observationContext,
          'attributes': attributes,
        },
        'ApiFleetLinkInput': <String, Object?>{
          'fleetUnitId': 'unit-1',
          'notes': 'Example fleet link',
          'attributes': labels,
        },
        'ApiOnboardingTemplateInput': <String, Object?>{
          ...wire('OnboardingTemplateInput'),
          'createdAt': start,
          'updatedAt': end,
          'attributes': labels,
        },
        'ApiConversationMessage': <String, Object?>{
          ...wire('ConversationMessage'),
          'meta': attributes,
        },
        'ApiDesignMetadata': <String, Object?>{
          ...wire('DesignMetadata'),
          'statusReason': 'Example reason',
          'statusUpdatedBy': 'user-1',
          'client.extension': attributes,
        },
        'ApiActivationAddressDraft': <String, Object?>{
          'id': 'address-1',
          'country': 'CO',
          'administrativeArea': 'Example',
          'city': 'Example',
          'locality': 'Example',
          'address': 'Example address',
          'notes': 'Example',
          'postalCode': 0,
        },
        'ApiActivationStoreDraft': <String, Object?>{
          'name': 'Example',
          'alias': 'example',
          'email': 'store@example.invalid',
          'photoUrl': 'about:blank',
          'coverPhotoUrl': 'about:blank',
          'phoneNumber1': 0,
          'phoneNumber2': 0,
          'address': <String, Object?>{
            'id': 'address-1',
            'country': 'CO',
            'administrativeArea': 'Example',
            'city': 'Example',
            'locality': 'Example',
            'address': 'Example address',
          },
        },
        'ApiScheduleQuery': <String, Object?>{
          'startsAtIso': start,
          'endsAtIso': end,
          'status': 'scheduled',
          'academicGroupId': 'group-1',
          'staffEmploymentId': 'staff-1',
          'programId': 'program-1',
          'limit': '10',
        },
        'ApiGradeQuery': <String, Object?>{
          'statusFilter': 'draft',
          'status': 'published',
          'gradeKindFilter': 'milestone',
          'gradeKind': 'numericScore',
          'periodKey': '2026-11',
          'limit': '10',
        },
        'ApiObservationQuery': <String, Object?>{
          'statusFilter': 'open',
          'status': 'resolved',
          'observationKindFilter': 'academic',
          'observationKind': 'general',
          'limit': '10',
        },
        'ApiAdminAssignmentLookupInput': <String, Object?>{
          'email': 'example@example.invalid',
          'targetUserId': 'user-1',
          'planId': 'plan-1',
          'backendFeatureContext': 'example',
          'status': 'active',
          'limit': 50,
        },
        'ApiStoreMovementInput': <String, Object?>{
          ...wire('StoreMovementInput'),
          'mathPrecision': 2,
          'description': 'Example movement',
          'externalReference': 'external-1',
        },
        'ApiPersonalMovementInput': <String, Object?>{
          ...wire('PersonalMovementInput'),
          'mathPrecision': 2,
          'description': 'Example movement',
          'externalReference': 'external-1',
        },
        'ApiPersonalLedgerCacheInput': <String, Object?>{
          'packageKey': 'package-1',
          'clientVersion': 1,
          'clientChecksum': '0' * 64,
        },
        'ApiStoreLedgerCacheInput': <String, Object?>{
          'storeId': 'store-1',
          'packageKey': 'package-1',
          'clientVersion': 1,
          'clientChecksum': '0' * 64,
        },
      };
  messages.forEach(checkApiMessage);

  test('populated nested metadata is owned and nullable input clearing stays distinct', () {
    final ApiStaffInput staff = ApiStaffInput.fromJson(
      messages['ApiStaffInput']!,
    );
    final Map<String, Object?> replacement = <String, Object?>{
      'client': <Object?>[1],
    };
    final ApiStaffInput changed = staff.copyWith(
      attributes: ApiField<Map<String, Object?>?>.present(replacement),
    );
    (replacement['client']! as List<Object?>).add(2);
    expect(changed.attributes.value, <String, Object?>{
      'client': <Object?>[1],
    });
    final ApiStaffInput cleared = staff.copyWith(
      attributes: const ApiField<Map<String, Object?>?>.present(null),
    );
    final ApiStaffInput absent = staff.copyWith(
      attributes: const ApiField<Map<String, Object?>?>.absent(),
    );
    expect(cleared.toJson().containsKey('attributes'), isTrue);
    expect(cleared.attributes.value, isNull);
    expect(absent.toJson().containsKey('attributes'), isFalse);
    expect(cleared, isNot(absent));
  });
  test(
    'clearing an inventory limit differs from preserving it or replacing tags',
    () {
      final ApiInventoryMetadataPatch patch =
          ApiInventoryMetadataPatch.fromJson(
            messages['ApiInventoryMetadataPatch']!,
          );
      final ApiInventoryMetadataPatch clear = patch.copyWith(
        maximumQuantity: const ApiField<int?>.present(null),
        tags: const ApiField<List<String>>.present(<String>[]),
      );
      expect(clear.maximumQuantity.value, isNull);
      expect(clear.minimumQuantity.value, 1);
      expect(clear.tags.value, isEmpty);
      expect(clear.toJson()['maximumQuantity'], isNull);
      expect(() => ApiInventoryMetadataPatch(), throwsFormatException);
      expect(() => ApiItemPatch(), throwsFormatException);
      expect(() => ApiStoreProfilePatch(), throwsFormatException);
    },
  );
}
