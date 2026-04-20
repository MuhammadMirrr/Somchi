import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/currency.dart';
import '../../l10n/app_localizations.dart';
import 'animated_rate.dart';

/// A flat-design list item for displaying a currency rate.
///
/// Shows flag, code, name, rate, diff percentage, and a favorite toggle.
/// No Card or elevation -- uses a plain container with ink splash.
class CurrencyListItem extends StatelessWidget {
  final Currency currency;
  final bool isFavorite;
  final String? heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onLongPress;

  const CurrencyListItem({
    super.key,
    required this.currency,
    this.isFavorite = false,
    this.heroTag,
    this.onTap,
    this.onFavoriteTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPositive = currency.isPositive;

    final Color diffColor = isPositive ? AppColors.positive : AppColors.negative;
    final Color textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final Color textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenPaddingH,
          vertical: 14,
        ),
        child: Row(
          children: [
            // Flag
            Semantics(
              label: AppLocalizations.of(context).semanticFlag(currency.code),
              child: heroTag != null
                  ? Hero(
                      tag: heroTag!,
                      child: Text(
                        AppConstants.getFlag(currency.code),
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                  : Text(
                      AppConstants.getFlag(currency.code),
                      style: const TextStyle(fontSize: 24),
                    ),
            ),
            const SizedBox(width: AppConstants.space12),

            // Code + Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppConstants.space2),
                  Text(
                    currency.displayName(context),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.space12),

            // Rate + Diff
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedRate(
                  value: currency.rate,
                  showPulse: true,
                  isPositive: currency.isPositive,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppConstants.space2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (currency.nominal > 1)
                      Text(
                        '${AppLocalizations.of(context).perNominal(currency.nominal)}  ',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textTertiary,
                        ),
                      ),
                    Icon(
                      isPositive
                          ? Icons.trending_up
                          : Icons.trending_down,
                      size: 14,
                      color: diffColor,
                    ),
                    const SizedBox(width: AppConstants.space4),
                    Text(
                      '${currency.diffPercent >= 0 ? '+' : ''}${currency.diffPercent.toStringAsFixed(2)}%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: diffColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: AppConstants.space8),

            // Favorite button
            IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                onFavoriteTap?.call();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: AppConstants.minTouchTarget,
                minHeight: AppConstants.minTouchTarget,
              ),
              icon: Builder(
                builder: (context) {
                  final reduceMotion = MediaQuery.of(context).disableAnimations;
                  return AnimatedSwitcher(
                    duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      if (reduceMotion) return child;
                      return ScaleTransition(
                        scale: CurvedAnimation(
                          parent: animation,
                          curve: Curves.elasticOut,
                        ),
                        child: child,
                      );
                    },
                    child: Icon(
                      isFavorite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      key: ValueKey<bool>(isFavorite),
                      size: 20,
                      color: isFavorite
                          ? (isDark ? AppColors.favoriteColorDark : AppColors.favoriteColor)
                          : textTertiary,
                      semanticLabel: isFavorite
                          ? AppLocalizations.of(context).detailRemoveFavorite
                          : AppLocalizations.of(context).detailAddFavorite,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
