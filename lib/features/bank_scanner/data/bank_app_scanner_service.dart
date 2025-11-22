// we_dont_pay_much/features/bank_scanner/data/bank_app_scanner_service.dart

import 'package:device_apps/device_apps.dart';

import 'package:we_dont_pay_much/features/bank_scanner/domain/models/bank_app.dart';

class BankAppScannerService {
  const BankAppScannerService();

  static const List<String> _keywords = [
    'bank',
    'card',
    'wallet',
    'pay',
    'payment',
  ];

  Future<List<BankApp>> scanInstalledBankApps() async {
    final apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: false,
      onlyAppsWithLaunchIntent: true,
    );

    final matches = <BankApp>[];

    for (final app in apps) {
      final lowerName = app.appName.toLowerCase();
      final lowerPackage = app.packageName.toLowerCase();
      final isMatch = _keywords.any(
            (keyword) =>
        lowerName.contains(keyword) || lowerPackage.contains(keyword),
      );

      if (isMatch) {
        matches.add(
          BankApp(
            name: app.appName,
            packageName: app.packageName,
          ),
        );
      }
    }

    matches.sort((a, b) => a.name.compareTo(b.name));
    return matches;
  }
}
