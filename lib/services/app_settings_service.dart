// we_dont_pay_much/services/app_settings_service.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:we_dont_pay_much/core/constants/currency_display_mode.dart';

class AppSettingsService extends ChangeNotifier {
  AppSettingsService({
    required SharedPreferences prefs,
    required ThemeMode initialThemeMode,
    required Locale initialLocale,
    required CurrencyDisplayMode initialCurrencyDisplayMode,
  })  : _prefs = prefs,
        _themeMode = initialThemeMode,
        _locale = initialLocale,
        _currencyDisplayMode = initialCurrencyDisplayMode;

  final SharedPreferences _prefs;

  static const String prefThemeModeKey = 'themeMode';
  static const String prefLocaleCodeKey = 'localeCode';
  static const String prefCurrencyDisplayModeKey = 'currencyDisplayMode';

  ThemeMode _themeMode;
  Locale _locale;
  CurrencyDisplayMode _currencyDisplayMode;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  CurrencyDisplayMode get currencyDisplayMode => _currencyDisplayMode;

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

  Future<void> setCurrencyDisplayMode(CurrencyDisplayMode mode) async {
    _currencyDisplayMode = mode;
    await _prefs.setInt(prefCurrencyDisplayModeKey, mode.index);
    notifyListeners();
  }
}
