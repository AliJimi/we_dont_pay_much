// we_dont_pay_much/core/utils/money_formatter.dart

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:we_dont_pay_much/core/constants/currency_display_mode.dart';
import 'package:we_dont_pay_much/l10n/app_localizations.dart';

class MoneyFormatter {
  MoneyFormatter._();

  static String _formatNumber(
      BuildContext context,
      double value,
      ) {
    final locale = Localizations.localeOf(context);
    final localeName = locale.toLanguageTag(); // e.g. "fa-IR", "en-US"

    final formatter = NumberFormat.decimalPattern(localeName)
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = 2;

    return formatter.format(value);
  }

  /// Assumes [amountInRial] is in **Rial**.
  /// Returns a string like:
  /// - "1,000,000 ریال"
  /// - "100,000 تومان"
  /// - "1,000,000 ریال (100,000 تومان)"
  static String formatCurrency(
      BuildContext context, {
        required double amountInRial,
        required CurrencyDisplayMode displayMode,
      }) {
    final t = AppLocalizations.of(context)!;
    final rialLabel = t.currencyRialLabel;
    final tomanLabel = t.currencyTomanLabel;

    final rialText = '${_formatNumber(context, amountInRial)} $rialLabel';
    final tomanAmount = amountInRial / 10.0;
    final tomanText =
        '${_formatNumber(context, tomanAmount)} $tomanLabel';

    switch (displayMode) {
      case CurrencyDisplayMode.rialOnly:
        return rialText;
      case CurrencyDisplayMode.tomanOnly:
        return tomanText;
      case CurrencyDisplayMode.both:
        return '$rialText ($tomanText)';
    }
  }
}
