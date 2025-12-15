import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
    Locale('ar'),
  ];

  /// No description provided for @transferTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer type'**
  String get transferTypeLabel;

  /// No description provided for @transferTypeCardToCard.
  ///
  /// In en, this message translates to:
  /// **'Shetabi card-to-card'**
  String get transferTypeCardToCard;

  /// No description provided for @transferTypePayaIndividual.
  ///
  /// In en, this message translates to:
  /// **'Paya – individual'**
  String get transferTypePayaIndividual;

  /// No description provided for @transferTypePayaGroup.
  ///
  /// In en, this message translates to:
  /// **'Paya – group'**
  String get transferTypePayaGroup;

  /// No description provided for @transferTypeSatna.
  ///
  /// In en, this message translates to:
  /// **'Satna'**
  String get transferTypeSatna;

  /// No description provided for @transferTypePol.
  ///
  /// In en, this message translates to:
  /// **'Pol (bridge transfer)'**
  String get transferTypePol;

  /// No description provided for @versionDiscontinuedTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get versionDiscontinuedTitle;

  /// No description provided for @versionDiscontinuedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your app version {current} is no longer supported. Please update to at least version {latest} to continue.'**
  String versionDiscontinuedMessage(String current, String latest);

  /// No description provided for @versionDiscontinuedExitButton.
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get versionDiscontinuedExitButton;

  /// No description provided for @versionUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get versionUpdateTitle;

  /// No description provided for @versionUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'A newer version ({latest}) of the app is available. You are currently on {current}.'**
  String versionUpdateMessage(String current, String latest);

  /// No description provided for @versionUpdateLaterButton.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get versionUpdateLaterButton;

  /// No description provided for @versionUpdateNowButton.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get versionUpdateNowButton;

  /// No description provided for @feeConfigLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading transfer fee rules...'**
  String get feeConfigLoading;

  /// No description provided for @feeConfigError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load fee rules. Please try again.'**
  String get feeConfigError;

  /// No description provided for @errorConfigNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Fee rules are not loaded yet. Please try again in a moment.'**
  String get errorConfigNotLoaded;

  /// No description provided for @errorNoTransferType.
  ///
  /// In en, this message translates to:
  /// **'Please choose a transfer type.'**
  String get errorNoTransferType;

  /// No description provided for @errorAmountOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Amount must be between {min} and {max}.'**
  String errorAmountOutOfRange(String min, String max);

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Interest Transfer Calculator'**
  String get appTitle;

  /// No description provided for @resultInterestLabel.
  ///
  /// In en, this message translates to:
  /// **'Interest / fee amount'**
  String get resultInterestLabel;

  /// No description provided for @currencySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencySettingsTitle;

  /// No description provided for @currencyRialOnly.
  ///
  /// In en, this message translates to:
  /// **'Rial only'**
  String get currencyRialOnly;

  /// No description provided for @currencyTomanOnly.
  ///
  /// In en, this message translates to:
  /// **'Toman only'**
  String get currencyTomanOnly;

  /// No description provided for @currencyRialAndToman.
  ///
  /// In en, this message translates to:
  /// **'Rial & Toman'**
  String get currencyRialAndToman;

  /// No description provided for @currencyRialLabel.
  ///
  /// In en, this message translates to:
  /// **'Rial'**
  String get currencyRialLabel;

  /// No description provided for @currencyTomanLabel.
  ///
  /// In en, this message translates to:
  /// **'Toman'**
  String get currencyTomanLabel;

  /// No description provided for @navCalculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get navCalculator;

  /// No description provided for @navBankApps.
  ///
  /// In en, this message translates to:
  /// **'Bank apps'**
  String get navBankApps;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @calculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Interest calculator'**
  String get calculatorTitle;

  /// No description provided for @calculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Quickly compute how much you send or receive when transfer interest or fees are added or removed.'**
  String get calculatorDescription;

  /// No description provided for @amountLabelBase.
  ///
  /// In en, this message translates to:
  /// **'Base amount'**
  String get amountLabelBase;

  /// No description provided for @amountLabelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total amount (with interest)'**
  String get amountLabelTotal;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get amountHint;

  /// No description provided for @interestRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Interest / fee (%)'**
  String get interestRateLabel;

  /// No description provided for @interestRateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2.5'**
  String get interestRateHint;

  /// No description provided for @calculationModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation mode'**
  String get calculationModeTitle;

  /// No description provided for @modeAddInterestTitle.
  ///
  /// In en, this message translates to:
  /// **'Add interest to base'**
  String get modeAddInterestTitle;

  /// No description provided for @modeAddInterestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You know the base amount and want the final total.'**
  String get modeAddInterestSubtitle;

  /// No description provided for @modeRemoveInterestTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove interest from total'**
  String get modeRemoveInterestTitle;

  /// No description provided for @modeRemoveInterestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You know the final total and want the base amount.'**
  String get modeRemoveInterestSubtitle;

  /// No description provided for @calculateButton.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculateButton;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @resultTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total with interest'**
  String get resultTotalLabel;

  /// No description provided for @resultBaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Base amount (without interest)'**
  String get resultBaseLabel;

  /// No description provided for @errorInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers for amount and interest rate.'**
  String get errorInvalidNumber;

  /// No description provided for @bankScannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Installed bank apps'**
  String get bankScannerTitle;

  /// No description provided for @bankScannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan your device for installed mobile banking and payment apps.'**
  String get bankScannerDescription;

  /// No description provided for @scanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan now'**
  String get scanButton;

  /// No description provided for @installedBankAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Detected apps'**
  String get installedBankAppsTitle;

  /// No description provided for @noBankAppsFound.
  ///
  /// In en, this message translates to:
  /// **'No banking apps detected on this device.'**
  String get noBankAppsFound;

  /// No description provided for @scanningInProgress.
  ///
  /// In en, this message translates to:
  /// **'Scanning installed apps...'**
  String get scanningInProgress;

  /// No description provided for @platformNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Bank app scanning is only available on Android devices.'**
  String get platformNotSupported;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get settingsTitle;

  /// No description provided for @themeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSectionTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Use system theme'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePersian.
  ///
  /// In en, this message translates to:
  /// **'Persian (Farsi)'**
  String get languagePersian;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
