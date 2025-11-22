// we_dont_pay_much/features/bank_scanner/presentation/screens/bank_scanner_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:we_dont_pay_much/core/constants/app_sizes.dart';
import 'package:we_dont_pay_much/features/bank_scanner/data/bank_app_scanner_service.dart';
import 'package:we_dont_pay_much/features/bank_scanner/domain/models/bank_app.dart';
import 'package:we_dont_pay_much/l10n/app_localizations.dart';

class BankScannerScreen extends StatefulWidget {
  const BankScannerScreen({super.key});

  @override
  State<BankScannerScreen> createState() => _BankScannerScreenState();
}

class _BankScannerScreenState extends State<BankScannerScreen> {
  final _scanner = const BankAppScannerService();
  Future<List<BankApp>>? _scanFuture;

  void _startScan() {
    setState(() {
      _scanFuture = _scanner.scanInstalledBankApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (!Platform.isAndroid) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.bankScannerTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Text(t.platformNotSupported, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.bankScannerDescription, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSizes.md),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _startScan,
                  icon: const Icon(Icons.search),
                  label: Text(t.scanButton),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Expanded(child: _buildResultList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultList(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_scanFuture == null) {
      return Center(
        child: Text(
          t.installedBankAppsTitle,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return FutureBuilder<List<BankApp>>(
      future: _scanFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text(t.scanningInProgress));
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              t.noBankAppsFound,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          );
        }

        final apps = snapshot.data ?? <BankApp>[];
        if (apps.isEmpty) {
          return Center(child: Text(t.noBankAppsFound));
        }

        return ListView.separated(
          itemCount: apps.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final app = apps[index];
            return ListTile(
              leading: const Icon(Icons.account_balance_outlined),
              title: Text(app.name),
              subtitle: Text(app.packageName),
            );
          },
        );
      },
    );
  }
}
