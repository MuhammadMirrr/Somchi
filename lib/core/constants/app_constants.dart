import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Somchi';

  // UZS (O'zbekiston so'mi)
  static const String uzsCode = 'UZS';
  static const String uzsNameUz = "O'zbekiston so'mi";
  static const String uzsUnit = "so'm";

  // CBU API
  static const String cbuBaseUrl =
      'https://cbu.uz/uz/arkhiv-kursov-valyut/json';
  static const String cbuWebsiteUrl = 'https://cbu.uz';

  // Legal URLs
  static const String privacyPolicyUrl =
      'https://muhammadmirrr.github.io/somchi-privacy/';
  static const String termsOfUseUrl =
      'https://muhammadmirrr.github.io/somchi-privacy/';

  // Developer
  static const String developerName = 'Muhammad Mirqobilov';
  static const String developerTelegramUrl = 'https://t.me/mirqobilov_mm';
  static const String developerLinkedInUrl =
      'https://www.linkedin.com/in/muhammad-mirqobilov-97056034b/';

  // Default sevimli valyutalar
  static const List<String> defaultFavorites = ['USD', 'EUR', 'RUB'];

  // Asosiy valyutalar (katta ko'rinishda)
  static const List<String> mainCurrencies = ['USD', 'EUR', 'RUB'];

  // Kategoriya filterlari uchun valyuta guruhlar
  static const List<String> majorCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'CHF', 'CNY', 'RUB', 'KRW', 'AED',
  ];
  static const List<String> metalCurrencies = [
    'XAU', 'XAG', 'XPT', 'XPD',
  ];

  // SharedPreferences kalitlari
  static const String prefFavorites = 'favorite_currencies';
  static const String prefThemeMode = 'theme_mode';
  static const String prefCachedRates = 'cached_rates';
  static const String prefLastUpdated = 'last_updated';
  static const String prefHistoryPrefix = 'history_';
  static const String prefHistoryDatePrefix = 'history_date_';
  static const String prefRewardedWatchTimestamps = 'rewarded_watch_timestamps';
  static const String prefFirstLaunchComplete = 'first_launch_complete';
  static const String prefLanguageIndex = 'language_index';
  static const String prefPriceAlerts = 'price_alerts';

  // Rewarded ad limits
  static const int maxDailyRewardedWatches = 3;

  // AdMob IDs — debug rejimida Google test ID'lari, release'da real ID'lar
  // Test ID'lar: https://developers.google.com/admob/android/test-ads
  static const String _adBannerIdProd = 'ca-app-pub-2977939261747724/4529059139';
  static const String _adAppOpenIdProd = 'ca-app-pub-2977939261747724/6963650781';
  static const String _adRewardedIdProd = 'ca-app-pub-2977939261747724/1276413090';

  static const String _adBannerIdTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String _adAppOpenIdTest = 'ca-app-pub-3940256099942544/9257395921';
  static const String _adRewardedIdTest = 'ca-app-pub-3940256099942544/5224354917';

  static String get adBannerIdAndroid =>
      kDebugMode ? _adBannerIdTest : _adBannerIdProd;
  static String get adAppOpenIdAndroid =>
      kDebugMode ? _adAppOpenIdTest : _adAppOpenIdProd;
  static String get adRewardedIdAndroid =>
      kDebugMode ? _adRewardedIdTest : _adRewardedIdProd;

  // Spacing (8px grid)
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0; // for list item vertical padding
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Screen padding
  static const double screenPaddingH = 20.0;

  // Component sizes
  static const double heroCardWidth = 160.0;
  static const double heroCardHeight = 160.0;
  static const double swapButtonSize = 52.0;
  static const double flagEmojiLarge = 28.0;
  static const double flagEmojiMedium = 24.0;
  static const double flagEmojiSmall = 20.0;
  static const double navBarHeight = 64.0;
  static const double stickySearchHeight = 64.0;

  // Border Radius
  static const double radiusXS = 6.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 999.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 28.0;

  // Touch target
  static const double minTouchTarget = 48.0;

  // Animation
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);
  static const Duration animationVerySlow = Duration(milliseconds: 600);

  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration swapDebounce = Duration(milliseconds: 350);

  // Chart
  static const double chartHeight = 220.0;

  // Valyuta bayroqlari (emoji)
  static const Map<String, String> currencyFlags = {
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'RUB': '🇷🇺',
    'JPY': '🇯🇵',
    'CHF': '🇨🇭',
    'CNY': '🇨🇳',
    'KRW': '🇰🇷',
    'TRY': '🇹🇷',
    'KZT': '🇰🇿',
    'UAH': '🇺🇦',
    'GEL': '🇬🇪',
    'AED': '🇦🇪',
    'AUD': '🇦🇺',
    'ARS': '🇦🇷',
    'AFN': '🇦🇫',
    'BDT': '🇧🇩',
    'BGN': '🇧🇬',
    'BHD': '🇧🇭',
    'BRL': '🇧🇷',
    'BYN': '🇧🇾',
    'CAD': '🇨🇦',
    'CLP': '🇨🇱',
    'COP': '🇨🇴',
    'CZK': '🇨🇿',
    'DKK': '🇩🇰',
    'DZD': '🇩🇿',
    'EGP': '🇪🇬',
    'HKD': '🇭🇰',
    'HUF': '🇭🇺',
    'IDR': '🇮🇩',
    'ILS': '🇮🇱',
    'INR': '🇮🇳',
    'IQD': '🇮🇶',
    'IRR': '🇮🇷',
    'ISK': '🇮🇸',
    'JOD': '🇯🇴',
    'KGS': '🇰🇬',
    'KWD': '🇰🇼',
    'LAK': '🇱🇦',
    'LBP': '🇱🇧',
    'LYD': '🇱🇾',
    'MAD': '🇲🇦',
    'MDL': '🇲🇩',
    'MNT': '🇲🇳',
    'MXN': '🇲🇽',
    'MYR': '🇲🇾',
    'NGN': '🇳🇬',
    'NOK': '🇳🇴',
    'NZD': '🇳🇿',
    'PHP': '🇵🇭',
    'PKR': '🇵🇰',
    'PLN': '🇵🇱',
    'QAR': '🇶🇦',
    'RON': '🇷🇴',
    'RSD': '🇷🇸',
    'SAR': '🇸🇦',
    'SDG': '🇸🇩',
    'SEK': '🇸🇪',
    'SGD': '🇸🇬',
    'SYP': '🇸🇾',
    'THB': '🇹🇭',
    'TJS': '🇹🇯',
    'TMT': '🇹🇲',
    'TND': '🇹🇳',
    'TWD': '🇹🇼',
    'VND': '🇻🇳',
    'XAU': '🥇',
    'XDR': '🌐',
    'ZAR': '🇿🇦',
  };

  static String getFlag(String currencyCode) {
    return currencyFlags[currencyCode] ?? '💱';
  }
}
