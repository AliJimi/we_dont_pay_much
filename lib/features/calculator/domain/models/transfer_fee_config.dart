// we_dont_pay_much/features/calculator/domain/models/transfer_fee_config.dart

import 'package:we_dont_pay_much/features/calculator/domain/models/transfer_type.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/fee_calculation_rule.dart';

class TransferFeeConfig {
  TransferFeeConfig({
    required this.type,
    required this.minAmountRial,
    required this.maxAmountRial,
    required this.calculation,
  });

  final TransferType type;
  final double minAmountRial;
  final double maxAmountRial;
  final FeeCalculationRule calculation;

  factory TransferFeeConfig.fromJson(Map<String, dynamic> json) {
    final typeCode = json['type_code'] as String;
    final type = transferTypeFromApiCode(typeCode);
    if (type == null) {
      throw ArgumentError('Unknown transfer type code: $typeCode');
    }

    return TransferFeeConfig(
      type: type,
      minAmountRial: (json['min_amount_rial'] as num).toDouble(),
      maxAmountRial: (json['max_amount_rial'] as num).toDouble(),
      calculation: FeeCalculationRule.fromJson(
        json['calculation'] as Map<String, dynamic>,
      ),
    );
  }

  double calculateFee(double baseAmountRial) {
    return calculation.calculateFee(baseAmountRial);
  }

  double calculateTotalFromBase(double baseAmountRial) {
    return baseAmountRial + calculateFee(baseAmountRial);
  }

  /// Generic numeric inversion:
  /// Given total (= base + fee(base)), solve for base.
  double calculateBaseFromTotal(double totalAmountRial) {
    if (totalAmountRial <= 0) return 0;

    double lo = 0;
    double hi = maxAmountRial > 0 ? maxAmountRial : totalAmountRial;

    for (var i = 0; i < 40; i++) {
      final mid = (lo + hi) / 2;
      final totalAtMid = calculateTotalFromBase(mid);
      if (totalAtMid > totalAmountRial) {
        hi = mid;
      } else {
        lo = mid;
      }
    }

    return (lo + hi) / 2;
  }
}
