import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_models.dart';
import 'package:test/test.dart';

void main() {
  test('death record decodes person, address and record ID from their declared keys', () {
    final DeathRecordModel source = defaultDeathRecord.copyWith(
      person: defaultPersonModel.copyWith(
        id: 'person-regression',
        names: 'Example',
      ),
      address: defaultAddressModel.copyWith(
        id: 'address-regression',
        city: 'Example city',
      ),
      recordId: '000123',
    );
    final Map<String, dynamic> wire =
        jsonDecode(jsonEncode(source.toJson())) as Map<String, dynamic>;
    final DeathRecordModel decoded = source.fromJson(wire);
    expect(decoded, source);
    expect(decoded.hashCode, source.hashCode);
    expect(decoded.person.id, 'person-regression');
    expect(decoded.address.id, 'address-regression');
    expect(decoded.recordId, '000123');
  });
  test('clinical values compare fields even when hashes collide', () {
    final List<(Model, Model)> collisions = <(Model, Model)>[
      (_CollidingAcceptance('first'), _CollidingAcceptance('second')),
      (_CollidingDental('first'), _CollidingDental('second')),
      (_CollidingDiagnosis('first'), _CollidingDiagnosis('second')),
    ];
    for (final (Model first, Model second) in collisions) {
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(second));
      expect(second, isNot(first));
      expect(<Model>{first, second}, hasLength(2));
    }
  });
}

// Deliberate collision fixtures prove that a hash is not an equality predicate.
// ignore: hash_and_equals
class _CollidingAcceptance extends AcceptanceClauseModel {
  _CollidingAcceptance(String print)
    : super(
        id: 'same',
        odontologistSignature: defaultOdontologistSignature,
        patientPrint: print,
        patientSignature: defaultPatientSignature,
        stringAcceptanceLeyend: 'Example',
      );
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  int get hashCode => 1;
}

// ignore: hash_and_equals
class _CollidingDental extends DentalConditionModel {
  _CollidingDental(String id)
    : super(
        id: id,
        dentalRegion: dentalConditionModelDefault.dentalRegion,
        condition: dentalConditionModelDefault.condition,
        dateTimeOfRecord: DateTime.utc(2026),
        dentalId: dentalConditionModelDefault.dentalId,
      );
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  int get hashCode => 1;
}

// ignore: hash_and_equals
class _CollidingDiagnosis extends MedicalDiagnosisTabModel {
  _CollidingDiagnosis(String id)
    : super(
        id: id,
        condition: 'Example',
        observation: '',
        quantity: 1,
        dateTimeOfRecord: DateTime.utc(2026),
      );
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  int get hashCode => 1;
}
