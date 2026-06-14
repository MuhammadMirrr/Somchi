import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/exceptions.dart';
import '../../data/models/currency.dart';
import '../../data/models/price_alert.dart';
import '../../data/models/rate_history.dart';
import '../../data/repositories/currency_repository.dart';

enum SortType { defaultOrder, alphabetical, rateHighToLow, rateLowToHigh, changePercent }

enum CurrencyCategory { all, major, minor, metals }

/// Xato holatlari — tarjima UI tomonida amalga oshiriladi
enum LoadError { networkError, serverError, unknown }

/// Refresh natijasi — snackbar uchun
enum RefreshStatus { success, networkError, serverError, cachedFallback, error }

class CurrencyProvider extends ChangeNotifier {
  final CurrencyRepository _repository;

  CurrencyProvider(this._repository);

  List<Currency> _rates = [];
  List<Currency> get rates => _rates;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoadError? _error;
  LoadError? get error => _error;

  bool _isFromCache = false;
  bool get isFromCache => _isFromCache;

  DateTime? get lastUpdated => _repository.getLastUpdated();

  List<String> _favorites = [];
  List<String> get favorites => _favorites;

  List<PriceAlert> _priceAlerts = [];
  List<PriceAlert> get priceAlerts => _priceAlerts;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  SortType _sortType = SortType.defaultOrder;
  SortType get sortType => _sortType;

  set sortType(SortType value) {
    if (_sortType == value) return;
    _sortType = value;
    notifyListeners();
  }

  CurrencyCategory _selectedCategory = CurrencyCategory.all;
  CurrencyCategory get selectedCategory => _selectedCategory;

  set selectedCategory(CurrencyCategory value) {
    if (_selectedCategory == value) return;
    _selectedCategory = value;
    notifyListeners();
  }

  List<RateHistory> _history = [];
  List<RateHistory> get history => _history;
  bool _isHistoryLoading = false;
  bool get isHistoryLoading => _isHistoryLoading;
  bool _hasHistoryError = false;
  bool get hasHistoryError => _hasHistoryError;

  // Oxirgi refresh natijasi (snackbar uchun)
  RefreshStatus? _refreshStatus;
  RefreshStatus? get refreshStatus => _refreshStatus;

  void clearRefreshStatus() {
    _refreshStatus = null;
  }

  List<Currency> get filteredRates {
    // 1. Category filter
    List<Currency> result;
    switch (_selectedCategory) {
      case CurrencyCategory.all:
        result = List.of(_rates);
        break;
      case CurrencyCategory.major:
        result = _rates
            .where((c) => AppConstants.majorCurrencies.contains(c.code))
            .toList();
        break;
      case CurrencyCategory.metals:
        result = _rates
            .where((c) => AppConstants.metalCurrencies.contains(c.code))
            .toList();
        break;
      case CurrencyCategory.minor:
        result = _rates
            .where((c) =>
                !AppConstants.majorCurrencies.contains(c.code) &&
                !AppConstants.metalCurrencies.contains(c.code))
            .toList();
        break;
    }

    // 2. Search filter — barcha til nomlari bo'yicha qidiradi
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((c) {
        return c.code.toLowerCase().contains(q) ||
            c.nameUz.toLowerCase().contains(q) ||
            c.nameRu.toLowerCase().contains(q) ||
            c.nameEn.toLowerCase().contains(q);
      }).toList();
    }

    // 3. Sort
    switch (_sortType) {
      case SortType.defaultOrder:
        break;
      case SortType.alphabetical:
        result.sort((a, b) => a.code.compareTo(b.code));
        break;
      case SortType.rateHighToLow:
        result.sort((a, b) => b.ratePerUnit.compareTo(a.ratePerUnit));
        break;
      case SortType.rateLowToHigh:
        result.sort((a, b) => a.ratePerUnit.compareTo(b.ratePerUnit));
        break;
      case SortType.changePercent:
        result.sort(
            (a, b) => b.diffPercent.abs().compareTo(a.diffPercent.abs()));
        break;
    }

