import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

import '../example/transversal_core_example.dart';

void main() {
  test('runnable consumer example composes the actual public API with controlled timers', () {
    fakeAsync((FakeAsync time) {
      List<String>? result;
      Object? failure;
      demonstrateCore().then<void>(
        (List<String> value) {
          result = value;
        },
        onError: (Object error, StackTrace stack) {
          failure = error;
        },
      );
      time.flushMicrotasks();
      time.elapse(const Duration(milliseconds: 1));
      time.flushMicrotasks();
      expect(failure, isNull);
      expect(result, isNotNull);
      expect(result!.take(8), <String>[
        '{"text":"42"}',
        '{"text":""}',
        'unit',
        'invalid',
        'callback error propagated',
        '2024-02-29T12:00:00.000Z',
        'missing=true,invalid=true',
        '2024-02-29T12:00:00.000Z',
      ]);
      final ModelLocalizedText localized = ModelLocalizedText.fromJson(
        jsonDecode(result![8]) as Map<String, dynamic>,
      );
      expect(localized.translations[ModelLanguage.spanishColombia], 'Hola');
      expect(result!.skip(9), <String>[
        'debounced',
        'a1:start',
        'b',
        'a1:end',
        'a2',
        'task error propagated',
        'recovered',
      ]);
      expect(time.pendingTimers, isEmpty);
    });
  });

  test('synthetic Model subclass implements copy, equality, hash and JSON contract', () {
    const ExampleNote note = ExampleNote('text');
    expect(note.copyWith(), note);
    expect(note.copyWith().hashCode, note.hashCode);
    expect(note.copyWith(text: 'other'), isNot(note));
    expect(note, isNot(Object()));
    expect(note.toJson(), <String, dynamic>{'text': 'text'});
  });
}
