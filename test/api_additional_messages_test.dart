import 'dart:convert';
import 'dart:io';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

import 'support/api_contract_checks.dart';

void main() {
  final Map<String, dynamic> fixtures = jsonDecode(
    File('test/fixtures/additional-api-messages.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  for (final MapEntry<String, dynamic> entry in fixtures.entries) {
    checkApiMessage(entry.key, entry.value as Map<String, Object?>);
  }
  test(
    'pending resolution is present null; it is neither failure nor approval',
    () {
      final ApiPaymentResolutionData data = ApiPaymentResolutionData.fromJson(
        <String, Object?>{'resolution': null},
      );
      expect(data.resolution, isNull);
      expect(data.toJson(), <String, Object?>{'resolution': null});
      expect(
        () => ApiPaymentResolutionData.fromJson(<String, Object?>{}),
        throwsFormatException,
      );
    },
  );
  test('payment options are exactly empty and isEnabled preserves false', () {
    expect(
      () => ApiPaymentProfileUpdateInput.fromJson(<String, Object?>{
        'paymentOptions': <String, Object?>{'hidden': true},
        'isEnabled': false,
      }),
      throwsFormatException,
    );
    expect(
      ApiPaymentProfileUpdateInput(
        paymentOptions: ApiEmptyObjectBody(),
        isEnabled: false,
      ).isEnabled,
      isFalse,
    );
  });
  test('fleet position permits missing observation as explicit null', () {
    final Map<String, Object?> wire = <String, Object?>{
      ...fixtures['ApiFleetUnit'] as Map<String, Object?>,
      'lastKnownPosition': null,
    };
    expect(ApiFleetUnit.fromJson(wire).lastKnownPosition, isNull);
    expect(
      ApiVehicleInput.fromJson(
        fixtures['ApiVehicleInput'] as Map<String, Object?>,
      ).isActive.value,
      isFalse,
    );
  });
}
