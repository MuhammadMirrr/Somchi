import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/number_formatter.dart';
import '../../data/models/rate_history.dart';
import '../../l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CurrencyHistoryChart — fl_chart LineChart with touch crosshair & tooltip
// ─────────────────────────────────────────────────────────────────────────────

class CurrencyHistoryChart extends StatelessWidget {
  final List<RateHistory> history;
  final VoidCallback? onRetry;

  const CurrencyHistoryChart({
    super.key,
    required this.history,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final dividerColor = theme.dividerColor.withValues(alpha: 0.3);

    // Build spots
    final spots = <FlSpot>[];
    for (int i = 0; i < history.length; i++) {
      spots.add(FlSpot(i.toDouble(), history[i].ratePerUnit));
    }

    // Y-axis range
    final values = spots.map((s) => s.y);
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    double yPadding;
    if (minY == maxY) {
      yPadding = minY * 0.01; // 1% of the value
      if (yPadding < 1.0) yPadding = 1.0; // minimum 1.0
    } else {
      yPadding = (maxY - minY) * 0.1;
    }
    final effectiveMinY = minY - yPadding;
    final effectiveMaxY = maxY + yPadding;
    final yInterval =
        maxY == minY ? 1.0 : (effectiveMaxY - effectiveMinY) / 4;

    // X-axis label interval
    final xInterval = (history.length / 5).ceil().toDouble();

    return SizedBox(
      height: AppConstants.chartHeight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.space8,
          AppConstants.space16,
          AppConstants.space48,
          AppConstants.space24,
        ),
        child: LineChart(
          LineChartData(
            minY: effectiveMinY,
            maxY: effectiveMaxY,
            clipData: const FlClipData.all(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: yInterval,
              getDrawingHorizontalLine: (value) => FlLine(
                color: dividerColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  interval: yInterval,
                  getTitlesWidget: (value, meta) {
                    if (value == effectiveMinY || value == effectiveMaxY) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: AppConstants.space8),
                      child: Text(
                        NumberFormatter.formatRate(value),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textTertiary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: xInterval,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= history.length) {
                      return const SizedBox.shrink();
                    }
                    final d = history[idx].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: AppConstants.space8),
                      child: Text(
                        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textTertiary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: primaryColor,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) {
                    if (index == bar.spots.length - 1) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: primaryColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    }
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Colors.transparent,
                      strokeWidth: 0,
                      strokeColor: Colors.transparent,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withValues(alpha: 0.08),
                      primaryColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((i) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: primaryColor.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: colorScheme.surface,
                          strokeWidth: 3,
                          strokeColor: primaryColor,
                        );
                      },
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipColor: (_) => colorScheme.surface,
                tooltipRoundedRadius: AppConstants.radiusS,
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.space8,
                  vertical: AppConstants.space6,
                ),
                tooltipBorder: BorderSide.none,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final idx = spot.x.toInt();
                    if (idx < 0 || idx >= history.length) return null;
                    final d = history[idx].date;
                    final dateStr = DateFormat(
                      'dd.MM.yyyy',
                      Localizations.localeOf(context).toString(),
                    ).format(d);
                    final rateStr = NumberFormatter.formatRate(spot.y);
                    return LineTooltipItem(
                      '$dateStr\n',
                      theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ) ??
                          const TextStyle(),
                      children: [
                        TextSpan(
                          text: rateStr,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ChartStatsRow — Min / Current / Max statistics
// ─────────────────────────────────────────────────────────────────────────────

class ChartStatsRow extends StatelessWidget {
  final List<RateHistory> history;

  const ChartStatsRow({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final surfaceColor = theme.colorScheme.surface;
    final borderColor = theme.colorScheme.outlineVariant;

    final l10n = AppLocalizations.of(context);
    final rates = history.map((h) => h.ratePerUnit).toList();
    final minRate = rates.reduce((a, b) => a < b ? a : b);
    final maxRate = rates.reduce((a, b) => a > b ? a : b);
    final currentRate = rates.last;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppConstants.space12),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildStatColumn(
                context,
                label: l10n.chartMin,
                value: minRate,
                color: AppColors.negative,
                textTertiary: textTertiary,
                theme: theme,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: borderColor,
            ),
            Expanded(
              child: _buildStatColumn(
                context,
                label: l10n.chartCurrent,
                value: currentRate,
                color: theme.colorScheme.primary,
                textTertiary: textTertiary,
                theme: theme,
                isCurrent: true,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: borderColor,
            ),
            Expanded(
              child: _buildStatColumn(
                context,
                label: l10n.chartMax,
                value: maxRate,
                color: AppColors.positive,
                textTertiary: textTertiary,
                theme: theme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context, {
    required String label,
    required double value,
    required Color color,
    required Color textTertiary,
    required ThemeData theme,
    bool isCurrent = false,
  }) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isCurrent ? color : textTertiary,
            fontWeight: isCurrent ? FontWeight.w600 : null,
          ),
        ),
        const SizedBox(height: AppConstants.space4),
        Text(
          NumberFormatter.formatRate(value),
          style: (isCurrent
                  ? theme.textTheme.titleMedium
                  : theme.textTheme.titleSmall)
              ?.copyWith(
            color: color,
            fontWeight: isCurrent ? FontWeight.w700 : null,
          ),
        ),
      ],
    );

    if (!isCurrent) return content;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space8,
        vertical: AppConstants.space4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: content,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ChartChangeCard — Period change summary
// ─────────────────────────────────────────────────────────────────────────────

class ChartChangeCard extends StatelessWidget {
  final List<RateHistory> history;

  const ChartChangeCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final rates = history.map((h) => h.ratePerUnit).toList();
    final change = rates.last - rates.first;
    final changePercent =
        rates.first != 0 ? (change / rates.first) * 100 : 0.0;
    final isPositive = change >= 0;

    final color = isPositive ? AppColors.positive : AppColors.negative;
    final bgColor = isPositive
        ? AppColors.primarySurface
        : AppColors.negativeLight;
    final isDark = theme.brightness == Brightness.dark;
    final effectiveBgColor = isDark
        ? (isPositive
            ? AppColors.primarySurfaceDark
            : AppColors.negative.withValues(alpha: 0.12))
        : bgColor;

    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space16,
        vertical: AppConstants.space12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: AppConstants.space8),
          Text(
            '${NumberFormatter.formatDiff(change)} (${changePercent.toStringAsFixed(2)}%)',
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppConstants.space4),
          Text(
            AppLocalizations.of(context).chartDuringPeriod,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