    return result;
  }

  List<Currency> get mainCurrencies {
    return _rates
        .where((c) => ['USD', 'EUR', 'RUB'].contains(c.code))
        .toList();
  }

  List<Currency> get favoriteCurrencies {
    return _favorites
        .map((code) =>
            _rates.where((c) => c.code == code).firstOrNull)
        .whereType<Currency>()
        .toList();
  }

  Future<void> init() async {
    _favorites = _repository.getFavorites();
    _priceAlerts = _repository.getPriceAlerts();
    await loadRates(forceRefresh: true);
  }

  Future<void> loadRates({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    _isFromCache = false;
    notifyListeners();

    try {
      final result =
          await _repository.getTodayRates(forceRefresh: forceRefresh);
      _rates = result.rates;
      _isFromCache = result.isFromCache;

      // Keshdan qaytgan bo'lsa va API xatosi bo'lgan bo'lsa — foydalanuvchiga bildirish
      if (result.isFromCache && _repository.lastFetchError != null) {
        final fetchError = _repository.lastFetchError;
        if (fetchError is NetworkException) {
          _error = LoadError.networkError;
        } else if (fetchError is ApiException) {
          _error = LoadError.serverError;
        }
      }
    } on NetworkException {
      _error = LoadError.networkError;
    } on ApiException {
      _error = LoadError.serverError;
    } catch (e) {
      _error = LoadError.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshRates() async {
    final hadData = _rates.isNotEmpty;
    await loadRates(forceRefresh: true);

    if (hadData && _error != null) {
      // Mavjud ma'lumotni ko'rsatishda davom etish, lekin snackbar orqali xatoni bildirish
      _refreshStatus = switch (_error!) {
        LoadError.networkError => RefreshStatus.cachedFallback,
        LoadError.serverError => RefreshStatus.serverError,
        LoadError.unknown => RefreshStatus.error,
      };
      _error = null;
    } else if (_error == null && _rates.isNotEmpty) {
      _refreshStatus = RefreshStatus.success;
    } else if (_error != null) {
      _refreshStatus = switch (_error!) {
        LoadError.networkError => RefreshStatus.networkError,
        LoadError.serverError => RefreshStatus.serverError,
        LoadError.unknown => RefreshStatus.error,
      };
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleFavorite(String currencyCode) async {
    if (_favorites.contains(currencyCode)) {
      _favorites.remove(currencyCode);
    } else {
      _favorites.add(currencyCode);
    }
    notifyListeners();
    await _repository.saveFavorites(_favorites);
  }

  Future<void> reorderFavorite(int oldIndex, int newIndex) async {
    final reorderableCodes = _favorites
        .where((code) => !['USD', 'EUR', 'RUB'].contains(code))
        .toList();
    if (newIndex > oldIndex) newIndex--;
    final item = reorderableCodes.removeAt(oldIndex);
    reorderableCodes.insert(newIndex, item);
    final mainFavs = _favorites
        .where((code) => ['USD', 'EUR', 'RUB'].contains(code))
        .toList();
    _favorites = [...mainFavs, ...reorderableCodes];
    notifyListeners();
    await _repository.saveFavorites(_favorites);
  }

  Future<int> removeFavorite(String currencyCode) async {
    final index = _favorites.indexOf(currencyCode);
    if (index != -1) {
      _favorites.removeAt(index);
      notifyListeners();
      await _repository.saveFavorites(_favorites);
    }
    return index;
  }

  Future<void> insertFavorite(String currencyCode, int index) async {
    if (!_favorites.contains(currencyCode)) {
      final safeIndex = index.clamp(0, _favorites.length);
      _favorites.insert(safeIndex, currencyCode);
      notifyListeners();
      await _repository.saveFavorites(_favorites);
    }
  }

  PriceAlert? getPriceAlert(String currencyCode) {
    try {
      return _priceAlerts.firstWhere((alert) => alert.currencyCode == currencyCode);
    } catch (_) {
      return null;
    }
  }

  bool hasPriceAlert(String currencyCode) => getPriceAlert(currencyCode) != null;

  Future<void> upsertPriceAlert({
    required String currencyCode,
    required double targetRate,
    required bool isEnabled,
  }) async {
    final index = _priceAlerts.indexWhere((alert) => alert.currencyCode == currencyCode);
    final alert = PriceAlert(
      currencyCode: currencyCode,
      targetRate: targetRate,
      isEnabled: isEnabled,
      createdAt: index >= 0 ? _priceAlerts[index].createdAt : DateTime.now(),
    );

    if (index >= 0) {
      _priceAlerts[index] = alert;
    } else {
      _priceAlerts.add(alert);
    }

    notifyListeners();
    await _repository.savePriceAlerts(_priceAlerts);
  }

  Future<void> removePriceAlert(String currencyCode) async {
    _priceAlerts.removeWhere((alert) => alert.currencyCode == currencyCode);
    notifyListeners();
    await _repository.savePriceAlerts(_priceAlerts);
  }

  Future<void> togglePriceAlert(String currencyCode, bool isEnabled) async {
    final index = _priceAlerts.indexWhere((alert) => alert.currencyCode == currencyCode);
    if (index == -1) return;

    _priceAlerts[index] = _priceAlerts[index].copyWith(isEnabled: isEnabled);
    notifyListeners();
    await _repository.savePriceAlerts(_priceAlerts);
  }

  Currency? getCurrencyByCode(String code) {
    try {
      return _rates.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadHistory({
    required String currencyCode,
    required int days,
  }) async {
    _isHistoryLoading = true;
    _hasHistoryError = false;
    notifyListeners();

    try {
      _history = await _repository.getCurrencyHistory(
        currencyCode: currencyCode,
        days: days,
      );
      _hasHistoryError = false;
    } catch (e) {
      _history = [];
      _hasHistoryError = true;
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }
}
