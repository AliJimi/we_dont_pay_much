// we_dont_pay_much/features/settings/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:we_dont_pay_much/core/constants/app_sizes.dart';
import 'package:we_dont_pay_much/core/constants/currency_display_mode.dart';
import 'package:we_dont_pay_much/core/widgets/app_scaffold.dart';
import 'package:we_dont_pay_much/l10n/app_localizations.dart';
import 'package:we_dont_pay_much/services/app_settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = context.watch<AppSettingsService>();

    return AppPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.settingsTitle,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.lg),

          // Theme section
          Text(
            t.themeSectionTitle,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.sm),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settings.setThemeMode(value);
                    }
                  },
                  title: Text(t.themeSystem),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settings.setThemeMode(value);
                    }
                  },
                  title: Text(t.themeLight),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settings.setThemeMode(value);
                    }
                  },
                  title: Text(t.themeDark),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.lg),

          // Language section
          Text(
            t.languageSectionTitle,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.sm),
          Card(
            child: Column(
              children: const [
                _LanguageTile(
                  labelKey: 'languageEnglish',
                  localeCode: 'en',
                ),
                _LanguageTile(
                  labelKey: 'languagePersian',
                  localeCode: 'fa',
                ),
                _LanguageTile(
                  labelKey: 'languageArabic',
                  localeCode: 'ar',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.lg),

          // Currency section
          Text(
            t.currencySettingsTitle,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.sm),
          Card(
            child: Column(
              children: const [
                _CurrencyTile(
                  mode: CurrencyDisplayMode.rialOnly,
                  labelKey: 'currencyRialOnly',
                ),
                _CurrencyTile(
                  mode: CurrencyDisplayMode.tomanOnly,
                  labelKey: 'currencyTomanOnly',
                ),
                _CurrencyTile(
                  mode: CurrencyDisplayMode.both,
                  labelKey: 'currencyRialAndToman',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.labelKey,
    required this.localeCode,
  });

  final String labelKey;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsService>();
    final t = AppLocalizations.of(context)!;

    final isSelected = settings.locale.languageCode == localeCode;

    String label;
    switch (labelKey) {
      case 'languagePersian':
        label = t.languagePersian;
        break;
      case 'languageArabic':
        label = t.languageArabic;
        break;
      case 'languageEnglish':
      default:
        label = t.languageEnglish;
        break;
    }

    return RadioListTile<String>(
      value: localeCode,
      groupValue: settings.locale.languageCode,
      title: Text(label),
      selected: isSelected,
      onChanged: (value) {
        if (value != null) {
          settings.setLocale(Locale(value));
        }
      },
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.mode,
    required this.labelKey,
  });

  final CurrencyDisplayMode mode;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsService>();
    final t = AppLocalizations.of(context)!;

    String label;
    switch (labelKey) {
      case 'currencyTomanOnly':
        label = t.currencyTomanOnly;
        break;
      case 'currencyRialAndToman':
        label = t.currencyRialAndToman;
        break;
      case 'currencyRialOnly':
      default:
        label = t.currencyRialOnly;
        break;
    }

    return RadioListTile<CurrencyDisplayMode>(
      value: mode,
      groupValue: settings.currencyDisplayMode,
      title: Text(label),
      onChanged: (value) {
        if (value != null) {
          settings.setCurrencyDisplayMode(value);
        }
      },
    );
  }
}
