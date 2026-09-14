import 'dart:async';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('Frozen public signatures', () {
    test('Given CP-1 static conversion and date signatures When assigning entrypoint tear-offs Then all types compile', () {
      const Map<String, dynamic> Function(dynamic) map =
          ModelUtils.jsonFromDynamic;
      const List<Map<String, dynamic>> Function(dynamic) list =
          ModelUtils.jsonListFromDynamic;
      const T Function<T extends Model>({
        required dynamic value,
        required T Function(Map<String, dynamic> json) fromJson,
      })
      model = ModelUtils.modelFromDynamic;
      const List<T> Function<T extends Model>({
        required dynamic value,
        required T Function(Map<String, dynamic> json) fromJson,
      })
      models = ModelUtils.modelListFromDynamic;
      const bool Function(String) canonical =
          DateTimeIsoUtils.isCanonicalUtcIso;
      const bool Function(String) optional =
          DateTimeIsoUtils.isEmptyOrCanonicalUtcIso;
      const DateTime? Function(String) parse =
          DateTimeIsoUtils.tryParseCanonicalUtc;
      const bool Function(String, String) compare =
          DateTimeIsoUtils.isSameOrAfter;
      const String Function() now = DateTimeIsoUtils.nowUtcIso;
      const DateTime Function(dynamic) date = DateUtils.dateTimeFromDynamic;
      const String Function(DateTime) encode = JocaDateUtils.dateTimeToString;
      const String Function(Object?) normalize = DateUtils.normalizeIsoOrEmpty;
      const ErrorLevelEnum Function(String?) level =
          ErrorItem.getErrorLevelFromString;
      expect(map(null), isEmpty);
      expect(list(null), isEmpty);
      expect(
        model<ErrorItem>(value: null, fromJson: ErrorItem.fromJson).title,
        '',
      );
      expect(
        models<ErrorItem>(value: null, fromJson: ErrorItem.fromJson),
        isEmpty,
      );
      expect(canonical(now()), isTrue);
      expect(optional(' '), isTrue);
      expect(parse(''), isNull);
      expect(compare('', ''), isFalse);
      expect(
        encode(date(0)),
        DateTime.fromMillisecondsSinceEpoch(0).toIso8601String(),
      );
      expect(normalize(null), '');
      expect(level(null), ErrorLevelEnum.systemInfo);
    });

    test('Given CP-1 result callbacks and FutureOr signatures When assigning generic tear-offs Then all types compile', () async {
      const Either<String?, int?> value = Right<String?, int?>(null);
      final Either<String?, T> Function<T>(T Function(int?) transform) map =
          value.map;
      final Either<T, int?> Function<T>(T Function(String?) transform) mapLeft =
          value.mapLeft;
      final Either<String?, T> Function<T>(
        Either<String?, T> Function(int?) transform,
      )
      bind = value.flatMap;
      final Future<Either<String?, T>> Function<T>(
        FutureOr<T> Function(int?) transform,
      )
      mapAsync = value.mapAsync;
      final Future<Either<String?, T>> Function<T>(
        FutureOr<Either<String?, T>> Function(int?) transform,
      )
      bindAsync = value.flatMapAsync;
      final T Function<T>(T Function(String?), T Function(int?)) fold =
          value.fold;
      final T Function<T>(T Function(String?), T Function(int?)) when =
          value.when;
      final T Function<T>({
        required T Function(String?) left,
        required T Function(int?) right,
      })
      match = value.match;
      expect(map<int>((int? n) => n ?? 1), const Right<String?, int>(1));
      expect(
        mapLeft<int>((String? s) => s?.length ?? 0),
        const Right<int, int?>(null),
      );
      expect(
        bind<int>((int? n) => Right<String?, int>(n ?? 2)),
        const Right<String?, int>(2),
      );
      expect(
        await mapAsync<int>((int? n) => n ?? 3),
        const Right<String?, int>(3),
      );
      expect(
        await bindAsync<int>((int? n) async => Right<String?, int>(n ?? 4)),
        const Right<String?, int>(4),
      );
      expect(fold<bool>((String? _) => false, (int? n) => n == null), isTrue);
      expect(when<bool>((String? _) => false, (int? n) => n == null), isTrue);
      expect(
        match<bool>(left: (String? _) => false, right: (int? n) => n == null),
        isTrue,
      );
    });
  });
}
