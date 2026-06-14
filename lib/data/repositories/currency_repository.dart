import 'package:flutter/foundation.dart';
import '../models/currency.dart';
import '../models/price_alert.dart';
import '../models/rate_history.dart';
import '../services/cbu_api_service.dart';
import '../services/cache_service.dart';

class CurrencyRepository {
  final CbuApiService _apiService;
  final CacheService _cacheService;

  /// Oxirgi API xatosi (keshga fallback qilinganda saqlanadi)
  Exception? _lastFetchError;
  Exception? get lastFetchError => _lastFetchError;

  CurrencyRepository({
    required CbuApiService apiService,
    required CacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  /// Bugungi kurslarni olish (API dan, xato bo'lsa cache dan)
  /// Kuniga 1 marta API ga murojaat — qolgani cache dan
  /// Returns: ({rates, isFromCache}) — keshdan qaytganini bildiradi
  Future<({List<Currency> rates, bool isFromCache})> getTodayRates({
    bool forceRefresh = false,
  }) async {
    // Bugun allaqachon yuklangan bo'lsa va force emas — cache dan
    if (!forceRefresh && _cacheService.isRatesCacheValid()) {
      final cached = _cacheService.getCachedRates();
      if (cached != null && cached.isNotEmpty) {
        _lastFetchError = null;
        return (rates: cached, isFromCache: true); // Bugungi kesh — keshdan
      }
    }

    try {
      final rates = await _apiService.fetchTodayRates();
      await _cacheService.cacheRates(rates);
      _lastFetchError = null;
      return (rates: rates, isFromCache: false);
    } catch (e) {
      _lastFetchError = e is Exception ? e : Exception(e.toString());
      final cached = _cacheService.getCachedRates();
      if (cached != null && cached.isNotEmpty) {
        return (rates: cached, isFromCache: true); // Eski kesh — offline
      }
      rethrow;
    }
  }

  /// Cache JSON -> RateHistory ro'yxati (noto'g'ri elementlarni tashlab yuboradi)
  List<RateHistory> _parseHistoryCache(List<Map<String, dynamic>> cached) {
    final result = <RateHistory>[];
    for (final item in cached) {
      try {
        final dateRaw = item['date'];
        final rateRaw = item['rate'];
        final nominalRaw = item['nominal'];
        if (dateRaw is! String) continue;
        final date = DateTime.tryParse(dateRaw);
        if (date == null) continue;
        if (rateRaw is! num || nominalRaw is! num) continue;
        result.add(RateHistory(
          date: date,
          rate: rateRaw.toDouble(),
          nominal: nominalRaw.toInt(),
        ));
      } catch (e) {
        debugPrint('RateHistory parse element xato: $e');
      }
    }
    return result;
  }

  /// Valyuta tarixini olish (cache bilan)
  /// Tarixiy kurslar o'zgarmaydi — kuniga 1 marta yangilash yetarli
  Future<List<RateHistory>> getCurrencyHistory({
    required String currencyCode,
    required int days,
  }) async {
    // Cache dan tekshiramiz
    final cached = _cacheService.getCachedHistory(currencyCode, days);
    if (cached != null && cached.isNotEmpty) {
      final parsed = _parseHistoryCache(cached);
      if (parsed.isNotEmpty) return parsed;
    }

    // API dan olamiz
    try {
      final history = await _apiService.fetchCurrencyHistory(
        currencyCode: currencyCode,
        days: days,
      );

      // Cache ga saqlaymiz
      if (history.isNotEmpty) {
        final cacheData = history
            .map((h) => {
                  'date': h.date.toIso8601String(),
                  'rate': h.rate,
                  'nominal': h.nominal,
                })
            .toList();
        await _cacheService.cacheHistory(currencyCode, days, cacheData);
      }

      return history;
    } catch (e) {
      // API xato — eskirgan keshdan ham qaytarish (muddati o'tgan bo'lsa ham)
      final expiredCache =
          _cacheService.getCachedHistoryAnyDate(currencyCode, days);
      if (expiredCache != null && expiredCache.isNotEmpty) {
        final parsed = _parseHistoryCache(expiredCache);
        if (parsed.isNotEmpty) return parsed;
      }
      rethrow;
    }
  }

  /// Oxirgi yangilanish vaqti
  DateTime? getLastUpdated() => _cacheService.getLastUpdated();

  /// Sevimli valyutalar
  List<String> getFavorites() => _cacheService.getFavorites();

  Future<void> saveFavorites(List<String> favorites) =>
      _cacheService.saveFavorites(favorites);

  /// Tema rejimi
  int getThemeMode() => _cacheService.getThemeMode();

  Future<void> saveThemeMode(int mode) => _cacheService.saveThemeMode(mode);

  /// Til
  int getLanguageIndex() => _cacheService.getLanguageIndex();

  Future<void> saveLanguageIndex(int index) =>
      _cacheService.saveLanguageIndex(index);

  List<PriceAlert> getPriceAlerts() {
    return _cacheService
        .getPriceAlerts()
        .map(PriceAlert.fromJson)
        .where((alert) => alert.currencyCode.isNotEmpty)
        .toList();
  }

  Future<void> savePriceAlerts(List<PriceAlert> alerts) {
    return _cacheService.savePriceAlerts(
      alerts.map((alert) => alert.toJson()).toList(),
    );
  }
}
