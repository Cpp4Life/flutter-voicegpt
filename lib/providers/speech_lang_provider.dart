import 'package:flutter/cupertino.dart';
import 'package:voicegpt/models/lang_model.dart';

class SpeechLangProvider with ChangeNotifier {
  LanguageModel _lm = const LanguageModel(
    lang: 'English (US)',
    flagUrl: 'assets/svg/us.svg',
    localeID: 'en-US',
  );

  LanguageModel get lm {
    return _lm;
  }

  void setSpeechLanguage(LanguageModel model) {
    _lm = model;
    notifyListeners();
  }
}
