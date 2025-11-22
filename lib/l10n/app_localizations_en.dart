// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get transferTypeLabel => 'Transfer type';

  @override
  String get transferTypeCardToCard => 'Shetabi card-to-card';

  @override
  String get transferTypePayaIndividual => 'Paya – individual';

  @override
  String get transferTypePayaGroup => 'Paya – group';

  @override
  String get transferTypeSatna => 'Satna';

  @override
  String get transferTypePol => 'Pol (bridge transfer)';

  @override
  String get feeConfigLoading => 'Loading transfer fee rules...';

  @override
  String get feeConfigError => 'Unable to load fee rules. Please try again.';

  @override
  String get errorConfigNotLoaded =>
      'Fee rules are not loaded yet. Please try again in a moment.';

  @override
  String get errorNoTransferType => 'Please choose a transfer type.';

  @override
  String errorAmountOutOfRange(String min, String max) {
    return 'Amount must be between $min and $max.';
  }

  @override
  String get appTitle => 'Interest Transfer Calculator';

  @override
  String get resultInterestLabel => 'Interest / fee amount';

  @override
  String get currencySettingsTitle => 'Currency';

  @override
  String get currencyRialOnly => 'Rial only';

  @override
  String get currencyTomanOnly => 'Toman only';

  @override
  String get currencyRialAndToman => 'Rial & Toman';

  @override
  String get currencyRialLabel => 'Rial';

  @override
  String get currencyTomanLabel => 'Toman';

  @override
  String get navCalculator => 'Calculator';

  @override
  String get navBankApps => 'Bank apps';

  @override
  String get navSettings => 'Settings';

  @override
  String get calculatorTitle => 'Interest calculator';

  @override
  String get calculatorDescription =>
      'Quickly compute how much you send or receive when transfer interest or fees are added or removed.';

  @override
  String get amountLabelBase => 'Base amount';

  @override
  String get amountLabelTotal => 'Total amount (with interest)';

  @override
  String get amountHint => 'Enter amount';

  @override
  String get interestRateLabel => 'Interest / fee (%)';

  @override
  String get interestRateHint => 'e.g. 2.5';

  @override
  String get calculationModeTitle => 'Calculation mode';

  @override
  String get modeAddInterestTitle => 'Add interest to base';

  @override
  String get modeAddInterestSubtitle =>
      'You know the base amount and want the final total.';

  @override
  String get modeRemoveInterestTitle => 'Remove interest from total';

  @override
  String get modeRemoveInterestSubtitle =>
      'You know the final total and want the base amount.';

  @override
  String get calculateButton => 'Calculate';

  @override
  String get resultTitle => 'Result';

  @override
  String get resultTotalLabel => 'Total with interest';

  @override
  String get resultBaseLabel => 'Base amount (without interest)';

  @override
  String get errorInvalidNumber =>
      'Please enter valid numbers for amount and interest rate.';

  @override
  String get bankScannerTitle => 'Installed bank apps';

  @override
  String get bankScannerDescription =>
      'Scan your device for installed mobile banking and payment apps.';

  @override
  String get scanButton => 'Scan now';

  @override
  String get installedBankAppsTitle => 'Detected apps';

  @override
  String get noBankAppsFound => 'No banking apps detected on this device.';

  @override
  String get scanningInProgress => 'Scanning installed apps...';

  @override
  String get platformNotSupported =>
      'Bank app scanning is only available on Android devices.';

  @override
  String get settingsTitle => 'App settings';

  @override
  String get themeSectionTitle => 'Theme';

  @override
  String get themeSystem => 'Use system theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'Persian (Farsi)';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get okButton => 'OK';

  @override
  String get cancelButton => 'Cancel';
}
