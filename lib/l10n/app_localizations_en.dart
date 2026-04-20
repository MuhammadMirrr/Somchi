// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Somchi';

  @override
  String get appTagline => 'Currency rates';

  @override
  String get splashSource => 'Based on Central Bank of Uzbekistan data';

  @override
  String get navRates => 'Rates';

  @override
  String get navCalculator => 'Calculator';

  @override
  String get navSettings => 'Settings';

  @override
  String get ratesRefreshing => 'Updating rates...';

  @override
  String get ratesUpdated => 'Rates updated';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading';

  @override
  String get cancel => 'No';

  @override
  String get confirm => 'Yes';

  @override
  String get clear => 'Clear';

  @override
  String get close => 'Close';

  @override
  String get searchHint => 'Search currency...';

  @override
  String searchNotFound(String query) {
    return 'No currency found for \'$query\'';
  }

  @override
  String get categoryEmpty => 'No currencies in this category';

  @override
  String get offline => 'Offline';

  @override
  String lastPrefix(String time) {
    return 'Last: $time';
  }

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String resultsCount(int count) {
    return 'Results ($count)';
  }

  @override
  String categoryWithCount(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get allCurrencies => 'All currencies';

  @override
  String get sort => 'Sort';

  @override
  String favoriteRemoved(String code) {
    return '$code removed from favorites';
  }

  @override
  String get undo => 'Undo';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String todayWithTime(String time) {
    return 'Today, $time';
  }

  @override
  String yesterdayWithTime(String time) {
    return 'Yesterday, $time';
  }

  @override
  String get categoryAll => 'All';

  @override
  String get categoryMajor => 'Major';

  @override
  String get categoryMinor => 'Other';

  @override
  String get categoryMetals => 'Metals';

  @override
  String get sortDefault => 'Default';

  @override
  String get sortAlphabetical => 'A-Z';

  @override
  String get sortRateHighToLow => 'Rate (high→low)';

  @override
  String get sortRateLowToHigh => 'Rate (low→high)';

  @override
  String get sortChangePercent => 'Change %';

  @override
  String get calcScreenTitle => 'Calculator';

  @override
  String get calcOffline => 'Offline rates';

  @override
  String get calcLoadError => 'Could not load rates';

  @override
  String get calcLoading => 'Loading rates...';

  @override
  String get calcAmount => 'Amount';

  @override
  String get calcResult => 'Result';

  @override
  String get calcSelectCurrency => 'Select currency';

  @override
  String get calcCopy => 'Copy';

  @override
  String get calcCopied => 'Copied';

  @override
  String get calcSwap => 'Swap currencies';

  @override
  String get detailNotFound => 'Currency not found';

  @override
  String get detailInfoNotFound => 'No data';

  @override
  String get detailCalculate => 'Calculate';

  @override
  String get detailRemoveFavorite => 'Remove from favorites';

  @override
  String get detailAddFavorite => 'Add to favorites';

  @override
  String get period7d => '7 days';

  @override
  String get period1m => '1 month';

  @override
  String get period3m => '3 months';

  @override
  String get period1y => '1 year';

  @override
  String periodSemantic(String label) {
    return '$label period';
  }

  @override
  String get chartMin => 'Minimum';

  @override
  String get chartCurrent => 'Current';

  @override
  String get chartMax => 'Maximum';

  @override
  String get chartDuringPeriod => 'over period';

  @override
  String get uzsName => 'Uzbek som';

  @override
  String get uzsUnit => 'sum';

  @override
  String get unitSuffix => 'units';

  @override
  String unitsFor(int count) {
    return 'per $count units';
  }

  @override
  String perNominal(int nominal) {
    return '$nominal units';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLegal => 'Legal';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsContact => 'Contact';

  @override
  String get settingsClearCacheQuestion => 'Clear cache?';

  @override
  String get settingsClearCacheBody =>
      'Cached rates will be deleted and reloaded from the CBU server.';

  @override
  String get settingsRefreshError => 'Error while refreshing';

  @override
  String get settingsCacheCleared => 'Cache cleared and updated';

  @override
  String get settingsUrlOpenError => 'Could not open link';

  @override
  String get settingsNeverUpdated => 'Never updated';

  @override
  String get settingsLastUpdate => 'Last update';

  @override
  String get settingsClearCache => 'Clear cache';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDataSource => 'Data source';

  @override
  String get settingsDataSourceValue => 'Central Bank of Uzbekistan';

  @override
  String get settingsDeveloper => 'Developer';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get langUzLatin => 'O\'zbekcha';

  @override
  String get langUzCyrillic => 'Ўзбекча';

  @override
  String get langRussian => 'Русский';

  @override
  String get langEnglish => 'English';

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorServer => 'Server error';

  @override
  String get errorRequestTimeout => 'Request timed out';

  @override
  String get errorInvalidResponse => 'Invalid response format';

  @override
  String get errorUnexpected => 'Unexpected error';

  @override
  String get errorCacheFallback => 'No internet. Showing cached data';

  @override
  String get errorServerRetry => 'Server error. Try again later';

  @override
  String get errorNoInternetCheck =>
      'No internet. Please check your connection.';

  @override
  String get errorLoadRates =>
      'Failed to load rates. Please check your internet connection.';

  @override
  String get errorLoadHistory => 'Failed to load history';

  @override
  String get errorNoRate => 'Currency rate not available';

  @override
  String get adFreeActivated =>
      'Thank you! Ad-free mode activated for 24 hours';

  @override
  String adFreeRemaining(int remaining) {
    return 'Thank you! $remaining more to go';
  }

  @override
  String get adLoadFailed => 'Ad failed to load, try again later';

  @override
  String get adFreeActive => 'Ad-free mode active!';

  @override
  String adFreeCountdown(int hours, int minutes) {
    return 'Remaining: ${hours}h ${minutes}m';
  }

  @override
  String get adFreeThanks =>
      'Thank you! Your support\nmeans a lot to the developer!';

  @override
  String get adFreeSupportTitle => 'Support the developer!';

  @override
  String adFreeDescription(int max) {
    return 'Watch $max ads and use\nthe app ad-free for 24 hours';
  }

  @override
  String adFreeProgress(int max, int used) {
    return '$used of $max watched';
  }

  @override
  String get adButtonLoading => 'Loading...';

  @override
  String adButtonWatch(int remaining) {
    return 'Watch ad ($remaining left)';
  }

  @override
  String get adButtonAdLoading => 'Ad loading...';

  @override
  String get selectCurrencyTitle => 'Select currency';

  @override
  String get selectCurrencySearch => 'Search...';

  @override
  String get selectCurrencyNotFound => 'Not found';

  @override
  String selectCurrencySelected(String code, String name) {
    return '$code — $name, selected';
  }

  @override
  String semanticFlag(String code) {
    return '$code flag';
  }

  @override
  String get semanticRateNoChange => 'No change';

  @override
  String semanticRateUp(String percent) {
    return 'Rate up by $percent percent';
  }

  @override
  String semanticRateDown(String percent) {
    return 'Rate down by $percent percent';
  }

  @override
  String semanticHeroRate(String unit, String units) {
    return '$unit$units';
  }

  @override
  String get currencyUSD => 'US dollar';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyRUB => 'Russian ruble';

  @override
  String get currencyGBP => 'Pound sterling';

  @override
  String get currencyJPY => 'Japanese yen';

  @override
  String get currencyCHF => 'Swiss franc';

  @override
  String get currencyCNY => 'Chinese yuan';

  @override
  String get currencyKRW => 'Korean won';

  @override
  String get currencyAED => 'UAE dirham';

  @override
  String get currencyXAU => 'Gold (g)';

  @override
  String get currencyXAG => 'Silver (g)';

  @override
  String get currencyXPT => 'Platinum (g)';

  @override
  String get currencyXPD => 'Palladium (g)';

  @override
  String get currencyUZS => 'Uzbek som';
}
