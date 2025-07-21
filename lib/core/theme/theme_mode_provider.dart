import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {

  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeModeProvider({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggle() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}