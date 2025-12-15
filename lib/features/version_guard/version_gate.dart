// we_dont_pay_much/features/version_guard/version_gate.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_dont_pay_much/l10n/app_localizations.dart';
import 'package:we_dont_pay_much/services/version_check_service.dart';

class VersionGate extends StatefulWidget {
  const VersionGate({super.key, required this.child});

  final Widget child;

  @override
  State<VersionGate> createState() => _VersionGateState();
}

class _VersionGateState extends State<VersionGate> {
  bool _checking = false;
  bool _checkedOnce = false;

  @override
  void initState() {
    super.initState();
    // Wait for first frame so context & localization are ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runCheckIfNeeded();
    });
  }

  Future<void> _runCheckIfNeeded() async {
    if (_checking || _checkedOnce || !mounted) return;
    _checking = true;

    final service = VersionCheckService();
    final result = await service.checkCurrentVersion();

    if (!mounted) return;
    _checkedOnce = true;
    _checking = false;

    switch (result.status) {
      case VersionStatus.discontinued:
        await _showDiscontinuedDialog(result);
        _forceCloseApp();
        break;
      case VersionStatus.updateAvailable:
        await _showUpdateDialog(result);
        break;
      case VersionStatus.ok:
      case VersionStatus.error:
        // Do nothing – app just runs.
        break;
    }
  }

  Future<void> _showDiscontinuedDialog(VersionCheckResult result) async {
    final t = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(t.versionDiscontinuedTitle),
          content: Text(
            t.versionDiscontinuedMessage(
              result.currentVersion,
              result.latestVersion ?? '-',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Exit directly; you can also open a store URL first.
                Navigator.of(context).pop();
              },
              child: Text(t.versionDiscontinuedExitButton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateDialog(VersionCheckResult result) async {
    final t = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(t.versionUpdateTitle),
          content: Text(
            t.versionUpdateMessage(
              result.currentVersion,
              result.latestVersion ?? '-',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Later
              },
              child: Text(t.versionUpdateLaterButton),
            ),
            TextButton(
              onPressed: () {
                // You can hook this to url_launcher for a store link if you want.
                Navigator.of(context).pop();
              },
              child: Text(t.versionUpdateNowButton),
            ),
          ],
        );
      },
    );
  }

  void _forceCloseApp() {
    // Respect platform recommendations as much as we can.
    if (Platform.isAndroid || Platform.isIOS) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
