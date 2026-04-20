import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/currency.dart';
import '../../l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CurrencySelectorSheet — DraggableScrollableSheet bottom sheet for picking
// a currency, with search, favorites section, and full list.
// ─────────────────────────────────────────────────────────────────────────────

class CurrencySelectorSheet extends StatefulWidget {
  final List<Currency> currencies;
  final String selectedCode;
  final List<String> favorites;
  final bool showUzs;

  const CurrencySelectorSheet({
    super.key,
    required this.currencies,
    required this.selectedCode,
    this.favorites = const [],
    this.showUzs = true,
  });

  @override
  State<CurrencySelectorSheet> createState() => _CurrencySelectorSheetState();
}

class _CurrencySelectorSheetState extends State<CurrencySelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  List<_CurrencyItem> _allItems = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allItems = _buildItems(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<_CurrencyItem> _buildItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <_CurrencyItem>[];
    if (widget.showUzs) {
      items.add(_CurrencyItem(
        code: AppConstants.uzsCode,
        name: l10n.uzsName,
        searchableNames: [AppConstants.uzsNameUz, 'UZS', l10n.uzsName],
        flag: '\u{1F1FA}\u{1F1FF}',
      ));
    }
    for (final c in widget.currencies) {
      items.add(_CurrencyItem(
        code: c.code,
        name: c.displayName(context),
        searchableNames: [c.nameUz, c.nameRu, c.nameEn],
        flag: AppConstants.getFlag(c.code),
      ));
    }
    return items;
  }

  List<_CurrencyItem> _filter(List<_CurrencyItem> source) {
    if (_query.isEmpty) return source;
    final q = _query.toLowerCase();
    return source
        .where((i) =>
            i.code.toLowerCase().contains(q) ||
            i.name.toLowerCase().contains(q) ||
            i.searchableNames.any((n) => n.toLowerCase().contains(q)))
        .toList();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      if (mounted) {
        setState(() => _query = value.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    // Determine favorite items
    final favoriteItems = widget.favorites.isEmpty
        ? <_CurrencyItem>[]
        : _allItems
            .where((i) => widget.favorites.contains(i.code))
            .toList();
    final allFiltered = _filter(_allItems);
    final favFiltered = _filter(favoriteItems);

    final showFavoritesSection =
        favFiltered.isNotEmpty && _query.isEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: AppConstants.space12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textTertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.space16),
              child: Text(
                AppLocalizations.of(context).selectCurrencyTitle,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.space16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).selectCurrencySearch,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          tooltip: AppLocalizations.of(context).clear,
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.space8),

            // List content
            if (allFiltered.isEmpty && !showFavoritesSection)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: AppConstants.space12),
                      Text(
                        AppLocalizations.of(context).selectCurrencyNotFound,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: _buildListLength(
                    showFavoritesSection: showFavoritesSection,
                    favCount: favFiltered.length,
                    allCount: allFiltered.length,
                  ),
                  itemBuilder: (context, index) {
                    return _buildListItem(
                      context,
                      index: index,
                      showFavoritesSection: showFavoritesSection,
                      favItems: favFiltered,
                      allItems: allFiltered,
                      theme: theme,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  int _buildListLength({
    required bool showFavoritesSection,
    required int favCount,
    required int allCount,
  }) {
    if (!showFavoritesSection) {
      // "Barchasi" header + all items
      return 1 + allCount;
    }
    // "Sevimlilar" header + fav items + "Barchasi" header + all items
    return 1 + favCount + 1 + allCount;
  }

  Widget _buildListItem(
    BuildContext context, {
    required int index,
    required bool showFavoritesSection,
    required List<_CurrencyItem> favItems,
    required List<_CurrencyItem> allItems,
    required ThemeData theme,
  }) {
    final l10n = AppLocalizations.of(context);
    if (!showFavoritesSection) {
      if (index == 0) {
        return _buildSectionHeader(context, l10n.categoryAll);
      }
      return _buildCurrencyTile(
        context,
        item: allItems[index - 1],
        theme: theme,
      );
    }

    // With favorites section
    if (index == 0) {
      return _buildSectionHeader(context, l10n.favoritesTitle);
    }
    if (index <= favItems.length) {
      return _buildCurrencyTile(
        context,
        item: favItems[index - 1],
        theme: theme,
      );
    }
    if (index == favItems.length + 1) {
      return _buildSectionHeader(context, l10n.categoryAll);
    }
    final allIndex = index - favItems.length - 2;
    return _buildCurrencyTile(
      context,
      item: allItems[allIndex],
      theme: theme,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.space16,
        AppConstants.space12,
        AppConstants.space16,
        AppConstants.space4,
      ),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textTertiary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCurrencyTile(
    BuildContext context, {
    required _CurrencyItem item,
    required ThemeData theme,
  }) {
    final isSelected = item.code == widget.selectedCode;

    final tile = ListTile(
      key: ValueKey(item.code),
      tileColor: isSelected
          ? theme.colorScheme.primary.withValues(alpha: 0.08)
          : null,
      leading: Text(
        item.flag,
        style: const TextStyle(fontSize: AppConstants.flagEmojiSmall),
      ),
      title: Text(
        item.code,
        style: theme.textTheme.titleSmall?.copyWith(
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: Text(
        item.name,
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context, item.code);
      },
    );

    if (isSelected) {
      return Semantics(
        selected: true,
        label: AppLocalizations.of(context)
            .selectCurrencySelected(item.code, item.name),
        child: tile,
      );
    }

    return tile;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal currency item model
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyItem {
  final String code;
  final String name;
  final String flag;
  final List<String> searchableNames;

  const _CurrencyItem({
    required this.code,
    required this.name,
    required this.flag,
    this.searchableNames = const [],
  });
}
