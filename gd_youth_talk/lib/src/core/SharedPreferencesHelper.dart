import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SharedPreferencesHelper {
  static const _themeKey = 'themeMode';

  // 테마 모드 저장
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeKey, mode.index);  // ThemeMode의 enum 값은 int로 저장됩니다.
  }
}
