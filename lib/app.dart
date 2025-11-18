// we_dont_pay_much/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:we_dont_pay_much/config/theme/app_theme.dart';
import 'package:we_dont_pay_much/l10n/app_localizations.dart';
import 'package:we_dont_pay_much/services/app_settings_service.dart';
import 'package:we_dont_pay_much/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:we_dont_pay_much/features/bank_scanner/presentation/screens/bank_scanner_screen.dart';
import 'package:we_dont_pay_much/features/settings/presentation/screens/settings_screen.dart';

class InterestTransferRoot extends StatelessWidget {
  const InterestTransferRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsService>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: const MainShell(),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final pages = const [
      CalculatorScreen(),
      BankScannerScreen(),
      SettingsScreen(),
    ];
    final titles = [t.calculatorTitle, t.bankScannerTitle, t.settingsTitle];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_currentIndex]), centerTitle: true),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.calculate_outlined),
            label: t.navCalculator,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: t.navBankApps,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: t.navSettings,
          ),
        ],
      ),
    );
  }
}
