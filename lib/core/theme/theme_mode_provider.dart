import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {

  late ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeModeProvider() { _init(); }

  static final String _keyTheme = 'keyTheme';

  void _init() async {
    _mode = ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyTheme);
    if (value == null || value.isEmpty) {
      _mode = ThemeMode.system;
      notifyListeners();
    } else {
      if (value == ThemeMode.light.toString()) {
        _mode = ThemeMode.light;
      } else {
        _mode = ThemeMode.dark;
      }
      notifyListeners();
    }
  }


  void toggle() async {
    final prefs = await SharedPreferences.getInstance();
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    prefs.setString(_keyTheme, _mode.toString());
    notifyListeners();
  }
}