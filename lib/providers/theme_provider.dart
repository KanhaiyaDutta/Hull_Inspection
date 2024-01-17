import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // ThemeData _lightTheme = ThemeData.light();
  // ThemeData _darkTheme = ThemeData.dark();
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData =
        _themeData == ThemeData.light() ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
