// we_dont_pay_much/services/app_settings_service.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends ChangeNotifier {
  AppSettingsService({
    required SharedPreferences prefs,
    required ThemeMode initialThemeMode,
    required Locale initialLocale,
  }) : _prefs = prefs,
       _themeMode = initialThemeMode,
       _locale = initialLocale;

  final SharedPreferences _prefs;

  static const String prefThemeModeKey = 'themeMode';
  static const String prefLocaleCodeKey = 'localeCode';

  ThemeMode _themeMode;
  Locale _locale;

  ThemeMode get themeMode => _themeMode;

  Locale get locale => _locale;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(prefThemeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(prefLocaleCodeKey, locale.languageCode);
    notifyListeners();
  }
}
