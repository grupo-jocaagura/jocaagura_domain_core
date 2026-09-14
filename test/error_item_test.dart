import 'dart:convert';
import 'dart:io';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

class _DerivedError extends ErrorItem {
  const _DerivedError() : super(title: 't', code: 'c', description: 'd');
}

void main() {
  const ErrorItem error = ErrorItem(title: 't', code: 'c', description: 'd');
  test('const construction, field keys, enum order and defaults', () {
    expect(
      identical(
        error,
        const ErrorItem(title: 't', code: 'c', description: 'd'),
      ),
      isTrue,
    );
    expect(ErrorLevelEnum.values.map((ErrorLevelEnum e) => e.name), <String>[
      'systemInfo',
      'warning',
      'severe',
      'danger',
    ]);
    expect(ErrorItemEnum.values.map((ErrorItemEnum e) => e.name), <String>[
      'title',
      'code',
      'description',
      'meta',
      'errorLevel',
    ]);
    expect(error.meta, isEmpty);
    expect(error.errorLevel, ErrorLevelEnum.systemInfo);
    expect(error.toString(), 't (c): d | Level: systemInfo');
  });

  test('legacy absent/null/coerced fields decode without tightening', () {
    for (final Map<String, dynamic> json in <Map<String, dynamic>>[
      <String, dynamic>{},
      <String, dynamic>{
        for (final ErrorItemEnum e in ErrorItemEnum.values) e.name: null,
      },
    ]) {
      expect(
        ErrorItem.fromJson(json),
        const ErrorItem(title: '', code: '', description: ''),
      );
    }
    final ErrorItem converted = ErrorItem.fromJson(<String, dynamic>{
      'title': 9,
      'code': false,
      'description': 2.5,
      'meta': '{"count":1}',
      'errorLevel': 'SEVERE',
      'extra': 'discard',
    });
    expect(converted.title, '9');
    expect(converted.code, 'false');
    expect(converted.description, '2.5');
    expect(converted.meta, <String, dynamic>{'count': 1});
    expect(converted.errorLevel, ErrorLevelEnum.systemInfo);
    expect(converted.toJson().containsKey('extra'), isFalse);
    for (final Object malformed in <Object>[
      'bad',
      <Object>[1],
      12,
    ]) {
      expect(
        ErrorItem.fromJson(<String, dynamic>{'meta': malformed}).meta,
        isEmpty,
      );
    }
    expect(
      ErrorItem.fromJson(<String, dynamic>{
        'meta': <Object, Object>{1: 'number', '1': 'text'},
      }).meta,
      <String, dynamic>{'1': 'text'},
    );
  });

  test('every error level round-trips; unknown text is systemInfo', () {
    for (final ErrorLevelEnum level in ErrorLevelEnum.values) {
      expect(ErrorItem.getErrorLevelFromString(level.name), level);
      expect(
        ErrorItem.fromJson(error.copyWith(errorLevel: level).toJson())
            .errorLevel,
        level,
      );
    }
    for (final String? invalid in <String?>[
      null,
      '',
      'Danger',
      ' severe ',
      'unknown',
    ]) {
      expect(
        ErrorItem.getErrorLevelFromString(invalid),
        ErrorLevelEnum.systemInfo,
      );
    }
  });

  test(
    'constructor/fromJson/toJson alias metadata; copyWith owns outer map only',
    () {
      final List<int> nested = <int>[1];
      final Map<String, dynamic> meta = <String, dynamic>{'nested': nested};
      final ErrorItem aliased = error.copyWith().copyWith(meta: meta);
      final ErrorItem direct = ErrorItem(
        title: 't',
        code: 'c',
        description: 'd',
        meta: meta,
      );
      final ErrorItem decoded = ErrorItem.fromJson(direct.toJson());
      expect(direct.meta, same(meta));
      expect(decoded.meta, same(meta));
      expect(direct.toJson()['meta'], same(meta));
      expect(aliased.meta, isNot(same(meta)));
      expect(() => aliased.meta['new'] = true, throwsUnsupportedError);
      meta['new'] = true;
      expect(direct.meta['new'], isTrue);
      expect(aliased.meta.containsKey('new'), isFalse);
      nested.add(2);
      expect(aliased.meta['nested'], <int>[1, 2]);
      final ErrorItem clone = direct.copyWith();
      expect(clone, direct);
      expect(clone.meta, isNot(same(meta)));
      expect(() => clone.meta.clear(), throwsUnsupportedError);
      expect(direct.toString(), contains(' | Meta: '));
    },
  );

  test('copyWith changes every field and null preserves values', () {
    final ErrorItem copy = error.copyWith(
      title: 'new',
      code: 'new-code',
      description: 'new-desc',
      meta: <String, dynamic>{'x': 1},
      errorLevel: ErrorLevelEnum.danger,
    );
    expect(copy.toJson(), <String, dynamic>{
      'title': 'new',
      'code': 'new-code',
      'description': 'new-desc',
      'meta': <String, dynamic>{'x': 1},
      'errorLevel': 'danger',
    });
    final Map<String, dynamic> absent = <String, dynamic>{};
    expect(
      copy.copyWith(
        title: absent['title'] as String?,
        code: absent['code'] as String?,
        description: absent['description'] as String?,
        meta: absent['meta'] as Map<String, dynamic>?,
        errorLevel: absent['errorLevel'] as ErrorLevelEnum?,
      ),
      copy,
    );
  });

  test('equality is shallow, runtime-aware and order-independent with matching hash', () {
    expect(error, error);
    expect(error, isNot(Object()));
    expect(error, isNot(const _DerivedError()));
    for (final ErrorItem other in <ErrorItem>[
      error.copyWith(title: 'x'),
      error.copyWith(code: 'x'),
      error.copyWith(description: 'x'),
      error.copyWith(errorLevel: ErrorLevelEnum.danger),
      error.copyWith(meta: <String, dynamic>{'x': 1}),
    ]) {
      expect(error, isNot(other));
    }
    final ErrorItem a = error.copyWith(meta: <String, dynamic>{'a': 1, 'b': 2});
    final ErrorItem b = error.copyWith(meta: <String, dynamic>{'b': 2, 'a': 1});
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(error.copyWith(meta: <String, dynamic>{'a': 1, 'c': 2})));
    expect(a, isNot(error.copyWith(meta: <String, dynamic>{'a': 1, 'b': 3})));
    expect(
      error.copyWith(
        meta: <String, dynamic>{
          'list': <int>[1],
        },
      ),
      isNot(
        error.copyWith(
          meta: <String, dynamic>{
            'list': <int>[1],
          },
        ),
      ),
    );
    final Map<String, dynamic> shared = <String, dynamic>{'x': 1};
    expect(
      ErrorItem(title: 't', code: 'c', description: 'd', meta: shared),
      ErrorItem(title: 't', code: 'c', description: 'd', meta: shared),
    );
  });

  test(
    'canonical fixture matches actual output; non-JSON metadata fails encoding',
    () {
      final Map<String, dynamic> golden = jsonDecode(
        File('docs/DTO/v1/examples/error-item.example.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final ErrorItem parsed = ErrorItem.fromJson(golden);
      expect(parsed.toJson(), golden);
      expect(
        parsed.toJson().keys,
        ErrorItemEnum.values.map((ErrorItemEnum e) => e.name),
      );
      expect(jsonDecode(jsonEncode(parsed.toJson())), golden);
      expect(
        () => jsonEncode(
          error.copyWith(meta: <String, dynamic>{'object': Object()}).toJson(),
        ),
        throwsA(isA<JsonUnsupportedObjectError>()),
      );
      final Map<String, dynamic> cycle = <String, dynamic>{};
      cycle['self'] = cycle;
      expect(
        () => jsonEncode(error.copyWith(meta: cycle).toJson()),
        throwsA(isA<JsonCyclicError>()),
      );
    },
  );
}
