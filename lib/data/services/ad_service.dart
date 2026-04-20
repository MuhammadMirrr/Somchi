import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Markaziy reklama boshqaruv servisi.
class AdService {
  static final AdService _instance = AdService._();
  static AdService get instance => _instance;
  AdService._();

  bool _initialized = false;
  AppOpenAd? _appOpenAd;
  bool _appOpenAdShown = false;
  RewardedAd? _rewardedAd;
  SharedPreferences? _prefs;

  /// Rewarded ad yuklanganmi
  bool get isRewardedAdReady => _rewardedAd != null;

  /// Birinchi marta ochilayaptimi (install'dan keyin)
  bool get _isFirstLaunch {
    final prefs = _prefs;
    if (prefs == null) return false;
    return !(prefs.getBool(AppConstants.prefFirstLaunchComplete) ?? false);
  }

  // ---------------------------------------------------------------------------
  // Initialize
  // ---------------------------------------------------------------------------

  Future<void> init(SharedPreferences prefs) async {
    if (_initialized) return;
    _prefs = prefs;
    await MobileAds.instance.initialize();
    _initialized = true;
    _loadAppOpenAd();
    loadRewardedAd();
  }

  // ---------------------------------------------------------------------------
  // Banner Ad — har bir joy o'zi yaratadi va dispose qiladi
  // ---------------------------------------------------------------------------

  BannerAd createBannerAd({VoidCallback? onLoaded, VoidCallback? onFailed}) {
    return BannerAd(
      adUnitId: AppConstants.adBannerIdAndroid,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed: $error');
          ad.dispose();
          onFailed?.call();
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // App Open Ad — faqat birinchi marta
  // ---------------------------------------------------------------------------

  void _loadAppOpenAd() {
    if (_appOpenAdShown) return;

    AppOpenAd.load(
      adUnitId: AppConstants.adAppOpenIdAndroid,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('App open ad failed to load: $error');
        },
      ),
    );
  }

  /// Ilova birinchi ochilganda chaqiriladi.
  /// Faqat 1 marta ko'rsatadi, keyin qayta yuklamaydi.
  /// Birinchi marta o'rnatilgandan keyin ochilganda reklama chiqmaydi —
  /// yangi foydalanuvchiga yaxshi birinchi taassurot.
  void showAppOpenAdIfAvailable() {
    if (_appOpenAdShown || _appOpenAd == null) return;

    // Birinchi launch'da reklama ko'rsatmaymiz, faqat flagni belgilab qo'yamiz
    if (_isFirstLaunch) {
      _prefs?.setBool(AppConstants.prefFirstLaunchComplete, true);
      _appOpenAdShown = true; // bu sessiya uchun boshqa ko'rsatmasin
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('App open ad failed to show: $error');
        ad.dispose();
        _appOpenAd = null;
      },
    );

    _appOpenAd!.show();
    _appOpenAdShown = true;
  }

  // ---------------------------------------------------------------------------
  // Rewarded Ad — qo'llab-quvvatlash uchun
  // ---------------------------------------------------------------------------

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AppConstants.adRewardedIdAndroid,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Rewarded video ko'rsatish.
  /// [onRewarded] — foydalanuvchi to'liq ko'rganda chaqiriladi.
  /// Returns: true agar reward olindi, false agar reklama tayyor bo'lmasa yoki
  /// foydalanuvchi to'liq ko'rmasdan yopsa.
  Future<bool> showRewardedAd({required VoidCallback onRewarded}) {
    final completer = Completer<bool>();

    if (_rewardedAd == null) {
      completer.complete(false);
      return completer.future;
    }

    var rewardEarned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd(); // keyingi marta uchun oldindan yuklash
        if (!completer.isCompleted) completer.complete(rewardEarned);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        if (rewardEarned) return; // ikki marta chaqirilsa, takror hisoblanmasin
        rewardEarned = true;
        onRewarded();
      },
    );

    return completer.future;
  }

  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
