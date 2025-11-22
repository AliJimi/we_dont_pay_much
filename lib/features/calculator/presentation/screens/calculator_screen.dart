// we_dont_pay_much/features/calculator/presentation/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:we_dont_pay_much/core/constants/app_sizes.dart';
import 'package:we_dont_pay_much/core/constants/app_colors.dart';
import 'package:we_dont_pay_much/core/widgets/app_scaffold.dart';
import 'package:we_dont_pay_much/core/widgets/primary_button.dart';
import 'package:we_dont_pay_much/features/calculator/application/calculator_controller.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/calculation_mode.dart';
import 'package:we_dont_pay_much/l10n/app_localizations.dart';

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
          Text(t.calculatorDescription, style: theme.textTheme.bodyMedium),
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
                    context.read<CalculatorController>().setMode(
                      CalculationMode.addInterest,
                    );
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
                    context.read<CalculatorController>().setMode(
                      CalculationMode.removeInterest,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: amountLabel,
                hintText: t.amountHint,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _interestController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
                  final errorKey = context
                      .read<CalculatorController>()
                      .calculate(
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

    final result = controller.result;
    if (result == null) {
      return const SizedBox.shrink();
    }

    final isAddInterest = controller.mode == CalculationMode.addInterest;
    final label = isAddInterest ? t.resultTotalLabel : t.resultBaseLabel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary.withOpacity(0.05),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
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
          Text('$label:', style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSizes.xs),
          Text(
            result.toStringAsFixed(2),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
