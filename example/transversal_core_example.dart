import 'dart:async';
import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';

/// Synthetic consumer model; it is not a production core export.
class ExampleNote extends Model {
  const ExampleNote(this.text);
  final String text;

  @override
  ExampleNote copyWith({String? text}) => ExampleNote(text ?? this.text);

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'text': text};

  @override
  // Final scalar field; keep the example SDK-only.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is ExampleNote && text == other.text;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => text.hashCode;
}

class ExampleNoteMapper extends Mapper<ExampleNote> {
  const ExampleNoteMapper();
  @override
  ExampleNote fromJson(Map<String, dynamic> json) =>
      ExampleNote(Utils.getStringFromDynamic(json['text']));
}

class ExampleClock extends ClockPolicy {
  const ExampleClock();
  @override
  DateTime nowUtc() => DateTime.utc(2024, 2, 29, 12);
}

/// Pure Dart in-package composition. No backend is contacted.
Future<List<String>> demonstrateCore() async {
  const ExampleNoteMapper mapper = ExampleNoteMapper();
  final List<ExampleNote> notes = ModelUtils.modelListFromDynamic<ExampleNote>(
    value: <Object?>[
      null,
      7,
      <String, dynamic>{'text': 42},
    ],
    fromJson: mapper.fromJson,
  );
  final ExampleNote empty = mapper.fromDynamic('malformed');
  final List<String> events = <String>[
    jsonEncode(mapper.toJson(notes.single)),
    jsonEncode(empty.toJson()),
  ];

  Future<Either<ErrorItem, Unit>> save(
    NoParams input, {
    required bool valid,
  }) async {
    if (!valid) {
      return const Left<ErrorItem, Unit>(
        ErrorItem(
          title: 'Input',
          code: 'invalid',
          description: 'Synthetic failure',
        ),
      );
    }
    return const Right<ErrorItem, Unit>(Unit.value);
  }

  final Either<ErrorItem, Unit> success = await save(
    const NoParams(),
    valid: true,
  ).flatMapAsync<Unit>((Unit value) => Right<ErrorItem, Unit>(value));
  events.add(
    success.fold<String>((ErrorItem e) => e.code, (Unit value) => '$value'),
  );
  final Either<ErrorItem, Unit> failure = await save(
    const NoParams(),
    valid: false,
  );
  events.add(
    failure.fold<String>((ErrorItem e) => e.code, (Unit _) => 'unexpected'),
  );
  try {
    await success.mapAsync<Unit>((Unit _) => throw StateError('callback'));
  } on StateError {
    events.add('callback error propagated');
  }

  const ClockPolicy clock = ExampleClock();
  final String utc = DateUtils.normalizeIsoOrEmpty(clock.nowUtc());
  events.add(DateTimeIsoUtils.tryParseCanonicalUtc(utc)!.toIso8601String());
  events.add(
    'missing=${DateUtils.normalizeIsoOrEmpty(null).isEmpty},'
    'invalid=${DateTimeIsoUtils.tryParseCanonicalUtc('invalid') == null}',
  );
  events.add(JocaDateUtils.normalizeIsoOrEmpty('2024-02-29T14:00:00+02:00'));

  final ModelLanguage language = ModelLanguage.fromJson(<String, dynamic>{
    'languageCode': ' ES ',
    'regionCode': 'co',
  });
  final ModelLocalizedText text = ModelLocalizedText(
    translations: <ModelLanguage, String>{language: 'Hola'},
    fallbackLanguage: language,
  );
  events.add(jsonEncode(ModelLocalizedText.fromJson(text.toJson()).toJson()));

  final Debouncer debouncer = Debouncer(milliseconds: 1);
  final Completer<void> debounced = Completer<void>();
  debouncer(() => events.add('superseded'));
  debouncer(() {
    events.add('debounced');
    debounced.complete();
  });
  await debounced.future;
  debouncer.dispose();

  final PerKeyFifoExecutor<String> executor = PerKeyFifoExecutor<String>();
  final Completer<void> release = Completer<void>();
  final Future<void> first = executor.withLock<void>('a', () async {
    events.add('a1:start');
    await release.future;
    events.add('a1:end');
  });
  final Future<void> second = executor.withLock<void>('a', () async {
    events.add('a2');
  });
  await executor.withLock<void>('b', () async {
    events.add('b');
  });
  release.complete();
  await Future.wait<void>(<Future<void>>[first, second]);
  try {
    await executor.withLock<void>('a', () async => throw StateError('task'));
  } on StateError {
    events.add('task error propagated');
  }
  await executor.withLock<void>('a', () async {
    events.add('recovered');
  });
  executor.dispose();
  return events;
}

Future<void> main() async {
  // ignore: avoid_print
  (await demonstrateCore()).forEach(print);
}
