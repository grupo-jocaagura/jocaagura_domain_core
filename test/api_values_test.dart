import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

import 'support/api_contract_checks.dart';

void main() {
  const Map<String, Object?> address = <String, Object?>{
    'id': 'address-1',
    'postalCode': 0,
    'country': 'CO',
    'administrativeArea': 'Example',
    'city': 'Example',
    'locality': '',
    'address': 'Example address',
    'notes': '',
  };
  const Map<String, Object?> person = <String, Object?>{
    'id': 'person-1',
    'names': 'Example',
    'lastNames': 'Person',
    'photoUrl': 'about:blank',
    'attributes': <String, Object?>{'personKind': 'me', 'userId': 'person-1'},
  };
  const Map<String, Object?> legal = <String, Object?>{
    'id': 'legal-1',
    'idType': 'Pasaporte',
    'names': 'Example',
    'lastNames': 'Person',
    'legalIdNumber': '000123',
    'attributes': <String, Object?>{
      'note': <String, Object?>{
        'name': 'note',
        'value': <Object?>[
          1,
          null,
          <String, Object?>{'enabled': true},
        ],
      },
    },
  };
  const Map<String, Object?> category = <String, Object?>{
    'category': 'example',
    'description': 'Example category',
  };
  const Map<String, Object?> price = <String, Object?>{
    'amount': 1234,
    'mathPrecision': 2,
    'currency': 'COP',
  };
  const Map<String, Object?> user = <String, Object?>{
    'id': 'user-1',
    'email': 'user@example.invalid',
    'displayName': '',
    'photoUrl': '',
  };
  const Map<String, Object?> session = <String, Object?>{
    'user': user,
    'createdAtIso': '2026-01-01T00:00:00.000Z',
    'expiresAtIso': '2026-01-01T02:00:00.000Z',
    'ttlMilliseconds': 7200000,
    'isActive': true,
  };
  const Map<String, Object?> summary = <String, Object?>{
    'status': 'open',
    'closureCause': null,
    'verificationStatus': 'notStarted',
    'isTerminal': false,
    'nextAction': 'startCheckout',
  };
  const Map<String, Object?> target = <String, Object?>{
    'targetType': 'signedUrl',
    'url': 'fake://opaque',
    'method': 'PUT',
    'expiresAt': null,
    'requiredHeaders': <String, Object?>{'Content-Type': 'image/webp'},
  };
  final Map<
    String,
    (ApiValue Function(Map<String, Object?>), Map<String, Object?>)
  >
  cases =
      <String, (ApiValue Function(Map<String, Object?>), Map<String, Object?>)>{
        'address': (ApiAddress.fromJson, address),
        'attribute': (
          ApiAttribute.fromJson,
          <String, Object?>{'name': 'example', 'value': null},
        ),
        'person': (ApiPerson.fromJson, person),
        'legal identity': (ApiLegalId.fromJson, legal),
        'current legal readiness': (
          ApiCurrentLegalState.fromJson,
          <String, Object?>{
            'person': person,
            'legalId': null,
            'legalReadinessStatus': 'missing',
          },
        ),
        'category': (ApiCategory.fromJson, category),
        'price': (ApiPrice.fromJson, price),
        'article': (
          ApiItem.fromJson,
          <String, Object?>{
            'id': 'item-1',
            'name': 'Example',
            'description': '',
            'type': category,
            'price': price,
            'attributes': <Object?>[
              <String, Object?>{
                'name': 'example',
                'value': <Object?>[null, 1],
              },
            ],
          },
        ),
        'session user': (ApiSessionUser.fromJson, user),
        'session': (ApiSession.fromJson, session),
        'opened session': (
          ApiOpenedSession.fromJson,
          <String, Object?>{
            'sessionToken': 'SYNTHETIC_TOKEN',
            'session': session,
          },
        ),
        'payment summary': (ApiPaymentLifecycleSummary.fromJson, summary),
        'upload target': (ApiMediaUploadTarget.fromJson, target),
        'upload intent': (
          ApiMediaUploadIntent.fromJson,
          <String, Object?>{
            'uploadId': 'upload-1',
            'imageId': 'image-1',
            'uploadTarget': target,
            'maxSizeBytes': 1048576,
          },
        ),
        'health': (
          ApiHealth.fromJson,
          <String, Object?>{
            'status': 'up',
            'environment': 'local',
            'version': 'unknown',
            'commitSha': 'unknown',
            'buildId': 'unknown',
            'buildTime': 'unknown',
          },
        ),
      };
  for (final MapEntry<
        String,
        (ApiValue Function(Map<String, Object?>), Map<String, Object?>)
      >
      entry
      in cases.entries) {
    test(
      '${entry.key}: normative wire round trip, ownership, required members and value equality',
      () {
        final ApiValue Function(Map<String, Object?>) decode = entry.value.$1;
        final Map<String, Object?> wire = entry.value.$2;
        final ApiValue value = decode(<String, Object?>{
          ...wire,
          'unknown': Object(),
        });
        verifyApiFieldContracts(value, decode, wire);
        expect(value.toJson(), wire);
        expect(value.copyWith(), value);
        final ApiValue restored = decode(
          jsonDecode(jsonEncode(value.toJson())) as Map<String, Object?>,
        );
        expect(restored, value);
        expect(restored.hashCode, value.hashCode);
        expect(value == Object(), isFalse);
        expect(value, isNot(ApiJsonObject(wire)));
        for (final String key in wire.keys) {
          final Map<String, Object?> missing = <String, Object?>{...wire}
            ..remove(key);
          expect(
            () => decode(missing),
            throwsFormatException,
            reason: '${entry.key} requires $key',
          );
          expect(
            () => decode(<String, Object?>{...wire, key: Object()}),
            throwsFormatException,
          );
        }
        final Map<String, dynamic> exported = value.toJson();
        exported.clear();
        expect(value.toJson(), wire);
      },
    );
  }

  test('API personal attributes remain string values instead of legacy attribute objects', () {
    final ApiPerson value = ApiPerson.fromJson(person);
    expect(value.attributes['personKind'], 'me');
    expect(() => value.attributes['new'] = 'x', throwsUnsupportedError);
    expect(
      () => ApiPerson.fromJson(<String, Object?>{
        ...person,
        'attributes': <String, Object?>{'x': 1},
      }),
      throwsFormatException,
    );
    expect(value.copyWith(names: 'Other').names, 'Other');
    expect(ApiLegalId.fromJson(legal).legalIdNumber, '000123');
  });

  test('nullable legal identity and JSON attribute values distinguish null from missing', () {
    final ApiCurrentLegalState declared = ApiCurrentLegalState(
      person: ApiPerson.fromJson(person),
      legalId: ApiLegalId.fromJson(legal),
      legalReadinessStatus: 'declared',
    );
    expect(declared.legalId, isNotNull);
    final ApiCurrentLegalState missing = declared.copyWith(
      legalId: const ApiField<ApiLegalId?>.present(null),
      legalReadinessStatus: 'missing',
    );
    expect(missing.legalId, isNull);
    expect(
      () => missing.copyWith(legalReadinessStatus: 'declared'),
      throwsFormatException,
    );
    expect(missing.toJson(), containsPair('legalId', null));
    expect(ApiCurrentLegalState.fromJson(declared.toJson()), declared);
    expect(
      ApiAttribute(name: 'nullable', value: null)
          .copyWith(
            value: const ApiField<Object?>.present(<String, Object?>{
              'x': true,
            }),
          )
          .value,
      <String, Object?>{'x': true},
    );
    expect(
      () => ApiCurrentLegalState(
        person: declared.person,
        legalId: null,
        legalReadinessStatus: 'approved',
      ),
      throwsFormatException,
    );
  });

  test(
    'article money preserves explicit scale and exact supported currency names',
    () {
      expect(
        ApiPrice.fromJson(price).copyWith(mathPrecision: 0).mathPrecision,
        0,
      );
      expect(
        () => ApiPrice(amount: -1, mathPrecision: 0, currency: 'COP'),
        throwsFormatException,
      );
      expect(
        () => ApiPrice(amount: 1, mathPrecision: -1, currency: 'COP'),
        throwsFormatException,
      );
      expect(
        () => ApiPrice(amount: 1, mathPrecision: 0, currency: 'cop'),
        throwsFormatException,
      );
      expect(ApiPrice(amount: 0, mathPrecision: 0, currency: 'BTC').amount, 0);
      final ApiItem item =
          cases['article']!.$1(cases['article']!.$2) as ApiItem;
      expect(
        () => item.attributes.add(ApiAttribute(name: 'x', value: 1)),
        throwsUnsupportedError,
      );
      expect(item.copyWith(id: 'changed').id, 'changed');
    },
  );

  test('closed economic summaries require a cause, terminal state and no next economic action', () {
    final ApiPaymentLifecycleSummary settled = ApiPaymentLifecycleSummary(
      status: 'closed',
      closureCause: 'settled',
      verificationStatus: 'approved',
      isTerminal: true,
      nextAction: 'none',
    );
    expect(ApiPaymentLifecycleSummary.fromJson(settled.toJson()), settled);
    expect(
      settled
          .copyWith(closureCause: const ApiField<String?>.present('cancelled'))
          .closureCause,
      'cancelled',
    );
    expect(() => settled.copyWith(isTerminal: false), throwsFormatException);
    expect(
      () => settled.copyWith(nextAction: 'checkStatus'),
      throwsFormatException,
    );
    expect(
      () =>
          settled.copyWith(closureCause: const ApiField<String?>.present(null)),
      throwsFormatException,
    );
    expect(
      () => settled.copyWith(verificationStatus: 'ambiguous'),
      throwsFormatException,
    );
    expect(() => settled.copyWith(status: 'open'), throwsFormatException);
    expect(() => settled.copyWith(status: 'other'), throwsFormatException);
    expect(
      () => settled.copyWith(
        closureCause: const ApiField<String?>.present('other'),
      ),
      throwsFormatException,
    );
    expect(
      () => settled.copyWith(verificationStatus: 'other'),
      throwsFormatException,
    );
    expect(() => settled.copyWith(nextAction: 'other'), throwsFormatException);
    final ApiPaymentLifecycleSummary open = ApiPaymentLifecycleSummary.fromJson(
      summary,
    );
    expect(open.copyWith(), open);
  });

  test('session TTL and opaque upload destinations keep their operation-specific semantics', () {
    expect(
      ApiSession.fromJson(session)
          .copyWith(ttlMilliseconds: -1)
          .ttlMilliseconds,
      -1,
    );
    final ApiMediaUploadTarget value = ApiMediaUploadTarget.fromJson(target);
    expect(value.url, 'fake://opaque');
    expect(
      value
          .copyWith(
            expiresAt: const ApiField<String?>.present(
              '2026-01-01T00:00:00.000Z',
            ),
          )
          .expiresAt,
      isNotNull,
    );
    expect(() => value.copyWith(method: 'POST'), throwsFormatException);
    expect(() => value.copyWith(targetType: 'other'), throwsFormatException);
  });

  test('equivalent opaque object key order produces deterministic JSON and homologated hashes', () {
    final ApiAttribute a = ApiAttribute(
      name: 'x',
      value: <String, Object?>{
        'z': <Object?>[1],
        'a': null,
      },
    );
    final ApiAttribute b = ApiAttribute(
      name: 'x',
      value: <String, Object?>{
        'a': null,
        'z': <Object?>[1],
      },
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(jsonEncode(a.toJson()), jsonEncode(b.toJson()));
  });
}
