import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:jocaagura_domain_core/jocaagura_domain_mappers.dart';
import 'package:jocaagura_domain_core/jocaagura_domain_models.dart';
import 'package:test/test.dart';

void main() {
  test(
    'address mapping preserves all fields without applying store input rules',
    () {
      const AddressModel domain = AddressModel(
        id: 'id',
        postalCode: -1,
        country: 'CO',
        administrativeArea: 'Example',
        city: 'Example',
        locality: 'Example',
        address: 'Example',
        notes: 'note',
      );
      final ApiAddress api = ApiDomainMapper.addressToApi(domain);
      expect(api.toJson(), domain.toJson());
      expect(ApiDomainMapper.addressFromApi(api), domain);
    },
  );

  test('person mapping is lossless for representable string attributes', () {
    const PersonModel domain = PersonModel(
      id: 'person-1',
      names: 'Example',
      lastNames: 'Person',
      photoUrl: '',
      attributes: <String, AttributeModel<dynamic>>{
        'userId': AttributeModel<String>(name: 'userId', value: 'user-1'),
      },
    );
    final ApiPerson api = ApiDomainMapper.personToApi(domain);
    expect(api.attributes, <String, String>{'userId': 'user-1'});
    expect(ApiDomainMapper.personFromApi(api), domain);
    expect(ApiDomainMapper.personFromApi(api).hashCode, domain.hashCode);
    expect(
      ApiDomainMapper.personToApi(ApiDomainMapper.personFromApi(api)),
      api,
    );
    expect(
      () => ApiDomainMapper.personToApi(
        domain.copyWith(
          attributes: <String, AttributeModel<dynamic>>{
            'x': const AttributeModel<int>(name: 'x', value: 1),
          },
        ),
      ),
      throwsFormatException,
    );
    expect(
      () => ApiDomainMapper.personToApi(
        domain.copyWith(
          attributes: <String, AttributeModel<dynamic>>{
            'x': const AttributeModel<String>(
              name: 'different',
              value: 'value',
            ),
          },
        ),
      ),
      throwsFormatException,
    );
  });

  test('legal mappings preserve zero-prefixed numbers and arbitrary JSON attributes', () {
    const LegalIdModel domain = LegalIdModel(
      id: 'legal-1',
      idType: LegalIdTypeEnum.pasaporte,
      names: 'Example',
      lastNames: 'Person',
      legalIdNumber: '000123',
      attributes: <String, AttributeModel<dynamic>>{
        'x': AttributeModel<dynamic>(
          name: 'x',
          value: <String, Object?>{
            'nested': <Object?>[1, null, true],
          },
        ),
      },
    );
    final ApiLegalId api = ApiDomainMapper.legalIdToApi(domain);
    expect(api.legalIdNumber, '000123');
    expect(ApiDomainMapper.legalIdFromApi(api), domain);
    expect(ApiDomainMapper.legalIdFromApi(api).hashCode, domain.hashCode);
    expect(
      ApiDomainMapper.legalIdToApi(ApiDomainMapper.legalIdFromApi(api)),
      api,
    );
    expect(
      LegalIdModel.fromJson(
        jsonDecode(jsonEncode(domain.toJson())) as Map<String, dynamic>,
      ),
      domain,
    );
    expect(
      () => ApiDomainMapper.legalIdFromApi(api.copyWith(idType: 'RUT')),
      throwsFormatException,
    );
    expect(
      () => ApiDomainMapper.legalIdToApi(
        domain.copyWith(
          attributes: <String, AttributeModel<dynamic>>{
            'invalid': const AttributeModel<Object>(
              name: 'invalid',
              value: Object(),
            ),
          },
        ),
      ),
      throwsFormatException,
    );
  });

  test(
    'price mapping preserves explicit precision and every supported currency',
    () {
      for (final CurrencyEnum currency in CurrencyEnum.values) {
        final ModelPrice domain = ModelPrice(
          amount: 1234,
          mathPrecision: 3,
          currency: currency,
        );
        final ApiPrice api = ApiDomainMapper.priceToApi(domain);
        expect(api.toJson(), domain.toJson());
        expect(ApiDomainMapper.priceFromApi(api), domain);
      }
    },
  );

  test('homologated collection equality is symmetric across attribute generic specializations', () {
    const AttributeModel<String> typed = AttributeModel<String>(
      name: 'name',
      value: 'Example',
    );
    const AttributeModel<dynamic> decoded = AttributeModel<dynamic>(
      name: 'name',
      value: 'Example',
    );
    expect(typed == decoded, isTrue);
    expect(decoded == typed, isTrue);
    expect(typed.hashCode, decoded.hashCode);
    const ModelGroupLabels a = ModelGroupLabels(
      pillar: ModelGroupPillar.education,
      kind: ModelGroupKind.other,
      attributes: <String, dynamic>{
        'z': <dynamic>[1, 2],
        'a': null,
      },
    );
    const ModelGroupLabels b = ModelGroupLabels(
      pillar: ModelGroupPillar.education,
      kind: ModelGroupKind.other,
      attributes: <String, dynamic>{
        'a': null,
        'z': <dynamic>[1, 2],
      },
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    final UserModel user = defaultUserModel.copyWith(
      jwt: <String, dynamic>{
        'a': <dynamic>[1, null],
        'b': true,
      },
    );
    final UserModel other = user.copyWith(
      jwt: <String, dynamic>{
        'b': true,
        'a': <dynamic>[1, null],
      },
    );
    expect(user, other);
    expect(user.hashCode, other.hashCode);
  });
}
