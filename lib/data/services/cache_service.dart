import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/currency.dart';
import '../../core/constants/app_constants.dart';

class CacheService {
  final SharedPreferences _prefs;

  CacheService(this._prefs);

  /// History cache key — separator bilan (collision'dan saqlash)
  /// history_USD__30 — ikki underscore "USD" va "USDT" ni ajratadi
  String _historyKey(String code, int days) =>
      '${AppConstants.prefHistoryPrefix}${code}__$days';

  String _historyDateKey(String code, int days) =>
      '${AppConstants.prefHistoryDatePrefix}${code}__$days';

  /// Kurslarni cache'lash
  Future<void> cacheRates(List<Currency> rates) async {
    try {
      final jsonList = rates.map((r) => r.toJson()).toList();
      await _prefs.setString(AppConstants.prefCachedRates, json.encode(jsonList));
      await _prefs.setString(
        AppConstants.prefLastUpdated,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      debugPrint('cacheRates xato: $e');
    }
  }

  /// Cache'langan kurslarni olish
  List<Currency>? getCachedRates() {
    final cached = _prefs.getString(AppConstants.prefCachedRates);
    if (cached == null) return null;

    try {
      final data = json.decode(cached);
      if (data is! List) return null;
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => Currency.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('getCachedRates parse xato: $e');
      return null;
    }
  }

  /// Oxirgi yangilanish vaqtini olish
  DateTime? getLastUpdated() {
    final str = _prefs.getString(AppConstants.prefLastUpdated);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  /// Sevimli valyutalarni olish
  List<String> getFavorites() {
    return List<String>.from(
      _prefs.getStringList(AppConstants.prefFavorites) ??
          AppConstants.defaultFavorites,
    );
  }

  /// Sevimli valyutalarni saqlash
  Future<void> saveFavorites(List<String> favorites) async {
    try {
      await _prefs.setStringList(AppConstants.prefFavorites, favorites);
    } catch (e) {
      debugPrint('saveFavorites xato: $e');
    }
  }

  /// Bugungi kurs hali yangilanganmi? (kuniga 1 marta yetarli)
  bool isRatesCacheValid() {
    final lastUpdated = getLastUpdated();
    if (lastUpdated == null) return false;
    final now = DateTime.now();
    // Bir xil kun bo'lsa cache hali yaroqli
    return lastUpdated.year == now.year &&
        lastUpdated.month == now.month &&
        lastUpdated.day == now.day;
  }

  /// Valyuta tarixini cache'lash
  Future<void> cacheHistory(
      String currencyCode, int days, List<Map<String, dynamic>> data) async {
    try {
      await _prefs.setString(_historyKey(currencyCode, days), json.encode(data));
      await _prefs.setString(
          _historyDateKey(currencyCode, days), DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('cacheHistory xato ($currencyCode/$days): $e');
    }
  }

  /// Cache'langan tarixni olish
  List<Map<String, dynamic>>? getCachedHistory(
      String currencyCode, int days) {
    final cached = _prefs.getString(_historyKey(currencyCode, days));
    final dateStr = _prefs.getString(_historyDateKey(currencyCode, days));
    if (cached == null || dateStr == null) return null;

    // Tarix cache muddati: bugungi sana bo'lsa yaroqli
    final cachedDate = DateTime.tryParse(dateStr);
    if (cachedDate == null) return null;
    final now = DateTime.now();
    if (cachedDate.year != now.year ||
        cachedDate.month != now.month ||
        cachedDate.day != now.day) {
      return null; // Eskirgan — yangi ma'lumot kerak
    }

    try {
      final data = json.decode(cached);
      if (data is! List) return null;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('getCachedHistory parse xato ($currencyCode/$days): $e');
      return null;
    }
  }

  /// Muddati o'tgan bo'lsa ham keshdan tarix olish (offline fallback)
  List<Map<String, dynamic>>? getCachedHistoryAnyDate(
      String currencyCode, int days) {
    final cached = _prefs.getString(_historyKey(currencyCode, days));
    if (cached == null) return null;

    try {
      final data = json.decode(cached);
      if (data is! List) return null;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('getCachedHistoryAnyDate parse xato ($currencyCode/$days): $e');
      return null;
    }
  }

  /// Tema rejimini olish (0=system, 1=light, 2=dark)
  int getThemeMode() {
    return _prefs.getInt(AppConstants.prefThemeMode) ?? 0;
  }

  /// Tema rejimini saqlash
  Future<void> saveThemeMode(int mode) async {
    try {
      await _prefs.setInt(AppConstants.prefThemeMode, mode);
    } catch (e) {
      debugPrint('saveThemeMode xato: $e');
    }
  }

  /// Til indeksini olish (0=uz, 1=uz_Cyrl, 2=ru, 3=en)
  int getLanguageIndex() {
    return _prefs.getInt(AppConstants.prefLanguageIndex) ?? 0;
  }

  /// Til indeksini saqlash
  Future<void> saveLanguageIndex(int index) async {
    try {
      await _prefs.setInt(AppConstants.prefLanguageIndex, index);
    } catch (e) {
      debugPrint('saveLanguageIndex xato: $e');
    }
  }

  List<Map<String, dynamic>> getPriceAlerts() {
    final raw = _prefs.getString(AppConstants.prefPriceAlerts);
    if (raw == null) return [];

    try {
      final data = json.decode(raw);
      if (data is! List) return [];
      return data.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('getPriceAlerts parse xato: $e');
      return [];
    }
  }

  Future<void> savePriceAlerts(List<Map<String, dynamic>> alerts) async {
    try {
      await _prefs.setString(AppConstants.prefPriceAlerts, json.encode(alerts));
    } catch (e) {
      debugPrint('savePriceAlerts xato: $e');
    }
  }
}
