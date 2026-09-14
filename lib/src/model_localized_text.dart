// Adapted from EV-A-0292; see docs/migration/CORE_SELECTION.md.
import 'model_language.dart';
import 'utils.dart';

/// Owned language-to-text values with sorted wire output.
/// The fallback language is metadata; no automatic text lookup is performed.
class ModelLocalizedText {
  ModelLocalizedText({
    required Map<ModelLanguage, String> translations,
    this.fallbackLanguage = ModelLanguage.undetermined,
  }) : translations = Map<ModelLanguage, String>.unmodifiable(translations);

  factory ModelLocalizedText.fromJson(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> rawTranslations = Utils.listFromDynamic(
      json[translationsKey],
    );

    final Map<ModelLanguage, String> translations = <ModelLanguage, String>{};

    for (final Map<String, dynamic> rawTranslation in rawTranslations) {
      final ModelLanguage language = ModelLanguage.fromJson(
        Utils.mapFromDynamic(rawTranslation[languageKey]),
      );

      final String text = Utils.getStringFromDynamic(rawTranslation[textKey]);

      translations[language] = text;
    }

    final ModelLanguage fallbackLanguage = ModelLanguage.fromJson(
      Utils.mapFromDynamic(json[fallbackLanguageKey]),
    );

    return ModelLocalizedText(
      translations: translations,
      fallbackLanguage: fallbackLanguage,
    );
  }

  final Map<ModelLanguage, String> translations;

  final ModelLanguage fallbackLanguage;

  static const String translationsKey = 'translations';

  static const String fallbackLanguageKey = 'fallbackLanguage';

  static const String languageKey = 'language';

  static const String textKey = 'text';
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelLocalizedText &&
            fallbackLanguage == other.fallbackLanguage &&
            _translationsAreEqual(translations, other.translations);
  }

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final Iterable<int> translationHashes = translations.entries.map((
      MapEntry<ModelLanguage, String> entry,
    ) {
      return Object.hash(entry.key, entry.value);
    });

    return Object.hash(
      fallbackLanguage,
      Object.hashAllUnordered(translationHashes),
    );
  }

  static bool _translationsAreEqual(
    Map<ModelLanguage, String> first,
    Map<ModelLanguage, String> second,
  ) {
    if (identical(first, second)) {
      return true;
    }

    if (first.length != second.length) {
      return false;
    }

    for (final MapEntry<ModelLanguage, String> entry in first.entries) {
      if (!second.containsKey(entry.key) || second[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  Map<String, dynamic> toJson() {
    final List<MapEntry<ModelLanguage, String>> sortedEntries =
        translations.entries.toList()..sort((
          MapEntry<ModelLanguage, String> first,
          MapEntry<ModelLanguage, String> second,
        ) {
          return first.key.canonicalTag.compareTo(second.key.canonicalTag);
        });

    return <String, dynamic>{
      translationsKey: sortedEntries
          .map(
            (MapEntry<ModelLanguage, String> entry) => <String, dynamic>{
              languageKey: entry.key.toJson(),
              textKey: entry.value,
            },
          )
          .toList(growable: false),
      fallbackLanguageKey: fallbackLanguage.toJson(),
    };
  }
}
