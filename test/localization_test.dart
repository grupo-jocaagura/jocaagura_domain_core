import 'dart:convert';
import 'dart:io';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

void main() {
  test(
    'language presets, const values, keys and canonical tags are retained',
    () {
      final Map<ModelLanguage, String> presets = <ModelLanguage, String>{
        ModelLanguage.undetermined: 'und',
        ModelLanguage.spanishColombia: 'es-CO',
        ModelLanguage.spanishMexico: 'es-MX',
        ModelLanguage.spanishSpain: 'es-ES',
        ModelLanguage.spanishArgentina: 'es-AR',
        ModelLanguage.spanishChile: 'es-CL',
        ModelLanguage.spanishPeru: 'es-PE',
        ModelLanguage.englishUnitedStates: 'en-US',
        ModelLanguage.englishUnitedKingdom: 'en-GB',
        ModelLanguage.englishCanada: 'en-CA',
        ModelLanguage.englishAustralia: 'en-AU',
        ModelLanguage.portugueseBrazil: 'pt-BR',
        ModelLanguage.portuguesePortugal: 'pt-PT',
        ModelLanguage.frenchFrance: 'fr-FR',
        ModelLanguage.germanGermany: 'de-DE',
        ModelLanguage.italianItaly: 'it-IT',
        ModelLanguage.dutchNetherlands: 'nl-NL',
        ModelLanguage.japaneseJapan: 'ja-JP',
        ModelLanguage.koreanSouthKorea: 'ko-KR',
        ModelLanguage.chineseChina: 'zh-Hans-CN',
        ModelLanguage.chineseTaiwan: 'zh-Hant-TW',
        ModelLanguage.hindiIndia: 'hi-IN',
        ModelLanguage.indonesianIndonesia: 'id-ID',
        ModelLanguage.turkishTurkey: 'tr-TR',
        ModelLanguage.polishPoland: 'pl-PL',
        ModelLanguage.swedishSweden: 'sv-SE',
        ModelLanguage.norwegianNorway: 'no-NO',
      };
      expect(ModelLanguage.undeterminedCode, 'und');
      expect(ModelLanguage.languageCodeKey, 'languageCode');
      expect(ModelLanguage.scriptCodeKey, 'scriptCode');
      expect(ModelLanguage.regionCodeKey, 'regionCode');
      for (final MapEntry<ModelLanguage, String> entry in presets.entries) {
        expect(entry.key.canonicalTag, entry.value);
        final ModelLanguage decoded = ModelLanguage.fromJson(
          entry.key.toJson(),
        );
        expect(decoded, entry.key);
        expect(decoded.hashCode, entry.key.hashCode);
      }
      expect(
        identical(
          ModelLanguage.spanishColombia,
          // Constructor/constant identity is the compatibility contract being tested.
          // ignore: use_named_constants
          const ModelLanguage(languageCode: 'es', regionCode: 'CO'),
        ),
        isTrue,
      );
      expect(
        const ModelLanguage(
          languageCode: 'zh',
          scriptCode: 'Hans',
        ).canonicalTag,
        'zh-Hans',
      );
    },
  );

  test('decoder normalizes, constructors preserve raw input and assert only empty language', () {
    expect(
      ModelLanguage.fromJson(<String, dynamic>{
        'languageCode': ' ES ',
        'scriptCode': ' lATN ',
        'regionCode': ' co ',
      }),
      const ModelLanguage(
        languageCode: 'es',
        scriptCode: 'Latn',
        regionCode: 'CO',
      ),
    );
    expect(
      ModelLanguage.fromJson(<String, dynamic>{}),
      ModelLanguage.undetermined,
    );
    expect(
      ModelLanguage.fromJson(<String, dynamic>{
        'languageCode': null,
        'scriptCode': null,
        'regionCode': null,
      }),
      ModelLanguage.undetermined,
    );
    expect(
      ModelLanguage.fromJson(<String, dynamic>{'languageCode': '  '}),
      ModelLanguage.undetermined,
    );
    expect(
      ModelLanguage.fromJson(<String, dynamic>{
        'languageCode': 123,
        'scriptCode': ' x ',
        'regionCode': true,
      }),
      const ModelLanguage(
        languageCode: '123',
        scriptCode: 'X',
        regionCode: 'TRUE',
      ),
    );
    const ModelLanguage raw = ModelLanguage(
      languageCode: ' ES ',
      scriptCode: 'lATN',
      regionCode: 'co',
    );
    expect(raw.languageCode, ' ES ');
    expect(raw.scriptCode, 'lATN');
    expect(raw.regionCode, 'co');
    final String empty = String.fromCharCodes(<int>[]);
    expect(
      () => ModelLanguage(languageCode: empty),
      throwsA(isA<AssertionError>()),
    );
    expect(const ModelLanguage(languageCode: ' ').canonicalTag, ' ');
    expect(raw, isNot(ModelLanguage.fromJson(raw.toJson())));
  });

  test(
    'language equality includes all fields and serialization emits all keys',
    () {
      const ModelLanguage value = ModelLanguage(
        languageCode: 'en',
        scriptCode: 'Latn',
        regionCode: 'US',
      );
      expect(value, value);
      expect(value, isNot(Object()));
      expect(
        value,
        isNot(
          const ModelLanguage(
            languageCode: 'es',
            scriptCode: 'Latn',
            regionCode: 'US',
          ),
        ),
      );
      expect(
        value,
        isNot(
          const ModelLanguage(
            languageCode: 'en',
            scriptCode: 'Hans',
            regionCode: 'US',
          ),
        ),
      );
      expect(
        value,
        isNot(
          const ModelLanguage(
            languageCode: 'en',
            scriptCode: 'Latn',
            regionCode: 'GB',
          ),
        ),
      );
      expect(value.toJson(), <String, dynamic>{
        'languageCode': 'en',
        'scriptCode': 'Latn',
        'regionCode': 'US',
      });
      expect(value.toJson().keys, <String>[
        'languageCode',
        'scriptCode',
        'regionCode',
      ]);
      expect(ModelLanguage.undetermined.toJson(), <String, dynamic>{
        'languageCode': 'und',
        'scriptCode': '',
        'regionCode': '',
      });
    },
  );

  test('localized text owns its input map and stores fallback without inventing lookup', () {
    final Map<ModelLanguage, String> input = <ModelLanguage, String>{
      ModelLanguage.spanishColombia: 'Hola',
    };
    final ModelLocalizedText value = ModelLocalizedText(translations: input);
    input[ModelLanguage.spanishColombia] = 'changed';
    expect(value.translations[ModelLanguage.spanishColombia], 'Hola');
    expect(value.fallbackLanguage, ModelLanguage.undetermined);
    expect(() => value.translations.clear(), throwsUnsupportedError);
    final ModelLocalizedText missingFallback = ModelLocalizedText(
      translations: input,
      fallbackLanguage: ModelLanguage.japaneseJapan,
    );
    expect(
      missingFallback.translations.containsKey(
        missingFallback.fallbackLanguage,
      ),
      isFalse,
    );
    expect(ModelLocalizedText.translationsKey, 'translations');
    expect(ModelLocalizedText.fallbackLanguageKey, 'fallbackLanguage');
    expect(ModelLocalizedText.languageKey, 'language');
    expect(ModelLocalizedText.textKey, 'text');
  });

  test(
    'malformed/duplicate translation records normalize with last-entry wins',
    () {
      final ModelLocalizedText value = ModelLocalizedText.fromJson(
        <String, dynamic>{
          'translations': <Object?>[
            null,
            5,
            'ignored',
            <String, dynamic>{
              'language': <String, dynamic>{
                'languageCode': 'ES',
                'regionCode': 'co',
              },
              'text': 'first',
            },
            <String, dynamic>{
              'language': <String, dynamic>{
                'languageCode': ' es ',
                'regionCode': ' CO ',
              },
              'text': 42,
            },
            <String, dynamic>{'language': 'bad', 'text': null},
          ],
          'fallbackLanguage': '{"languageCode":"es","regionCode":"co"}',
          'extra': 'discard',
        },
      );
      expect(value.translations, <ModelLanguage, String>{
        ModelLanguage.spanishColombia: '42',
        ModelLanguage.undetermined: '',
      });
      expect(value.fallbackLanguage, ModelLanguage.spanishColombia);
      expect(value.toJson().containsKey('extra'), isFalse);
      for (final Object? malformed in <Object?>[
        null,
        5,
        'bad',
        <String, dynamic>{},
      ]) {
        final ModelLocalizedText empty = ModelLocalizedText.fromJson(
          <String, dynamic>{
            'translations': malformed,
            'fallbackLanguage': malformed,
          },
        );
        expect(empty.translations, isEmpty);
        expect(empty.fallbackLanguage, ModelLanguage.undetermined);
      }
      final ModelLocalizedText fromText = ModelLocalizedText.fromJson(
        <String, dynamic>{'translations': '[{"language":{},"text":true}]'},
      );
      expect(fromText.translations, isEmpty);
    },
  );

  test('translation equality/hash ignore insertion order and compare language/text/fallback', () {
    final ModelLocalizedText a = ModelLocalizedText(
      translations: <ModelLanguage, String>{
        ModelLanguage.spanishColombia: 'Hola',
        ModelLanguage.englishUnitedStates: 'Hello',
      },
    );
    final ModelLocalizedText b = ModelLocalizedText(
      translations: <ModelLanguage, String>{
        ModelLanguage.englishUnitedStates: 'Hello',
        ModelLanguage.spanishColombia: 'Hola',
      },
    );
    expect(a, a);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(Object()));
    expect(
      a,
      isNot(
        ModelLocalizedText(
          translations: b.translations,
          fallbackLanguage: ModelLanguage.spanishColombia,
        ),
      ),
    );
    expect(
      a,
      isNot(ModelLocalizedText(translations: <ModelLanguage, String>{})),
    );
    expect(
      a,
      isNot(
        ModelLocalizedText(
          translations: <ModelLanguage, String>{
            ModelLanguage.spanishColombia: 'Hola',
            ModelLanguage.frenchFrance: 'Hello',
          },
        ),
      ),
    );
    expect(
      a,
      isNot(
        ModelLocalizedText(
          translations: <ModelLanguage, String>{
            ModelLanguage.spanishColombia: 'Hola',
            ModelLanguage.englishUnitedStates: 'Different',
          },
        ),
      ),
    );
    expect(a.toJson(), b.toJson());
    expect(ModelLocalizedText.fromJson(a.toJson()), a);
    final List<dynamic> entries = a.toJson()['translations'] as List<dynamic>;
    expect(
      (entries.first as Map<String, dynamic>)['language'],
      ModelLanguage.englishUnitedStates.toJson(),
    );
  });

  test(
    'permissive language tags can collide; sorting does not normalize identity',
    () {
      const ModelLanguage first = ModelLanguage(languageCode: 'a-b');
      const ModelLanguage second = ModelLanguage(
        languageCode: 'a',
        scriptCode: 'b',
      );
      expect(first.canonicalTag, second.canonicalTag);
      expect(first, isNot(second));
      final ModelLocalizedText value = ModelLocalizedText(
        translations: <ModelLanguage, String>{first: 'one', second: 'two'},
      );
      final List<dynamic> output =
          value.toJson()['translations'] as List<dynamic>;
      expect(output, hasLength(2));
      expect(
        output.map((dynamic item) => (item as Map<String, dynamic>)['text']),
        unorderedEquals(<String>['one', 'two']),
      );
    },
  );

  test('both canonical synthetic fixtures match actual wire output', () {
    final Map<String, dynamic> language = jsonDecode(
      File('test/fixtures/model-language.example.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final Map<String, dynamic> localized = jsonDecode(
      File('test/fixtures/model-localized-text.example.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    expect(ModelLanguage.fromJson(language).toJson(), language);
    expect(ModelLocalizedText.fromJson(localized).toJson(), localized);
    expect(
      jsonDecode(jsonEncode(ModelLocalizedText.fromJson(localized).toJson())),
      localized,
    );
  });
}
