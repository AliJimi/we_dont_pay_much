// we_dont_pay_much/services/version_check_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

enum VersionStatus {
  ok,
  updateAvailable,
  discontinued,
  error,
}

class VersionCheckResult {
  VersionCheckResult({
    required this.status,
    required this.currentVersion,
    this.latestVersion,
  });

  final VersionStatus status;
  final String currentVersion;
  final String? latestVersion;
}

/// Fetches versions.json from the backend and evaluates the current app version.
///
/// Expected JSON (you can adjust backend as needed):
/// {
///   "latest_version": "1.2.0",
///   "min_supported_version": "1.0.0",
///   "discontinued_versions": ["0.9.0", "0.9.1"]
/// }
class VersionCheckService {
  static const String _url = 'https://wdpm.guthub.ir/releases/versions.json';

  final http.Client _client;

  VersionCheckService({http.Client? client}) : _client = client ?? http.Client();

  Future<VersionCheckResult> checkCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    final current = info.version; // e.g. "1.0.0"

    try {
      final uri = Uri.parse(_url);
      final resp = await _client
          .get(uri)
          .timeout(const Duration(seconds: 6));

      if (resp.statusCode != 200) {
        return VersionCheckResult(
          status: VersionStatus.error,
          currentVersion: current,
        );
      }

      final raw = jsonDecode(resp.body);
      if (raw is! Map<String, dynamic>) {
        return VersionCheckResult(
          status: VersionStatus.error,
          currentVersion: current,
        );
      }

      final latest = raw['latest_version'] as String?;
      final minSupported = raw['min_supported_version'] as String?;
      final discontinuedRaw = raw['discontinued_versions'] as List<dynamic>?;

      final discontinued = discontinuedRaw == null
          ? <String>[]
          : discontinuedRaw
          .whereType<String>()
          .toList();

      final bool isExplicitlyDiscontinued =
      discontinued.contains(current);

      final bool belowMinSupported = minSupported != null &&
          _compareVersions(current, minSupported) < 0;

      if (isExplicitlyDiscontinued || belowMinSupported) {
        return VersionCheckResult(
          status: VersionStatus.discontinued,
          currentVersion: current,
          latestVersion: latest,
        );
      }

      if (latest != null && _compareVersions(current, latest) < 0) {
        return VersionCheckResult(
          status: VersionStatus.updateAvailable,
          currentVersion: current,
          latestVersion: latest,
        );
      }

      return VersionCheckResult(
        status: VersionStatus.ok,
        currentVersion: current,
        latestVersion: latest,
      );
    } on TimeoutException {
      return VersionCheckResult(
        status: VersionStatus.error,
        currentVersion: current,
      );
    } catch (_) {
      return VersionCheckResult(
        status: VersionStatus.error,
        currentVersion: current,
      );
    }
  }

  /// Compare semantic versions like "1.2.3".
  /// Returns <0 if [a] < [b], 0 if equal, >0 if [a] > [b].
  int _compareVersions(String a, String b) {
    final aParts = a
        .split('.')
        .map((p) => int.tryParse(p) ?? 0)
        .toList();
    final bParts = b
        .split('.')
        .map((p) => int.tryParse(p) ?? 0)
        .toList();

    final maxLen = math.max(aParts.length, bParts.length);
    for (var i = 0; i < maxLen; i++) {
      final ai = i < aParts.length ? aParts[i] : 0;
      final bi = i < bParts.length ? bParts[i] : 0;
      if (ai != bi) {
        return ai.compareTo(bi);
      }
    }
    return 0;
  }
}
