// Adapted from EV-A-0292; see docs/migration/CORE_SELECTION.md.
import 'model_language.dart';
import 'utils.dart';

/// Owned language-to-text values with sorted wire output.
/// The fallback language is metadata; no automatic text lookup is performed.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// void main() {
///   final ModelLocalizedText text = ModelLocalizedText(
///     translations: <ModelLanguage, String>{ModelLanguage.spanishColombia: 'Hola'},
///   );
///   assert(text.translations[text.fallbackLanguage] == null);
///   assert(ModelLocalizedText.fromJson(text.toJson()) == text);
/// }
/// ```
class ModelLocalizedText {
  /// Copies [translations] into an unmodifiable map and stores [fallbackLanguage].
  ///
  /// The fallback is metadata only: it need not have a translation, and no lookup
  /// or substitution is performed. Later changes to the input map have no effect.
  ModelLocalizedText({
    required Map<ModelLanguage, String> translations,
    this.fallbackLanguage = ModelLanguage.undetermined,
  }) : translations = Map<ModelLanguage, String>.unmodifiable(translations);

  /// Decodes translation records and fallback from [json] using tolerant Utils
  /// and [ModelLanguage.fromJson] conversions.
  ///
  /// Non-list translations become empty; non-map records are skipped. Normalized
  /// duplicate languages use the last retained record. Missing text becomes empty
  /// and missing fallback becomes the undetermined language.
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

  /// Owned, unmodifiable language-to-text entries, including empty text values.
  final Map<ModelLanguage, String> translations;

  /// Fallback metadata; does not imply a stored translation or automatic lookup.
  final ModelLanguage fallbackLanguage;

  /// Wire key `translations`.
  static const String translationsKey = 'translations';

  /// Wire key `fallbackLanguage`.
  static const String fallbackLanguageKey = 'fallbackLanguage';

  /// Wire key `language`.
  static const String languageKey = 'language';

  /// Wire key `text`.
  static const String textKey = 'text';

  /// Uses fallback and all language/text entries, ignoring insertion order.
  ///
  /// Equal objects have matching hashes under their language component contracts.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelLocalizedText &&
            fallbackLanguage == other.fallbackLanguage &&
            _translationsAreEqual(translations, other.translations);
  }

  /// Uses fallback and all language/text entries, ignoring insertion order.
  ///
  /// Equal objects have matching hashes under their language component contracts.
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

  /// Returns new wire maps with translations sorted by language canonical tag.
  ///
  /// Fallback is always emitted. Distinct permissive language objects can share
  /// a tag: sorting does not merge them or guarantee tie order across inputs.
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
