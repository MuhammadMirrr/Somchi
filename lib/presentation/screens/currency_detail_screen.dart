import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/number_formatter.dart';
import '../../data/models/currency.dart';
import '../../l10n/app_localizations.dart';
import '../providers/ad_free_provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/currency_history_chart.dart';
import '../widgets/inline_banner_ad.dart';
import '../widgets/animated_rate.dart';
import '../widgets/rate_diff_badge.dart';
import '../widgets/segmented_control.dart';
import '../widgets/state_widgets.dart';

class CurrencyDetailScreen extends StatefulWidget {
  final String currencyCode;
  final String? heroTag;

  const CurrencyDetailScreen({
    super.key,
    required this.currencyCode,
    this.heroTag,
  });

  @override
  State<CurrencyDetailScreen> createState() => _CurrencyDetailScreenState();
}

class _CurrencyDetailScreenState extends State<CurrencyDetailScreen> {
  static const _periods = [7, 30, 90, 365];

  List<String> _periodLabels(AppLocalizations l10n) => [
        l10n.period7d,
        l10n.period1m,
        l10n.period3m,
        l10n.period1y,
      ];

  int _selectedPeriodIndex = 1; // default: 30 days

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  void _loadHistory() {
    context.read<CurrencyProvider>().loadHistory(
          currencyCode: widget.currencyCode,
          days: _periods[_selectedPeriodIndex],
        );
  }

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedPeriodIndex = index;
    });
    context.read<CurrencyProvider>().loadHistory(
          currencyCode: widget.currencyCode,
          days: _periods[index],
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return Scaffold(
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, _) {
          final currency = provider.getCurrencyByCode(widget.currencyCode);

          if (currency == null) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: scaffoldBg,
                  surfaceTintColor: Colors.transparent,
                  leading: _buildBackButton(context),
                ),
                SliverFillRemaining(
                  child: EmptyStateWidget(
                    message: AppLocalizations.of(context).detailNotFound,
                    icon: Icons.currency_exchange_rounded,
                  ),
                ),
              ],
            );
          }

          final flag = AppConstants.getFlag(currency.code);
          final formattedRate = NumberFormatter.formatRate(currency.rate);
          final history = provider.history;
          final hasData = !provider.isHistoryLoading &&
              !provider.hasHistoryError &&
              history.length >= 2;
          final isFavorite = provider.favorites.contains(currency.code);

          return RefreshIndicator(
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surface,
            onRefresh: () async {
              HapticFeedback.mediumImpact();
              final currProvider = context.read<CurrencyProvider>();
              await currProvider.refreshRates();
              if (mounted) {
                _loadHistory();
              }
            },
            child: CustomScrollView(
              slivers: [
              // ── Pinned AppBar (faqat toolbar) ──
              SliverAppBar(
                pinned: true,
                backgroundColor: scaffoldBg,
                surfaceTintColor: Colors.transparent,
                leading: _buildBackButton(context),
                title: _CollapsedTitle(
                  flag: flag,
                  code: currency.code,
                  formattedRate: formattedRate,
                ),
              ),

              // ── Hero content (scroll bo'ladigan) ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppConstants.space24,
                  ),
                  child: Column(
                    children: [
                      if (widget.heroTag != null)
                        Hero(
                          tag: widget.heroTag!,
                          child: Text(
                            flag,
                            style: const TextStyle(fontSize: 40),
                          ),
                        )
                      else
                        Text(
                          flag,
                          style: const TextStyle(fontSize: 40),
                        ),
                      const SizedBox(height: AppConstants.space8),
                      Text(
                        currency.code,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppConstants.space4),
                      Text(
                        currency.displayName(context),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.space16),
                      AnimatedRate(
                        value: currency.rate,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: AppConstants.space2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context).uzsUnit,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: textTertiary,
                            ),
                          ),
                          if (currency.nominal > 1)
                            Text(
                              ' / ${AppLocalizations.of(context).perNominal(currency.nominal)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textTertiary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.space12),
                      RateDiffBadge(
                        diff: currency.diff,
                        diffPercent: currency.diffPercent,
                        isPositive: currency.isPositive,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Period selector ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPaddingH,
                  ),
                  child: SegmentedControl(
                    labels: _periodLabels(AppLocalizations.of(context)),
                    selectedIndex: _selectedPeriodIndex,
                    onChanged: _onPeriodChanged,
                  ),
                ),
              ),

              // ── Spacing ──
              const SliverToBoxAdapter(
                child: SizedBox(height: AppConstants.space20),
              ),

              // ── Chart ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPaddingH,
                  ),
                  child: _buildChart(provider),
                ),
              ),

              // ── Stats & change card (only when data is available) ──
              if (hasData) ...[
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.space16),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPaddingH,
                    ),
                    child: ChartStatsRow(history: history),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.space12),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPaddingH,
                    ),
                    child: ChartChangeCard(history: history),
                  ),
                ),
              ],

              // ── Spacing ──
              const SliverToBoxAdapter(
                child: SizedBox(height: AppConstants.space24),
              ),

              // ── Banner ad ──
              SliverToBoxAdapter(
                child: Consumer<AdFreeProvider>(
                  builder: (context, adFree, _) {
                    if (adFree.isAdFree) return const SizedBox.shrink();
                    return const Padding(
                      padding: EdgeInsets.only(bottom: AppConstants.space24),
                      child: InlineBannerAd(),
                    );
                  },
                ),
              ),

              // ── Quick actions ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPaddingH,
                  ),
                  child: _buildQuickActions(
                    context,
                    provider: provider,
                    isFavorite: isFavorite,
                    currencyCode: currency.code,
                  ),
                ),
              ),

                // ── Bottom padding ──
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.space40),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.arrow_back_ios_new,
        size: 20,
      ),
    );
  }

  Widget _buildChart(CurrencyProvider provider) {
    final history = provider.history;

    // Loading with existing data: show chart with overlay spinner
    if (provider.isHistoryLoading && history.length >= 2) {
      return SizedBox(
        height: AppConstants.chartHeight,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: CurrencyHistoryChart(
                history: history,
                onRetry: _loadHistory,
              ),
            ),
            Center(
              child: SizedBox(
                width: AppConstants.iconSizeLarge,
                height: AppConstants.iconSizeLarge,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Loading with no existing data: full spinner
    if (provider.isHistoryLoading) {
      return SizedBox(
        height: AppConstants.chartHeight,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (provider.hasHistoryError) {
      return SizedBox(
        height: AppConstants.chartHeight,
        child: ErrorStateWidget(
          message: AppLocalizations.of(context).errorLoadHistory,
          onRetry: _loadHistory,
        ),
      );
    }

    if (history.length < 2) {
      return SizedBox(
        height: AppConstants.chartHeight,
        child: EmptyStateWidget(
          message: AppLocalizations.of(context).detailInfoNotFound,
          icon: Icons.show_chart_rounded,
        ),
      );
    }

    return CurrencyHistoryChart(
      history: history,
      onRetry: _loadHistory,
    );
  }

  Widget _buildQuickActions(
    BuildContext context, {
    required CurrencyProvider provider,
    required bool isFavorite,
    required String currencyCode,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Pop and signal the caller to switch to the calculator tab
              Navigator.of(context).pop('calculator');
            },
            icon: const Icon(Icons.calculate_outlined, size: 20),
            label: Text(AppLocalizations.of(context).detailCalculate),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.space12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.space12),
        Expanded(
          child: isFavorite
              ? OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    provider.toggleFavorite(currencyCode);
                  },
                  icon: Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    AppLocalizations.of(context).detailRemoveFavorite,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.space8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusM),
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    provider.toggleFavorite(currencyCode);
                  },
                  icon: const Icon(Icons.star_outline_rounded, size: 20),
                  label: Text(
                    AppLocalizations.of(context).detailAddFavorite,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.space8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusM),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _CollapsedTitle -- compact row visible when the SliverAppBar is collapsed
// ---------------------------------------------------------------------------

class _CollapsedTitle extends StatelessWidget {
  final String flag;
  final String code;
  final String formattedRate;

  const _CollapsedTitle({
    required this.flag,
    required this.code,
    required this.formattedRate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(flag, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: AppConstants.space6),
        Text(
          code,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppConstants.space8),
        Text(
          formattedRate,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textSecondary,
          ),
        ),
      ],
    );
  }
}
