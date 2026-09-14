// Adapted from EV-A-0291; see docs/migration/CORE_SELECTION.md.
import 'utils.dart';

/// Language, script and region value. Decoding normalizes; construction preserves input.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// void main() {
///   final ModelLanguage language = ModelLanguage.fromJson(<String, dynamic>{
///     'languageCode': ' ES ', 'regionCode': 'co',
///   });
///   assert(language == ModelLanguage.spanishColombia);
///   assert(language.canonicalTag == 'es-CO');
/// }
/// ```
class ModelLanguage {
  /// Stores [languageCode], [scriptCode] and [regionCode] without normalization.
  ///
  /// Only an empty language is rejected, via a debug assertion. Direct strings
  /// are otherwise permissive; this constructor does not validate BCP 47 syntax.
  const ModelLanguage({
    required this.languageCode,
    this.scriptCode = '',
    this.regionCode = '',
  }) : assert(languageCode != '');

  /// Decodes [json] with Utils text coercion and trimmed language components.
  ///
  /// Language becomes lowercase or `und` when absent; script becomes title case
  /// and region uppercase. It does not validate registered language tags.
  factory ModelLanguage.fromJson(Map<String, dynamic> json) {
    final String rawLanguageCode = Utils.getStringFromDynamic(
      json[languageCodeKey],
    ).trim();

    final String rawScriptCode = Utils.getStringFromDynamic(json[scriptCodeKey])
        .trim();

    final String rawRegionCode = Utils.getStringFromDynamic(json[regionCodeKey])
        .trim();

    return ModelLanguage(
      languageCode: rawLanguageCode.isEmpty
          ? undeterminedCode
          : rawLanguageCode.toLowerCase(),
      scriptCode: _normalizeScriptCode(rawScriptCode),
      regionCode: rawRegionCode.toUpperCase(),
    );
  }

  /// Wire key `languageCode`.
  static const String languageCodeKey = 'languageCode';

  /// Wire key `scriptCode`.
  static const String scriptCodeKey = 'scriptCode';

  /// Wire key `regionCode`.
  static const String regionCodeKey = 'regionCode';

  /// Language code used when decoding absent or empty language text.
  static const String undeterminedCode = 'und';

  /// Preset for `und`.
  static const ModelLanguage undetermined = ModelLanguage(
    languageCode: undeterminedCode,
  );

  /// Preset for `es-CO`.
  static const ModelLanguage spanishColombia = ModelLanguage(
    languageCode: 'es',
    regionCode: 'CO',
  );

  /// Preset for `es-MX`.
  static const ModelLanguage spanishMexico = ModelLanguage(
    languageCode: 'es',
    regionCode: 'MX',
  );

  /// Preset for `es-ES`.
  static const ModelLanguage spanishSpain = ModelLanguage(
    languageCode: 'es',
    regionCode: 'ES',
  );

  /// Preset for `es-AR`.
  static const ModelLanguage spanishArgentina = ModelLanguage(
    languageCode: 'es',
    regionCode: 'AR',
  );

  /// Preset for `es-CL`.
  static const ModelLanguage spanishChile = ModelLanguage(
    languageCode: 'es',
    regionCode: 'CL',
  );

  /// Preset for `es-PE`.
  static const ModelLanguage spanishPeru = ModelLanguage(
    languageCode: 'es',
    regionCode: 'PE',
  );

  /// Preset for `en-US`.
  static const ModelLanguage englishUnitedStates = ModelLanguage(
    languageCode: 'en',
    regionCode: 'US',
  );

  /// Preset for `en-GB`.
  static const ModelLanguage englishUnitedKingdom = ModelLanguage(
    languageCode: 'en',
    regionCode: 'GB',
  );

  /// Preset for `en-CA`.
  static const ModelLanguage englishCanada = ModelLanguage(
    languageCode: 'en',
    regionCode: 'CA',
  );

  /// Preset for `en-AU`.
  static const ModelLanguage englishAustralia = ModelLanguage(
    languageCode: 'en',
    regionCode: 'AU',
  );

  /// Preset for `pt-BR`.
  static const ModelLanguage portugueseBrazil = ModelLanguage(
    languageCode: 'pt',
    regionCode: 'BR',
  );

