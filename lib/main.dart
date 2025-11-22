// we_dont_pay_much/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:we_dont_pay_much/app.dart';
import 'package:we_dont_pay_much/services/app_settings_service.dart';
import 'package:we_dont_pay_much/core/constants/currency_display_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final storedThemeIndex =
      prefs.getInt(AppSettingsService.prefThemeModeKey) ??
          ThemeMode.system.index;
  final storedLocaleCode =
  prefs.getString(AppSettingsService.prefLocaleCodeKey);
  final storedCurrencyIndex =
      prefs.getInt(AppSettingsService.prefCurrencyDisplayModeKey) ??
          CurrencyDisplayMode.both.index;

  final initialThemeMode = ThemeMode.values[storedThemeIndex];
  final initialLocale =
  storedLocaleCode != null && storedLocaleCode.isNotEmpty
      ? Locale(storedLocaleCode)
      : const Locale('en');
  final initialCurrencyDisplayMode =
  CurrencyDisplayMode.values[storedCurrencyIndex];

  final settings = AppSettingsService(
    prefs: prefs,
    initialThemeMode: initialThemeMode,
    initialLocale: initialLocale,
    initialCurrencyDisplayMode: initialCurrencyDisplayMode,
  );

  runApp(
    ChangeNotifierProvider<AppSettingsService>.value(
      value: settings,
      child: const InterestTransferRoot(),
    ),
  );
}
