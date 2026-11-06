import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

import 'support/api_contract_checks.dart';

void main() {
  const Map<String, Object?> user = <String, Object?>{
    'userId': 'user-1',
    'email': 'user@example.invalid',
    'displayName': 'Example',
    'photoUrl': '',
  };
  const Map<String, Object?> session = <String, Object?>{
    'userId': 'user-1',
    'status': 'active',
    'createdAtIso': '2026-01-01T00:00:00.000Z',
    'expiresAtIso': '2026-01-01T02:00:00.000Z',
  };
  const Map<String, Object?> context = <String, Object?>{
    'contextType': 'example',
    'contextId': 'context-1',
  };
  const Map<String, Object?> subject = <String, Object?>{
    'contextKey': 'people_me',
    'resourceType': 'person',
    'resourceId': 'user-1',
  };
  const Map<String, Object?> readTarget = <String, Object?>{
    'targetType': 'signedUrl',
    'url': 'fake://opaque-read',
    'method': 'GET',
    'expiresAt': null,
  };
  final Map<
    String,
    (ApiValue Function(Map<String, Object?>), Map<String, Object?>)
  >
  full =
      <String, (ApiValue Function(Map<String, Object?>), Map<String, Object?>)>{
        'root message': (
          ApiMessage.fromJson,
          <String, Object?>{'message': 'Example'},
        ),
        'session status': (ApiSessionStatus.fromJson, session),
        'authenticated user': (ApiAuthenticatedUser.fromJson, user),
        'authentication state': (
          ApiAuthenticationState.fromJson,
          <String, Object?>{'session': session, 'user': user},
        ),
        'logout result': (
          ApiLogoutData.fromJson,
          <String, Object?>{
            'authenticatedSession': <String, Object?>{
              'session': <String, Object?>{...session, 'status': 'inactive'},
              'user': user,
            },
          },
        ),
        'user/person identity': (
          ApiUserIdentity.fromJson,
          <String, Object?>{...user, 'personId': 'person-1'},
        ),
        'idempotency context': (ApiIdempotencyContext.fromJson, context),
        'key request': (
          ApiIdempotencyRequest.fromJson,
          <String, Object?>{
            'operationType': 'critical.operation.example',
            'contextRef': context,
          },
        ),
        'key response': (
          ApiIssuedIdempotencyKey.fromJson,
          <String, Object?>{
            'idempotencyKey': 'SYNTHETIC_KEY',
            'operationType': 'critical.operation.example',
            'contextRef': context,
            'status': 'waiting',
            'expiresAtIso': '2026-01-01T00:30:00.000Z',
          },
        ),
        'media subject': (ApiMediaSubject.fromJson, subject),
        'image confirmation request': (
          ApiMediaConfirmRequest.fromJson,
          <String, Object?>{'uploadId': 'upload-1'},
        ),
        'image confirmation result': (
          ApiMediaConfirmation.fromJson,
          <String, Object?>{
            'imageId': 'image-1',
            'status': 'ready',
            'description': '',
            'analysisSummary': '',
          },
        ),
        'image read request': (
          ApiMediaReadRequest.fromJson,
          <String, Object?>{'variantKey': 'original'},
        ),
        'image read destination': (ApiMediaReadTarget.fromJson, readTarget),
        'image read result': (
          ApiMediaReadData.fromJson,
          <String, Object?>{
            'imageId': 'image-1',
            'variantKey': 'original',
            'readTarget': readTarget,
          },
        ),
        'email identity lookup': (
          ApiResolveUserByEmailRequest.fromJson,
          <String, Object?>{'email': 'user@example.invalid'},
        ),
      };
  for (final MapEntry<
        String,
        (ApiValue Function(Map<String, Object?>), Map<String, Object?>)
      >
      entry
      in full.entries) {
    test('${entry.key} has an explicit complete functional projection', () {
      final ApiValue Function(Map<String, Object?>) decode = entry.value.$1;
      final Map<String, Object?> json = entry.value.$2;
      final ApiValue value = decode(<String, Object?>{
        ...json,
        'extra': Object(),
      });
      verifyApiFieldContracts(value, decode, json);
      expect(value.toJson(), json);
      expect(value.copyWith(), value);
      final ApiValue restored = decode(
        jsonDecode(jsonEncode(value.toJson())) as Map<String, Object?>,
      );
      expect(restored, value);
      expect(restored.hashCode, value.hashCode);
      for (final String key in json.keys) {
        expect(
          () => decode(<String, Object?>{...json}..remove(key)),
          throwsFormatException,
        );
        expect(
          () => decode(<String, Object?>{...json, key: Object()}),
          throwsFormatException,
        );
      }
    });
  }

  test(
    'session creation preserves optional duration syntax, null and absence',
    () {
      final ApiSessionStartRequest absent = ApiSessionStartRequest(
        idToken: 'SYNTHETIC',
      );
      expect(absent.ttlMilliseconds.isPresent, isFalse);
      expect(absent.toJson(), <String, Object?>{'idToken': 'SYNTHETIC'});
      expect(absent.copyWith(), absent);
      for (final Object? duration in <Object?>[
        null,
        -1,
        0,
        0.5,
        '2h45m',
        'PT2H',
        '7200000',
      ]) {
        final ApiSessionStartRequest request = absent.copyWith(
          ttlMilliseconds: ApiField<Object?>.present(duration),
        );
        expect(request.ttlMilliseconds.value, duration);
        expect(ApiSessionStartRequest.fromJson(request.toJson()), request);
      }
      expect(absent.copyWith(idToken: 'OTHER').idToken, 'OTHER');
      expect(() => ApiSessionStartRequest(idToken: ' '), throwsFormatException);
      expect(
        () => absent.copyWith(
          ttlMilliseconds: const ApiField<Object?>.present(true),
        ),
        throwsFormatException,
      );
      expect(
        () => ApiSessionStartRequest.fromJson(<String, Object?>{}),
        throwsFormatException,
      );
    },
  );

  test('profile patches preserve omissions, require complete names and reject unsupported fields', () {
    final ApiProfilePatch photo = ApiProfilePatch(
      photoUrl: const ApiField<String>.present(
        'https://image.example.invalid/a.webp',
      ),
    );
    expect(photo.names.isPresent, isFalse);
    expect(photo.lastNames.isPresent, isFalse);
    expect(ApiProfilePatch.fromJson(photo.toJson()), photo);
    expect(photo.copyWith(), photo);
    final ApiProfilePatch names = photo.copyWith(
      names: const ApiField<String>.present('Example'),
      lastNames: const ApiField<String>.present('Person'),
      photoUrl: const ApiField<String>.absent(),
    );
    expect(names.photoUrl.isPresent, isFalse);
    expect(names.names.value, 'Example');
    expect(names.lastNames.value, 'Person');
    expect(ApiProfilePatch.fromJson(names.toJson()), names);
    expect(() => ApiProfilePatch(), throwsFormatException);
    expect(
      () => ApiProfilePatch(names: const ApiField<String>.present('Example')),
      throwsFormatException,
    );
    expect(
      () => photo.copyWith(photoUrl: const ApiField<String>.present(' ')),
      throwsFormatException,
    );
    expect(
      () => names.copyWith(names: const ApiField<String>.present(' ')),
      throwsFormatException,
    );
    expect(
      () => names.copyWith(lastNames: const ApiField<String>.present(' ')),
      throwsFormatException,
    );
    expect(
      () => ApiProfilePatch.fromJson(<String, Object?>{
        ...photo.toJson(),
        'attributes': <String, Object?>{},
      }),
      throwsFormatException,
    );
    expect(
      () => ApiProfilePatch.fromJson(<String, Object?>{'photoUrl': null}),
      throwsFormatException,
    );
  });

  test('address input has six required nonblank members and explicit optional defaults', () {
    final ApiAddressInput address = ApiAddressInput(
      id: 'address-1',
      country: 'CO',
      administrativeArea: 'Example',
      city: 'Example',
      locality: 'Example',
      address: 'Example',
    );
    expect(address.notes.isPresent, isFalse);
    expect(address.postalCode.isPresent, isFalse);
    expect(address.copyWith(), address);
    expect(ApiAddressInput.fromJson(address.toJson()), address);
    final ApiAddressInput full = address.copyWith(
      notes: const ApiField<String?>.present(null),
      postalCode: const ApiField<int>.present(0),
    );
    expect(full.notes.value, isNull);
    expect(full.postalCode.value, 0);
    expect(ApiAddressInput.fromJson(full.toJson()), full);
    for (final String key in <String>[
      'id',
      'country',
      'administrativeArea',
      'city',
      'locality',
      'address',
    ]) {
      expect(
        () => ApiAddressInput.fromJson(<String, Object?>{
          ...address.toJson(),
          key: ' ',
        }),
        throwsFormatException,
      );
      expect(
        () => ApiAddressInput.fromJson(
          <String, Object?>{...address.toJson()}..remove(key),
        ),
        throwsFormatException,
      );
    }
    expect(
      () => address.copyWith(postalCode: const ApiField<int>.present(-1)),
      throwsFormatException,
    );
  });

  test('legal input supports RUT and optional named JSON attributes without a legacy enum fallback', () {
    final ApiPersonalLegalIdDeclaration request = ApiPersonalLegalIdDeclaration(
      idType: 'RUT',
      names: 'Example',
      lastNames: 'Person',
      legalIdNumber: '000123',
    );
    expect(request.attributes.isPresent, isFalse);
    expect(request.copyWith(), request);
    expect(ApiPersonalLegalIdDeclaration.fromJson(request.toJson()), request);
    final ApiAttributeInput attribute = ApiAttributeInput(name: 'x');
    expect(attribute.value.isPresent, isFalse);
    expect(ApiAttributeInput.fromJson(attribute.toJson()), attribute);
    expect(attribute.copyWith(), attribute);
    final ApiPersonalLegalIdDeclaration withAttribute = request.copyWith(
      attributes: ApiField<Map<String, ApiAttributeInput>?>.present(
        <String, ApiAttributeInput>{
          'x': attribute.copyWith(value: const ApiField<Object?>.present(null)),
        },
      ),
    );
    expect(
      ApiPersonalLegalIdDeclaration.fromJson(withAttribute.toJson()),
      withAttribute,
    );
    expect(withAttribute.attributes.value!['x']!.value.value, isNull);
    expect(
      request
          .copyWith(
            attributes: const ApiField<Map<String, ApiAttributeInput>?>.present(
              null,
            ),
          )
          .attributes
          .value,
      isNull,
    );
    expect(() => request.copyWith(idType: 'NIT'), throwsFormatException);
    expect(() => request.copyWith(names: ' '), throwsFormatException);
    expect(() => request.copyWith(lastNames: ' '), throwsFormatException);
    expect(() => request.copyWith(legalIdNumber: ' '), throwsFormatException);
    expect(() => ApiAttributeInput(name: ' '), throwsFormatException);
    expect(
      () => ApiAttributeInput.fromJson(<String, Object?>{}),
      throwsFormatException,
    );
    for (final String key in <String>[
      'idType',
      'names',
      'lastNames',
      'legalIdNumber',
    ]) {
      expect(
        () => ApiPersonalLegalIdDeclaration.fromJson(
          <String, Object?>{...request.toJson()}..remove(key),
        ),
        throwsFormatException,
      );
    }
  });

  test('media input keeps functional identity, optional fields and local validation without I/O', () {
    final ApiMediaUploadRequest request = ApiMediaUploadRequest(
      intentKey: 'people_me.profilePhoto',
      subjectRef: ApiMediaSubject.fromJson(subject),
      contentType: 'image/webp',
      sizeBytes: 100,
    );
    expect(request.fileName.isPresent, isFalse);
    expect(request.clientHash.isPresent, isFalse);
    expect(request.description.isPresent, isFalse);
    expect(request.copyWith(), request);
    expect(ApiMediaUploadRequest.fromJson(request.toJson()), request);
    final ApiMediaUploadRequest full = request.copyWith(
      fileName: const ApiField<String?>.present('a.webp'),
      clientHash: const ApiField<String?>.present(null),
      description: const ApiField<String?>.present('Example'),
    );
    expect(full.fileName.value, 'a.webp');
    expect(full.clientHash.value, isNull);
    expect(full.description.value, 'Example');
    expect(ApiMediaUploadRequest.fromJson(full.toJson()), full);
    expect(() => request.copyWith(sizeBytes: 0), throwsFormatException);
    expect(() => request.copyWith(sizeBytes: 1048577), throwsFormatException);
    expect(() => request.copyWith(intentKey: 'unknown'), throwsFormatException);
    expect(() => request.copyWith(contentType: ' '), throwsFormatException);
    expect(
      () => request.copyWith(contentType: 'image/png'),
      throwsFormatException,
    );
    expect(
      () => request.copyWith(
        subjectRef: request.subjectRef.copyWith(resourceId: 'invalid/id'),
      ),
      throwsFormatException,
    );
    expect(
      () => request.copyWith(
        subjectRef: request.subjectRef.copyWith(contextKey: 'commerce'),
      ),
      throwsFormatException,
    );
    expect(
      () => request.copyWith(description: ApiField<String?>.present('x' * 501)),
      throwsFormatException,
    );
    for (final String key in <String>[
      'intentKey',
      'subjectRef',
      'contentType',
      'sizeBytes',
    ]) {
      expect(
        () => ApiMediaUploadRequest.fromJson(
          <String, Object?>{...request.toJson()}..remove(key),
        ),
        throwsFormatException,
      );
    }
    final ApiMediaUploadRequest commercial = ApiMediaUploadRequest(
      intentKey: 'commerce.itemImage',
      subjectRef: ApiMediaSubject(
        contextKey: 'commerce',
        resourceType: 'inventoryItem',
        resourceId: 'store-1:item-1',
      ),
      contentType: 'image/png',
      sizeBytes: 512000,
    );
    expect(commercial.sizeBytes, 512000);
  });

  test('operation-specific literals and name constraints fail explicitly', () {
    expect(
      () => ApiSessionStatus.fromJson(<String, Object?>{
        ...session,
        'status': 'unknown',
      }),
      throwsFormatException,
    );
    expect(
      () => ApiAuthenticationState(
        session: ApiSessionStatus.fromJson(session),
        user: ApiAuthenticatedUser.fromJson(<String, Object?>{
          ...user,
          'userId': 'other',
        }),
      ),
      throwsFormatException,
    );
    expect(
      () => ApiIdempotencyContext(contextType: '', contextId: 'id'),
      throwsFormatException,
    );
    expect(
      () => ApiIdempotencyContext(contextType: 'x', contextId: ' '),
      throwsFormatException,
    );
    expect(
      () => ApiIdempotencyRequest(
        operationType: 'other',
        contextRef: ApiIdempotencyContext.fromJson(context),
      ),
      throwsFormatException,
    );
    expect(
      () => ApiIssuedIdempotencyKey(
        idempotencyKey: 'x',
        operationType: 'x',
        contextRef: ApiIdempotencyContext.fromJson(context),
        status: 'executed',
        expiresAtIso: '',
      ),
      throwsFormatException,
    );
    expect(() => ApiMediaConfirmRequest(uploadId: ''), throwsFormatException);
    expect(() => ApiMediaReadRequest(variantKey: ' '), throwsFormatException);
    expect(
      () => ApiMediaReadTarget.fromJson(<String, Object?>{
        ...readTarget,
        'targetType': 'other',
      }),
      throwsFormatException,
    );
    expect(
      () => ApiMediaReadTarget.fromJson(<String, Object?>{
        ...readTarget,
        'method': 'PUT',
      }),
      throwsFormatException,
    );
    expect(
      () => ApiResolveUserByEmailRequest(email: ' '),
      throwsFormatException,
    );
  });
}
