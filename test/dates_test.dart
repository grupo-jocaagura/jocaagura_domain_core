import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

class _FixedClock extends ClockPolicy {
  const _FixedClock(this.value);
  final DateTime value;
  @override
  DateTime nowUtc() => value;
}

class _IsoSubclass extends DateTimeIsoUtils {}

void main() {
  group('Date and clock contracts', () {
    const String canonical = '2024-02-29T12:34:56.123456Z';
    test('Given canonical and noncanonical timestamps When validating Then exact UTC whitespace and precision rules apply', () {
      expect(DateTimeIsoUtils.isCanonicalUtcIso(canonical), isTrue);
      expect(
        DateTimeIsoUtils.isCanonicalUtcIso('2024-02-29T12:34:56.000Z'),
        isTrue,
      );
      for (final String invalid in <String>[
        '',
        ' ',
        'badZ',
        '2024-02-29',
        '2024-02-29T12:34:56Z',
        '2024-02-29T12:34:56.0Z',
        '2024-02-29T12:34:56.000000Z',
        '2024-02-29T12:34:56.1234567Z',
        '2024-02-29T12:34:56.123456+00:00',
        '2024-02-29T12:34:56.123456z',
        '2024-02-30T12:34:56.000Z',
        ' $canonical',
        '$canonical ',
        '2024-02-29T12:34:56.123456',
      ]) {
        expect(
          DateTimeIsoUtils.isCanonicalUtcIso(invalid),
          isFalse,
          reason: invalid,
        );
        expect(
          DateTimeIsoUtils.tryParseCanonicalUtc(invalid),
          isNull,
          reason: invalid,
        );
      }
      expect(_IsoSubclass(), isA<DateTimeIsoUtils>());
      final DateTime parsed = DateTimeIsoUtils.tryParseCanonicalUtc(canonical)!;
      expect(parsed, DateTime.utc(2024, 2, 29, 12, 34, 56, 123, 456));
      expect(parsed.isUtc, isTrue);
    });

    test('Given absent malformed or canonical text When checking absence and parsing Then the distinct results are retained', () {
      for (final String empty in <String>['', ' ', '\t\n']) {
        expect(DateTimeIsoUtils.isEmptyOrCanonicalUtcIso(empty), isTrue);
        expect(DateTimeIsoUtils.tryParseCanonicalUtc(empty), isNull);
      }
      expect(DateTimeIsoUtils.isEmptyOrCanonicalUtcIso(canonical), isTrue);
      expect(
        DateTimeIsoUtils.isEmptyOrCanonicalUtcIso(' $canonical '),
        isFalse,
      );
      expect(DateTimeIsoUtils.isEmptyOrCanonicalUtcIso('invalid'), isFalse);
    });

    test('Given earlier equal later or invalid instants When comparing Then only valid same-or-after values pass', () {
      const String earlier = '2024-02-29T12:34:56.123455Z';
      expect(DateTimeIsoUtils.isSameOrAfter(canonical, earlier), isTrue);
      expect(DateTimeIsoUtils.isSameOrAfter(canonical, canonical), isTrue);
      expect(DateTimeIsoUtils.isSameOrAfter(earlier, canonical), isFalse);
      expect(DateTimeIsoUtils.isSameOrAfter('', canonical), isFalse);
      expect(DateTimeIsoUtils.isSameOrAfter(canonical, 'invalid'), isFalse);
    });

    test('Given a clock policy and the system helper When reading time Then controlled and real UTC contracts remain distinct', () {
      final DateTime fixed = DateTime.utc(2001, 2, 3);
      final ClockPolicy clock = _FixedClock(fixed);
      expect(clock.nowUtc(), same(fixed));
      expect(
        DateTimeIsoUtils.tryParseCanonicalUtc(clock.nowUtc().toIso8601String()),
        fixed,
      );
      final DateTime before = DateTime.now().toUtc();
      final String iso = DateTimeIsoUtils.nowUtcIso();
      final DateTime after = DateTime.now().toUtc();
      final DateTime now = DateTimeIsoUtils.tryParseCanonicalUtc(iso)!;
      expect(now.isBefore(before), isFalse);
      expect(now.isAfter(after), isFalse);
    });

    test('Given DateUtils and its alias When constructing and converting Then public signatures remain compatible', () {
      const DateUtils Function() constructor = DateUtils.new;
      const DateUtils Function() aliasConstructor = JocaDateUtils.new;
      expect(constructor(), isA<DateUtils>());
      expect(aliasConstructor(), isA<DateUtils>());
      final DateTime value = DateTime.utc(2024, 2, 29, 12, 34, 56, 123, 456);
      expect(DateUtils.dateTimeFromDynamic(value), same(value));
      expect(DateUtils.dateTimeFromDynamic(canonical), value);
      expect(DateUtils.dateTimeToString(value), canonical);
      expect(JocaDateUtils.dateTimeToString(value), canonical);
      final DateTime local = DateTime(2024, 2, 29, 12);
      expect(DateUtils.dateTimeToString(local), local.toIso8601String());
      for (final int milliseconds in <int>[0, -1, 1709210096123]) {
        final DateTime epoch = DateUtils.dateTimeFromDynamic(milliseconds);
        expect(epoch.millisecondsSinceEpoch, milliseconds);
        expect(epoch.isUtc, isFalse);
      }
    });

    test('Given invalid input or a Duration When converting Then the current local clock supplies the fallback', () {
      for (final Object? value in <Object?>[
        null,
        'bad',
        ' $canonical ',
        true,
        3.14,
        Object(),
        const Duration(days: 1),
      ]) {
        final DateTime before = DateTime.now();
        final DateTime result = DateUtils.dateTimeFromDynamic(value);
        final DateTime after = DateTime.now();
        final Duration delta = value is Duration ? value : Duration.zero;
        expect(result.isUtc, isFalse);
        expect(result.isBefore(before.add(delta)), isFalse);
        expect(result.isAfter(after.add(delta)), isFalse);
      }
    });

    test('Given null dates epochs offset text or invalid text When normalizing Then the result is empty or UTC', () {
      for (final Object? value in <Object?>[
        null,
        '',
        '  ',
        'bad',
        true,
        const Duration(days: 1),
        <int>[1],
      ]) {
        expect(DateUtils.normalizeIsoOrEmpty(value), '');
      }
      expect(DateUtils.normalizeIsoOrEmpty(' $canonical '), canonical);
      expect(
        DateUtils.normalizeIsoOrEmpty('2024-02-29T14:34:56.123456+02:00'),
        canonical,
      );
      expect(
        DateUtils.normalizeIsoOrEmpty(DateTime.parse(canonical)),
        canonical,
      );
      final DateTime local = DateTime(2024, 2, 29, 12);
      expect(
        DateUtils.normalizeIsoOrEmpty(local),
        local.toUtc().toIso8601String(),
      );
      expect(
        DateUtils.normalizeIsoOrEmpty('2024-02-29T12:00:00'),
        local.toUtc().toIso8601String(),
      );
      expect(DateUtils.normalizeIsoOrEmpty(0), '1970-01-01T00:00:00.000Z');
      expect(DateUtils.normalizeIsoOrEmpty(-1), '1969-12-31T23:59:59.999Z');
      expect(
        DateUtils.normalizeIsoOrEmpty('2024-02-30T00:00:00Z'),
        '2024-03-01T00:00:00.000Z',
      );
      expect(
        () => DateUtils.dateTimeFromDynamic(8640000000000001),
        throwsArgumentError,
      );
      expect(
        () => DateUtils.normalizeIsoOrEmpty(8640000000000001),
        throwsArgumentError,
      );
    });
  });
}
