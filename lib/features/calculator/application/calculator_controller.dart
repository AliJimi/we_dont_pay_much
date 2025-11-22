// we_dont_pay_much/features/calculator/application/calculator_controller.dart
import 'package:flutter/foundation.dart';

import 'package:we_dont_pay_much/core/utils/interest_calculator.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/calculation_mode.dart';

class CalculatorController extends ChangeNotifier {
  CalculationMode _mode = CalculationMode.addInterest;

  double? _baseAmountRial;
  double? _totalAmountRial;
  double? _interestAmountRial;

  CalculationMode get mode => _mode;

  double? get baseAmountRial => _baseAmountRial;
  double? get totalAmountRial => _totalAmountRial;
  double? get interestAmountRial => _interestAmountRial;

  bool get hasResult =>
      _baseAmountRial != null &&
          _totalAmountRial != null &&
          _interestAmountRial != null;

  void setMode(CalculationMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    _baseAmountRial = null;
    _totalAmountRial = null;
    _interestAmountRial = null;
    notifyListeners();
  }

  /// Returns an error localization key if validation fails, otherwise null.
  ///
  /// [amountText] and [interestText] are raw user inputs.
  /// Internally everything is kept in **Rial**.
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
        final total = calculateTotalWithInterest(
          baseAmount: amount,
          ratePercent: rate,
        );
        _baseAmountRial = amount;
        _totalAmountRial = total;
        _interestAmountRial = total - amount;
        break;

      case CalculationMode.removeInterest:
        final base = calculateBaseFromTotal(
          totalAmount: amount,
          ratePercent: rate,
        );
        _baseAmountRial = base;
        _totalAmountRial = amount;
        _interestAmountRial = amount - base;
        break;
    }

    notifyListeners();
    return null;
  }
}
