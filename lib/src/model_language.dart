// Adapted from EV-A-0291; see docs/migration/CORE_SELECTION.md.
import 'utils.dart';

/// Language, script and region value. Decoding normalizes; construction preserves input.
class ModelLanguage {
  const ModelLanguage({
    required this.languageCode,
    this.scriptCode = '',
    this.regionCode = '',
  }) : assert(languageCode != '');

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

  static const String languageCodeKey = 'languageCode';

  static const String scriptCodeKey = 'scriptCode';

  static const String regionCodeKey = 'regionCode';

  static const String undeterminedCode = 'und';

  static const ModelLanguage undetermined = ModelLanguage(
    languageCode: undeterminedCode,
  );

  static const ModelLanguage spanishColombia = ModelLanguage(
    languageCode: 'es',
    regionCode: 'CO',
  );

  static const ModelLanguage spanishMexico = ModelLanguage(
    languageCode: 'es',
    regionCode: 'MX',
  );

  static const ModelLanguage spanishSpain = ModelLanguage(
    languageCode: 'es',
    regionCode: 'ES',
  );

  static const ModelLanguage spanishArgentina = ModelLanguage(
    languageCode: 'es',
    regionCode: 'AR',
  );

  static const ModelLanguage spanishChile = ModelLanguage(
    languageCode: 'es',
    regionCode: 'CL',
  );

  static const ModelLanguage spanishPeru = ModelLanguage(
    languageCode: 'es',
    regionCode: 'PE',
  );

  static const ModelLanguage englishUnitedStates = ModelLanguage(
    languageCode: 'en',
    regionCode: 'US',
  );

  static const ModelLanguage englishUnitedKingdom = ModelLanguage(
    languageCode: 'en',
    regionCode: 'GB',
  );

  static const ModelLanguage englishCanada = ModelLanguage(
    languageCode: 'en',
    regionCode: 'CA',
  );

  static const ModelLanguage englishAustralia = ModelLanguage(
    languageCode: 'en',
    regionCode: 'AU',
  );

  static const ModelLanguage portugueseBrazil = ModelLanguage(
    languageCode: 'pt',
    regionCode: 'BR',
  );

  static const ModelLanguage portuguesePortugal = ModelLanguage(
    languageCode: 'pt',
    regionCode: 'PT',
  );

  static const ModelLanguage frenchFrance = ModelLanguage(
    languageCode: 'fr',
    regionCode: 'FR',
  );

  static const ModelLanguage germanGermany = ModelLanguage(
    languageCode: 'de',
    regionCode: 'DE',
  );

  static const ModelLanguage italianItaly = ModelLanguage(
    languageCode: 'it',
    regionCode: 'IT',
  );

  static const ModelLanguage dutchNetherlands = ModelLanguage(
    languageCode: 'nl',
    regionCode: 'NL',
  );

  static const ModelLanguage japaneseJapan = ModelLanguage(
    languageCode: 'ja',
    regionCode: 'JP',
  );

  static const ModelLanguage koreanSouthKorea = ModelLanguage(
    languageCode: 'ko',
    regionCode: 'KR',
  );

  static const ModelLanguage chineseChina = ModelLanguage(
    languageCode: 'zh',
    scriptCode: 'Hans',
    regionCode: 'CN',
  );

  static const ModelLanguage chineseTaiwan = ModelLanguage(
    languageCode: 'zh',
    scriptCode: 'Hant',
    regionCode: 'TW',
  );

  static const ModelLanguage hindiIndia = ModelLanguage(
    languageCode: 'hi',
    regionCode: 'IN',
  );

  static const ModelLanguage indonesianIndonesia = ModelLanguage(
    languageCode: 'id',
    regionCode: 'ID',
  );

  static const ModelLanguage turkishTurkey = ModelLanguage(
    languageCode: 'tr',
    regionCode: 'TR',
  );

  static const ModelLanguage polishPoland = ModelLanguage(
    languageCode: 'pl',
    regionCode: 'PL',
  );

  static const ModelLanguage swedishSweden = ModelLanguage(
    languageCode: 'sv',
    regionCode: 'SE',
  );

  static const ModelLanguage norwegianNorway = ModelLanguage(
    languageCode: 'no',
    regionCode: 'NO',
  );

  final String languageCode;

  final String scriptCode;

  final String regionCode;

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

  @override
  // SDK-only contract; no external immutable annotation is introduced.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(languageCode, scriptCode, regionCode);

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

  String get canonicalTag {
    return <String>[
      languageCode,
      if (scriptCode.isNotEmpty) scriptCode,
      if (regionCode.isNotEmpty) regionCode,
    ].join('-');
  }
}
