import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LoadingShimmer
// ─────────────────────────────────────────────────────────────────────────────

/// A shimmer loading skeleton with optional hero cards and list item
/// placeholders. Used as a full-screen loading state.
class LoadingShimmer extends StatelessWidget {
  final bool showHeroCards;
  final int listItemCount;

  const LoadingShimmer({
    super.key,
    this.showHeroCards = true,
    this.listItemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceVariantLight;
    final highlightColor = isDark
        ? AppColors.surfaceVariantDark
        : AppColors.surfaceLight;

    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: AppLocalizations.of(context).loading,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: reduceMotion
            ? const Duration(days: 999)
            : const Duration(milliseconds: 1500),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.space16),
          child: Column(
            children: [
              if (showHeroCards) ...[
                // Horizontal hero card placeholders matching actual layout
                // (3 fixed-width cards in a horizontal scroll)
                SizedBox(
                  height: AppConstants.heroCardHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AppConstants.mainCurrencies.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppConstants.space12),
                    itemBuilder: (_, _) => const SizedBox(
                      width: AppConstants.heroCardWidth,
                      child: _ShimmerBox(borderRadius: AppConstants.radiusL),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.space24),
              ],
              // List item placeholders matching CurrencyListItem layout
              for (int i = 0; i < listItemCount; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.space14,
                  ),
                  child: Row(
                    children: [
                      // Flag placeholder (circle)
                      const _ShimmerBox(
                        height: AppConstants.flagEmojiMedium,
                        width: AppConstants.flagEmojiMedium,
                        borderRadius: AppConstants.radiusFull,
                      ),
                      const SizedBox(width: AppConstants.space12),
                      // Code + name placeholder
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _ShimmerBox(
                              height: AppConstants.space14,
                              width: 48,
                              borderRadius: AppConstants.radiusXS,
                            ),
                            SizedBox(height: AppConstants.space4),
                            _ShimmerBox(
                              height: AppConstants.space12,
                              width: 100,
                              borderRadius: AppConstants.radiusXS,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppConstants.space12),
                      // Rate + diff placeholder
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _ShimmerBox(
                            height: AppConstants.space14,
                            width: 72,
                            borderRadius: AppConstants.radiusXS,
                          ),
                          SizedBox(height: AppConstants.space4),
                          _ShimmerBox(
                            height: AppConstants.space12,
                            width: 48,
                            borderRadius: AppConstants.radiusXS,
                          ),
                        ],
                      ),
                      const SizedBox(width: AppConstants.space8),
                      // Star icon placeholder
                      const _ShimmerBox(
                        height: AppConstants.iconSizeMedium,
                        width: AppConstants.iconSizeMedium,
                        borderRadius: AppConstants.radiusFull,
                      ),
                    ],
                  ),
                ),
                if (i < listItemCount - 1)
                  const Divider(
                    indent: AppConstants.flagEmojiMedium + AppConstants.space12,
                    endIndent: 0,
                    height: 1,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Internal shimmer placeholder box.
///
/// Uses a plain opaque fill so the shimmer gradient shows through correctly.
/// The color adapts to light/dark mode for proper contrast.
class _ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const _ShimmerBox({
    this.height,
    this.width,
    this.borderRadius = AppConstants.radiusM,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ErrorStateWidget
// ─────────────────────────────────────────────────────────────────────────────

/// Displays a centered error state with an icon, message, and optional retry
/// button.
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final illustration = isDark
        ? 'assets/images/no_connection_dark.png'
        : 'assets/images/no_connection_light.png';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenPaddingH,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              illustration,
              width: 160,
              height: 160,
            ),
            const SizedBox(height: AppConstants.space16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.space16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: AppConstants.iconSizeMedium),
                label: Text(
                  AppLocalizations.of(context).retry,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EmptyStateWidget
// ─────────────────────────────────────────────────────────────────────────────

/// Displays a centered empty state with an icon and message.
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? darkImage;
  final String? lightImage;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
    this.darkImage,
    this.lightImage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final hasImage = darkImage != null && lightImage != null;
    final illustration = isDark ? darkImage : lightImage;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenPaddingH,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasImage)
              Image.asset(
                illustration!,
                width: 140,
                height: 140,
              )
            else
              Icon(
                icon,
                size: 48,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
            const SizedBox(height: AppConstants.space16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
