// we_dont_pay_much/features/bank_scanner/data/bank_app_scanner_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:we_dont_pay_much/features/bank_scanner/domain/models/bank_app.dart';

class BankAppScannerService {
  BankAppScannerService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const List<String> _keywords = [
    'bank',
    'card',
    'wallet',
    'pay',
    'payment',
  ];

  static const String _packagesUrl = 'https://wdpm.guthub.ir/bank-apps/packages/latest.json';

  /// Fetches a normalized set of package names from the backend.
  ///
  /// Accepts multiple JSON shapes (so your backend can evolve safely):
  /// 1) ["com.foo.bank", "com.bar.wallet"]
  /// 2) { "packages": ["com.foo.bank", "com.bar.wallet"] }
  /// 3) { "packages": [ { "package": "com.foo.bank" }, { "packageName": "com.bar.wallet" } ] }
  Future<Set<String>> _fetchKnownBankPackages() async {
    try {
      final resp = await _client
          .get(Uri.parse(_packagesUrl))
          .timeout(const Duration(seconds: 6));

      if (resp.statusCode != 200) return <String>{};

      final dynamic raw = jsonDecode(resp.body);

      final set = <String>{};

      void addPkg(String? v) {
        final p = (v ?? '').trim().toLowerCase();
        if (p.isNotEmpty) set.add(p);
      }

      if (raw is List) {
        // ["com.x", "com.y"]
        for (final item in raw) {
          if (item is String) addPkg(item);
        }
        return set;
      }

      if (raw is Map<String, dynamic>) {
        final dynamic pkgs = raw['packages'];
        if (pkgs is List) {
          for (final item in pkgs) {
            if (item is String) {
              addPkg(item);
            } else if (item is Map) {
              // {package: "..."} or {packageName: "..."}
              addPkg(item['package']?.toString());
              addPkg(item['packageName']?.toString());
            }
          }
        }
      }

      return set;
    } catch (_) {
      return <String>{};
    }
  }

  bool _matchesKeywords(Application app) {
    final lowerName = app.appName.toLowerCase();
    final lowerPackage = app.packageName.toLowerCase();

    return _keywords.any(
          (k) => lowerName.contains(k) || lowerPackage.contains(k),
    );
  }

  Future<List<BankApp>> scanInstalledBankApps() async {
    // Fetch known packages (remote) + installed apps (local)
    // If remote fails, we still keep keyword matching.
    final knownPackagesFuture = _fetchKnownBankPackages();

    final apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );

    final knownPackages = await knownPackagesFuture;

    final byPackage = <String, BankApp>{};

    for (final app in apps) {
      final pkg = app.packageName.toLowerCase();

      final isKeywordMatch = _matchesKeywords(app);
      final isRemoteMatch = knownPackages.contains(pkg);

      if (isKeywordMatch || isRemoteMatch) {
        byPackage[pkg] = BankApp(
          icon: (app is ApplicationWithIcon) ? app.icon : null,
          name: app.appName,
          packageName: app.packageName,
        );
      }
    }

    final matches = byPackage.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return matches;
  }
}
