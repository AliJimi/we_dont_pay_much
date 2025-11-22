// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'محاسبه‌گر کارمزد انتقال';

  @override
  String get resultInterestLabel => 'مبلغ سود / کارمزد';

  @override
  String get currencySettingsTitle => 'واحد پول';

  @override
  String get currencyRialOnly => 'فقط ریال';

  @override
  String get currencyTomanOnly => 'فقط تومان';

  @override
  String get currencyRialAndToman => 'ریال و تومان';

  @override
  String get currencyRialLabel => 'ریال';

  @override
  String get currencyTomanLabel => 'تومان';

  @override
  String get navCalculator => 'محاسبه';

  @override
  String get navBankApps => 'اپ‌های بانکی';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get calculatorTitle => 'محاسبه‌گر سود و کارمزد';

  @override
  String get calculatorDescription =>
      'مبلغ نهایی یا مبلغ پایه‌ی انتقال پول را با درنظرگرفتن سود و کارمزد محاسبه کنید.';

  @override
  String get amountLabelBase => 'مبلغ پایه';

  @override
  String get amountLabelTotal => 'مبلغ نهایی (با کارمزد)';

  @override
  String get amountHint => 'مبلغ را وارد کنید';

  @override
  String get interestRateLabel => 'درصد سود / کارمزد';

  @override
  String get interestRateHint => 'مثلاً ۲.۵';

  @override
  String get calculationModeTitle => 'نوع محاسبه';

  @override
  String get modeAddInterestTitle => 'افزودن کارمزد به مبلغ پایه';

  @override
  String get modeAddInterestSubtitle =>
      'مبلغ پایه را می‌دانید و می‌خواهید مبلغ نهایی را حساب کنید.';

  @override
  String get modeRemoveInterestTitle => 'حذف کارمزد از مبلغ نهایی';

  @override
  String get modeRemoveInterestSubtitle =>
      'مبلغ نهایی را می‌دانید و می‌خواهید مبلغ پایه را حساب کنید.';

  @override
  String get calculateButton => 'محاسبه';

  @override
  String get resultTitle => 'نتیجه';

  @override
  String get resultTotalLabel => 'مبلغ نهایی با کارمزد';

  @override
  String get resultBaseLabel => 'مبلغ پایه بدون کارمزد';

  @override
  String get errorInvalidNumber => 'لطفاً مبلغ و درصد را به‌درستی وارد کنید.';

  @override
  String get bankScannerTitle => 'اپ‌های بانکی نصب‌شده';

  @override
  String get bankScannerDescription =>
      'دستگاه را برای پیدا کردن اپ‌های بانکی و پرداخت اسکن کنید.';

  @override
  String get scanButton => 'اسکن';

  @override
  String get installedBankAppsTitle => 'اپ‌های شناسایی‌شده';

  @override
  String get noBankAppsFound => 'هیچ اپ بانکی‌ای روی این دستگاه پیدا نشد.';

  @override
  String get scanningInProgress => 'در حال اسکن اپ‌های نصب‌شده...';

  @override
  String get platformNotSupported =>
      'اسکن اپ‌های بانکی فقط روی دستگاه‌های اندروید فعال است.';

  @override
  String get settingsTitle => 'تنظیمات برنامه';

  @override
  String get themeSectionTitle => 'پوسته';

  @override
  String get themeSystem => 'همان پوستهٔ سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get languageSectionTitle => 'زبان';

  @override
  String get languageEnglish => 'انگلیسی';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get languageArabic => 'عربی';

  @override
  String get okButton => 'باشه';

  @override
  String get cancelButton => 'انصراف';
}
