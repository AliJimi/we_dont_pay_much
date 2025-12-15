// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get transferTypeLabel => 'نوع خدمة التحويل';

  @override
  String get transferTypeCardToCard => 'تحويل شبكي من بطاقة إلى بطاقة / شباً';

  @override
  String get transferTypePayaIndividual => 'تحويل بايا - فردي';

  @override
  String get transferTypePayaGroup => 'تحويل بايا - جماعي';

  @override
  String get transferTypeSatna => 'ساتنا';

  @override
  String get transferTypePol => 'تحويل بطريقة بول (الجسر)';

  @override
  String get versionDiscontinuedTitle => 'تحديث التطبيق مطلوب';

  @override
  String versionDiscontinuedMessage(String current, String latest) {
    return 'إصدار التطبيق الحالي ($current) لم يعد مدعومًا. يُرجى التحديث إلى الإصدار $latest أو أحدث للمتابعة في الاستخدام.';
  }

  @override
  String get versionDiscontinuedExitButton => 'إغلاق التطبيق';

  @override
  String get versionUpdateTitle => 'يتوفر تحديث جديد';

  @override
  String versionUpdateMessage(String current, String latest) {
    return 'يتوفر إصدار أحدث من التطبيق ($latest). الإصدار الحالي لديك هو $current.';
  }

  @override
  String get versionUpdateLaterButton => 'لاحقًا';

  @override
  String get versionUpdateNowButton => 'حدّث الآن';

  @override
  String get feeConfigLoading => 'جاري تحميل رسوم التحويل...';

  @override
  String get feeConfigError => 'تعذر تحميل رسوم التحويل. حاول مرة أخرى.';

  @override
  String get errorConfigNotLoaded =>
      'لم يتم تحميل بيانات الرسوم بعد. حاول بعد قليل.';

  @override
  String get errorNoTransferType => 'يرجى اختيار نوع خدمة التحويل.';

  @override
  String errorAmountOutOfRange(String min, String max) {
    return 'يجب أن يكون المبلغ بين $min و $max.';
  }

  @override
  String get appTitle => 'حاسبة رسوم التحويل';

  @override
  String get resultInterestLabel => 'قيمة الفائدة / الرسوم';

  @override
  String get currencySettingsTitle => 'العملة';

  @override
  String get currencyRialOnly => 'ريال فقط';

  @override
  String get currencyTomanOnly => 'تومان فقط';

  @override
  String get currencyRialAndToman => 'ريال و تومان';

  @override
  String get currencyRialLabel => 'ريال';

  @override
  String get currencyTomanLabel => 'تومان';

  @override
  String get navCalculator => 'الحاسبة';

  @override
  String get navBankApps => 'تطبيقات البنوك';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get calculatorTitle => 'حاسبة الفائدة والرسوم';

  @override
  String get calculatorDescription =>
      'احسب المبلغ الأساسي أو المبلغ النهائي عند إضافة أو خصم الفائدة والرسوم.';

  @override
  String get amountLabelBase => 'المبلغ الأساسي';

  @override
  String get amountLabelTotal => 'المبلغ النهائي (مع الفائدة)';

  @override
  String get amountHint => 'أدخل المبلغ';

  @override
  String get interestRateLabel => 'نسبة الفائدة / الرسوم (%)';

  @override
  String get interestRateHint => 'مثال: 2.5';

  @override
  String get calculationModeTitle => 'وضع الحسبة';

  @override
  String get modeAddInterestTitle => 'إضافة الفائدة إلى المبلغ الأساسي';

  @override
  String get modeAddInterestSubtitle =>
      'تعرف المبلغ الأساسي وتريد معرفة المبلغ النهائي.';

  @override
  String get modeRemoveInterestTitle => 'خصم الفائدة من المبلغ النهائي';

  @override
  String get modeRemoveInterestSubtitle =>
      'تعرف المبلغ النهائي وتريد معرفة المبلغ الأساسي.';

  @override
  String get calculateButton => 'احسب';

  @override
  String get resultTitle => 'النتيجة';

  @override
  String get resultTotalLabel => 'المبلغ النهائي مع الفائدة';

  @override
  String get resultBaseLabel => 'المبلغ الأساسي بدون فائدة';

  @override
  String get errorInvalidNumber =>
      'يرجى إدخال أرقام صحيحة للمبلغ ونسبة الفائدة.';

  @override
  String get bankScannerTitle => 'تطبيقات البنوك المثبتة';

  @override
  String get bankScannerDescription =>
      'افحص الجهاز للعثور على تطبيقات البنوك والدفع.';

  @override
  String get scanButton => 'فحص الآن';

  @override
  String get installedBankAppsTitle => 'التطبيقات المكتشفة';

  @override
  String get noBankAppsFound =>
      'لم يتم العثور على أي تطبيقات بنكية على هذا الجهاز.';

  @override
  String get scanningInProgress => 'جارٍ فحص التطبيقات المثبتة...';

  @override
  String get platformNotSupported =>
      'فحص تطبيقات البنوك متوفر فقط على أجهزة أندرويد.';

  @override
  String get settingsTitle => 'إعدادات التطبيق';

  @override
  String get themeSectionTitle => 'المظهر';

  @override
  String get themeSystem => 'مثل مظهر النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get languageSectionTitle => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languagePersian => 'الفارسية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get okButton => 'موافق';

  @override
  String get cancelButton => 'إلغاء';
}
