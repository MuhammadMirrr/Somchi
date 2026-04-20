import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/number_formatter.dart';
import '../../data/models/currency.dart';
import '../../l10n/app_localizations.dart';
import '../providers/calculator_provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/currency_selector_sheet.dart';
import '../widgets/state_widgets.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  final _sourceController = TextEditingController();
  final _targetController = TextEditingController();
  final _sourceFocus = FocusNode();
  final _targetFocus = FocusNode();

  late AnimationController _swapAnimController;
  late Animation<double> _swapScale;
  late Animation<double> _swapOpacity;
  late final VoidCallback _sourceFocusListener;
  late final VoidCallback _targetFocusListener;

  bool _isSourceFocused = false;
  bool _isTargetFocused = false;
  bool _isSwapping = false;

  @override
  void initState() {
    super.initState();
    _swapAnimController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _swapScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.96), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _swapAnimController,
      curve: Curves.easeInOutCubic,
    ));
    _swapOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 70),
    ]).animate(CurvedAnimation(
      parent: _swapAnimController,
      curve: Curves.easeInOutCubic,
    ));

    _sourceFocusListener = () {
      if (_isSourceFocused != _sourceFocus.hasFocus) {
        setState(() => _isSourceFocused = _sourceFocus.hasFocus);
      }
    };
    _targetFocusListener = () {
      if (_isTargetFocused != _targetFocus.hasFocus) {
        setState(() => _isTargetFocused = _targetFocus.hasFocus);
      }
    };
    _sourceFocus.addListener(_sourceFocusListener);
    _targetFocus.addListener(_targetFocusListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currencyProvider = context.read<CurrencyProvider>();
    final calcProvider = context.read<CalculatorProvider>();
    calcProvider.setRates(currencyProvider.rates);
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _targetController.dispose();
    _sourceFocus.removeListener(_sourceFocusListener);
    _targetFocus.removeListener(_targetFocusListener);
    _sourceFocus.dispose();
    _targetFocus.dispose();
    _swapAnimController.dispose();
    super.dispose();
  }

  void _syncController(TextEditingController controller, String value) {
    final formatted = _formatNumber(value);
    if (controller.text != formatted) {
      controller.text = formatted;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      );
    }
  }

  /// Raqamni ming ajratgich bilan formatlash: 1234567.89 → 1 234 567.89
  String _formatNumber(String raw) {
    if (raw.isEmpty) return '';
    final parts = raw.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';
    return _CurrencyInputFormatter.addSpaces(intPart) + decPart;
  }

  Future<void> _openCurrencySelector(bool isSource) async {
    final currencyProvider = context.read<CurrencyProvider>();
    final calcProvider = context.read<CalculatorProvider>();

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CurrencySelectorSheet(
        currencies: currencyProvider.rates,
        selectedCode:
            isSource ? calcProvider.sourceCurrency : calcProvider.targetCurrency,
      ),
    );

    if (result != null) {
      if (isSource) {
        calcProvider.setSourceCurrency(result);
      } else {
        calcProvider.setTargetCurrency(result);
      }
    }
  }

  String _getCurrencyName(BuildContext context, String code, List<Currency> rates) {
    if (code == AppConstants.uzsCode) {
      return AppLocalizations.of(context).uzsName;
    }
    try {
      final currency = rates.firstWhere((c) => c.code == code);
      return currency.displayName(context);
    } catch (_) {
      return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencyProvider = context.watch<CurrencyProvider>();
    final calcProvider = context.watch<CalculatorProvider>();
    final rates = currencyProvider.rates;

    // Sync controllers when the corresponding field is not focused
    if (!_sourceFocus.hasFocus) {
      _syncController(_sourceController, calcProvider.sourceAmount);
    }
    if (!_targetFocus.hasFocus) {
      _syncController(_targetController, calcProvider.targetAmount);
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenPaddingH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).calcScreenTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (currencyProvider.isFromCache && rates.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          size: 14,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context).calcOffline,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Loading state
            if (currencyProvider.isLoading && rates.isEmpty)
              _buildLoadingState(theme),

            // Error state — rates failed to load
            if (rates.isEmpty && !currencyProvider.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: ErrorStateWidget(
                  message: AppLocalizations.of(context).calcLoadError,
                  onRetry: () => currencyProvider.refreshRates(),
                ),
              ),

            // Calculator panels
            if (rates.isNotEmpty) ...[
              _buildPanelsWithSwap(
                theme: theme,
                isDark: isDark,
                calcProvider: calcProvider,
                rates: rates,
              ),
              const SizedBox(height: 24),
              _buildRateInfoBar(
                theme: theme,
                isDark: isDark,
                currencyProvider: currencyProvider,
                calcProvider: calcProvider,
              ),
              if (calcProvider.hasConversionError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    AppLocalizations.of(context).errorNoRate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.negative,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Center(
                child: Semantics(
                  label: AppLocalizations.of(context).clear,
                  button: true,
                  child: TextButton.icon(
                    onPressed: () {
                      calcProvider.setSourceAmount('');
                      calcProvider.setTargetAmount('');
                      _sourceController.clear();
                      _targetController.clear();
                    },
                    icon: Icon(Icons.restart_alt_rounded, size: AppConstants.iconSizeMedium),
                    label: Text(AppLocalizations.of(context).clear),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).calcLoading,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelsWithSwap({
    required ThemeData theme,
    required bool isDark,
    required CalculatorProvider calcProvider,
    required List<Currency> rates,
  }) {
    // Calculate the center position for the swap button.
    // Each panel is estimated; we position the button between the two panels.
    // We use a LayoutBuilder approach via Stack with Positioned.
    const double panelEstimatedHeight = 110.0;
    const double gapHeight = 12.0;
    const double swapButtonSize = 52.0;
    const double swapTopOffset =
        panelEstimatedHeight + (gapHeight / 2) - (swapButtonSize / 2);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _swapAnimController,
          builder: (context, child) {
            final reduceMotion = MediaQuery.of(context).disableAnimations;
            return Transform.scale(
              scale: reduceMotion ? 1.0 : _swapScale.value,
              child: Opacity(
                opacity: reduceMotion ? 1.0 : _swapOpacity.value,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              _buildCurrencyPanel(
                theme: theme,
                isDark: isDark,
                label: AppLocalizations.of(context).calcAmount,
                currencyCode: calcProvider.sourceCurrency,
                controller: _sourceController,
                focusNode: _sourceFocus,
                isFocused: _isSourceFocused,
                isSource: true,
                calcProvider: calcProvider,
                rates: rates,
              ),
              const SizedBox(height: gapHeight),
              _buildCurrencyPanel(
                theme: theme,
                isDark: isDark,
                label: AppLocalizations.of(context).calcResult,
                currencyCode: calcProvider.targetCurrency,
                controller: _targetController,
                focusNode: _targetFocus,
                isFocused: _isTargetFocused,
                isSource: false,
                calcProvider: calcProvider,
                rates: rates,
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: swapTopOffset,
          child: Center(
            child: _buildSwapButton(theme: theme, isDark: isDark, calcProvider: calcProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyPanel({
    required ThemeData theme,
    required bool isDark,
    required String label,
    required String currencyCode,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isFocused,
    required bool isSource,
    required CalculatorProvider calcProvider,
    required List<Currency> rates,
  }) {
    final flag = currencyCode == AppConstants.uzsCode
        ? '\u{1F1FA}\u{1F1FF}'
        : AppConstants.getFlag(currencyCode);
    final currencyName = _getCurrencyName(context, currencyCode, rates);

    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceVariantDark
            : AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: dividerColor,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Currency selector button
              Semantics(
                label: AppLocalizations.of(context).calcSelectCurrency,
                child: GestureDetector(
                  onTap: () => _openCurrencySelector(isSource),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currencyCode,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: AppConstants.iconSizeMedium,
                        color: textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Amount input
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    const _CurrencyInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: textTertiary,
                    ),
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (value) {
                    final raw = value.replaceAll(' ', '');
                    if (isSource) {
                      calcProvider.setSourceAmount(raw);
                    } else {
                      calcProvider.setTargetAmount(raw);
                    }
                  },
                ),
              ),
              // Copy button for target (result) panel
              if (!isSource && controller.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: AppConstants.iconSizeSmall,
                      icon: Icon(
                        Icons.copy_rounded,
                        color: textSecondary,
                      ),
                      tooltip: AppLocalizations.of(context).calcCopy,
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Clipboard.setData(
                          ClipboardData(text: controller.text),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context).calcCopied),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            currencyName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwapButton({
    required ThemeData theme,
    required bool isDark,
    required CalculatorProvider calcProvider,
  }) {
    return Semantics(
      label: AppLocalizations.of(context).calcSwap,
      button: true,
      child: GestureDetector(
        onTap: () {
          if (_isSwapping) return;
          final reduceMotion = MediaQuery.of(context).disableAnimations;
          _isSwapping = true;
          if (!reduceMotion) {
            _swapAnimController.forward(from: 0.0);
          }
          HapticFeedback.mediumImpact();
          calcProvider.swap();
          Future.delayed(
            reduceMotion ? Duration.zero : const Duration(milliseconds: 350),
            () {
              _isSwapping = false;
            },
          );
        },
        child: Builder(
          builder: (context) {
            final reduceMotion = MediaQuery.of(context).disableAnimations;
            final container = Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.surfaceLight,
                boxShadow: isDark ? null : AppColors.shadowMd,
              ),
              child: Icon(
                Icons.swap_vert_rounded,
                size: AppConstants.iconSizeLarge,
                color: isDark
                    ? AppColors.primaryLightDark
                    : AppColors.primary,
              ),
            );
            if (reduceMotion) return container;
            return RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 0.5).animate(
                CurvedAnimation(
                  parent: _swapAnimController,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: container,
            );
          },
        ),
      ),
    );
  }

  Widget _buildRateInfoBar({
    required ThemeData theme,
    required bool isDark,
    required CurrencyProvider currencyProvider,
    required CalculatorProvider calcProvider,
  }) {
    final source = calcProvider.sourceCurrency;
    final target = calcProvider.targetCurrency;

    String rateText = '';

    if (source == 'UZS' && target != 'UZS') {
      final c = currencyProvider.getCurrencyByCode(target);
      if (c != null) {
        rateText = '1 $target = ${NumberFormatter.formatRate(c.ratePerUnit)} UZS';
      }
    } else if (target == 'UZS' && source != 'UZS') {
      final c = currencyProvider.getCurrencyByCode(source);
      if (c != null) {
        rateText = '1 $source = ${NumberFormatter.formatRate(c.ratePerUnit)} UZS';
      }
    } else if (source != 'UZS' && target != 'UZS') {
      final sc = currencyProvider.getCurrencyByCode(source);
      final tc = currencyProvider.getCurrencyByCode(target);
      if (sc != null &&
          tc != null &&
          sc.nominal != 0 &&
          tc.nominal != 0 &&
          tc.rate != 0) {
        final crossRate =
            (sc.rate / sc.nominal) / (tc.rate / tc.nominal);
        rateText = '1 $source = ${NumberFormatter.formatRate(crossRate)} $target';
      }
    }

    if (rateText.isEmpty) return const SizedBox.shrink();

    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.primarySurfaceDark : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: isDark ? AppColors.primaryLightDark : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rateText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Custom input formatter: ming ajratgich (1 234 567.89)
// =============================================================================

class _CurrencyInputFormatter extends TextInputFormatter {
  const _CurrencyInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Faqat raqamlar va bitta nuqta
    var raw = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Bitta nuqtadan ko'p bo'lmasin
    final dotIndex = raw.indexOf('.');
    if (dotIndex != -1) {
      raw = raw.substring(0, dotIndex + 1) +
          raw.substring(dotIndex + 1).replaceAll('.', '');
    }

    // Uzunlik limiti (raw, bo'shliqlarsiz)
    if (raw.length > 15) raw = raw.substring(0, 15);

    if (raw.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Butun va kasr qismlarni ajratish
    final parts = raw.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Formatlash
    final formatted = addSpaces(intPart) + decPart;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Butun qismga ming ajratgich qo'shish: 1234567 → 1 234 567
  static String addSpaces(String s) {
    if (s.isEmpty) return s;
    final result = StringBuffer();
    final len = s.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) result.write(' ');
      result.write(s[i]);
    }
    return result.toString();
  }
}
