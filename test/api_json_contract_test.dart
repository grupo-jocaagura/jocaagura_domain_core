import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

void main() {
  test(
    'API object owns its complete JSON tree and exports independent copies',
    () {
      final List<Object?> nested = <Object?>[
        1,
        <String, Object?>{'value': 'original'},
        null,
        true,
        1.5,
      ];
      final ApiJsonObject value = ApiJsonObject(<String, Object?>{
        'nested': nested,
      });
      nested[0] = 2;
      final Map<String, dynamic> copy = value.toJson();
      (copy['nested'] as List<Object?>)[0] = 3;
      expect((value['nested']! as List<Object?>)[0], 1);
      expect(
        () => (value['nested']! as List<Object?>).add('x'),
        throwsUnsupportedError,
      );
      expect(value.containsKey('nested'), isTrue);
      expect(value.containsKey('missing'), isFalse);
      expect(value['missing'], isNull);
      final ApiJsonObject restored = ApiJsonObject(
        jsonDecode(jsonEncode(value.toJson())) as Map<String, Object?>,
      );
      expect(restored, value);
      expect(restored.hashCode, value.hashCode);
      expect(value == Object(), isFalse);
      expect(ApiJsonObject(<String, Object?>{'other': 1}), isNot(value));
    },
  );

  test(
    'API JSON rejects non-JSON values, keys, cycles and non-finite numbers',
    () {
      for (final Object invalid in <Object>[
        Object(),
        DateTime.utc(2024),
        double.nan,
        double.infinity,
      ]) {
        expect(
          () => ApiJsonObject(<String, Object?>{'invalid': invalid}),
          throwsFormatException,
        );
      }
      expect(
        () => ApiJsonObject(<String, Object?>{
          'invalid': <Object?, Object?>{1: 'x'},
        }),
        throwsFormatException,
      );
      final Map<String, Object?> cycle = <String, Object?>{};
      cycle['self'] = cycle;
      expect(() => ApiJsonObject(cycle), throwsFormatException);
      final List<Object?> list = <Object?>[];
      list.add(list);
      expect(
        () => ApiJsonObject(<String, Object?>{'list': list}),
        throwsFormatException,
      );
      final Map<String, Object?> shared = <String, Object?>{'same': true};
      expect(
        ApiJsonObject(<String, Object?>{'a': shared, 'b': shared})
            .toJson()['a'],
        shared,
      );
    },
  );

  test(
    'strict API readers reject coercion instead of changing legacy helpers',
    () {
      final Map<String, Object?> json = <String, Object?>{
        'text': '',
        'number': 1,
        'flag': false,
      };
      expect(ApiJson.string(json, 'text'), '');
      expect(ApiJson.integer(json, 'number'), 1);
      expect(ApiJson.boolean(json, 'flag'), isFalse);
      expect(ApiJson.object(json, 'root'), same(json));
      expect(ApiJson.array(<Object?>[], 'items'), isEmpty);
      expect(() => ApiJson.string(json, 'missing'), throwsFormatException);
      expect(() => ApiJson.string(json, 'number'), throwsFormatException);
      expect(
        () => ApiJson.integer(<String, Object?>{'n': 1.0}, 'n'),
        throwsFormatException,
      );
      expect(
        () => ApiJson.boolean(<String, Object?>{'b': 'true'}, 'b'),
        throwsFormatException,
      );
      expect(() => ApiJson.object(<Object?>[], 'data'), throwsFormatException);
      expect(
        () => ApiJson.array(<String, Object?>{}, 'items'),
        throwsFormatException,
      );
    },
  );

  test('partial updates distinguish omitted members, explicit null and empty values', () {
    final ApiField<String?> missing = ApiField.fromJson<String?>(
      <String, Object?>{},
      'name',
      (Object? value) => value as String?,
    );
    final ApiField<String?> cleared = ApiField.fromJson<String?>(
      <String, Object?>{'name': null},
      'name',
      (Object? value) => value as String?,
    );
    const ApiField<String?> empty = ApiField<String?>.present('');
    expect(missing.isPresent, isFalse);
    expect(() => missing.value, throwsStateError);
    expect(cleared.isPresent, isTrue);
    expect(cleared.value, isNull);
    expect(empty.value, '');
    final Map<String, Object?> encoded = <String, Object?>{};
    missing.writeTo(encoded, 'missing', (String? value) => value);
    cleared.writeTo(encoded, 'clear', (String? value) => value);
    empty.writeTo(encoded, 'empty', (String? value) => value);
    expect(encoded, <String, Object?>{'clear': null, 'empty': ''});
    expect(missing.map<int>((String? value) => 1).isPresent, isFalse);
    expect(empty.map<int>((String? value) => value!.length).value, 0);
  });

  test('common success envelope delegates only the documented data object', () {
    final ApiEnvelope<ApiJsonObject> value =
        ApiEnvelope<ApiJsonObject>.fromJson(<String, Object?>{
          'ok': true,
          'data': <String, Object?>{'message': 'Example'},
          'extra': 1,
        }, ApiJsonObject.new);
    expect(value, isA<ApiSuccess<ApiJsonObject>>());
    expect(value.isSuccess, isTrue);
    expect((value as ApiSuccess<ApiJsonObject>).data['message'], 'Example');
    expect(
      value.toJson((ApiJsonObject data) => data.toJson()),
      <String, Object?>{
        'ok': true,
        'data': <String, Object?>{'message': 'Example'},
      },
    );
    expect(
      () => ApiEnvelope<ApiJsonObject>.fromJson(<String, Object?>{
        'ok': true,
        'data': null,
      }, ApiJsonObject.new),
      throwsFormatException,
    );
    expect(
      () => ApiEnvelope<ApiJsonObject>.fromJson(
        <String, Object?>{},
        ApiJsonObject.new,
      ),
      throwsFormatException,
    );
  });

  test('common failure envelope preserves code/severity and owns opaque JSON metadata', () {
    for (final ErrorLevelEnum level in ErrorLevelEnum.values) {
      final Map<String, Object?> meta = <String, Object?>{
        'nested': <Object?>[1, null],
      };
      final Map<String, Object?> json = <String, Object?>{
        'ok': false,
        'error': <String, Object?>{
          'title': 'Synthetic',
          'code': 'EXAMPLE',
          'description': 'Example failure',
          'meta': meta,
          'errorLevel': level.name,
        },
      };
      final ApiEnvelope<ApiJsonObject> value =
          ApiEnvelope<ApiJsonObject>.fromJson(json, ApiJsonObject.new);
      expect(value.isSuccess, isFalse);
      final ApiFailure<ApiJsonObject> failure =
          value as ApiFailure<ApiJsonObject>;
      expect(failure.error.code, 'EXAMPLE');
      expect(failure.error.errorLevel, level);
      expect(failure.toJson((ApiJsonObject data) => data.toJson()), json);
      meta['new'] = 1;
      expect(failure.error.meta.containsKey('new'), isFalse);
      expect(() => failure.error.meta['new'] = 1, throwsUnsupportedError);
    }
    final Map<String, Object?> error = <String, Object?>{
      'title': '',
      'code': 'E',
      'description': '',
      'meta': <String, Object?>{},
      'errorLevel': 'unknown',
    };
    expect(
      () => ApiEnvelope<ApiJsonObject>.fromJson(<String, Object?>{
        'ok': false,
        'error': error,
      }, ApiJsonObject.new),
      throwsFormatException,
    );
    error['errorLevel'] = 'warning';
    error['meta'] = null;
    expect(
      () => ApiEnvelope<ApiJsonObject>.fromJson(<String, Object?>{
        'ok': false,
        'error': error,
      }, ApiJsonObject.new),
      throwsFormatException,
    );
    expect(
      () => ApiEnvelope<ApiJsonObject>.fromJson(<String, Object?>{
        'ok': false,
      }, ApiJsonObject.new),
      throwsFormatException,
    );
    expect(
      () => ApiFailure<ApiJsonObject>(
        const ErrorItem(
          title: '',
          code: '',
          description: '',
          meta: <String, dynamic>{'x': Object()},
        ),
      ),
      throwsFormatException,
    );
  });
}
