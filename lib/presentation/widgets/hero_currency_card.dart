import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/number_formatter.dart';
import '../../data/models/currency.dart';
import '../../l10n/app_localizations.dart';
import 'animated_rate.dart';
import 'rate_diff_badge.dart';

/// A compact hero card for main currencies (USD, EUR, RUB).
///
/// Used in a horizontal scroll list on the home screen. Features a subtle
/// press-scale animation and displays rate, nominal info, and a diff badge.
class HeroCurrencyCard extends StatefulWidget {
  final Currency currency;
  final VoidCallback? onTap;
  final String? heroTag;

  const HeroCurrencyCard({
    super.key,
    required this.currency,
    this.onTap,
    this.heroTag,
  });

  @override
  State<HeroCurrencyCard> createState() => _HeroCurrencyCardState();
}

class _HeroCurrencyCardState extends State<HeroCurrencyCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppConstants.animationFast,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 0.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (MediaQuery.of(context).disableAnimations) return;
    _scaleController.animateTo(1.0, duration: const Duration(milliseconds: 80));
  }

  void _onTapUp(TapUpDetails details) {
    if (MediaQuery.of(context).disableAnimations) return;
    _scaleController.animateBack(0.0, duration: const Duration(milliseconds: 150));
  }

  void _onTapCancel() {
    if (MediaQuery.of(context).disableAnimations) return;
    _scaleController.animateBack(0.0, duration: const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = widget.currency;

    final l10n = AppLocalizations.of(context);
    final unitsSuffix =
        currency.nominal > 1 ? ', ${l10n.unitsFor(currency.nominal)}' : '';
    return Semantics(
      label:
          '${currency.code}: ${NumberFormatter.formatRate(currency.rate)} ${l10n.uzsUnit}$unitsSuffix',
      button: true,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            final reduceMotion = MediaQuery.of(context).disableAnimations;
            return Transform.scale(
              scale: reduceMotion ? 1.0 : _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            width: AppConstants.heroCardWidth,
            padding: const EdgeInsets.all(AppConstants.space16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.95),
                ],
              ),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusL),
              boxShadow: isDark ? AppColors.shadowSmDark : AppColors.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (widget.heroTag != null)
                      Hero(
                        tag: widget.heroTag!,
                        child: Text(
                          AppConstants.getFlag(currency.code),
                          style: const TextStyle(fontSize: AppConstants.flagEmojiLarge),
                        ),
                      )
                    else
                      Text(
                        AppConstants.getFlag(currency.code),
                        style: const TextStyle(fontSize: AppConstants.flagEmojiLarge),
                      ),
                    const SizedBox(width: AppConstants.space8),
                    Flexible(
                      child: Text(
                        currency.code,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AnimatedRate(
                    value: currency.rate,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.space2),
                Row(
                  children: [
                    Text(
                      l10n.uzsUnit,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                    ),
                    if (currency.nominal > 1)
                      Text(
                        ' / ${currency.nominal}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.space8),
                RateDiffBadge(
                  diff: currency.diff,
                  diffPercent: currency.diffPercent,
                  isPositive: currency.isPositive,
                  compact: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
