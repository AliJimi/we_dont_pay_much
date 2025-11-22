// we_dont_pay_much/features/calculator/application/calculator_controller.dart

import 'package:flutter/foundation.dart';

import 'package:we_dont_pay_much/core/utils/interest_calculator.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/calculation_mode.dart';

class CalculatorController extends ChangeNotifier {
  CalculationMode _mode = CalculationMode.addInterest;
  double? _result;

  CalculationMode get mode => _mode;

  double? get result => _result;

  void setMode(CalculationMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    _result = null;
    notifyListeners();
  }

  /// Returns an error localization key if validation fails, otherwise null.
  String? calculate({
    required String amountText,
    required String interestText,
  }) {
    final normalizedAmount = amountText.replaceAll(',', '').trim();
    final normalizedInterest = interestText.replaceAll(',', '').trim();

    final amount = double.tryParse(normalizedAmount);
    final rate = double.tryParse(normalizedInterest);

    if (amount == null || rate == null) {
      return 'errorInvalidNumber';
    }

    switch (_mode) {
      case CalculationMode.addInterest:
        _result = calculateTotalWithInterest(
          baseAmount: amount,
          ratePercent: rate,
        );
        break;
      case CalculationMode.removeInterest:
        _result = calculateBaseFromTotal(
          totalAmount: amount,
          ratePercent: rate,
        );
        break;
    }

    notifyListeners();
    return null;
  }
}
