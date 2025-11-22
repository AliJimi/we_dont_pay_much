// we_dont_pay_much/features/calculator/application/calculator_controller.dart
import 'package:flutter/foundation.dart';

import 'package:we_dont_pay_much/core/utils/interest_calculator.dart' as legacy; // keep if you still want generic percentage mode somewhere else.
import 'package:we_dont_pay_much/features/calculator/domain/models/calculation_mode.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/transfer_fee_config.dart';

class CalculatorController extends ChangeNotifier {
  CalculationMode _mode = CalculationMode.addInterest;

  double? _baseAmountRial;
  double? _totalAmountRial;
  double? _feeAmountRial;

  CalculationMode get mode => _mode;

  double? get baseAmountRial => _baseAmountRial;
  double? get totalAmountRial => _totalAmountRial;
  double? get feeAmountRial => _feeAmountRial;

  bool get hasResult =>
      _baseAmountRial != null &&
          _totalAmountRial != null &&
          _feeAmountRial != null;

  void setMode(CalculationMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    _baseAmountRial = null;
    _totalAmountRial = null;
    _feeAmountRial = null;
    notifyListeners();
  }

  /// Uses dynamic [config] to compute fee and base/total.
  ///
  /// Returns a localization key string on error, or null on success.
  String? calculateWithConfig({
    required String amountText,
    required TransferFeeConfig config,
  }) {
    final normalizedAmount = amountText.replaceAll(',', '').trim();
    final amount = double.tryParse(normalizedAmount);

    if (amount == null) {
      return 'errorInvalidNumber';
    }

    // Basic range check using config's min/max.
    if (amount < config.minAmountRial || amount > config.maxAmountRial) {
      return 'errorAmountOutOfRange';
    }

    switch (_mode) {
      case CalculationMode.addInterest:
        final base = amount;
        final total = config.calculateTotalFromBase(base);
        final fee = total - base;

        _baseAmountRial = base;
        _totalAmountRial = total;
        _feeAmountRial = fee;
        break;

      case CalculationMode.removeInterest:
        final total = amount;
        final base = config.calculateBaseFromTotal(total);
        final fee = total - base;

        _baseAmountRial = base;
        _totalAmountRial = total;
        _feeAmountRial = fee;
        break;
    }

    notifyListeners();
    return null;
  }
}
