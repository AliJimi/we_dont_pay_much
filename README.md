# WeDontPayMuch

## Use flutter


### MacOS / Linux
```bash
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

### Windows
```bash
set PUB_HOSTED_URL="https://pub.flutter-io.cn"
set FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

```text
we_dont_pay_much/
├─ pubspec.yaml
├─ analysis_options.yaml
├─ l10n/
│  ├─ app_en.arb        # English strings
│  ├─ app_fa.arb        # (Example) Persian strings
│  └─ app_ar.arb        # (Example) Arabic strings
├─ assets/
│  ├─ icons/
│  └─ images/
└─ lib/
   ├─ main.dart         # Entry point, sets up App widget
   ├─ app.dart          # MaterialApp, routes, themeMode, locale setup
   ├─ config/
   │  ├─ theme/
   │  │  └─ app_theme.dart          # Light/Dark theme definitions
   │  └─ localization/
   │     └─ localization_config.dart # Supported locales, delegates
   ├─ core/
   │  ├─ constants/
   │  │  ├─ app_colors.dart
   │  │  └─ app_sizes.dart
   │  ├─ utils/
   │  │  └─ interest_calculator.dart  # Pure functions for interest logic
   │  └─ widgets/
   │     ├─ app_scaffold.dart
   │     └─ primary_button.dart
   ├─ features/
   │  ├─ onboarding/
   │  │  └─ presentation/
   │  │     └─ screens/
   │  │        └─ onboarding_screen.dart
   │  ├─ calculator/
   │  │  ├─ domain/
   │  │  │  └─ models/
   │  │  │     └─ transfer_option.dart
   │  │  ├─ application/
   │  │  │  └─ calculator_controller.dart  # State + logic
   │  │  └─ presentation/
   │  │     ├─ screens/
   │  │     │  └─ calculator_screen.dart   # UI for both calculation modes
   │  │     └─ widgets/
   │  │        └─ calculator_form.dart
   │  └─ bank_scanner/
   │     ├─ data/
   │     │  └─ bank_app_scanner_service.dart  # Wraps device_apps / platform
   │     ├─ domain/
   │     │  └─ models/
   │     │     └─ bank_app.dart
   │     └─ presentation/
   │        └─ screens/
   │           └─ bank_scanner_screen.dart
   └─ services/
      └─ app_settings_service.dart  # Persist theme mode, language, etc.
```