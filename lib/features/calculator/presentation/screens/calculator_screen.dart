// we_dont_pay_much/features/calculator/presentation/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:we_dont_pay_much/core/constants/app_sizes.dart';
import 'package:we_dont_pay_much/core/constants/app_colors.dart';
import 'package:we_dont_pay_much/core/constants/currency_display_mode.dart';
import 'package:we_dont_pay_much/core/utils/money_formatter.dart';
import 'package:we_dont_pay_much/core/widgets/app_scaffold.dart';
import 'package:we_dont_pay_much/core/widgets/primary_button.dart';
import 'package:we_dont_pay_much/features/calculator/application/calculator_controller.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/calculation_mode.dart';
import 'package:we_dont_pay_much/l10n/app_localizations.dart';
import 'package:we_dont_pay_much/services/app_settings_service.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalculatorController>(
      create: (_) => CalculatorController(),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatefulWidget {
  const _CalculatorView();

  @override
  State<_CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<_CalculatorView> {
  final _amountController = TextEditingController();
  final _interestController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.calculatorDescription,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSizes.lg),
          _buildCard(context),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controller = context.watch<CalculatorController>();

    final isAddInterest = controller.mode == CalculationMode.addInterest;
    final amountLabel = isAddInterest ? t.amountLabelBase : t.amountLabelTotal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.calculationModeTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                ChoiceChip(
                  selected: isAddInterest,
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.modeAddInterestTitle),
                      Text(
                        t.modeAddInterestSubtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  selectedColor: theme.colorScheme.primary.withOpacity(0.15),
                  onSelected: (_) {
                    context
                        .read<CalculatorController>()
                        .setMode(CalculationMode.addInterest);
                  },
                ),
                ChoiceChip(
                  selected: !isAddInterest,
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.modeRemoveInterestTitle),
                      Text(
                        t.modeRemoveInterestSubtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  selectedColor: theme.colorScheme.primary.withOpacity(0.15),
                  onSelected: (_) {
                    context
                        .read<CalculatorController>()
                        .setMode(CalculationMode.removeInterest);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            TextField(
              controller: _amountController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: amountLabel,
                hintText: t.amountHint,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _interestController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: t.interestRateLabel,
                hintText: t.interestRateHint,
                suffixText: '%',
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Align(
              alignment: Alignment.centerRight,
              child: PrimaryButton(
                label: t.calculateButton,
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  final errorKey =
                  context.read<CalculatorController>().calculate(
                    amountText: _amountController.text,
                    interestText: _interestController.text,
                  );
                  if (errorKey != null && mounted) {
                    final t = AppLocalizations.of(context)!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.errorInvalidNumber),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            _buildResult(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controller = context.watch<CalculatorController>();
    final settings = context.watch<AppSettingsService>();

    if (!controller.hasResult) {
      return const SizedBox.shrink();
    }

    final displayMode = settings.currencyDisplayMode;
    final base = controller.baseAmountRial!;
    final total = controller.totalAmountRial!;
    final interest = controller.interestAmountRial!;

    final isAddInterest = controller.mode == CalculationMode.addInterest;

    final baseLabel = t.resultBaseLabel;     // "Base amount (without interest)"
    final totalLabel = t.resultTotalLabel;   // "Total with interest"
    final interestLabel = t.resultInterestLabel;

    String format(double value) => MoneyFormatter.formatCurrency(
      context,
      amountInRial: value,
      displayMode: displayMode,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary.withOpacity(0.05),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.resultTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),

          // Base amount
          _ResultLine(
            label: baseLabel,
            valueText: format(base),
          ),
          const SizedBox(height: AppSizes.xs),

          // Interest / fee amount
          _ResultLine(
            label: interestLabel,
            valueText: format(interest),
          ),
          const SizedBox(height: AppSizes.xs),

          // Total amount (emphasized)
          _ResultLine(
            label: totalLabel,
            valueText: format(total),
            emphasize: true,
          ),

          if (!isAddInterest) ...[
            const SizedBox(height: AppSizes.sm),
            Text(
              // small hint: in this mode, user input was the total
              t.modeRemoveInterestSubtitle,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({
    required this.label,
    required this.valueText,
    this.emphasize = false,
  });

  final String label;
  final String valueText;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = emphasize
        ? theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    )
        : theme.textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Text(
          valueText,
          style: textStyle,
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}
