import 'dart:convert';
import 'dart:io';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

import 'api_contract_types.dart';

final Map<String, Map<String, dynamic>> _definitions =
    <String, Map<String, dynamic>>{
      for (final Map<String, dynamic> model
          in ((jsonDecode(
                    File('test/fixtures/api-values.json').readAsStringSync(),
                  ) as Map<String, dynamic>)['models']
                  as List<dynamic>)
              .cast<Map<String, dynamic>>())
        model['name'] as String: model,
    };

/// Schema/codec checks complement independently authored functional fixtures.
/// They do not establish that a definition matches a deployed server.
void verifyApiFieldContracts(
  ApiValue value,
  ApiValue Function(Map<String, Object?>) decode,
  Map<String, Object?> wire,
) {
  final String name = apiContractTypes[value.runtimeType]!;
  final List<Map<String, dynamic>> fields =
      (_definitions[name]!['fields'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
  void rejects(String key, Object? invalid) {
    expect(
      () => decode(<String, Object?>{...wire, key: invalid}),
      throwsFormatException,
      reason: '$name.$key must obey its reviewed field contract',
    );
  }

  for (final Map<String, dynamic> field in fields) {
    final String key = field['name'] as String;
    if (field.containsKey('minimum')) {
      rejects(key, (field['minimum'] as num) - 1);
    }
    if (field.containsKey('maximum')) {
      rejects(key, (field['maximum'] as num) + 1);
    }
    if (field.containsKey('minLength')) {
      rejects(key, 'x' * ((field['minLength'] as int) - 1));
    }
    if (field.containsKey('maxLength')) {
      rejects(key, 'x' * ((field['maxLength'] as int) + 1));
    }
    if (field['canonicalUtc'] == true || field['emptyCanonicalUtc'] == true) {
      rejects(key, '2026-11-06T08:00:00-05:00');
    }
    if (field['noActiveHtml'] == true) {
      rejects(key, '<script>example</script>');
    }
    if (field['forbidAngleBrackets'] == true) {
      rejects(key, 'example <text>');
    }
    if (field.containsKey('forbiddenWords')) {
      for (final String word
          in (field['forbiddenWords'] as List<dynamic>).cast<String>()) {
        rejects(key, 'example $word');
      }
    }
    if (field.containsKey('uniqueBy')) {
      final List<Object?>? members = wire[key] as List<Object?>?;
      if (members != null && members.isNotEmpty) {
        rejects(key, <Object?>[members.first, members.first]);
      }
    }
    if (field.containsKey('enum')) {
      rejects(key, '__outside_the_contract__');
    }
    if (field['nonblank'] == true) {
      rejects(key, ' ');
    }
    if (field.containsKey('minItems')) {
      rejects(key, <Object?>[]);
    }
    if (field['uniqueTrimmed'] == true) {
      final String allowed =
          (field['allowedItems'] as List<dynamic>).first as String;
      rejects(key, <String>[allowed, ' $allowed ']);
    }
    if (field.containsKey('allowedItems')) {
      rejects(key, <String>['__outside_the_contract__']);
    }
    if (field['https'] == true) {
      rejects(key, 'http://checkout.example.invalid/opaque');
      rejects(key, 'not a URL');
    }
    if (field.containsKey('pattern')) {
      rejects(key, '! invalid /');
    }
    if (field.containsKey('allowedKinds')) {
      rejects(key, <Object?>[]);
    }
  }
  for (final String key
      in ((_definitions[name]!['forbiddenKeys'] as List<dynamic>?) ??
              <dynamic>[])
          .cast<String>()) {
    rejects(key, null);
  }
}

/// Exercises independent functional messages against the public codec contract.
void checkApiMessage(String name, Map<String, Object?> wire) {
  test('$name preserves its functional message and owns nested values', () {
    final ApiValue Function(Map<String, Object?>) decode =
        apiContractDecoders[name]!;
    final ApiValue value = decode(wire);
    expect(value.toJson(), wire);
    expect(value.copyWith(), value);
    final ApiValue roundTrip = decode(
      jsonDecode(jsonEncode(wire)) as Map<String, Object?>,
    );
    expect(roundTrip, value);
    expect(roundTrip.hashCode, value.hashCode);
    final Map<String, dynamic> copy = value.toJson()..clear();
    expect(copy, isEmpty);
    expect(value.toJson(), wire);
    verifyApiFieldContracts(value, decode, wire);
    for (final Map<String, dynamic> field
        in (_definitions[name]!['fields'] as List<dynamic>)
            .cast<Map<String, dynamic>>()) {
      if (field['optional'] != true) {
        final Map<String, Object?> missing = <String, Object?>{...wire}
          ..remove(field['name']);
        expect(
          () => decode(missing),
          throwsFormatException,
          reason: '$name requires ${field['name']}',
        );
      }
    }
  });
}
