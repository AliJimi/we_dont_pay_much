// we_dont_pay_much/features/calculator/presentation/screens/calculator_screen.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:we_dont_pay_much/core/constants/app_sizes.dart';
import 'package:we_dont_pay_much/core/constants/app_colors.dart';
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
  final _amountFocus = FocusNode();

  final _service = TransferFeeConfigService(baseUrl: 'https://wdpm.guthub.ir');

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
      if (!mounted) return;
      setState(() {
        _configs = configs;
        _selectedType = configs.isNotEmpty ? configs.keys.first : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
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
          // Header / description (clean, modern)
          _HeroHeader(
            title: t.calculationModeTitle,
            subtitle: t.calculatorDescription,
            onRefresh: _loadConfigs,
          ),
          const SizedBox(height: AppSizes.lg),

          // Main card
          _buildModernCard(context),

          const SizedBox(height: AppSizes.lg),
        ],
      ),
    );
  }

  Widget _buildModernCard(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final controller = context.watch<CalculatorController>();

    final isAddInterest = controller.mode == CalculationMode.addInterest;
    final amountLabel = isAddInterest ? t.amountLabelBase : t.amountLabelTotal;

    final locale = Localizations.localeOf(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.14),
            theme.colorScheme.secondary.withOpacity(0.08),
            theme.colorScheme.surface.withOpacity(0.90),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 18),
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.35 : 0.10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Mode
            _SectionTitle(
              icon: Icons.tune_rounded,
              title: t.calculationModeTitle,
            ),
            const SizedBox(height: AppSizes.sm),
            _ModeSegmented(
              isAddInterest: isAddInterest,
              onSelect: (mode) {
                context.read<CalculatorController>().setMode(mode);
              },
            ),

            const SizedBox(height: AppSizes.lg),

            // Section: Transfer type
            _SectionTitle(
              icon: Icons.swap_horiz_rounded,
              title: t.transferTypeLabel,
            ),
            const SizedBox(height: AppSizes.xs),
            _buildTransferTypeDropdown(context),

            const SizedBox(height: AppSizes.sm),
            _buildRangeInfoPill(context),

            const SizedBox(height: AppSizes.lg),

            // Section: Amount input
            _SectionTitle(
              icon: Icons.payments_rounded,
              title: amountLabel,
            ),
            const SizedBox(height: AppSizes.sm),

            TextField(
              controller: _amountController,
              focusNode: _amountFocus,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                _LocalizedThousandsFormatter(locale: locale),
              ],
              decoration: InputDecoration(
                hintText: t.amountHint,
                prefixIcon: const Icon(Icons.currency_exchange_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(
                  theme.brightness == Brightness.dark ? 0.65 : 0.9,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.onSurface.withOpacity(0.12),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.onSurface.withOpacity(0.10),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.7),
                    width: 1.6,
                  ),
                ),
              ),
              onSubmitted: (_) => _onCalculatePressed(),
            ),

            const SizedBox(height: AppSizes.lg),

            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: t.calculateButton,
                    icon: Icons.play_arrow_rounded,
                    onPressed: _onCalculatePressed,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.lg),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: controller.hasResult
                  ? _buildResult(context)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferTypeDropdown(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoading) {
      return _InlineStatus(
        icon: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        text: t.feeConfigLoading,
      );
    }

    if (_loadError != null) {
      return _InlineStatus(
        icon: Icon(Icons.error_outline_rounded, color: theme.colorScheme.error),
        text: t.feeConfigError,
        trailing: IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _loadConfigs,
        ),
        error: true,
      );
    }

    final configs = _configs;
    if (configs == null || configs.isEmpty) {
      return _InlineStatus(
        icon: Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
        text: t.feeConfigError,
        error: true,
      );
    }

    return DropdownButtonFormField<TransferType>(
      value: _selectedType,
      isExpanded: true, // ✅ prevents tight row overflow
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(
          theme.brightness == Brightness.dark ? 0.60 : 0.95,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.12),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),

      // ✅ This controls how the CLOSED dropdown shows the selected value.
      selectedItemBuilder: (context) {
        return configs.keys.map((type) {
          final label = _localizeTransferType(context, type);
          return SizedBox(
            width: double.infinity, // bounded -> Expanded is safe here
            child: Row(
              children: [
                Icon(_iconForType(type), size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // ✅ no overflow
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },

      // ✅ This controls the dropdown MENU items (must NOT use Expanded)
      items: configs.keys.map((type) {
        final label = _localizeTransferType(context, type);
        return DropdownMenuItem(
          value: type,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_iconForType(type), size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),

      onChanged: (value) {
        setState(() => _selectedType = value);
      },
    );
  }

  Widget _buildRangeInfoPill(BuildContext context) {
    final settings = context.watch<AppSettingsService>();
    final configs = _configs;
    final selectedType = _selectedType;

    if (configs == null || selectedType == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final cfg = configs[selectedType]!;
    final displayMode = settings.currencyDisplayMode;

    String format(double v) => MoneyFormatter.formatCurrency(
      context,
      amountInRial: v,
      displayMode: displayMode,
    );

    final minText = format(cfg.minAmountRial);
    final maxText = format(cfg.maxAmountRial);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.primary.withOpacity(0.08),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              t.errorAmountOutOfRange(minText, maxText),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.75),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCalculatePressed() {
    final t = AppLocalizations.of(context)!;
    final controller = context.read<CalculatorController>();

    if (_configs == null) {
      _snackError(t.errorConfigNotLoaded);
      return;
    }

    if (_selectedType == null) {
      _snackError(t.errorNoTransferType);
      return;
    }

    // IMPORTANT: sanitize text -> ASCII digits, no separators
    final sanitized = _sanitizeAmountText(_amountController.text);

    final cfg = _configs![_selectedType]!;
    final errorKey = controller.calculateWithConfig(
      amountText: sanitized,
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

          message = tt.errorAmountOutOfRange(
            format(cfg.minAmountRial),
            format(cfg.maxAmountRial),
          );
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

      _snackError(message);
    } else {
      // collapse keyboard for “clean” feel
      FocusScope.of(context).unfocus();
    }
  }

  void _snackError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controller = context.watch<CalculatorController>();
    final settings = context.watch<AppSettingsService>();

    final displayMode = settings.currencyDisplayMode;
    final base = controller.baseAmountRial!;
    final total = controller.totalAmountRial!;
    final fee = controller.feeAmountRial!;

    String format(double value) => MoneyFormatter.formatCurrency(
      context,
      amountInRial: value,
      displayMode: displayMode,
    );

    return Container(
      key: const ValueKey('result'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.surface.withOpacity(
          theme.brightness == Brightness.dark ? 0.70 : 0.95,
        ),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.30 : 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                t.resultTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          _ResultLine(
            label: t.resultBaseLabel,
            valueText: format(base),
          ),
          const SizedBox(height: AppSizes.xs),

          _ResultLine(
            label: t.resultInterestLabel,
            valueText: format(fee),
          ),
          const SizedBox(height: AppSizes.sm),

          Divider(color: theme.colorScheme.onSurface.withOpacity(0.10)),
          const SizedBox(height: AppSizes.sm),

          _ResultLine(
            label: t.resultTotalLabel,
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

  IconData _iconForType(TransferType type) {
    switch (type) {
      case TransferType.cardToCard:
        return Icons.credit_card_rounded;
      case TransferType.payaIndividual:
        return Icons.account_balance_rounded;
      case TransferType.payaGroup:
        return Icons.groups_rounded;
      case TransferType.satna:
        return Icons.bolt_rounded;
      case TransferType.pol:
        return Icons.route_rounded;
    }
  }

  /// Removes separators and converts any Persian/Arabic-Indic digits to ASCII digits.
  String _sanitizeAmountText(String input) {
    final buf = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);

      // Strip common separators/spaces
      if (ch == ',' || ch == '٬' || ch == ' ' || ch == '\u200f' || ch == '\u200e') {
        continue;
      }

      final d = _DigitMaps.toAsciiDigit(ch);
      if (d != null) {
        buf.write(d);
      }
    }
    return buf.toString();
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.onRefresh,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withOpacity(0.9),
                theme.colorScheme.tertiary.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 12),
                color: theme.colorScheme.primary.withOpacity(
                  theme.brightness == Brightness.dark ? 0.25 : 0.18,
                ),
              ),
            ],
          ),
          child: const Icon(Icons.calculate_rounded, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.70),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Refresh',
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ModeSegmented extends StatelessWidget {
  const _ModeSegmented({
    required this.isAddInterest,
    required this.onSelect,
  });

  final bool isAddInterest;
  final void Function(CalculationMode mode) onSelect;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Material 3 SegmentedButton = modern, clean.
    return SegmentedButton<CalculationMode>(
      style: ButtonStyle(
        visualDensity: VisualDensity.standard,
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
        side: WidgetStateProperty.all(
          BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.10)),
        ),
      ),
      segments: [
        ButtonSegment(
          value: CalculationMode.addInterest,
          label: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.modeAddInterestTitle),
              const SizedBox(height: 2),
              Text(
                t.modeAddInterestSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
            ],
          ),
          icon: const Icon(Icons.add_circle_outline_rounded),
        ),
        ButtonSegment(
          value: CalculationMode.removeInterest,
          label: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.modeRemoveInterestTitle),
              const SizedBox(height: 2),
              Text(
                t.modeRemoveInterestSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
            ],
          ),
          icon: const Icon(Icons.remove_circle_outline_rounded),
        ),
      ],
      selected: {isAddInterest ? CalculationMode.addInterest : CalculationMode.removeInterest},
      onSelectionChanged: (set) {
        if (set.isEmpty) return;
        onSelect(set.first);
      },
    );
  }
}

