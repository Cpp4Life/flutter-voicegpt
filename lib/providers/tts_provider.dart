import 'package:flutter/foundation.dart';

class AutoTTSProvider with ChangeNotifier {
  bool _isSwitched = true;

  bool get isSwitched {
    return _isSwitched;
  }

  void toggleAutoTTS(bool value) {
    _isSwitched = value;
    notifyListeners();
  }
}
