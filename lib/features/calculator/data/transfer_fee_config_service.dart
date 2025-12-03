// we_dont_pay_much/features/calculator/data/transfer_fee_config_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:we_dont_pay_much/features/calculator/domain/models/transfer_fee_config.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/transfer_type.dart';

class TransferFeeConfigService {
  TransferFeeConfigService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? 'https://wdpm.guthub.ir';

  final http.Client _client;
  final String _baseUrl;

  /// Fetches all transfer types and returns them as a map keyed by [TransferType].
  ///
  /// Expected endpoint: GET {baseUrl}/api/transactions
  Future<Map<TransferType, TransferFeeConfig>> fetchConfigs() async {
    final uri = Uri.parse('$_baseUrl/fee/latest.json');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch transfer config: ${response.statusCode}',
      );
    }

    final raw = jsonDecode(response.body);
    final transactions = raw["transactions"];

    final Map<TransferType, TransferFeeConfig> result = {};

    for (final item in transactions) {
      if (item is! Map<String, dynamic>) continue;

      try {
        final cfg = TransferFeeConfig.fromJson(item);
        result[cfg.type] = cfg;
      } catch (_) {
        // Ignore invalid/unknown types so the app still works with the rest.
        continue;
      }
    }

    return result;
  }
}
