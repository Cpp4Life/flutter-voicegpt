import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isSwitched = false;

  bool get isSwitched {
    return _isSwitched;
  }

  void toggleTheme(bool value) {
    _isSwitched = value;
    notifyListeners();
  }
}