  /// Preset for `pt-PT`.
  static const ModelLanguage portuguesePortugal = ModelLanguage(
    languageCode: 'pt',
    regionCode: 'PT',
  );

  /// Preset for `fr-FR`.
  static const ModelLanguage frenchFrance = ModelLanguage(
    languageCode: 'fr',
    regionCode: 'FR',
  );

  /// Preset for `de-DE`.
  static const ModelLanguage germanGermany = ModelLanguage(
    languageCode: 'de',
    regionCode: 'DE',
  );

  /// Preset for `it-IT`.
  static const ModelLanguage italianItaly = ModelLanguage(
    languageCode: 'it',
    regionCode: 'IT',
  );

  /// Preset for `nl-NL`.
  static const ModelLanguage dutchNetherlands = ModelLanguage(
    languageCode: 'nl',
    regionCode: 'NL',
  );

  /// Preset for `ja-JP`.
  static const ModelLanguage japaneseJapan = ModelLanguage(
    languageCode: 'ja',
    regionCode: 'JP',
  );

  /// Preset for `ko-KR`.
  static const ModelLanguage koreanSouthKorea = ModelLanguage(
    languageCode: 'ko',
    regionCode: 'KR',
  );

  /// Preset for `zh-Hans-CN`.
  static const ModelLanguage chineseChina = ModelLanguage(
    languageCode: 'zh',
    scriptCode: 'Hans',
    regionCode: 'CN',
  );

  /// Preset for `zh-Hant-TW`.
  static const ModelLanguage chineseTaiwan = ModelLanguage(
    languageCode: 'zh',
    scriptCode: 'Hant',
    regionCode: 'TW',
  );

  /// Preset for `hi-IN`.
  static const ModelLanguage hindiIndia = ModelLanguage(
    languageCode: 'hi',
    regionCode: 'IN',
  );

  /// Preset for `id-ID`.
  static const ModelLanguage indonesianIndonesia = ModelLanguage(
    languageCode: 'id',
    regionCode: 'ID',
  );

  /// Preset for `tr-TR`.
  static const ModelLanguage turkishTurkey = ModelLanguage(
    languageCode: 'tr',
    regionCode: 'TR',
  );

  /// Preset for `pl-PL`.
  static const ModelLanguage polishPoland = ModelLanguage(
    languageCode: 'pl',
    regionCode: 'PL',
  );

  /// Preset for `sv-SE`.
  static const ModelLanguage swedishSweden = ModelLanguage(
    languageCode: 'sv',
    regionCode: 'SE',
  );

  /// Preset for `no-NO`.
  static const ModelLanguage norwegianNorway = ModelLanguage(
    languageCode: 'no',
    regionCode: 'NO',
  );

  /// Language component, preserved by construction and lowercased on decoding.
  final String languageCode;

  /// Optional script component; empty means omitted from [canonicalTag].
  final String scriptCode;

  /// Optional region component; empty means omitted from [canonicalTag].
  final String regionCode;

  /// Uses all three component strings for value equality and consistent hashing.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelLanguage &&
            languageCode == other.languageCode &&
            scriptCode == other.scriptCode &&
            regionCode == other.regionCode;
  }

  /// Uses all three component strings for value equality and consistent hashing.
  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(languageCode, scriptCode, regionCode);

  /// Returns a new map containing all three component keys, including empty ones.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      languageCodeKey: languageCode,
      scriptCodeKey: scriptCode,
      regionCodeKey: regionCode,
    };
  }

  static String _normalizeScriptCode(String value) {
    if (value.isEmpty) {
      return '';
    }

    final String normalized = value.toLowerCase();

    return '${normalized[0].toUpperCase()}${normalized.substring(1)}';
  }

  /// Joins the language and nonempty script/region components with hyphens.
  ///
  /// No normalization or validation occurs here. Permissive component strings can
  /// give unequal language objects identical tags; the tag is not a unique key.
  String get canonicalTag {
    return <String>[
      languageCode,
      if (scriptCode.isNotEmpty) scriptCode,
      if (regionCode.isNotEmpty) regionCode,
    ].join('-');
  }
}
