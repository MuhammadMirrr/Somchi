import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// A small colored pill badge showing the rate change (diff) for a currency.
///
/// Displays an arrow icon and formatted diff percentage.
/// Green for positive changes, red for negative, gray for zero.
class RateDiffBadge extends StatelessWidget {
  final double diff;
  final double diffPercent;
  final bool isPositive;
  final bool compact;

  const RateDiffBadge({
    super.key,
    required this.diff,
    required this.diffPercent,
    required this.isPositive,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isZero = diff == 0;

    final Color foreground;
    final Color background;
    final IconData icon;
    final String label;

    if (isZero) {
      foreground = isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
      background = foreground.withValues(alpha: 0.1);
      icon = Icons.remove;
      label = '\u2014';
    } else if (isPositive) {
      foreground = AppColors.positive;
      background = AppColors.positive.withValues(alpha: 0.1);
      icon = Icons.trending_up;
      label = '+${diffPercent.abs().toStringAsFixed(2)}%';
    } else {
      foreground = AppColors.negative;
      background = AppColors.negative.withValues(alpha: 0.1);
      icon = Icons.trending_down;
      label = '${diffPercent.toStringAsFixed(2)}%';
    }

    final double iconSize = compact ? 12.0 : 14.0;
    final double fontSize = compact ? 10.0 : 12.0;
    final EdgeInsets padding = compact
        ? const EdgeInsets.symmetric(
            horizontal: AppConstants.space6,
            vertical: AppConstants.space2,
          )
        : const EdgeInsets.symmetric(
            horizontal: AppConstants.space8,
            vertical: AppConstants.space4,
          );

    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: isZero
          ? l10n.semanticRateNoChange
          : isPositive
              ? l10n.semanticRateUp(diffPercent.toStringAsFixed(2))
              : l10n.semanticRateDown(diffPercent.abs().toStringAsFixed(2)),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: foreground,
            ),
            SizedBox(width: compact ? AppConstants.space2 : AppConstants.space4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: foreground,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
