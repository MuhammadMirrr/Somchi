import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/currency.dart';
import '../../l10n/app_localizations.dart';
import '../providers/ad_free_provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/hero_currency_card.dart';
import '../widgets/currency_list_item.dart';
import '../widgets/state_widgets.dart';
import '../../app.dart';
import '../widgets/inline_banner_ad.dart';
import 'currency_detail_screen.dart';

String _categoryLabel(AppLocalizations l10n, CurrencyCategory cat) {
  switch (cat) {
    case CurrencyCategory.all:
      return l10n.categoryAll;
    case CurrencyCategory.major:
      return l10n.categoryMajor;
    case CurrencyCategory.minor:
      return l10n.categoryMinor;
    case CurrencyCategory.metals:
      return l10n.categoryMetals;
  }
}

String _sortLabel(AppLocalizations l10n, SortType sort) {
  switch (sort) {
    case SortType.defaultOrder:
      return l10n.sortDefault;
    case SortType.alphabetical:
      return l10n.sortAlphabetical;
    case SortType.rateHighToLow:
      return l10n.sortRateHighToLow;
    case SortType.rateLowToHigh:
      return l10n.sortRateLowToHigh;
    case SortType.changePercent:
      return l10n.sortChangePercent;
  }
}

const _sortIcons = <SortType, IconData>{
  SortType.defaultOrder: Icons.format_list_numbered_rounded,
  SortType.alphabetical: Icons.sort_by_alpha_rounded,
  SortType.rateHighToLow: Icons.arrow_downward_rounded,
  SortType.rateLowToHigh: Icons.arrow_upward_rounded,
  SortType.changePercent: Icons.trending_up_rounded,
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _isEditing = false;
  bool _isNavigating = false;
  bool _hasAnimatedFirstLoad = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, _) {
        // Handle refresh message via post-frame callback
        _handleRefreshMessage(provider);

        // First load stagger animation flag
        bool animateEntrance = false;
        if (!_hasAnimatedFirstLoad && provider.rates.isNotEmpty) {
          animateEntrance = true;
          _hasAnimatedFirstLoad = true;
        }

        // State crossfade between loading/error/content
        Widget content;

        // Loading state with no data
        if (provider.isLoading && provider.rates.isEmpty) {
          content = const LoadingShimmer(key: ValueKey('loading'));
        }
        // Error state with no data
        else if (provider.error != null && provider.rates.isEmpty) {
          final l10n = AppLocalizations.of(context);
          final msg = switch (provider.error!) {
            LoadError.networkError => l10n.errorNoInternetCheck,
            LoadError.serverError => l10n.errorServerRetry,
            LoadError.unknown => l10n.errorLoadRates,
          };
          content = ErrorStateWidget(
            key: const ValueKey('error'),
            message: msg,
            onRetry: provider.refreshRates,
          );
        }
        // Data state
        else {
          content = SafeArea(
            key: const ValueKey('content'),
            bottom: false,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  HapticFeedback.mediumImpact();
                  await provider.refreshRates();
                },
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Scrollbar(
                child: CustomScrollView(
                  key: const PageStorageKey<String>('home'),
                  slivers: [
                    _buildHeader(context, provider),
                    _buildHeroCurrencies(context, provider, animateEntrance: animateEntrance),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickySearchDelegate(
                        searchController: _searchController,
                        onChanged: (value) {
                          _debounce?.cancel();
                          _debounce = Timer(AppConstants.searchDebounce, () {
                            provider.setSearchQuery(value);
                          });
                        },
                        onClear: () {
                          _debounce?.cancel();
                          _searchController.clear();
                          provider.setSearchQuery('');
                        },
                        selectedCategory: provider.selectedCategory,
                        onCategoryChanged: (cat) {
                          provider.selectedCategory = cat;
                        },
                        sortType: provider.sortType,
                        onSortTap: () => _showSortMenu(context, provider),
                      ),
                    ),
                    if (_getNonMainFavorites(provider).isNotEmpty &&
                        provider.searchQuery.isEmpty)
                      _buildFavoritesHeader(context, provider),
                    if (_getNonMainFavorites(provider).isNotEmpty &&
                        provider.searchQuery.isEmpty)
                      _isEditing
                          ? _buildEditableFavoritesList(context, provider)
                          : _buildFavoritesList(context, provider),
                    _buildAllCurrenciesHeader(context, provider),
                    if (provider.filteredRates.isEmpty &&
                        (provider.searchQuery.isNotEmpty ||
                            provider.selectedCategory != CurrencyCategory.all))
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyStateWidget(
                          message: provider.searchQuery.isNotEmpty
                              ? AppLocalizations.of(context)
                                  .searchNotFound(provider.searchQuery)
                              : AppLocalizations.of(context).categoryEmpty,
                          icon: Icons.search_off_rounded,
                          darkImage: 'assets/images/no_results_dark.png',
                          lightImage: 'assets/images/no_results_light.png',
                        ),
                      )
                    else
                      _buildCurrencyList(context, provider, animateEntrance: animateEntrance),
                    SliverToBoxAdapter(
                      child: Consumer<AdFreeProvider>(
                        builder: (context, adFree, _) {
                          if (adFree.isAdFree) return const SizedBox.shrink();
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: InlineBannerAd(),
                          );
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                  ],
                ),
                ),
              ),
              // Linear progress indicator at top when refreshing with existing data
              if (provider.isLoading && provider.rates.isNotEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.transparent,
                  ),
                ),
            ],
          ),
        );
        }

        final reduceMotion = MediaQuery.of(context).disableAnimations;
        return AnimatedSwitcher(
          duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: content,
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Refresh message handler
  // ---------------------------------------------------------------------------

  void _handleRefreshMessage(CurrencyProvider provider) {
    final status = provider.refreshStatus;
    if (status == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final isError = status != RefreshStatus.success;
      final message = switch (status) {
        RefreshStatus.success => l10n.ratesUpdated,
        RefreshStatus.networkError => l10n.errorNoInternetCheck,
        RefreshStatus.serverError => l10n.errorServerRetry,
        RefreshStatus.error => l10n.errorLoadRates,
        RefreshStatus.cachedFallback => l10n.errorCacheFallback,
      };
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isError ? AppColors.negative : AppColors.positive,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
          ),
        );
      provider.clearRefreshStatus();
    });
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  SliverToBoxAdapter _buildHeader(
      BuildContext context, CurrencyProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.rubik(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (provider.isFromCache)
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
                        const SizedBox(width: AppConstants.space4),
                        Text(
                          AppLocalizations.of(context).offline,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            if (provider.lastUpdated != null)
              Text(
                AppLocalizations.of(context)
                    .lastPrefix(_formatTime(context, provider.lastUpdated!)),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Hero currencies (horizontal scroll)
  // ---------------------------------------------------------------------------

  SliverToBoxAdapter _buildHeroCurrencies(
      BuildContext context, CurrencyProvider provider, {bool animateEntrance = false}) {
    final mainCurrencies = provider.mainCurrencies;
    if (mainCurrencies.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: AppConstants.space12, bottom: AppConstants.space16),
        child: SizedBox(
          height: AppConstants.heroCardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: mainCurrencies.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppConstants.space12),
            itemBuilder: (context, index) {
              final currency = mainCurrencies[index];
              final heroTag = 'hero_${currency.code}';
              Widget card = HeroCurrencyCard(
                currency: currency,
                heroTag: heroTag,
                onTap: () => _openDetail(context, currency.code, heroTag: heroTag),
              );
              if (animateEntrance) {
                card = _StaggeredItem(index: index, child: card);
              }
              return card;
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Favorites header
  // ---------------------------------------------------------------------------

  SliverToBoxAdapter _buildFavoritesHeader(
      BuildContext context, CurrencyProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(context).favoritesTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _isEditing
                    ? AppLocalizations.of(context).done
                    : AppLocalizations.of(context).edit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Favorites list (non-editing mode)
  // ---------------------------------------------------------------------------

  SliverList _buildFavoritesList(
      BuildContext context, CurrencyProvider provider) {
    final favCurrencies = _getNonMainFavorites(provider);

    return SliverList.builder(
      itemCount: favCurrencies.length,
      itemBuilder: (context, index) {
        final currency = favCurrencies[index];
        final heroTag = 'fav_${currency.code}';
        return Column(
          children: [
            CurrencyListItem(
              currency: currency,
              isFavorite: true,
              heroTag: heroTag,
              onTap: () => _openDetail(context, currency.code, heroTag: heroTag),
              onFavoriteTap: () => provider.toggleFavorite(currency.code),
            ),
            if (index < favCurrencies.length - 1)
              const Divider(indent: 56, endIndent: 20, height: 1),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Favorites list (editing mode — reorderable + dismissible)
  // ---------------------------------------------------------------------------

  SliverReorderableList _buildEditableFavoritesList(
      BuildContext context, CurrencyProvider provider) {
    final favCurrencies = _getNonMainFavorites(provider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverReorderableList(
      itemCount: favCurrencies.length,
      onReorder: (oldIndex, newIndex) {
        HapticFeedback.lightImpact();
        provider.reorderFavorite(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final currency = favCurrencies[index];
        return ReorderableDelayedDragStartListener(
          key: ValueKey(currency.code),
          index: index,
          child: Dismissible(
            key: ValueKey('dismiss_${currency.code}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.space16, vertical: AppConstants.space4),
              decoration: BoxDecoration(
                color: AppColors.negative,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            onDismissed: (_) =>
                _handleDismiss(context, provider, currency),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.drag_handle_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                    const SizedBox(width: AppConstants.space8),
                    Expanded(
                      child: CurrencyListItem(
                        currency: currency,
                        isFavorite: true,
                        heroTag: 'edit_${currency.code}',
                        onTap: () => _openDetail(context, currency.code, heroTag: 'edit_${currency.code}'),
                        onFavoriteTap: () =>
                            provider.toggleFavorite(currency.code),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // All currencies header
  // ---------------------------------------------------------------------------

  SliverToBoxAdapter _buildAllCurrenciesHeader(
      BuildContext context, CurrencyProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSearchActive = provider.searchQuery.isNotEmpty;
    final isCategoryActive = provider.selectedCategory != CurrencyCategory.all;
    final count = provider.filteredRates.length;

    final l10n = AppLocalizations.of(context);
    String headerText;
    if (isSearchActive) {
      headerText = l10n.resultsCount(count);
    } else if (isCategoryActive) {
      headerText = l10n.categoryWithCount(
        _categoryLabel(l10n, provider.selectedCategory),
        count,
      );
    } else {
      headerText = l10n.allCurrencies;
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Text(
          headerText,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // All currencies list
  // ---------------------------------------------------------------------------

  SliverList _buildCurrencyList(
      BuildContext context, CurrencyProvider provider, {bool animateEntrance = false}) {
    final currencies = provider.filteredRates;

    return SliverList.builder(
      itemCount: currencies.length,
      itemBuilder: (context, index) {
        final currency = currencies[index];
        final heroTag = 'all_${currency.code}';
        Widget item = Column(
          children: [
            CurrencyListItem(
              currency: currency,
              isFavorite: provider.favorites.contains(currency.code),
              heroTag: heroTag,
              onTap: () => _openDetail(context, currency.code, heroTag: heroTag),
              onFavoriteTap: () => provider.toggleFavorite(currency.code),
            ),
            if (index < currencies.length - 1)
              const Divider(indent: 56, endIndent: 20, height: 1),
          ],
        );
        if (animateEntrance) {
          item = _StaggeredItem(index: index + 3, child: item);
        }
        return item;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Sort menu
  // ---------------------------------------------------------------------------

  void _showSortMenu(BuildContext context, CurrencyProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.space16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPaddingH,
                  ),
                  child: Text(
                    AppLocalizations.of(context).sort,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.space8),
                ...SortType.values.map((sort) {
                  final isSelected = provider.sortType == sort;
                  return ListTile(
                    leading: Icon(
                      _sortIcons[sort],
                      size: AppConstants.iconSizeMedium,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                    ),
                    title: Text(
                      _sortLabel(AppLocalizations.of(context), sort),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: AppConstants.iconSizeMedium,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      provider.sortType = sort;
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  List<Currency> _getNonMainFavorites(CurrencyProvider provider) {
    return provider.favoriteCurrencies
        .where((c) => !AppConstants.mainCurrencies.contains(c.code))
        .toList();
  }

  void _handleDismiss(
      BuildContext context, CurrencyProvider provider, Currency currency) {
    final code = currency.code;
    // Capture current index before removal for undo
    final removedIndex = provider.favorites.indexOf(code);
    provider.removeFavorite(code);

    HapticFeedback.mediumImpact();

    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.favoriteRemoved(currency.code)),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () {
              provider.insertFavorite(code, removedIndex);
            },
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      );
  }

  void _openDetail(BuildContext context, String code, {String? heroTag}) {
    if (_isNavigating) return;
    _isNavigating = true;
    final mainState = context.findAncestorStateOfType<MainScreenState>();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    Navigator.push<String>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CurrencyDetailScreen(currencyCode: code, heroTag: heroTag),
        transitionDuration: reduceMotion ? Duration.zero : const Duration(milliseconds: 350),
        reverseTransitionDuration: reduceMotion ? Duration.zero : AppConstants.animationFast,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (reduceMotion) return child;
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutExpo,
            )),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    ).then((result) {
      _isNavigating = false;
      if (result == 'calculator') {
        mainState?.switchToTab(1);
      }
    });
  }

  String _formatTime(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final time = '$h:$m';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(dt.year, dt.month, dt.day);

    if (dateOnly == today) {
      return l10n.todayWithTime(time);
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return l10n.yesterdayWithTime(time);
    } else {
      final d = dt.day.toString().padLeft(2, '0');
      final mo = dt.month.toString().padLeft(2, '0');
      return '$d.$mo.${dt.year}, $time';
    }
  }
}

// =============================================================================
// Staggered entrance animation wrapper (first load only)
// =============================================================================

class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;

  const _StaggeredItem({
    required this.child,
    required this.index,
  });

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_reduceMotion) {
      _controller.value = 1.0;
    } else if (_controller.value == 0.0) {
      if (widget.index < 10) {
        Future.delayed(Duration(milliseconds: 50 * widget.index), () {
          if (mounted) _controller.forward();
        });
      } else {
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion || _controller.isCompleted) return widget.child;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

// =============================================================================
// Sticky search delegate
// =============================================================================

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final CurrencyCategory selectedCategory;
  final ValueChanged<CurrencyCategory> onCategoryChanged;
  final SortType sortType;
  final VoidCallback onSortTap;

  const _StickySearchDelegate({
    required this.searchController,
    required this.onChanged,
    required this.onClear,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.sortType,
    required this.onSortTap,
  });

  static const double _searchRowHeight = 64.0;
  static const double _chipRowHeight = 48.0;

  @override
  double get maxExtent => _searchRowHeight + _chipRowHeight;

  @override
  double get minExtent => _searchRowHeight + _chipRowHeight;

  @override
  bool shouldRebuild(covariant _StickySearchDelegate oldDelegate) {
    return searchController != oldDelegate.searchController ||
        selectedCategory != oldDelegate.selectedCategory ||
        sortType != oldDelegate.sortType;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final showBorder = shrinkOffset > 0;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnimatedContainer(
      duration: reduceMotion ? Duration.zero : AppConstants.animationFast,
      decoration: BoxDecoration(
        color: scaffoldBg,
        border: Border(
          bottom: BorderSide(
            color: showBorder
                ? (isDark ? AppColors.dividerDark : AppColors.dividerLight)
                : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search row with sort button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: _SearchField(
                    controller: searchController,
                    onChanged: onChanged,
                    onClear: onClear,
                  ),
                ),
                const SizedBox(width: AppConstants.space4),
                _SortButton(
                  sortType: sortType,
                  onTap: onSortTap,
                ),
              ],
            ),
          ),
          // Category chips row
          SizedBox(
            height: _chipRowHeight,
            child: _CategoryChips(
              selected: selectedCategory,
              onChanged: onCategoryChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Sort icon button
// =============================================================================

class _SortButton extends StatelessWidget {
  final SortType sortType;
  final VoidCallback onTap;

  const _SortButton({required this.sortType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = sortType != SortType.defaultOrder;

    return SizedBox(
      width: AppConstants.minTouchTarget,
      height: AppConstants.minTouchTarget,
      child: IconButton(
        onPressed: onTap,
        tooltip: AppLocalizations.of(context).sort,
        icon: Icon(
          Icons.sort_rounded,
          size: AppConstants.iconSizeLarge,
          color: isActive
              ? theme.colorScheme.primary
              : (isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight),
        ),
      ),
    );
  }
}

// =============================================================================
// Category chips
// =============================================================================

class _CategoryChips extends StatelessWidget {
  final CurrencyCategory selected;
  final ValueChanged<CurrencyCategory> onChanged;

  const _CategoryChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenPaddingH,
        vertical: AppConstants.space8,
      ),
      itemCount: CurrencyCategory.values.length,
      separatorBuilder: (_, _) => const SizedBox(width: AppConstants.space8),
      itemBuilder: (context, index) {
        final category = CurrencyCategory.values[index];
        final isSelected = category == selected;
        final label = _categoryLabel(AppLocalizations.of(context), category);

        return GestureDetector(
          onTap: () => onChanged(category),
          child: AnimatedContainer(
            duration: AppConstants.animationFast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space14,
              vertical: AppConstants.space6,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : (isDark
                      ? AppColors.surfaceVariantDark
                      : AppColors.surfaceVariantLight),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              border: isSelected
                  ? null
                  : Border.all(
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                      width: 1,
                    ),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}

// A stateful widget so the clear button reactively appears/disappears
class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).searchHint,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: isDark
              ? AppColors.textTertiaryDark
              : AppColors.textTertiaryLight,
        ),
        suffixIcon: _hasText
            ? IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
                onPressed: widget.onClear,
                tooltip: AppLocalizations.of(context).clear,
              )
            : null,
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceVariantDark
            : AppColors.surfaceVariantLight,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
