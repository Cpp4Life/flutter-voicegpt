class LanguageModel {
  final String lang;
  final String flagUrl;
  final String localeID;

  const LanguageModel({
    required this.lang,
    required this.flagUrl,
    required this.localeID,
  });

  LanguageModel copyWith({String? lang, String? flagUrl, String? localeID}) {
    return LanguageModel(
        lang: lang ?? this.lang,
        flagUrl: flagUrl ?? this.flagUrl,
        localeID: localeID ?? this.localeID);
  }
}
