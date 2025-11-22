// we_dont_pay_much/features/calculator/domain/models/fee_calculation_rule.dart

import 'dart:math';

/// Base class for fee calculation rules.
abstract class FeeCalculationRule {
  const FeeCalculationRule();

  /// Returns the fee in **Rial** for the given [amountRial].
  double calculateFee(double amountRial);

  factory FeeCalculationRule.fromJson(Map<String, dynamic> json) {
    final kind = (json['kind'] as String?)?.toLowerCase();

    switch (kind) {
      case 'step':
        return StepFeeCalculationRule(
          baseFeeRial: (json['base_fee_rial'] as num).toDouble(),
          baseAmountRial: (json['base_amount_rial'] as num).toDouble(),
          stepFeeRial: (json['step_fee_rial'] as num).toDouble(),
          stepAmountRial: (json['step_amount_rial'] as num).toDouble(),
        );

      case 'percent_with_min_max':
        return PercentWithMinMaxFeeCalculationRule(
          percent: (json['percent'] as num).toDouble(),
          minFeeRial: (json['min_fee_rial'] as num).toDouble(),
          maxFeeRial: (json['max_fee_rial'] as num).toDouble(),
        );

      default:
      // Fallback: zero fee.
        return const FlatFeeCalculationRule(feeRial: 0);
    }
  }
}

/// Example for شتابی:
/// - base fee for first N Rials
/// - then stepFee per each stepAmount above that.
class StepFeeCalculationRule extends FeeCalculationRule {
  const StepFeeCalculationRule({
    required this.baseFeeRial,
    required this.baseAmountRial,
    required this.stepFeeRial,
    required this.stepAmountRial,
  });

  final double baseFeeRial;
  final double baseAmountRial;
  final double stepFeeRial;
  final double stepAmountRial;

  @override
  double calculateFee(double amountRial) {
    if (amountRial <= 0) return 0;

    if (amountRial <= baseAmountRial) {
      return baseFeeRial;
    }

    final extra = amountRial - baseAmountRial;
    final steps = (extra / stepAmountRial).ceil().clamp(0, double.infinity);
    return baseFeeRial + steps * stepFeeRial;
  }
}

/// Example for پایا انفرادی / ساتنا:
/// - percent of amount with min/max cap.
class PercentWithMinMaxFeeCalculationRule extends FeeCalculationRule {
  const PercentWithMinMaxFeeCalculationRule({
    required this.percent,
    required this.minFeeRial,
    required this.maxFeeRial,
  });

  final double percent; // 0.01 → 0.01%
  final double minFeeRial;
  final double maxFeeRial;

  @override
  double calculateFee(double amountRial) {
    if (amountRial <= 0) return 0;
    final raw = amountRial * (percent / 100.0);
    return max(minFeeRial, min(maxFeeRial, raw));
  }
}

/// Simple flat fee (can be used for fallback or special cases).
class FlatFeeCalculationRule extends FeeCalculationRule {
  const FlatFeeCalculationRule({required this.feeRial});

  final double feeRial;

  @override
  double calculateFee(double amountRial) => feeRial;
}
