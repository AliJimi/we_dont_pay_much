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
import 'package:we_dont_pay_much/features/calculator/data/transfer_fee_config_service.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/calculation_mode.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/transfer_fee_config.dart';
import 'package:we_dont_pay_much/features/calculator/domain/models/transfer_type.dart';
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
  final _service = TransferFeeConfigService();

  Map<TransferType, TransferFeeConfig>? _configs;
  TransferType? _selectedType;
  Object? _loadError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final configs = await _service.fetchConfigs();
      setState(() {
        _configs = configs;
        _selectedType = configs.isNotEmpty ? configs.keys.first : null;
      });
    } catch (e) {
      setState(() {
        _loadError = e;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
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
            // Mode
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

            // Transfer type selector
            Text(
              t.transferTypeLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            _buildTransferTypeDropdown(context),

            const SizedBox(height: AppSizes.sm),
            _buildRangeInfo(context),

            const SizedBox(height: AppSizes.lg),

            // Amount input
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

            const SizedBox(height: AppSizes.lg),

            Align(
              alignment: Alignment.centerRight,
              child: PrimaryButton(
                label: t.calculateButton,
                icon: Icons.play_arrow_rounded,
                onPressed: _onCalculatePressed,
              ),
            ),

            const SizedBox(height: AppSizes.lg),
            _buildResult(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferTypeDropdown(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoading) {
      return Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(t.feeConfigLoading, style: theme.textTheme.bodySmall),
        ],
      );
    }

    if (_loadError != null) {
      return Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              t.feeConfigError,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadConfigs),
        ],
      );
    }

    final configs = _configs;
    if (configs == null || configs.isEmpty) {
      return Text(
        t.feeConfigError,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }

    return DropdownButtonFormField<TransferType>(
      value: _selectedType,
      items: configs.keys.map((type) {
        final label = _localizeTransferType(context, type);
        return DropdownMenuItem(value: type, child: Text(label));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
    );
  }

  Widget _buildRangeInfo(BuildContext context) {
    final settings = context.watch<AppSettingsService>();
    final configs = _configs;
    final selectedType = _selectedType;

    if (configs == null || selectedType == null) {
      return const SizedBox.shrink();
    }

    final cfg = configs[selectedType]!;
    final displayMode = settings.currencyDisplayMode;

    String format(double v) => MoneyFormatter.formatCurrency(
      context,
      amountInRial: v,
      displayMode: displayMode,
    );

    final minText = format(cfg.minAmountRial);
    final maxText = format(cfg.maxAmountRial);

    return Text(
      // e.g., "Amount must be between X and Y"
      AppLocalizations.of(context)!.errorAmountOutOfRange(minText, maxText),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  void _onCalculatePressed() {
    final t = AppLocalizations.of(context)!;
    final controller = context.read<CalculatorController>();

    if (_configs == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.errorConfigNotLoaded),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.errorNoTransferType),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final cfg = _configs![_selectedType]!;
    final errorKey = controller.calculateWithConfig(
      amountText: _amountController.text,
      config: cfg,
    );

    if (errorKey != null) {
      final tt = AppLocalizations.of(context)!;
      String message;
      switch (errorKey) {
        case 'errorAmountOutOfRange':
          final settings = context.read<AppSettingsService>();
          final displayMode = settings.currencyDisplayMode;

          String format(double v) => MoneyFormatter.formatCurrency(
            context,
            amountInRial: v,
            displayMode: displayMode,
          );

          final minText = format(cfg.minAmountRial);
          final maxText = format(cfg.maxAmountRial);
          message = tt.errorAmountOutOfRange(minText, maxText);
          break;
        case 'errorNoTransferType':
          message = tt.errorNoTransferType;
          break;
        case 'errorConfigNotLoaded':
          message = tt.errorConfigNotLoaded;
          break;
        case 'errorInvalidNumber':
        default:
          message = tt.errorInvalidNumber;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    }
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
    final fee = controller.feeAmountRial!;

    final baseLabel = t.resultBaseLabel;
    final totalLabel = t.resultTotalLabel;
    final feeLabel = t.resultInterestLabel;

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

          _ResultLine(label: baseLabel, valueText: format(base)),
          const SizedBox(height: AppSizes.xs),

          _ResultLine(label: feeLabel, valueText: format(fee)),
          const SizedBox(height: AppSizes.xs),

          _ResultLine(
            label: totalLabel,
            valueText: format(total),
            emphasize: true,
          ),
        ],
      ),
    );
  }

  String _localizeTransferType(BuildContext context, TransferType type) {
    final t = AppLocalizations.of(context)!;
    switch (type) {
      case TransferType.cardToCard:
        return t.transferTypeCardToCard;
      case TransferType.payaIndividual:
        return t.transferTypePayaIndividual;
      case TransferType.payaGroup:
        return t.transferTypePayaGroup;
      case TransferType.satna:
        return t.transferTypeSatna;
      case TransferType.pol:
        return t.transferTypePol;
    }
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
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: theme.textTheme.bodyMedium)),
        const SizedBox(width: AppSizes.md),
        Text(valueText, style: textStyle, textAlign: TextAlign.end),
      ],
    );
  }
}
