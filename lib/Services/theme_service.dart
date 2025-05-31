import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Load the theme from local storage
  ThemeMode loadTheme() {
    bool isDarkMode = _box.read(_key) ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // Save the theme mode to local storage
  void saveTheme(ThemeMode themeMode) {
    _box.write(_key, themeMode == ThemeMode.dark);
  }
}
