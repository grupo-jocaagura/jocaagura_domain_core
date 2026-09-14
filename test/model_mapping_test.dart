import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

class _Utility extends EntityUtil {
  const _Utility();
}

class _ErrorMapper extends Mapper<ErrorItem> {
  const _ErrorMapper();
  @override
  ErrorItem fromJson(Map<String, dynamic> json) => ErrorItem.fromJson(json);
}

class _FailingMapper extends Mapper<ErrorItem> {
  const _FailingMapper(this.error);
  final StateError error;
  @override
  ErrorItem fromJson(Map<String, dynamic> json) => throw error;
}

void main() {
  const _ErrorMapper mapper = _ErrorMapper();
  test('const abstract contracts and no-input marker remain extensible', () {
    const EntityUtil util = _Utility();
    expect(util, isA<EntityUtil>());
    const NoParams noParams = NoParams();
    expect(identical(noParams, const NoParams()), isTrue);
    expect(noParams, isNot(unit));
    const Model model = ErrorItem(title: 't', code: 'c', description: 'd');
    final Map<String, dynamic> Function() encode = model.toJson;
    final Model Function() copy = model.copyWith;
    expect(encode()['title'], 't');
    expect(copy(), model);
    expect(copy().hashCode, model.hashCode);
    expect(identical(mapper, const _ErrorMapper()), isTrue);
  });

  test('map converters tolerate JSON strings/raw keys/null/invalid input', () {
    final Map<String, dynamic> map = <String, dynamic>{'title': 't'};
    expect(ModelUtils.jsonFromDynamic(map), same(map));
    expect(ModelUtils.jsonFromDynamic('{"title":"t"}'), map);
    expect(
      ModelUtils.jsonFromDynamic(<Object, Object>{1: 'a', '1': 'b'}),
      <String, dynamic>{'1': 'b'},
    );
    for (final Object? bad in <Object?>[
      null,
      'bad',
      '[1]',
      <Object>[1],
      17,
    ]) {
      expect(ModelUtils.jsonFromDynamic(bad), isEmpty);
      expect(
        mapper.fromDynamic(bad),
        const ErrorItem(title: '', code: '', description: ''),
      );
    }
    expect(
      ModelUtils.modelFromDynamic<ErrorItem>(
        value: map,
        fromJson: ErrorItem.fromJson,
      ),
      mapper.fromDynamic(map),
    );
    expect(
      mapper.toJson(mapper.fromDynamic(map)),
      mapper.fromDynamic(map).toJson(),
    );
  });

  test('lists discard non-maps; retained records preserve order and legacy coercions', () {
    final List<Object?> input = <Object?>[
      null,
      1,
      'ignored',
      <String, dynamic>{'title': 1},
      <Object, Object>{'title': 2},
    ];
    expect(ModelUtils.jsonListFromDynamic(input), <Map<String, dynamic>>[
      <String, dynamic>{'title': 1},
      <String, dynamic>{'title': 2},
    ]);
    final List<ErrorItem> models = ModelUtils.modelListFromDynamic<ErrorItem>(
      value: input,
      fromJson: ErrorItem.fromJson,
    );
    expect(models.map((ErrorItem e) => e.title), <String>['1', '2']);
    expect(mapper.fromDynamicList(input), models);
    expect(
      mapper.fromDynamicList('[null, {"title":1}, false, {"title":2}]'),
      isEmpty,
    );
    models.add(const ErrorItem(title: 't', code: 'c', description: 'd'));
    expect(models, hasLength(3));
    for (final Object? bad in <Object?>[
      null,
      'bad',
      '{}',
      1,
      <String, dynamic>{},
    ]) {
      expect(ModelUtils.jsonListFromDynamic(bad), isEmpty);
      expect(
        ModelUtils.modelListFromDynamic<ErrorItem>(
          value: bad,
          fromJson: ErrorItem.fromJson,
        ),
        isEmpty,
      );
      expect(mapper.fromDynamicList(bad), isEmpty);
    }
  });

  test(
    'decoder failures propagate and stop at the failing retained record',
    () {
      final StateError error = StateError('decoder');
      final _FailingMapper failing = _FailingMapper(error);
      expect(() => failing.fromDynamic(null), throwsA(same(error)));
      expect(
        () => failing.fromDynamicList(<Object>[1, <String, dynamic>{}]),
        throwsA(same(error)),
      );
      expect(
        () => ModelUtils.modelFromDynamic<ErrorItem>(
          value: null,
          fromJson: failing.fromJson,
        ),
        throwsA(same(error)),
      );
      int calls = 0;
      expect(
        () => ModelUtils.modelListFromDynamic<ErrorItem>(
          value: <Object>[
            1,
            <String, dynamic>{'n': 1},
            <String, dynamic>{'n': 2},
          ],
          fromJson: (Map<String, dynamic> json) {
            calls++;
            throw error;
          },
        ),
        throwsA(same(error)),
      );
      expect(calls, 1);
    },
  );
}