class _InlineStatus extends StatelessWidget {
  const _InlineStatus({
    required this.icon,
    required this.text,
    this.trailing,
    this.error = false,
  });

  final Widget icon;
  final String text;
  final Widget? trailing;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: (error ? theme.colorScheme.error : theme.colorScheme.primary).withOpacity(0.06),
        border: Border.all(
          color: (error ? theme.colorScheme.error : theme.colorScheme.primary).withOpacity(0.16),
        ),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: error
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface.withOpacity(0.75),
              ),
            ),
          ),
          if (trailing != null) trailing!,
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
    final valueStyle = emphasize
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.72),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Flexible(
          child: Text(
            valueText,
            style: valueStyle,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

/// Formats input as user types:
/// - accepts ASCII + Persian + Arabic-Indic digits
/// - applies thousand separators instantly
/// - displays digits in FA/AR if locale is fa/ar
class _LocalizedThousandsFormatter extends TextInputFormatter {
  _LocalizedThousandsFormatter({required this.locale});

  final Locale locale;

  bool get _useFaDigits => locale.languageCode.toLowerCase() == 'fa';
  bool get _useArDigits => locale.languageCode.toLowerCase() == 'ar';

  String get _sep => (_useFaDigits || _useArDigits) ? '٬' : ',';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Extract digits (as ASCII), and remember how many digits were before cursor.
    final raw = newValue.text;
    final cursor = newValue.selection.end;

    int digitsBeforeCursor = 0;
    final asciiDigits = <String>[];

    for (int i = 0; i < raw.length; i++) {
      final ch = raw[i];
      final d = _DigitMaps.toAsciiDigit(ch);
      if (d != null) {
        asciiDigits.add(d);
        if (i < cursor) digitsBeforeCursor++;
      }
    }

    if (asciiDigits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Prevent absurd length (optional safety)
    if (asciiDigits.length > 18) {
      // keep last 18 digits
      final trimmed = asciiDigits.sublist(asciiDigits.length - 18);
      digitsBeforeCursor = math.min(digitsBeforeCursor, 18);
      asciiDigits
        ..clear()
        ..addAll(trimmed);
    }

    final groupedAscii = _groupThousands(asciiDigits.join(), sep: _sep);

    // Convert digits for display
    final displayed = _useFaDigits
        ? _DigitMaps.asciiToPersian(groupedAscii)
        : _useArDigits
        ? _DigitMaps.asciiToArabicIndic(groupedAscii)
        : groupedAscii;

    // Restore cursor to same "digit index" position inside the new formatted string.
    final newCursor = _cursorForDigitIndex(
      displayed,
      digitIndex: digitsBeforeCursor,
    );

    return TextEditingValue(
      text: displayed,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }

  static String _groupThousands(String digits, {required String sep}) {
    // remove leading zeros (but keep a single zero)
    final normalized = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final chars = normalized.split('');
    final out = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      final idxFromRight = chars.length - i;
      out.write(chars[i]);
      if (idxFromRight > 1 && idxFromRight % 3 == 1) {
        out.write(sep);
      }
    }
    return out.toString();
  }

  static int _cursorForDigitIndex(String text, {required int digitIndex}) {
    // digitIndex = number of digits before cursor (1..N)
    if (digitIndex <= 0) return 0;

    int seenDigits = 0;
    for (int i = 0; i < text.length; i++) {
      final d = _DigitMaps.toAsciiDigit(text[i]);
      if (d != null) {
        seenDigits++;
        if (seenDigits >= digitIndex) {
          return i + 1;
        }
      }
    }
    return text.length;
  }
}

class _DigitMaps {
  static const _persian = {
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  static const _arabicIndic = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  static String? toAsciiDigit(String ch) {
    // ASCII
    final code = ch.codeUnitAt(0);
    if (code >= 48 && code <= 57) return ch;

    // Persian
    final p = _persian[ch];
    if (p != null) return p;

    // Arabic-Indic
    final a = _arabicIndic[ch];
    if (a != null) return a;

    return null;
  }

  static String asciiToPersian(String s) {
    return s
        .replaceAll('0', '۰')
        .replaceAll('1', '۱')
        .replaceAll('2', '۲')
        .replaceAll('3', '۳')
        .replaceAll('4', '۴')
        .replaceAll('5', '۵')
        .replaceAll('6', '۶')
        .replaceAll('7', '۷')
        .replaceAll('8', '۸')
        .replaceAll('9', '۹');
  }

  static String asciiToArabicIndic(String s) {
    return s
        .replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
  }
}
