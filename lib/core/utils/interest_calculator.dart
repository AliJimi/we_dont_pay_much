// we_dont_pay_much/core/utils/interest_calculator.dart

double calculateTotalWithInterest({
  required double baseAmount,
  required double ratePercent,
}) {
  final factor = 1 + ratePercent / 100.0;
  return baseAmount * factor;
}

double calculateBaseFromTotal({
  required double totalAmount,
  required double ratePercent,
}) {
  final factor = 1 + ratePercent / 100.0;
  if (factor == 0) {
    return totalAmount;
  }
  return totalAmount / factor;
}
