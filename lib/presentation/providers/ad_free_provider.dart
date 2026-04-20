import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class AdFreeProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  List<DateTime> _watchTimestamps = [];
  Timer? _expiryTimer;

  AdFreeProvider(this._prefs) {
    _load();
  }

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  /// 24 soat ichida ko'rilgan rewarded video soni
  int get watchesUsedToday => _recentWatches.length;

  /// Qolgan ko'rish imkoniyati
  int get watchesRemaining =>
      (AppConstants.maxDailyRewardedWatches - watchesUsedToday)
          .clamp(0, AppConstants.maxDailyRewardedWatches);

  /// 3 ta ko'rilganmi — ad-free faolmi
  bool get isAdFree =>
      _recentWatches.length >= AppConstants.maxDailyRewardedWatches;

  /// Yana ko'rish mumkinmi
  bool get canWatch => watchesRemaining > 0;

  /// Ad-free tugashiga qolgan vaqt
  Duration get adFreeRemaining {
    final recent = _recentWatches;
    if (recent.length < AppConstants.maxDailyRewardedWatches) {
      return Duration.zero;
    }
    // 3-chi (eng eski hisoblangan) ko'rishdan 24 soat
    final thirdWatch =
        recent[recent.length - AppConstants.maxDailyRewardedWatches];
    final expiry = thirdWatch.add(const Duration(hours: 24));
    final remaining = expiry.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // ---------------------------------------------------------------------------
  // Methods
  // ---------------------------------------------------------------------------

  /// Rewarded video ko'rilganda chaqiriladi
  Future<void> recordWatch() async {
    _watchTimestamps.add(DateTime.now());
    _prune();
    await _save();
    _scheduleExpiryTimer();
    notifyListeners();
  }

  /// App resume bo'lganda yoki tashqi holatda yangilash uchun
  void refresh() {
    _prune();
    _scheduleExpiryTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  /// Oxirgi 24 soatdagi ko'rishlar (sorted, eng eski birinchi)
  List<DateTime> get _recentWatches {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    return _watchTimestamps.where((t) => t.isAfter(cutoff)).toList()..sort();
  }

  void _load() {
    final raw = _prefs.getStringList(AppConstants.prefRewardedWatchTimestamps);
    if (raw != null) {
      _watchTimestamps = raw
          .map((s) => DateTime.tryParse(s))
          .whereType<DateTime>()
          .toList();
    }
    _prune();
    _scheduleExpiryTimer();
  }

  /// 48 soatdan eski timestamp'larni o'chirish
  void _prune() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 48));
    _watchTimestamps.removeWhere((t) => t.isBefore(cutoff));
  }

  Future<void> _save() async {
    final raw = _watchTimestamps.map((t) => t.toIso8601String()).toList();
    await _prefs.setStringList(AppConstants.prefRewardedWatchTimestamps, raw);
  }

  void _scheduleExpiryTimer() {
    _expiryTimer?.cancel();
    if (!isAdFree) return;

    final remaining = adFreeRemaining;
    if (remaining <= Duration.zero) return;

    _expiryTimer = Timer(remaining, () {
      _prune();
      notifyListeners();
    });
  }
}
