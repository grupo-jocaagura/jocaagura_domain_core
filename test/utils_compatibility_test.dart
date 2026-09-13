// Characterization cases adapted from backend_bienvenido at
// 993b2d10d804d5715c6719d08c2ef64d4837d1bb, test/core/utils_test.dart.
// Duplicate ID cases and probabilistic uniqueness assertions were omitted.
import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

enum _PaymentStatus { pending, completed, failed }

void main() {
  group('Utils.generatePrefixedId', () {
    test('Given a valid prefix When an id is generated Then it uses six random base36 characters by default', () {
      // Act
      final String id = Utils.generatePrefixedId('Person');

      // Assert
      expect(id, matches(RegExp(r'^person-[0-9a-z]+-[0-9a-z]{6}$')));
    });

    test('Given a custom random space When an id is generated Then the random segment uses that length', () {
      // Act
      final String id = Utils.generatePrefixedId('Person', 4);

      // Assert
      expect(id, matches(RegExp(r'^person-[0-9a-z]+-[0-9a-z]{4}$')));
    });

    test('Given a random space lower than one When an id is generated Then random segment is clamped to one character', () {
      // Act
      final String id = Utils.generatePrefixedId('Person', 0);

      // Assert
      expect(id, matches(RegExp(r'^person-[0-9a-z]+-[0-9a-z]{1}$')));
    });

    test('Given a random space greater than six When an id is generated Then random segment is clamped to six characters', () {
      // Act
      final String id = Utils.generatePrefixedId('Person', 12);

      // Assert
      expect(id, matches(RegExp(r'^person-[0-9a-z]+-[0-9a-z]{6}$')));
    });

    test('Given a prefix with spaces uppercase numbers and symbols When an id is generated Then only lowercase ascii letters remain', () {
      // Act
      final String id = Utils.generatePrefixedId('  Person_ID-01  ');

      // Assert
      expect(id, startsWith('personid-'));
      expect(id, matches(RegExp(r'^personid-[0-9a-z]+-[0-9a-z]{6}$')));
    });

    test('Given an invalid prefix When an id is generated Then an empty string is returned', () {
      // Act
      final String id = Utils.generatePrefixedId('  123-_*  ');

      // Assert
      expect(id, '');
    });
  });

  group('Utils.generateSecureToken', () {
    test('Given a session prefix When a token is generated Then it is opaque and URL safe', () {
      final String token = Utils.generateSecureToken(prefix: 'sess');

      expect(token, matches(RegExp(r'^sess_[A-Za-z0-9_-]{43}$')));
      expect(token, isNot(contains('=')));
      expect(token, isNot(contains('+')));
      expect(token, isNot(contains('/')));
      expect(token, isNot(contains('user-001')));
    });

    test('Given no prefix When a token is generated Then only the random token is returned', () {
      final String token = Utils.generateSecureToken();

      expect(token, matches(RegExp(r'^[A-Za-z0-9_-]{43}$')));
    });

    test('Given an unsafe prefix When a token is generated Then it is normalized and separated by underscore', () {
      final String token = Utils.generateSecureToken(prefix: '  Sess Token!  ');

      expect(token, matches(RegExp(r'^sesstoken_[A-Za-z0-9_-]{43}$')));
    });

    test('Given a short byte length When a token is generated Then at least sixteen bytes are used', () {
      final String token = Utils.generateSecureToken(
        prefix: 'sess',
        byteLength: 1,
      );

      expect(token, matches(RegExp(r'^sess_[A-Za-z0-9_-]{22}$')));
    });
  });

  group('Utils.durationToJson and Utils.durationFromJson', () {
    test('Given a duration When serialized Then milliseconds are returned', () {
      // Arrange
      const Duration duration = Duration(
        hours: 1,
        minutes: 2,
        seconds: 3,
        milliseconds: 4,
      );

      // Act
      final int milliseconds = Utils.durationToJson(duration);

      // Assert
      expect(milliseconds, 3723004);
    });

    test('Given an integer milliseconds value When parsed Then a duration is returned', () {
      // Act
      final Duration duration = Utils.durationFromJson(1500);
      final Duration duration2 = Utils.durationFromJson(1500.2);

      // Assert
      expect(duration, const Duration(milliseconds: 1500));
      expect(duration2, const Duration(milliseconds: 1500));
    });
    test('Given an integer milliseconds string When parsed Then a duration with those milliseconds is returned', () {
      // Act
      final Duration result = Utils.durationFromJson('1500');

      // Assert
      expect(result, const Duration(milliseconds: 1500));
    });

    test('Given an integer milliseconds string with spaces When parsed Then spaces are trimmed and a duration is returned', () {
      // Act
      final Duration result = Utils.durationFromJson('  2500  ');

      // Assert
      expect(result, const Duration(milliseconds: 2500));
    });

    test('Given a negative integer milliseconds string When parsed Then a negative duration is returned', () {
      // Act
      final Duration result = Utils.durationFromJson('-500');

      // Assert
      expect(result, const Duration(milliseconds: -500));
    });

    test('Given a positive signed integer milliseconds string When parsed Then a duration is returned', () {
      // Act
      final Duration result = Utils.durationFromJson('+750');

      // Assert
      expect(result, const Duration(milliseconds: 750));
    });

    test('Given a decimal milliseconds string When parsed Then the value is truncated toward zero', () {
      // Act
      final Duration duration = Utils.durationFromJson('1500.9');

      // Assert
      expect(duration, const Duration(milliseconds: 1500));
    });

    test(
      'Given an HH MM SS string When parsed Then a duration is returned',
      () {
        // Act
        final Duration duration = Utils.durationFromJson('01:02:03.004');

        // Assert
        expect(
          duration,
          const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4),
        );
      },
    );

    test('Given an MM SS string When parsed Then a duration is returned', () {
      // Act
      final Duration duration = Utils.durationFromJson('02:03.004');

      // Assert
      expect(duration, const Duration(minutes: 2, seconds: 3, milliseconds: 4));
    });

    test('Given an ISO8601 duration string When parsed Then a duration is returned', () {
      // Act
      final Duration duration = Utils.durationFromJson('P1DT2H3M4.5S');

      // Assert
      expect(
        duration,
        const Duration(hours: 26, minutes: 3, seconds: 4, milliseconds: 500),
      );
    });

    test('Given a shorthand duration string When parsed Then a duration is returned', () {
      // Act
      final Duration duration = Utils.durationFromJson('2h45m3.5s');

      // Assert
      expect(
        duration,
        const Duration(hours: 2, minutes: 45, seconds: 3, milliseconds: 500),
      );
    });

    test('Given an invalid duration value When parsed Then the default duration is returned', () {
      // Arrange
      const Duration fallback = Duration(seconds: 7);

      // Act
      final Duration duration = Utils.durationFromJson(
        'invalid',
        defaultDuration: fallback,
      );

      // Assert
      expect(duration, fallback);
    });

    test('Given NaN as duration input When parsed Then the default duration is returned', () {
      // Arrange
      const Duration fallback = Duration(seconds: 5);

      // Act
      final Duration duration = Utils.durationFromJson(
        double.nan,
        defaultDuration: fallback,
      );

      // Assert
      expect(duration, fallback);
    });
  });

  group('Utils.enumFromJson', () {
    test('Given a valid enum name When decoded Then the matching enum value is returned', () {
      // Act
      final _PaymentStatus status = Utils.enumFromJson<_PaymentStatus>(
        _PaymentStatus.values,
        'completed',
        _PaymentStatus.failed,
      );

      // Assert
      expect(status, _PaymentStatus.completed);
    });

    test(
      'Given an unknown enum name When decoded Then the fallback is returned',
      () {
        // Act
        final _PaymentStatus status = Utils.enumFromJson<_PaymentStatus>(
          _PaymentStatus.values,
          'unknown',
          _PaymentStatus.failed,
        );

        // Assert
        expect(status, _PaymentStatus.failed);
      },
    );

    test(
      'Given a null enum name When decoded Then the fallback is returned',
      () {
        // Act
        final _PaymentStatus status = Utils.enumFromJson<_PaymentStatus>(
          _PaymentStatus.values,
          null,
          _PaymentStatus.pending,
        );

        // Assert
        expect(status, _PaymentStatus.pending);
      },
    );
  });

  group('Utils.stringListFromDynamic', () {
    test(
      'Given a native list When converted Then each element is stringified',
      () {
        // Act
        final List<String> result = Utils.stringListFromDynamic(<Object?>[
          'a',
          1,
          true,
          null,
        ]);

        // Assert
        expect(result, <String>['a', '1', 'true', 'null']);
      },
    );

    test(
      'Given a JSON array string When converted Then a string list is returned',
      () {
        // Act
        final List<String> result = Utils.stringListFromDynamic(
          '["a", 2, false]',
        );

        // Assert
        expect(result, <String>['a', '2', 'false']);
      },
    );

    test('Given a scalar JSON value When converted Then a single item list is returned', () {
      // Act
      final List<String> result = Utils.stringListFromDynamic('42');

      // Assert
      expect(result, <String>['42']);
    });

    test('Given an invalid JSON string When converted Then an empty list is returned', () {
      // Act
      final List<String> result = Utils.stringListFromDynamic('oops');

      // Assert
      expect(result, const <String>[]);
    });

    test('Given null When converted Then an empty list is returned', () {
      // Act
      final List<String> result = Utils.stringListFromDynamic(null);

      // Assert
      expect(result, const <String>[]);
    });
  });

  group('Utils numeric parsing', () {
    test('Given a Colombian formatted numeric string When converted to int Then thousands and decimals are handled', () {
      // Act
      final int result = Utils.getIntegerFromDynamic('  1.234,56 COP ');
      final int result2 = Utils.getIntegerFromDynamic(1.2);

      // Assert
      expect(result, 1234);
      expect(result2, 1);
    });
    test('Given a num that isNan or infinite return defalult value', () {
      const num check = double.nan;
      // Act
      final double result = Utils.getDouble(check, 3);

      // Assert
      expect(result, 3);
    });
    test('Given a US formatted numeric string When converted to double Then thousands and decimals are handled', () {
      // Act
      final double result = Utils.getDouble(r'  $1,234.56  ', 0.0);

      // Assert
      expect(result, 1234.56);
    });

    test('Given scientific notation When converted to int Then parsed value is truncated', () {
      // Act
      final int result = Utils.getIntegerFromDynamic('3e2');

      // Assert
      expect(result, 300);
    });

    test('Given invalid double input When converted Then default value is returned', () {
      // Act
      final double result = Utils.getDouble('invalid', 7.5);

      // Assert
      expect(result, 7.5);
    });

    test(
      'Given NaN double input When converted to int Then zero is returned',
      () {
        // Act
        final int result = Utils.getIntegerFromDynamic(double.nan);

        // Assert
        expect(result, 0);
      },
    );
  });
  group('Utils.convertJsonToList', () {
    test('Given null When converted Then an empty list is returned', () {
      // Act
      final List<String> result = Utils.convertJsonToList(null);

      // Assert
      expect(result, const <String>[]);
    });

    test('Given a JSON list When converted Then each item is stringified', () {
      // Act
      final List<String> result = Utils.convertJsonToList(
        '["a", 1, true, null]',
      );

      // Assert
      expect(result, <String>['a', '1', 'true', 'null']);
    });

    test(
      'Given a JSON scalar When converted Then a single item list is returned',
      () {
        // Act
        final List<String> result = Utils.convertJsonToList('42');

        // Assert
        expect(result, <String>['42']);
      },
    );

    test('Given a JSON object When converted Then a single map string item is returned', () {
      // Act
      final List<String> result = Utils.convertJsonToList('{"a":1}');

      // Assert
      expect(result, <String>['{a: 1}']);
    });

    test(
      'Given invalid JSON When converted Then an empty list is returned',
      () {
        // Act
        final List<String> result = Utils.convertJsonToList('oops');

        // Assert
        expect(result, const <String>[]);
      },
    );
  });
  group('Utils.getBoolFromDynamic', () {
    test('Given null and a default value When converted Then the default value is returned', () {
      // Act
      final bool result = Utils.getBoolFromDynamic(
        null,
        defaultValueIfNull: true,
      );

      // Assert
      expect(result, isTrue);
    });

    test('Given null without a default value When converted Then false is returned', () {
      // Act
      final bool result = Utils.getBoolFromDynamic(null);

      // Assert
      expect(result, isFalse);
    });

    test('Given true When converted Then true is returned', () {
      // Act
      final bool result = Utils.getBoolFromDynamic(true);

      // Assert
      expect(result, isTrue);
    });

    test('Given false When converted Then false is returned', () {
      // Act
      final bool result = Utils.getBoolFromDynamic(false);

      // Assert
      expect(result, isFalse);
    });

    test('Given a truthy string When converted Then false is returned because only boolean true is accepted', () {
      // Act
      final bool result = Utils.getBoolFromDynamic('true');

      // Assert
      expect(result, isFalse);
    });
    group('Utils.listFromDynamic', () {
      test(
        'Given a non list value When converted Then an empty list is returned',
        () {
          // Act
          final List<Map<String, dynamic>> result = Utils.listFromDynamic(
            'not-a-list',
          );

          // Assert
          expect(result, const <Map<String, dynamic>>[]);
        },
      );

      test('Given a list with string keyed maps When converted Then maps are preserved', () {
        // Arrange
        final Map<String, dynamic> first = <String, dynamic>{'a': 1};
        final Map<String, dynamic> second = <String, dynamic>{'b': true};

        // Act
        final List<Map<String, dynamic>> result = Utils.listFromDynamic(
          <dynamic>[first, second],
        );

        // Assert
        expect(result, <Map<String, dynamic>>[
          <String, dynamic>{'a': 1},
          <String, dynamic>{'b': true},
        ]);
      });

      test('Given a list with raw maps When converted Then map keys are stringified', () {
        // Act
        final List<Map<String, dynamic>> result = Utils.listFromDynamic(
          <dynamic>[
            <Object, Object>{1: 'one', true: 2},
          ],
        );

        // Assert
        expect(result, <Map<String, dynamic>>[
          <String, dynamic>{'1': 'one', 'true': 2},
        ]);
      });

      test(
        'Given a mixed list When converted Then non map elements are ignored',
        () {
          // Act
          final List<Map<String, dynamic>> result = Utils.listFromDynamic(
            <dynamic>[
              <String, dynamic>{'a': 1},
              'noise',
              42,
              null,
              <Object, Object>{2: 'x'},
            ],
          );

          // Assert
          expect(result, <Map<String, dynamic>>[
            <String, dynamic>{'a': 1},
            <String, dynamic>{'2': 'x'},
          ]);
        },
      );

      test(
        'Given an empty list When converted Then an empty list is returned',
        () {
          // Act
          final List<Map<String, dynamic>> result = Utils.listFromDynamic(
            <dynamic>[],
          );

          // Assert
          expect(result, const <Map<String, dynamic>>[]);
        },
      );
    });
    test('Given a non boolean value When converted Then false is returned', () {
      // Act
      final bool result = Utils.getBoolFromDynamic(1);

      // Assert
      expect(result, isFalse);
    });
  });
  group('Utils map and list conversions', () {
    test('Given a null value return an empty map', () {
      // Act
      final Map<String, dynamic> result = Utils.mapFromDynamic(null);

      // Assert
      expect(result, <String, dynamic>{});
    });

    test('Given a JSON map string When converted Then a string keyed map is returned', () {
      // Act
      final Map<String, dynamic> result = Utils.mapFromDynamic('{"a":1}');

      // Assert
      expect(result, <String, dynamic>{'a': 1});
    });

    test('Given a raw map with non string keys When converted Then keys are stringified', () {
      // Act
      final Map<String, dynamic> result = Utils.mapFromDynamic(<Object, Object>{
        1: true,
        'b': 2,
      });

      // Assert
      expect(result, <String, dynamic>{'1': true, 'b': 2});
    });

    test(
      'Given an invalid map input When converted Then an empty map is returned',
      () {
        // Act
        final Map<String, dynamic> result = Utils.mapFromDynamic('oops');

        // Assert
        expect(result, const <String, dynamic>{});
      },
    );

    test('Given a dynamic list with maps and noise When converted Then only maps are kept', () {
      // Act
      final List<Map<String, dynamic>> result = Utils.listFromDynamic(<dynamic>[
        <String, dynamic>{'a': 1},
        <Object, Object>{2: 'x'},
        'noise',
        null,
      ]);

      // Assert
      expect(result, <Map<String, dynamic>>[
        <String, dynamic>{'a': 1},
        <String, dynamic>{'2': 'x'},
      ]);
    });
  });

  group('Utils validation and formatting', () {
    test('Given a valid email When validated Then true is returned', () {
      // Act
      final bool result = Utils.isEmail('test.user+demo@example.com');

      // Assert
      expect(result, isTrue);
    });

    test('Given an invalid email When extracted from dynamic Then empty string is returned', () {
      // Act
      final String result = Utils.getEmailFromDynamic('invalid');

      // Assert
      expect(result, '');
    });

    test('Given a valid https URL When validated Then true is returned', () {
      // Act
      final bool result = Utils.isValidUrl('https://example.com/path');

      // Assert
      expect(result, isTrue);
    });

    test('Given an invalid URL When extracted from dynamic Then empty string is returned', () {
      // Act
      final String result = Utils.getUrlFromDynamic('not-a-url');

      // Assert
      expect(result, '');
    });

    test('Given a phone number When formatted Then the legacy grouped format is returned', () {
      // Act
      final String result = Utils.getFormatedPhoneNumber(3001234567);
      final String result2 = Utils.getFormattedPhoneNumber(3001234567);

      // Assert
      expect(result, '(30) 0 123 4567');
      expect(result2, '(30) 0 123 4567');
    });

    test('Given a phone number When formatted with alt formatter Then the alternate grouped format is returned', () {
      // Act
      final String result = Utils.getFormatedPhoneNumberAlt(3001234567);
      final String result2 = Utils.getFormattedPhoneNumberAlt(3001234567);

      // Assert
      expect(result, '300 123 4567');
      expect(result2, '300 123 4567');
    });
  });

  group('Utils.getJsonEncode', () {
    test('Given an encodable map When encoded Then a valid JSON string is returned', () {
      // Arrange
      final Map<String, dynamic> map = <String, dynamic>{
        'name': 'Ana',
        'age': 30,
        'active': true,
        'tags': <String>['flutter', 'dart'],
      };

      // Act
      final String result = Utils.getJsonEncode(map);

      // Assert
      expect(
        result,
        '{"name":"Ana","age":30,"active":true,"tags":["flutter","dart"]}',
      );
    });

    test('Given an unencodable map When encoded Then an error map string is returned', () {
      // Arrange
      final Map<String, dynamic> map = <String, dynamic>{'bad': Object()};

      // Act
      final String result = Utils.mapToString(map);

      // Assert
      expect(result, startsWith('{error: '));
      expect(
        result,
        contains('Converting object to an encodable object failed'),
      );
      expect(result, endsWith('}'));
    });

    test('Given an encodable map When mapToString is called Then it delegates to getJsonEncode', () {
      // Arrange
      final Map<String, dynamic> map = <String, dynamic>{'key': 'value'};

      // Act
      final String result = Utils.mapToString(map);

      // Assert
      expect(result, '{"key":"value"}');
    });
  });

  group('Utils equality and hashing', () {
    test('Given two equal lists When compared Then true is returned', () {
      // Arrange
      final List<int> a = <int>[1, 2, 3];
      final List<int> b = <int>[1, 2, 3];

      // Act
      final bool result = Utils.listEquals<int>(a, b);

      // Assert
      expect(result, isTrue);
    });

    test('Given two lists with different order When compared Then false is returned', () {
      // Arrange
      final List<int> a = <int>[1, 2, 3];
      final List<int> b = <int>[3, 2, 1];

      // Act
      final bool result = Utils.listEquals<int>(a, b);

      // Assert
      expect(result, isFalse);
    });

    test('Given two deep equal maps with different key order When compared Then true is returned', () {
      // Arrange
      final Map<String, dynamic> a = <String, dynamic>{
        'user': <String, dynamic>{
          'id': 1,
          'tags': <String>['a', 'b'],
        },
        'ok': true,
      };
      final Map<String, dynamic> b = <String, dynamic>{
        'ok': true,
        'user': <String, dynamic>{
          'tags': <String>['a', 'b'],
          'id': 1,
        },
      };

      // Act
      final bool result = Utils.deepEqualsMap(a, b);

      // Assert
      expect(result, isTrue);
    });

    test('Given two maps with different nested list order When compared Then false is returned', () {
      // Arrange
      final Map<String, dynamic> a = <String, dynamic>{
        'items': <int>[1, 2, 3],
      };
      final Map<String, dynamic> b = <String, dynamic>{
        'items': <int>[3, 2, 1],
      };

      // Act
      final bool result = Utils.deepEqualsMap(a, b);

      // Assert
      expect(result, isFalse);
    });

    test('Given two deep equal maps with different key order When hashed Then hashes are equal', () {
      // Arrange
      final Map<String, dynamic> a = <String, dynamic>{
        'x': 1,
        'y': <String>['a', 'b'],
      };
      final Map<String, dynamic> b = <String, dynamic>{
        'y': <String>['a', 'b'],
        'x': 1,
      };

      // Act
      final int hashA = Utils.deepHash(a);
      final int hashB = Utils.deepHash(b);

      // Assert
      expect(hashA, hashB);
    });

    test('Given NaN values When deeply compared Then false is returned', () {
      // Act
      final bool result = Utils.deepEqualsDynamic(double.nan, double.nan);

      // Assert
      expect(result, isFalse);
    });
  });

  group('Utils.normalizeNumberString', () {
    test('Given an empty string When normalized Then null is returned', () {
      // Act
      final String? result = Utils.normalizeNumberString('');

      // Assert
      expect(result, isNull);
    });

    test(
      'Given only non numeric symbols When normalized Then null is returned',
      () {
        // Act
        final String? result = Utils.normalizeNumberString(r'COP $');

        // Assert
        expect(result, isNull);
      },
    );

    test('Given a plain integer string When normalized Then the same value is returned', () {
      // Act
      final String? result = Utils.normalizeNumberString('1234');

      // Assert
      expect(result, '1234');
    });

    test('Given a plain decimal string When normalized Then the same value is returned', () {
      // Act
      final String? result = Utils.normalizeNumberString('1234.56');

      // Assert
      expect(result, '1234.56');
    });

    test('Given a string with non breaking spaces When normalized Then spaces are handled', () {
      // Arrange
      const String value = '\u00A0 1234 \u202F';

      // Act
      final String? result = Utils.normalizeNumberString(value);

      // Assert
      expect(result, '1234');
    });

    test('Given a Colombian formatted value When normalized Then comma becomes decimal separator', () {
      // Act
      final String? result = Utils.normalizeNumberString('1.234,56 COP');

      // Assert
      expect(result, '1234.56');
    });

    test('Given a US formatted value When normalized Then comma is removed as thousands separator', () {
      // Act
      final String? result = Utils.normalizeNumberString(r'$1,234.56');

      // Assert
      expect(result, '1234.56');
    });

    test('Given a value with only one comma When normalized Then comma becomes decimal separator', () {
      // Act
      final String? result = Utils.normalizeNumberString('1234,56');

      // Assert
      expect(result, '1234.56');
    });

    test('Given a value with multiple commas When normalized Then commas are removed as thousands separators', () {
      // Act
      final String? result = Utils.normalizeNumberString('1,234,567');

      // Assert
      expect(result, '1234567');
    });

    test('Given a value with multiple dots When normalized Then dots are removed as thousands separators', () {
      // Act
      final String? result = Utils.normalizeNumberString('1.234.567');

      // Assert
      expect(result, '1234567');
    });

    test('Given a signed value When normalized Then the sign is preserved', () {
      // Act
      final String? result = Utils.normalizeNumberString('-1.234,56');

      // Assert
      expect(result, '-1234.56');
    });

    test('Given a positive signed value When normalized Then the positive sign is preserved', () {
      // Act
      final String? result = Utils.normalizeNumberString('+1,234.56');

      // Assert
      expect(result, '+1234.56');
    });

    test(
      'Given scientific notation When normalized Then exponent is preserved',
      () {
        // Act
        final String? result = Utils.normalizeNumberString('3e2');

        // Assert
        expect(result, '3e2');
      },
    );

    test('Given scientific notation with decimal comma When normalized Then exponent and decimal are preserved', () {
      // Act
      final String? result = Utils.normalizeNumberString('1,5e3');

      // Assert
      expect(result, '1.5e3');
    });

    test('Given a value with duplicated decimal dots When normalized Then only the first decimal dot is kept', () {
      // Act
      final String? result = Utils.normalizeNumberString('12.3.4');

      // Assert
      expect(result, '1234');
    });

    test('Given only a minus sign When normalized Then null is returned', () {
      // Act
      final String? result = Utils.normalizeNumberString('-');

      // Assert
      expect(result, isNull);
    });

    test('Given only a plus sign When normalized Then null is returned', () {
      // Act
      final String? result = Utils.normalizeNumberString('+');

      // Assert
      expect(result, isNull);
    });

    test('Given only a decimal dot When normalized Then null is returned', () {
      // Act
      final String? result = Utils.normalizeNumberString('.');

      // Assert
      expect(result, isNull);
    });

    test('Given signed decimal dot When normalized Then null is returned', () {
      // Act
      final String? result = Utils.normalizeNumberString('-.');

      // Assert
      expect(result, isNull);
    });
  });
  group('Utils.listHash', () {
    test('Given an empty list When hashed Then zero is returned', () {
      // Arrange
      final List<int> values = <int>[];

      // Act
      final int result = Utils.listHash<int>(values);

      // Assert
      expect(result, 0);
    });

    test('Given two lists with the same values in the same order When hashed Then hashes are equal', () {
      // Arrange
      final List<String> first = <String>['a', 'b', 'c'];
      final List<String> second = <String>['a', 'b', 'c'];

      // Act
      final int firstHash = Utils.listHash<String>(first);
      final int secondHash = Utils.listHash<String>(second);

      // Assert
      expect(firstHash, secondHash);
    });

    test('Given two lists with the same values in different order When hashed Then hashes are different', () {
      // Arrange
      final List<String> first = <String>['a', 'b', 'c'];
      final List<String> second = <String>['c', 'b', 'a'];

      // Act
      final int firstHash = Utils.listHash<String>(first);
      final int secondHash = Utils.listHash<String>(second);

      // Assert
      expect(firstHash, isNot(secondHash));
    });

    test('Given a list with nullable values When hashed Then a stable integer hash is returned', () {
      // Arrange
      final List<String?> values = <String?>['a', null, 'c'];

      // Act
      final int firstHash = Utils.listHash<String?>(values);
      final int secondHash = Utils.listHash<String?>(values);

      // Assert
      expect(firstHash, isA<int>());
      expect(firstHash, secondHash);
    });

    test('Given two equal lists When compared and hashed Then equality implies same hash', () {
      // Arrange
      final List<int> first = <int>[1, 2, 3];
      final List<int> second = <int>[1, 2, 3];

      // Act
      final bool areEqual = Utils.listEquals<int>(first, second);
      final int firstHash = Utils.listHash<int>(first);
      final int secondHash = Utils.listHash<int>(second);

      // Assert
      expect(areEqual, isTrue);
      expect(firstHash, secondHash);
    });
  });
  group('Utils.safeId', () {
    test('Given a simple lowercase value When converted Then the same value is returned', () {
      // Act
      final String result = Utils.safeId('commerce');

      // Assert
      expect(result, 'commerce');
    });

    test('Given a value with surrounding spaces When converted Then spaces are trimmed', () {
      // Act
      final String result = Utils.safeId('  commerce  ');

      // Assert
      expect(result, 'commerce');
    });

    test(
      'Given uppercase letters When converted Then lowercase value is returned',
      () {
        // Act
        final String result = Utils.safeId('CommerceStore');

        // Assert
        expect(result, 'commercestore');
      },
    );

    test('Given words separated by spaces When converted Then spaces become hyphens', () {
      // Act
      final String result = Utils.safeId('Commerce Store');

      // Assert
      expect(result, 'commerce-store');
    });

    test('Given multiple non alphanumeric characters When converted Then they collapse into one hyphen', () {
      // Act
      final String result = Utils.safeId('Commerce___Store###01');

      // Assert
      expect(result, 'commerce-store-01');
    });

    test('Given leading and trailing symbols When converted Then surrounding hyphens are removed', () {
      // Act
      final String result = Utils.safeId('---Commerce Store---');

      // Assert
      expect(result, 'commerce-store');
    });

    test('Given letters numbers and symbols When converted Then letters and numbers are preserved', () {
      // Act
      final String result = Utils.safeId('Store #123 - Main');

      // Assert
      expect(result, 'store-123-main');
    });

    test(
      'Given only symbols When converted Then an empty string is returned',
      () {
        // Act
        final String result = Utils.safeId('---###___');

        // Assert
        expect(result, '');
      },
    );

    test(
      'Given an empty string When converted Then an empty string is returned',
      () {
        // Act
        final String result = Utils.safeId('');

        // Assert
        expect(result, '');
      },
    );

    test(
      'Given an already safe id When converted Then operation is idempotent',
      () {
        // Arrange
        const String value = 'commerce-store-01';

        // Act
        final String firstResult = Utils.safeId(value);
        final String secondResult = Utils.safeId(firstResult);

        // Assert
        expect(firstResult, 'commerce-store-01');
        expect(secondResult, firstResult);
      },
    );
  });
  group('Utils.safeId accented characters', () {
    test('Given Spanish accented characters When converted Then accents are replaced with ASCII equivalents', () {
      // Act
      final String result = Utils.safeId('Categoría Única');

      // Assert
      expect(result, 'categoria-unica');
    });

    test(
      'Given ñ and ü characters When converted Then they are normalized',
      () {
        // Act
        final String result = Utils.safeId('Niñez Pingüino');

        // Assert
        expect(result, 'ninez-pinguino');
      },
    );

    test('Given uppercase accented characters When converted Then they are lowercased and normalized', () {
      // Act
      final String result = Utils.safeId('ÁRBOL ÉPICO ÍTEM ÓPTIMO ÚTIL');

      // Assert
      expect(result, 'arbol-epico-item-optimo-util');
    });

    test('Given mixed accents numbers and symbols When converted Then a readable safe id is returned', () {
      // Act
      final String result = Utils.safeId('  Localización #01 - Bogotá D.C.  ');

      // Assert
      expect(result, 'localizacion-01-bogota-d-c');
    });
  });
}
