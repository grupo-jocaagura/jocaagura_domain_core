import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

enum _State { pending, complete }

class _ThrowingString {
  @override
  String toString() => throw StateError('fixture string conversion failed');
}

void main() {
  group('numeric compatibility boundaries', () {
    final List<(Object?, int)> integerCases = <(Object?, int)>[
      (null, 17),
      (42, 42),
      (-3.9, -3),
      (double.infinity, 0),
      (double.negativeInfinity, 0),
      ('', 0),
      ('abc', 0),
      ('NaN', 0),
      ('Infinity', 0),
      ('1e999', 0),
      ('-12', -12),
      ('-3,9', -3),
      (false, 0),
    ];
    for (final (Object? input, int expected) in integerCases) {
      test('integer input $input preserves its fallback contract', () {
        expect(Utils.getIntegerFromDynamic(input, defaultValue: 17), expected);
      });
    }

    final List<(Object?, double)> doubleCases = <(Object?, double)>[
      (null, 7.5),
      (42, 42),
      (-3.9, -3.9),
      (double.infinity, 7.5),
      ('', 7.5),
      ('abc', 7.5),
      ('NaN', 7.5),
      ('Infinity', 7.5),
      ('1e999', 7.5),
      ('-3,9', -3.9),
      ('3e-2', 0.03),
    ];
    for (final (Object? input, double expected) in doubleCases) {
      test('double input $input preserves its fallback contract', () {
        expect(Utils.getDouble(input, 7.5), expected);
      });
    }

    test('default double fallback is NaN and signed zero is retained', () {
      expect(Utils.getDouble(null), isNaN);
      expect(Utils.getDouble('invalid'), isNaN);
      expect(Utils.getDouble(-0.0).isNegative, isTrue);
    });

    test('normalization retains legacy separator and exponent heuristics', () {
      expect(Utils.normalizeNumberString('1.234'), '1.234');
      expect(Utils.normalizeNumberString('1,234'), '1.234');
      expect(Utils.normalizeNumberString('1.234.567'), '1234567');
      expect(Utils.normalizeNumberString('-1.234,5e+2'), '-1234.5e+2');
      expect(Utils.normalizeNumberString('+.'), isNull);
      expect(
        Utils.normalizeNumberString('1\u00a0234\u202f567\u2009'),
        '1234567',
      );
    });
  });

  group('conversion ownership and errors', () {
    test('typed maps are aliases, not immutable snapshots', () {
      final Map<String, dynamic> input = <String, dynamic>{'id': 'order-1'};
      final Map<String, dynamic> result = Utils.mapFromDynamic(input);
      expect(identical(result, input), isTrue);
      result['id'] = 'order-2';
      expect(input['id'], 'order-2');
      final List<Map<String, dynamic>> list = Utils.listFromDynamic(<Object?>[
        input,
        null,
        1,
      ]);
      expect(list, hasLength(1));
      expect(identical(list.single, input), isTrue);
    });

    test(
      'stringified map-key collisions preserve the last encountered value',
      () {
        final Map<Object?, Object?> input = <Object?, Object?>{
          1: 'first',
          '1': 'last',
          null: 'null key',
        };
        expect(Utils.mapFromDynamic(input), <String, dynamic>{
          '1': 'last',
          'null': 'null key',
        });
        expect(
          Utils.listFromDynamic(<Object?>[input]).single,
          <String, dynamic>{'1': 'last', 'null': 'null key'},
        );
        expect(input.length, 3);
      },
    );

    test('malformed and non-map JSON return an empty map', () {
      for (final Object? input in <Object?>[
        null,
        true,
        '[]',
        '42',
        '{bad json}',
        _ThrowingString(),
      ]) {
        expect(Utils.mapFromDynamic(input), isEmpty);
      }
    });

    test('custom key and value conversion failures retain source behavior', () {
      final Map<Object, Object?> input = <Object, Object?>{
        _ThrowingString(): 1,
      };
      expect(() => Utils.mapFromDynamic(input), throwsStateError);
      expect(() => Utils.listFromDynamic(<Object>[input]), throwsStateError);
      expect(
        () => Utils.getStringFromDynamic(_ThrowingString()),
        throwsStateError,
      );
    });

    test(
      'JSON round trips nested values but encoding failures are not JSON',
      () {
        final Map<String, dynamic> input = <String, dynamic>{
          'id': 'order-1',
          'attributes': <String, dynamic>{'enabled': true, 'optional': null},
          'items': <Object?>['one', 2, false],
        };
        expect(
          Utils.deepEqualsMap(
            Utils.mapFromDynamic(Utils.mapToString(input)),
            input,
          ),
          isTrue,
        );
        final Map<String, dynamic> cyclic = <String, dynamic>{};
        cyclic['self'] = cyclic;
        final String error = Utils.getJsonEncode(cyclic);
        expect(error, startsWith('{error: '));
        expect(() => jsonDecode(error), throwsFormatException);
      },
    );

    test('defaults and strict true preserve consumer decoding', () {
      expect(
        Utils.getStringFromDynamic(null, defaultValue: 'missing'),
        'missing',
      );
      expect(Utils.getStringFromDynamic(0), '0');
      expect(Utils.getBoolFromDynamic(null), isFalse);
      expect(
        Utils.getBoolFromDynamic(null, defaultValueIfNull: false),
        isFalse,
      );
      expect(
        Utils.getBoolFromDynamic('true', defaultValueIfNull: true),
        isFalse,
      );
      expect(Utils.stringListFromDynamic('[]'), isEmpty);
      expect(Utils.convertJsonToList('{"a":1}'), <String>['{a: 1}']);
    });
  });

  group('validation and formatting compatibility', () {
    test('URL validation is scheme/authority validation only', () {
      expect(Utils.isValidUrl('http://[invalid'), isFalse);
      expect(Utils.isValidUrl('ftp://example.com/file'), isTrue);
      expect(Utils.isValidUrl('file:///tmp/file'), isFalse);
      expect(Utils.isValidUrl('/relative/path'), isFalse);
      expect(
        Utils.getUrlFromDynamic('  https://example.com  '),
        '  https://example.com  ',
      );
      expect(Utils.getUrlFromDynamic(null), '');
      expect(Utils.getUrlFromDynamic('not a url'), '');
    });

    test('email extraction preserves valid input without trimming', () {
      expect(Utils.getEmailFromDynamic('a@example.com'), 'a@example.com');
      expect(Utils.getEmailFromDynamic(null), '');
      expect(Utils.getEmailFromDynamic(' a@example.com '), '');
      expect(Utils.isEmail('a@example.c'), isFalse);
    });

    test('phone aliases retain padding and extra digits', () {
      expect(Utils.getFormattedPhoneNumber(0), '(00) 0 000 0000');
      expect(Utils.getFormattedPhoneNumberAlt(0), '000 000 0000');
      expect(Utils.getFormattedPhoneNumber(123456789012), '(12) 3 456 789012');
      expect(Utils.getFormattedPhoneNumberAlt(123456789012), '123 456 789012');
      expect(
        Utils.getFormattedPhoneNumber(-12),
        Utils.getFormatedPhoneNumber(-12),
      );
      expect(
        Utils.getFormattedPhoneNumberAlt(-12),
        Utils.getFormatedPhoneNumberAlt(-12),
      );
    });
  });

  group('equality and hash contracts', () {
    test(
      'shallow lists preserve identity, length and nested identity semantics',
      () {
        final List<int> a = <int>[1];
        expect(Utils.listEquals(a, a), isTrue);
        expect(Utils.listEquals(a, <int>[1, 2]), isFalse);
        expect(
          Utils.listEquals(
            <List<int>>[a],
            <List<int>>[
              <int>[1],
            ],
          ),
          isFalse,
        );
        expect(Utils.listEquals(<List<int>>[a], <List<int>>[a]), isTrue);
        expect(
          Utils.listEquals(<double>[double.nan], <double>[double.nan]),
          isFalse,
        );
      },
    );

    test('deep comparison handles key, length, order and null differences', () {
      final Map<String, dynamic> a = <String, dynamic>{'one': null};
      expect(Utils.deepEqualsMap(a, a), isTrue);
      expect(Utils.deepEqualsMap(a, <String, dynamic>{}), isFalse);
      expect(Utils.deepEqualsMap(a, <String, dynamic>{'two': null}), isFalse);
      expect(Utils.deepEqualsDynamic(<int>[1], <int>[1, 2]), isFalse);
      expect(Utils.deepEqualsDynamic(null, null), isTrue);
      expect(Utils.deepEqualsDynamic(null, 0), isFalse);
      expect(Utils.deepEqualsDynamic(<int>[1], 1), isFalse);
      expect(Utils.deepEqualsDynamic(0.0, -0.0), isTrue);
      expect(Utils.deepEqualsDynamic(double.infinity, double.infinity), isTrue);
    });

    test('identity fast path precedes traversal of nested NaN', () {
      final List<double> a = <double>[double.nan];
      expect(Utils.deepEqualsDynamic(a, a), isTrue);
      expect(Utils.deepEqualsDynamic(a, <double>[double.nan]), isFalse);
    });

    test('equal normalized maps have equal deep hashes in the same run', () {
      final Map<Object, Object?> a = <Object, Object?>{
        1: <Object?>[
          null,
          3,
          <String, int>{'x': 2},
        ],
        'enabled': true,
      };
      final Map<String, dynamic> b = <String, dynamic>{
        'enabled': true,
        '1': <Object?>[
          null,
          3.0,
          <String, int>{'x': 2},
        ],
      };
      expect(Utils.deepEqualsDynamic(a, b), isTrue);
      expect(Utils.deepHash(a), Utils.deepHash(b));
      expect(Utils.deepHash(null), null.hashCode);
      expect(Utils.listHash(<int?>[1, null]), Utils.listHash(<int?>[1, null]));
    });
  });

  group('duration and enum boundaries', () {
    test(
      'millisecond serialization explicitly loses sub-millisecond precision',
      () {
        expect(Utils.durationToJson(const Duration(microseconds: 1999)), 1);
        expect(Utils.durationToJson(const Duration(microseconds: -1999)), -1);
        expect(
          Utils.durationFromJson(
            Utils.durationToJson(const Duration(microseconds: 1999)),
          ),
          const Duration(milliseconds: 1),
        );
      },
    );

    final List<(Object?, Duration)> cases = <(Object?, Duration)>[
      (null, const Duration(seconds: 7)),
      (const Duration(microseconds: 123), const Duration(microseconds: 123)),
      (double.infinity, const Duration(seconds: 7)),
      ('', const Duration(seconds: 7)),
      ('1:60:00', const Duration(seconds: 7)),
      ('1:60', const Duration(seconds: 7)),
      ('NaN', const Duration(seconds: 7)),
      ('1:02:03', const Duration(hours: 1, minutes: 2, seconds: 3)),
      ('1:02', const Duration(minutes: 1, seconds: 2)),
      ('1:02.5', const Duration(minutes: 1, seconds: 2, milliseconds: 500)),
      ('P2D', const Duration(days: 2)),
      ('PT2H', const Duration(hours: 2)),
      ('PT3M', const Duration(minutes: 3)),
      ('pt1.9999s', const Duration(seconds: 2)),
      ('P', Duration.zero),
      ('PT', Duration.zero),
      ('2h', const Duration(hours: 2)),
      ('3m', const Duration(minutes: 3)),
      ('-1.5s', const Duration(milliseconds: -1500)),
      (-1500.9, const Duration(milliseconds: -1500)),
    ];
    for (final (Object? input, Duration expected) in cases) {
      test('duration input $input preserves the accepted format', () {
        expect(
          Utils.durationFromJson(
            input,
            defaultDuration: const Duration(seconds: 7),
          ),
          expected,
        );
      });
    }

    test('enum names are exact and the provided fallback is retained', () {
      expect(
        Utils.enumFromJson(_State.values, 'Complete', _State.pending),
        _State.pending,
      );
      expect(
        Utils.enumFromJson(_State.values, ' complete ', _State.pending),
        _State.pending,
      );
      expect(
        Utils.enumFromJson(<_State>[], 'complete', _State.pending),
        _State.pending,
      );
    });
  });

  group('nondeterministic helper output contracts', () {
    for (final (int requested, int expected) in <(int, int)>[
      (-1, 16),
      (16, 16),
      (32, 32),
      (48, 48),
    ]) {
      test(
        'token byte length $requested produces $expected decodable bytes',
        () {
          final String token = Utils.generateSecureToken(
            prefix: '  #! ',
            byteLength: requested,
          );
          expect(token, matches(RegExp(r'^[A-Za-z0-9_-]+$')));
          expect(
            base64Url.decode(base64Url.normalize(token)),
            hasLength(expected),
          );
        },
      );
    }

    test(
      'token prefixes retain digits and IDs expose a parseable time segment',
      () {
        final String token = Utils.generateSecureToken(prefix: ' Session_2 ');
        expect(token, startsWith('session2_'));
        final List<String> parts = Utils.generatePrefixedId(
          'Order',
          -3,
        ).split('-');
        expect(parts, hasLength(3));
        expect(parts.first, 'order');
        expect(int.tryParse(parts[1], radix: 36), isNotNull);
        expect(parts.last, matches(RegExp(r'^[0-9a-z]$')));
      },
    );
  });
}
