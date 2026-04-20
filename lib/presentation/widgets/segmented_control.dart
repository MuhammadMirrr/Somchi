import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// An animated segmented control widget similar to the iOS style.
///
/// Displays a row of selectable segments with a sliding indicator
/// that animates between selections.
class SegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool enabled;

  const SegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryLightDark : AppColors.primary;
    final containerColor =
        isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
    final unselectedTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final selectedTextColor = isDark
        ? AppColors.onPrimaryDark
        : Theme.of(context).colorScheme.onPrimary;

    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: reduceMotion ? Duration.zero : AppConstants.animationFast,
        child: Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          padding: const EdgeInsets.all(AppConstants.space4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentCount = labels.length;
              if (segmentCount == 0) return const SizedBox.shrink();

              final segmentWidth =
                  (constraints.maxWidth - AppConstants.space4 * 2) /
                      segmentCount;

              // Clamp selectedIndex to valid range
              final clampedIndex = selectedIndex.clamp(0, segmentCount - 1);

              return SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    // Sliding indicator
                    AnimatedPositioned(
                      duration: reduceMotion ? Duration.zero : AppConstants.animationNormal,
                      curve: Curves.easeOutCubic,
                      left: clampedIndex * segmentWidth,
                      top: 0,
                      bottom: 0,
                      width: segmentWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusS),
                          boxShadow: isDark ? null : AppColors.shadowSm,
                        ),
                      ),
                    ),
                    // Segment labels
                    Row(
                      children: List.generate(segmentCount, (index) {
                        final isSelected = index == clampedIndex;
                        return Expanded(
                          child: Semantics(
                            label: labels[index],
                            selected: isSelected,
                            button: true,
                            enabled: enabled,
                            child: GestureDetector(
                              onTap: () {
                                if (index != clampedIndex) {
                                  onChanged(index);
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: SizedBox(
                                height: 40,
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: reduceMotion ? Duration.zero : AppConstants.animationFast,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? selectedTextColor
                                          : unselectedTextColor,
                                    ),
                                    child: Text(
                                      labels[index],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
