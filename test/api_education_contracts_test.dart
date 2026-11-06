import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

import 'support/api_contract_checks.dart';

// Independently composed school messages: no identities, secrets or source
// sample payloads. Input and hydrated output are intentionally different.
void main() {
  const String start = '2026-11-06T13:00:00.000Z';
  const String end = '2026-11-06T14:00:00.000Z';
  const Map<String, Object?> address = <String, Object?>{
    'id': 'address-school',
    'postalCode': 0,
    'country': 'CO',
    'administrativeArea': 'Example',
    'city': 'Example',
    'locality': 'Example',
    'address': 'Example address',
    'notes': '',
  };
  const Map<String, Object?> school = <String, Object?>{
    'id': 'school-1',
    'name': 'Example school',
    'alias': 'example',
    'email': 'school@example.invalid',
    'photoUrl': '',
    'coverPhotoUrl': '',
    'photoImageId': '',
    'coverImageId': '',
    'storeType': 'school',
    'phoneNumber1': 0,
    'phoneNumber2': 0,
    'address': address,
    'capabilities': <Object?>['education'],
    'nit': 0,
  };
  const Map<String, Object?> schoolRef = <String, Object?>{
    'id': 'school-1',
    'storeType': 'school',
  };
  const Map<String, Object?> summary = <String, Object?>{'totalItems': 1};
  const Map<String, Object?> relationship = <String, Object?>{
    'membershipId': 'membership-1',
    'personId': 'person-1',
    'schoolStoreId': 'school-1',
    'roles': <Object?>['owner'],
    'status': 'active',
  };
  final Map<String, Object?> observedRelationship = <String, Object?>{
    ...relationship,
    'relationshipHealth': 'healthy',
  };
  const Map<String, Object?> action = <String, Object?>{
    'key': 'education.groups',
    'capability': 'education',
    'enabled': true,
    'status': 'ready',
    'reason': 'ready',
  };
  const Map<String, Object?> dashboard = <String, Object?>{
    'state': 'ready',
    'availableActions': <Object?>[action],
  };
  const Map<String, Object?> group = <String, Object?>{
    'groupId': 'group-1',
    'groupKey': 'cohort-a',
    'name': 'Example cohort',
    'description': '',
    'academicGroupKind': 'cohort',
    'status': 'active',
    'createdAtIso': start,
    'updatedAtIso': start,
  };
  const Map<String, Object?> groupRef = <String, Object?>{
    'groupId': 'group-1',
    'groupKey': 'cohort-a',
    'name': 'Example cohort',
  };
  const Map<String, Object?> member = <String, Object?>{
    'membershipId': 'member-1',
    'memberId': 'student-1',
    'displayName': 'Example student',
    'email': '',
    'phone': '',
    'documentHint': '',
    'roleDisplayName': 'Student',
    'memberType': 'customerSnapshot',
    'academicRoleKey': 'student',
    'status': 'active',
    'startsAtIso': start,
    'endsAtIso': '',
    'updatedAtIso': start,
  };
  const Map<String, Object?> memberInput = <String, Object?>{
    'memberType': 'customerSnapshot',
    'memberId': 'student-1',
    'academicRoleKey': 'student',
    'roleDisplayName': 'Student',
    'startsAtIso': start,
  };
  const Map<String, Object?> actor = <String, Object?>{
    'actorId': 'student-1',
    'actorType': 'customerSnapshot',
    'displayName': 'Example student',
    'email': '',
    'phoneNumber': '',
    'status': 'active',
    'linkStatus': 'noUserYet',
    'educationalRole': 'student',
  };
  const Map<String, Object?> customer = <String, Object?>{
    'id': 'student-1',
    'storeId': 'school-1',
    'displayName': 'Example student',
    'email': '',
    'phoneNumber': '',
    'status': 'active',
  };
  const Map<String, Object?> baseMembership = <String, Object?>{
    'membershipId': 'membership-1',
    'groupId': 'base-students',
    'memberId': 'student-1',
    'memberType': 'customerSnapshot',
    'roleKey': 'student',
    'status': 'active',
    'linkStatus': 'noUserYet',
  };
  const Map<String, Object?> academyRef = <String, Object?>{
    'refType': 'assessment',
    'refId': 'assessment-1',
    'code': 'A1',
    'label': 'Example assessment',
    'category': 'example',
    'cineLevel': 2,
    'order': 0,
  };
  const Map<String, Object?> academyInput = <String, Object?>{
    'refType': 'assessment',
    'refId': 'assessment-1',
    'order': 0,
  };
  const Map<String, Object?> unit = <String, Object?>{
    'unitKey': 'unit-1',
    'title': 'Example unit',
    'description': '',
    'order': 0,
    'academyRefs': <Object?>[academyRef],
  };
  const Map<String, Object?> unitInput = <String, Object?>{
    'unitKey': 'unit-1',
    'title': 'Example unit',
    'order': 0,
    'academyRefs': <Object?>[academyInput],
  };
  const Map<String, Object?> programBase = <String, Object?>{
    'id': 'program-1',
    'schoolStoreId': 'school-1',
    'programKey': 'example',
    'name': 'Example course',
    'description': '',
    'programType': 'course',
    'status': 'draft',
    'cineLevel': 2,
    'createdAtIso': start,
    'updatedAtIso': start,
    'activatedAtIso': '',
    'archivedAtIso': '',
  };
  const Map<String, Object?> program = <String, Object?>{
    ...programBase,
    'units': <Object?>[unit],
    'academicGroupIds': <Object?>['group-1'],
  };
  const Map<String, Object?> programSummary = <String, Object?>{
    ...programBase,
    'unitCount': 1,
    'academicGroupCount': 1,
  };
  const Map<String, Object?> legalInput = <String, Object?>{
    'legalIdType': 'CC',
    'legalIdDocumentId': '000123',
    'countryCode': 'CO',
    'maskedValue': '***123',
  };
  const Map<String, Object?> employeeInput = <String, Object?>{
    'displayName': 'Example teacher',
    'legalIdRef': legalInput,
  };
  const Map<String, Object?> positionInput = <String, Object?>{
    'positionKey': 'teacher',
    'displayName': 'Teacher',
  };
  const Map<String, Object?> agreementInput = <String, Object?>{
    'agreementType': 'volunteer',
    'startsAtIso': start,
  };
  const Map<String, Object?> compensationInput = <String, Object?>{
    'amount': 0,
    'frequency': 'monthly',
    'concept': 'Example',
    'category': 'example',
  };
  const Map<String, Object?> staffSummary = <String, Object?>{
    'employmentId': 'staff-1',
    'displayName': 'Example teacher',
    'email': '',
    'phone': '',
    'positionDisplayName': 'Teacher',
    'status': 'draft',
    'positionKey': 'teacher',
    'personLinkStatus': 'unlinked',
    'startsAtIso': start,
    'updatedAtIso': start,
  };
  const Map<String, Object?> position = <String, Object?>{
    ...positionInput,
    'description': '',
  };
  const Map<String, Object?> agreement = <String, Object?>{
    ...agreementInput,
    'endsAtIso': '',
  };
  const Map<String, Object?> legalSnapshot = <String, Object?>{
    'legalIdType': 'CC',
    'countryCode': 'CO',
    'maskedValue': '***123',
  };
  const Map<String, Object?> personLink = <String, Object?>{
    'status': 'unlinked',
  };
  const Map<String, Object?> staff = <String, Object?>{
    ...staffSummary,
    'position': position,
    'agreement': agreement,
    'legalId': legalSnapshot,
    'personLink': personLink,
    'createdAtIso': start,
  };
  const Map<String, Object?> scheduleGroup = <String, Object?>{
    ...groupRef,
    'status': 'active',
  };
  const Map<String, Object?> scheduleStaff = <String, Object?>{
    'employmentId': 'staff-1',
    'displayName': 'Example teacher',
    'positionKey': 'teacher',
    'positionDisplayName': 'Teacher',
    'status': 'active',
  };
  const Map<String, Object?> scheduleProgram = <String, Object?>{
    'programId': 'program-1',
    'programKey': 'example',
    'programType': 'course',
    'name': 'Example course',
    'status': 'active',
    'unitKey': 'unit-1',
  };
  const Map<String, Object?> schedule = <String, Object?>{
    'appointmentId': 'event-1',
    'title': 'Example class',
    'description': '',
    'timeZone': 'America/Bogota',
    'eventKind': 'class',
    'status': 'scheduled',
    'startsAtIso': start,
    'endsAtIso': end,
    'academicGroups': <Object?>[scheduleGroup],
    'staff': <Object?>[scheduleStaff],
    'programs': <Object?>[scheduleProgram],
    'academyRefs': <Object?>[academyRef],
  };
  const Map<String, Object?> scheduleInput = <String, Object?>{
    'eventKind': 'class',
    'title': 'Example class',
    'startsAtIso': start,
    'endsAtIso': end,
    'timeZone': 'America/Bogota',
    'academicGroupIds': <Object?>['group-1'],
    'staffEmploymentIds': <Object?>['staff-1'],
    'programId': 'program-1',
    'unitKey': 'unit-1',
    'academyRefs': <Object?>[academyInput],
  };
  final Map<String, Object?> scheduleUpdate = <String, Object?>{
    ...scheduleInput,
  }..remove('eventKind');
  const Map<String, Object?> author = <String, Object?>{
    'authorType': 'person',
    'authorId': 'person-1',
    'displayName': 'Example teacher',
  };
  const Map<String, Object?> evaluation = <String, Object?>{
    'refType': 'manualMilestone',
    'refId': '',
    'label': 'Example milestone',
    'code': '',
  };
  const Map<String, Object?> evaluationInput = <String, Object?>{
    'refType': 'manualMilestone',
    'label': 'Example milestone',
  };
  const Map<String, Object?> result = <String, Object?>{
    'score': 0,
    'maxScore': 0,
    'qualitativeLevel': 'pending',
    'passed': false,
  };
  const Map<String, Object?> resultInput = <String, Object?>{'passed': false};
  const Map<String, Object?> gradeContext = <String, Object?>{
    'academicGroupId': 'group-1',
    'scheduleEventId': '',
    'programId': '',
    'programUnitKey': '',
    'periodKey': '',
    'flowDefinitionId': '',
    'evaluatedAtIso': '',
  };
  const Map<String, Object?> grade = <String, Object?>{
    'id': 'grade-1',
    'schoolStoreId': 'school-1',
    'studentSnapshotId': 'student-1',
    'gradeKind': 'milestone',
    'status': 'draft',
    'evaluationRef': evaluation,
    'result': result,
    'context': gradeContext,
    'author': author,
    'feedback': '',
    'createdAtIso': start,
    'updatedAtIso': start,
    'publishedAtIso': '',
    'archivedAtIso': '',
  };
  const Map<String, Object?> gradeInput = <String, Object?>{
    'gradeKind': 'milestone',
    'evaluationRef': evaluationInput,
    'result': resultInput,
  };
  const Map<String, Object?> observationContext = <String, Object?>{
    'academicGroupId': '',
    'scheduleEventId': '',
    'programId': '',
    'programUnitKey': '',
    'attendanceRecordId': '',
    'occurredAtIso': '',
  };
  const Map<String, Object?> observation = <String, Object?>{
    'id': 'observation-1',
    'schoolStoreId': 'school-1',
    'studentSnapshotId': 'student-1',
    'observationKind': 'general',
    'severity': 'info',
    'status': 'open',
    'visibility': 'internal',
    'title': 'Example title',
    'body': 'Example observation',
    'resolutionSummary': '',
    'context': observationContext,
    'author': author,
    'createdAtIso': start,
    'updatedAtIso': start,
  };
  const Map<String, Object?> observationInput = <String, Object?>{
    'observationKind': 'general',
    'severity': 'info',
    'visibility': 'internal',
    'title': 'Example title',
    'body': 'Example observation',
  };
  const Map<String, Object?> paymentContext = <String, Object?>{
    'schoolStoreId': 'school-1',
    'studentSnapshotId': 'student-1',
    'academicGroupId': 'group-1',
    'serviceKey': 'monthlyFee',
    'academicPeriodKey': '2026-11',
  };
  const Map<String, Object?> idempotencyContext = <String, Object?>{
    'operationType': 'payment',
    'contextType': 'school',
    'contextId': 'reference-1',
  };

  final Map<String, Map<String, Object?>> messages =
      <String, Map<String, Object?>>{
        'ApiSchool': school,
        'ApiSchoolRef': schoolRef,
        'ApiCreatedSchoolRelationship': relationship,
        'ApiSchoolRelationship': observedRelationship,
        'ApiCreatedSchoolData': <String, Object?>{
          'school': school,
          'relationship': relationship,
        },
        'ApiSchoolListEntry': <String, Object?>{
          'school': school,
          'relationship': observedRelationship,
        },
        'ApiSchoolsData': <String, Object?>{
          'schools': <Object?>[
            <String, Object?>{
              'school': school,
              'relationship': observedRelationship,
            },
          ],
          'diagnostics': <String, Object?>{
            'inconsistentRelationshipsCount': 0,
            'omittedRelationshipsCount': 0,
          },
        },
        'ApiSchoolAction': action,
        'ApiSchoolDashboard': dashboard,
        'ApiSchoolDashboardData': <String, Object?>{
          'school': school,
          'relationship': observedRelationship,
          'dashboard': dashboard,
        },
        'ApiSchoolInput': <String, Object?>{
          'name': 'Example school',
          'alias': 'example',
          'email': 'school@example.invalid',
          'photoUrl': 'about:blank',
          'coverPhotoUrl': 'about:blank',
          'address': address,
          'capabilities': <Object?>['educationPrograms'],
        },
        'ApiReturnedItemsSummary': summary,
        'ApiAcademicGroup': group,
        'ApiAcademicGroupRef': groupRef,
        'ApiAcademicGroupInput': <String, Object?>{
          'groupKey': 'cohort-a',
          'name': 'Example cohort',
          'academicGroupKind': 'cohort',
        },
        'ApiAcademicGroupDetailsInput': <String, Object?>{
          'name': 'Example cohort',
        },
        'ApiAcademicGroupData': <String, Object?>{
          'school': schoolRef,
          'academicGroup': group,
        },
        'ApiAcademicGroupsData': <String, Object?>{
          'school': schoolRef,
          'items': <Object?>[group],
          'summary': summary,
        },
        'ApiAcademicMember': member,
        'ApiAcademicMemberInput': memberInput,
        'ApiAcademicRoleInput': <String, Object?>{
          'academicRoleKey': 'student',
          'roleDisplayName': 'Student',
        },
        'ApiAcademicMemberData': <String, Object?>{
          'school': schoolRef,
          'academicGroup': groupRef,
          'member': member,
        },
        'ApiAcademicMembersData': <String, Object?>{
          'school': schoolRef,
          'academicGroup': groupRef,
          'items': <Object?>[member],
          'summary': summary,
        },
        'ApiSchoolActor': actor,
        'ApiSchoolCustomerSnapshot': customer,
        'ApiSchoolBaseMembership': baseMembership,
        'ApiSchoolActorData': <String, Object?>{
          'school': school,
          'actor': actor,
          'customerSnapshot': customer,
          'membership': baseMembership,
        },
        'ApiSchoolActorInput': <String, Object?>{
          'displayName': 'Example student',
          'educationalRole': 'student',
        },
        'ApiActorLinkCodeInput': <String, Object?>{'ttlHours': 168},
        'ApiActorLinkCode': <String, Object?>{
          'customerSnapshotId': 'student-1',
          'membershipId': 'membership-1',
          'linkCode': 'synthetic-opaque-code',
          'linkCodeExpiresAtIso': end,
        },
        'ApiActorUserLinkInput': <String, Object?>{
          'linkCode': 'synthetic-opaque-code',
        },
        'ApiAcademyReference': academyRef,
        'ApiAcademyReferenceInput': academyInput,
        'ApiProgramUnit': unit,
        'ApiProgramUnitInput': unitInput,
        'ApiSchoolProgram': program,
        'ApiSchoolProgramSummary': programSummary,
        'ApiSchoolProgramInput': <String, Object?>{
          'programKey': 'example',
          'name': 'Example course',
          'programType': 'course',
          'units': <Object?>[unitInput],
        },
        'ApiProgramDetailsInput': <String, Object?>{'name': 'Example course'},
        'ApiSchoolProgramData': <String, Object?>{
          'school': schoolRef,
          'program': program,
        },
        'ApiSchoolProgramsData': <String, Object?>{
          'school': schoolRef,
          'items': <Object?>[programSummary],
          'summary': summary,
        },
        'ApiStaffLegalRefInput': legalInput,
        'ApiStaffEmployeeInput': employeeInput,
        'ApiStaffPositionInput': positionInput,
        'ApiStaffAgreementInput': agreementInput,
        'ApiStaffCompensationInput': compensationInput,
        'ApiStaffWorkPolicyInput': <String, Object?>{},
        'ApiStaffInput': <String, Object?>{
          'employee': employeeInput,
          'position': positionInput,
          'agreement': agreementInput,
          'compensation': compensationInput,
          'workPolicy': <String, Object?>{},
        },
        'ApiStaffSummary': staffSummary,
        'ApiStaffPosition': position,
        'ApiStaffAgreement': agreement,
        'ApiStaffLegalSnapshot': legalSnapshot,
        'ApiStaffPersonLink': personLink,
        'ApiStaff': staff,
        'ApiStaffData': <String, Object?>{'school': schoolRef, 'staff': staff},
        'ApiStaffListData': <String, Object?>{
          'school': schoolRef,
          'items': <Object?>[staffSummary],
          'summary': summary,
        },
        'ApiScheduleGroup': scheduleGroup,
        'ApiScheduleStaff': scheduleStaff,
        'ApiScheduleProgram': scheduleProgram,
        'ApiScheduleEvent': schedule,
        'ApiScheduleInput': scheduleInput,
        'ApiScheduleUpdateInput': scheduleUpdate,
        'ApiScheduleEventData': <String, Object?>{
          'school': schoolRef,
          'scheduleEvent': schedule,
        },
        'ApiScheduleEventsData': <String, Object?>{
          'school': schoolRef,
          'items': <Object?>[schedule],
          'summary': summary,
        },
        'ApiSchoolAcademicQuery': <String, Object?>{
          'status': 'active',
          'academicGroupKind': 'cohort',
          'limit': '10',
        },
        'ApiAcademicMembersQuery': <String, Object?>{
          'status': 'active',
          'academicRoleKey': 'student',
          'memberType': 'customerSnapshot',
          'limit': '10',
        },
        'ApiSchoolProgramsQuery': <String, Object?>{
          'status': 'draft',
          'programType': 'course',
          'limit': '10',
        },
        'ApiStaffQuery': <String, Object?>{
          'status': 'draft',
          'positionKey': 'teacher',
          'limit': '10',
        },
        'ApiScheduleQuery': <String, Object?>{
          'startsAtIso': start,
          'endsAtIso': end,
        },
        'ApiSchoolAuthor': author,
        'ApiGradeEvaluationRef': evaluation,
        'ApiGradeEvaluationInput': evaluationInput,
        'ApiGradeResult': result,
        'ApiGradeResultInput': resultInput,
        'ApiGradeContext': gradeContext,
        'ApiGradeContextInput': <String, Object?>{},
        'ApiGrade': grade,
        'ApiGradeInput': gradeInput,
        'ApiGradeUpdateInput': <String, Object?>{
          ...gradeInput,
          'feedback': '',
          'attributes': <String, Object?>{},
        },
        'ApiGradeData': <String, Object?>{'school': schoolRef, 'grade': grade},
        'ApiGradesData': <String, Object?>{
          'school': schoolRef,
          'items': <Object?>[grade],
          'summary': summary,
        },
        'ApiGradeQuery': <String, Object?>{
          'gradeKindFilter': 'milestone',
          'status': 'draft',
          'limit': '10',
        },
        'ApiObservationContext': observationContext,
        'ApiObservationContextInput': <String, Object?>{},
        'ApiObservation': observation,
        'ApiObservationInput': observationInput,
        'ApiObservationUpdateInput': <String, Object?>{
          'severity': 'info',
          'status': 'inReview',
          'visibility': 'restricted',
          'title': 'Example title',
          'body': 'Example observation',
        },
        'ApiObservationData': <String, Object?>{
          'school': schoolRef,
          'observation': observation,
        },
        'ApiObservationsData': <String, Object?>{
          'school': schoolRef,
          'items': <Object?>[observation],
          'summary': summary,
        },
        'ApiObservationQuery': <String, Object?>{
          'observationKindFilter': 'general',
          'status': 'open',
          'limit': '10',
        },
        'ApiStudentPaymentReferenceInput': <String, Object?>{
          'academicGroupId': 'group-1',
          'serviceKey': 'monthlyFee',
          'academicPeriodKey': '2026-11',
        },
        'ApiStudentPaymentContext': paymentContext,
        'ApiStudentIdempotencyContext': idempotencyContext,
        'ApiStudentPaymentReference': <String, Object?>{
          'paymentReference': 'synthetic-reference',
          'concept': 'Example fee',
          'category': 'education',
          'context': paymentContext,
          'idempotencyContext': idempotencyContext,
        },
      };
  messages.forEach(checkApiMessage);

  test(
    'academic roles and date windows respect member type and UTC contract',
    () {
      expect(
        () => ApiAcademicMemberInput.fromJson(<String, Object?>{
          ...memberInput,
          'academicRoleKey': 'leadTeacher',
        }),
        throwsFormatException,
      );
      expect(
        () => ApiAcademicMember.fromJson(<String, Object?>{
          ...member,
          'endsAtIso': '2026-11-06T12:00:00.000Z',
        }),
        throwsFormatException,
      );
      expect(
        ApiAcademicMember.fromJson(<String, Object?>{
          ...member,
          'endsAtIso': start,
        }).endsAtIso,
        start,
      );
      expect(
        ApiAcademicMemberInput.fromJson(<String, Object?>{
          ...memberInput,
          'memberType': 'employeeSnapshot',
          'academicRoleKey': 'leadTeacher',
        }).academicRoleKey,
        'leadTeacher',
      );
    },
  );
  test('class references, strict intervals and 31-day query window differ', () {
    expect(
      () => ApiScheduleInput.fromJson(<String, Object?>{
        ...scheduleInput,
        'staffEmploymentIds': <Object?>[],
      }),
      throwsFormatException,
    );
    expect(
      () => ApiScheduleInput.fromJson(<String, Object?>{
        ...scheduleInput,
        'endsAtIso': start,
      }),
      throwsFormatException,
    );
    expect(
      () => ApiScheduleInput.fromJson(<String, Object?>{
        ...scheduleInput,
        'programId': null,
      }),
      throwsFormatException,
    );
    expect(
      () => ApiScheduleQuery(
        startsAtIso: start,
        endsAtIso: '2026-12-08T13:00:00.000Z',
      ),
      throwsFormatException,
    );
    expect(
      ApiScheduleQuery(
        startsAtIso: start,
        endsAtIso: '2026-12-07T13:00:00.000Z',
      ).endsAtIso,
      '2026-12-07T13:00:00.000Z',
    );
    expect(
      ApiScheduleInput(
        eventKind: 'academicEvent',
        title: 'Example event',
        startsAtIso: start,
        endsAtIso: end,
        timeZone: 'consumer-label',
      ).timeZone,
      'consumer-label',
    );
  });
  test('program orders are unique within arrays and creation status is server-owned', () {
    expect(
      () => ApiProgramUnitInput.fromJson(<String, Object?>{
        ...unitInput,
        'academyRefs': <Object?>[academyInput, academyInput],
      }),
      throwsFormatException,
    );
    expect(
      () => ApiSchoolProgramInput(
        programKey: 'example',
        name: 'Example',
        programType: 'course',
        status: const ApiField<String?>.present('draft'),
      ),
      throwsFormatException,
    );
    expect(
      ApiSchoolProgramInput(
        programKey: 'example',
        name: 'Example',
        programType: 'course',
        status: const ApiField<String?>.present(null),
      ).status.value,
      isNull,
    );
  });
  test(
    'grading preserves explicit false rather than deriving a pass from score',
    () {
      const Map<String, Object?> ref = <String, Object?>{
        'refType': 'academyAssessment',
        'refId': 'assessment-1',
      };
      final ApiGradeInput numeric = ApiGradeInput.fromJson(<String, Object?>{
        'gradeKind': 'numericScore',
        'evaluationRef': ref,
        'result': <String, Object?>{
          'score': 10,
          'maxScore': 10,
          'passed': false,
        },
      });
      expect(numeric.result.passed, isFalse);
      expect(
        () => ApiGradeInput.fromJson(<String, Object?>{
          'gradeKind': 'numericScore',
          'evaluationRef': ref,
          'result': <String, Object?>{
            'score': 11,
            'maxScore': 10,
            'passed': false,
          },
        }),
        throwsFormatException,
      );
      expect(
        () => ApiGradeInput.fromJson(<String, Object?>{
          'gradeKind': 'qualitativeLevel',
          'evaluationRef': ref,
          'result': <String, Object?>{'passed': true},
        }),
        throwsFormatException,
      );
      expect(
        ApiGradeInput.fromJson(<String, Object?>{
          'gradeKind': 'qualitativeLevel',
          'evaluationRef': ref,
          'result': <String, Object?>{
            'qualitativeLevel': 'developing',
            'passed': true,
          },
        }).result.passed,
        isTrue,
      );
      expect(
        () => ApiGradeEvaluationInput.fromJson(<String, Object?>{
          ...ref,
          'label': 'Client overrides hydrated label',
        }),
        throwsFormatException,
      );
      expect(
        () => ApiGradeInput.fromJson(<String, Object?>{
          ...gradeInput,
          'result': <String, Object?>{},
        }),
        throwsFormatException,
      );
      expect(
        () => ApiGrade.fromJson(<String, Object?>{
          ...grade,
          'result': <String, Object?>{...result, 'passed': true},
        }),
        throwsFormatException,
      );
      expect(
        () => ApiGradeInput.fromJson(<String, Object?>{
          ...gradeInput,
          'schoolStoreId': null,
        }),
        throwsFormatException,
      );
    },
  );
  test(
    'observation updates cannot replace identity, author or observation kind',
    () {
      final Map<String, Object?> update =
          messages['ApiObservationUpdateInput']!;
      expect(
        () => ApiObservationUpdateInput.fromJson(<String, Object?>{
          ...update,
          'observationKind': 'academic',
        }),
        throwsFormatException,
      );
      expect(
        () => ApiObservationUpdateInput.fromJson(<String, Object?>{
          ...update,
          'status': 'archived',
        }),
        throwsFormatException,
      );
      expect(
        () => ApiObservationInput.fromJson(<String, Object?>{
          ...observationInput,
          'body': 'Click javascript:example',
        }),
        throwsFormatException,
      );
      expect(
        ApiObservationInput.fromJson(<String, Object?>{
          ...observationInput,
          'body': 'Plain text: 2 < 3',
        }).body,
        'Plain text: 2 < 3',
      );
    },
  );
  test(
    'payment reference validates local text without performing a payment',
    () {
      final Map<String, Object?> input =
          messages['ApiStudentPaymentReferenceInput']!;
      expect(
        () => ApiStudentPaymentReferenceInput.fromJson(<String, Object?>{
          ...input,
          'serviceKey': 'other',
        }),
        throwsFormatException,
      );
      expect(
        () => ApiStudentPaymentReferenceInput.fromJson(<String, Object?>{
          ...input,
          'academicPeriodKey': '2026-13',
        }),
        throwsFormatException,
      );
      expect(
        ApiStudentPaymentReferenceInput.fromJson(<String, Object?>{
          ...input,
          'serviceKey': 'other',
          'label': 'Example service',
        }).label.value,
        'Example service',
      );
    },
  );
  test('public staff output exposes masked legal data without compensation or raw document ID', () {
    final Map<String, dynamic> wire = ApiStaff.fromJson(staff).toJson();
    expect(wire.containsKey('compensation'), isFalse);
    expect(
      (wire['legalId'] as Map<String, dynamic>).containsKey(
        'legalIdDocumentId',
      ),
      isFalse,
    );
    expect(
      ApiStaffInput.fromJson(messages['ApiStaffInput']!).compensation.amount,
      0,
    );
  });
}
