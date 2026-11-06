/// Explicit mappings between legacy domain values and public API projections.
///
/// Unsupported or lossy values fail explicitly. These functions execute no
/// transport or persistence and depend on the Dart SDK only.
library;

import 'jocaagura_domain_api.dart';
import 'jocaagura_domain_models.dart';

/// Conversion boundaries where legacy wire shapes differ from functional APIs.
abstract final class ApiDomainMapper {
  static ApiAddress addressToApi(AddressModel value) => ApiAddress(
    id: value.id,
    postalCode: value.postalCode,
    country: value.country,
    administrativeArea: value.administrativeArea,
    city: value.city,
    locality: value.locality,
    address: value.address,
    notes: value.notes,
  );

  static AddressModel addressFromApi(ApiAddress value) => AddressModel(
    id: value.id,
    postalCode: value.postalCode,
    country: value.country,
    administrativeArea: value.administrativeArea,
    city: value.city,
    locality: value.locality,
    address: value.address,
    notes: value.notes,
  );

  /// Personal API attributes are strings. Other legacy attribute types are not
  /// silently stringified and cannot be represented by this projection.
  static ApiPerson personToApi(PersonModel value) => ApiPerson(
    id: value.id,
    names: value.names,
    lastNames: value.lastNames,
    photoUrl: value.photoUrl,
    attributes: <String, String>{
      for (final MapEntry<String, AttributeModel<dynamic>> entry
          in value.attributes.entries)
        entry.key: _personAttribute(entry),
    },
  );

  static String _personAttribute(
    MapEntry<String, AttributeModel<dynamic>> entry,
  ) {
    if (entry.value.name != entry.key || entry.value.value is! String) {
      throw const FormatException(
        'Personal API attributes require matching names and string values.',
      );
    }
    return entry.value.value as String;
  }

  static PersonModel personFromApi(ApiPerson value) => PersonModel(
    id: value.id,
    names: value.names,
    lastNames: value.lastNames,
    photoUrl: value.photoUrl,
    attributes: <String, AttributeModel<dynamic>>{
      for (final MapEntry<String, String> entry in value.attributes.entries)
        entry.key: AttributeModel<dynamic>(name: entry.key, value: entry.value),
    },
  );

  static ApiLegalId legalIdToApi(LegalIdModel value) => ApiLegalId(
    id: value.id,
    idType: value.idType.description,
    names: value.names,
    lastNames: value.lastNames,
    legalIdNumber: value.legalIdNumber,
    attributes: <String, ApiAttribute>{
      for (final MapEntry<String, AttributeModel<dynamic>> entry
          in value.attributes.entries)
        entry.key: ApiAttribute(
          name: entry.value.name,
          value: entry.value.value,
        ),
    },
  );

  /// Unknown document types fail instead of adopting a legacy enum fallback.
  static LegalIdModel legalIdFromApi(ApiLegalId value) {
    final List<LegalIdTypeEnum> matches = LegalIdTypeEnum.values
        .where((LegalIdTypeEnum type) => type.description == value.idType)
        .toList();
    if (matches.isEmpty) {
      throw const FormatException(
        'The legal document type is not representable by the legacy enum.',
      );
    }
    return LegalIdModel(
      id: value.id,
      idType: matches.single,
      names: value.names,
      lastNames: value.lastNames,
      legalIdNumber: value.legalIdNumber,
      attributes: <String, AttributeModel<dynamic>>{
        for (final MapEntry<String, ApiAttribute> entry
            in value.attributes.entries)
          entry.key: AttributeModel<dynamic>(
            name: entry.value.name,
            value: entry.value.value,
          ),
      },
    );
  }

  static ApiPrice priceToApi(ModelPrice value) => ApiPrice(
    amount: value.amount,
    mathPrecision: value.mathPrecision,
    currency: value.currency.name,
  );

  static ModelPrice priceFromApi(ApiPrice value) => ModelPrice(
    amount: value.amount,
    mathPrecision: value.mathPrecision,
    currency: CurrencyEnum.values.singleWhere(
      (CurrencyEnum currency) => currency.name == value.currency,
    ),
  );
}
