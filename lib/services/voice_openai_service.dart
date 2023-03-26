import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

class VoiceOpenAIService {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  SpeechToText get speechToText {
    return _speechToText;
  }

  bool get isEnabled {
    return _speechEnabled;
  }

  Future<String> startListening() async {
    final completer = Completer<String>();
    _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          completer.complete(result.recognizedWords);
        }
      },
    );
    return completer.future;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}
