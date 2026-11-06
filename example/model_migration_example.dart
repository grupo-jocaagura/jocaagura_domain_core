import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:jocaagura_domain_core/jocaagura_domain_mappers.dart';
import 'package:jocaagura_domain_core/models/common.dart';
import 'package:jocaagura_domain_core/models/identity.dart';

void main() {
  const PersonModel person = PersonModel(
    id: 'example-person',
    names: 'Example',
    lastNames: 'Person',
    photoUrl: 'about:blank',
    attributes: <String, AttributeModel<dynamic>>{
      'personKind': AttributeModel<String>(name: 'personKind', value: 'me'),
    },
  );
  final ApiPerson functional = ApiDomainMapper.personToApi(person);
  final ApiPerson decoded = ApiPerson.fromJson(
    jsonDecode(jsonEncode(functional.toJson())) as Map<String, Object?>,
  );
  assert(decoded == functional);
  assert(decoded.hashCode == functional.hashCode);
  assert(ApiDomainMapper.personFromApi(decoded) == person);

  // Absence, explicit null and an empty JSON body represent different inputs.
  final ApiActorLinkCodeInput defaults = ApiActorLinkCodeInput();
  final ApiActorLinkCodeInput explicitNull = ApiActorLinkCodeInput(
    ttlHours: const ApiField<int?>.present(null),
  );
  assert(!defaults.toJson().containsKey('ttlHours'));
  assert(explicitNull.toJson().containsKey('ttlHours'));
  assert(defaults != explicitNull);
  assert(ApiEmptyObjectBody().toJson().isEmpty);

  // This is data composition only. Consumers own HTTP, Flutter and credentials.
  final ApiPaymentResolutionData awaitingResolution = ApiPaymentResolutionData(
    resolution: null,
  );
  assert(awaitingResolution.resolution == null);
  assert(jsonEncode(decoded.toJson()).contains('example-person'));
}
