import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
    Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
  ];

  /// No description provided for @appName.
  ///
  /// In uz, this message translates to:
  /// **'Somchi'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In uz, this message translates to:
  /// **'Valyuta kurslari'**
  String get appTagline;

  /// No description provided for @splashSource.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbekiston Markaziy Banki ma\'lumotlari asosida'**
  String get splashSource;

  /// No description provided for @navRates.
  ///
  /// In uz, this message translates to:
  /// **'Kurslar'**
  String get navRates;

  /// No description provided for @navCalculator.
  ///
  /// In uz, this message translates to:
  /// **'Hisoblash'**
  String get navCalculator;

  /// No description provided for @navSettings.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get navSettings;

  /// No description provided for @ratesRefreshing.
  ///
  /// In uz, this message translates to:
  /// **'Kurslar yangilanmoqda...'**
  String get ratesRefreshing;

  /// No description provided for @ratesUpdated.
  ///
  /// In uz, this message translates to:
  /// **'Kurslar yangilandi'**
  String get ratesUpdated;

  /// No description provided for @retry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In uz, this message translates to:
  /// **'Yuklanmoqda'**
  String get loading;

  /// No description provided for @cancel.
  ///
  /// In uz, this message translates to:
  /// **'Yo\'q'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In uz, this message translates to:
  /// **'Ha'**
  String get confirm;

  /// No description provided for @clear.
  ///
  /// In uz, this message translates to:
  /// **'Tozalash'**
  String get clear;

  /// No description provided for @close.
  ///
  /// In uz, this message translates to:
  /// **'Yopish'**
  String get close;

  /// No description provided for @searchHint.
  ///
  /// In uz, this message translates to:
  /// **'Valyuta qidirish...'**
  String get searchHint;

  /// No description provided for @searchNotFound.
  ///
  /// In uz, this message translates to:
  /// **'\'{query}\' bo\'yicha valyuta topilmadi'**
  String searchNotFound(String query);

  /// No description provided for @categoryEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Bu kategoriyada valyuta topilmadi'**
  String get categoryEmpty;

  /// No description provided for @offline.
  ///
  /// In uz, this message translates to:
  /// **'Oflayn'**
  String get offline;

  /// No description provided for @lastPrefix.
  ///
  /// In uz, this message translates to:
  /// **'Oxirgi: {time}'**
  String lastPrefix(String time);

  /// No description provided for @favoritesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sevimlilar'**
  String get favoritesTitle;

  /// No description provided for @edit.
  ///
  /// In uz, this message translates to:
  /// **'Tahrirlash'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In uz, this message translates to:
  /// **'Tayyor'**
  String get done;

  /// No description provided for @resultsCount.
  ///
  /// In uz, this message translates to:
  /// **'Natijalar ({count})'**
  String resultsCount(int count);

  /// No description provided for @categoryWithCount.
  ///
  /// In uz, this message translates to:
  /// **'{name} ({count})'**
  String categoryWithCount(String name, int count);

  /// No description provided for @allCurrencies.
  ///
  /// In uz, this message translates to:
  /// **'Barcha valyutalar'**
  String get allCurrencies;

  /// No description provided for @sort.
  ///
  /// In uz, this message translates to:
  /// **'Saralash'**
  String get sort;

  /// No description provided for @favoriteRemoved.
  ///
  /// In uz, this message translates to:
  /// **'{code} sevimlilardan o\'chirildi'**
  String favoriteRemoved(String code);

  /// No description provided for @undo.
  ///
  /// In uz, this message translates to:
  /// **'Qaytarish'**
  String get undo;

  /// No description provided for @today.
  ///
  /// In uz, this message translates to:
  /// **'Bugun'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In uz, this message translates to:
  /// **'Kecha'**
  String get yesterday;

  /// No description provided for @todayWithTime.
  ///
  /// In uz, this message translates to:
  /// **'Bugun, {time}'**
  String todayWithTime(String time);

  /// No description provided for @yesterdayWithTime.
  ///
  /// In uz, this message translates to:
  /// **'Kecha, {time}'**
  String yesterdayWithTime(String time);

  /// No description provided for @categoryAll.
  ///
  /// In uz, this message translates to:
  /// **'Barchasi'**
  String get categoryAll;

  /// No description provided for @categoryMajor.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy'**
  String get categoryMajor;

  /// No description provided for @categoryMinor.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get categoryMinor;

  /// No description provided for @categoryMetals.
  ///
  /// In uz, this message translates to:
  /// **'Metallar'**
  String get categoryMetals;

  /// No description provided for @sortDefault.
  ///
  /// In uz, this message translates to:
  /// **'Standart'**
  String get sortDefault;

  /// No description provided for @sortAlphabetical.
  ///
  /// In uz, this message translates to:
  /// **'A-Z'**
  String get sortAlphabetical;

  /// No description provided for @sortRateHighToLow.
  ///
  /// In uz, this message translates to:
  /// **'Kurs (yuqori→past)'**
  String get sortRateHighToLow;

  /// No description provided for @sortRateLowToHigh.
  ///
  /// In uz, this message translates to:
  /// **'Kurs (past→yuqori)'**
  String get sortRateLowToHigh;

  /// No description provided for @sortChangePercent.
  ///
  /// In uz, this message translates to:
  /// **'O\'zgarish %'**
  String get sortChangePercent;

  /// No description provided for @calcScreenTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hisoblash'**
  String get calcScreenTitle;

  /// No description provided for @calcOffline.
  ///
  /// In uz, this message translates to:
  /// **'Oflayn kurslar'**
  String get calcOffline;

  /// No description provided for @calcLoadError.
  ///
  /// In uz, this message translates to:
  /// **'Kurslarni yuklab bo\'lmadi'**
  String get calcLoadError;

  /// No description provided for @calcLoading.
  ///
  /// In uz, this message translates to:
  /// **'Kurslar yuklanmoqda...'**
  String get calcLoading;

  /// No description provided for @calcAmount.
  ///
  /// In uz, this message translates to:
  /// **'Miqdor'**
  String get calcAmount;

  /// No description provided for @calcResult.
  ///
  /// In uz, this message translates to:
  /// **'Natija'**
  String get calcResult;

  /// No description provided for @calcSelectCurrency.
  ///
  /// In uz, this message translates to:
  /// **'Valyuta tanlash'**
  String get calcSelectCurrency;

  /// No description provided for @calcCopy.
  ///
  /// In uz, this message translates to:
  /// **'Nusxa olish'**
  String get calcCopy;

  /// No description provided for @calcCopied.
  ///
  /// In uz, this message translates to:
  /// **'Nusxa olindi'**
  String get calcCopied;

  /// No description provided for @calcSwap.
  ///
  /// In uz, this message translates to:
  /// **'Valyutalarni almashtirish'**
  String get calcSwap;

  /// No description provided for @detailNotFound.
  ///
  /// In uz, this message translates to:
  /// **'Valyuta topilmadi'**
  String get detailNotFound;

  /// No description provided for @detailInfoNotFound.
  ///
  /// In uz, this message translates to:
  /// **'Ma\'lumot topilmadi'**
  String get detailInfoNotFound;

  /// No description provided for @detailCalculate.
  ///
  /// In uz, this message translates to:
  /// **'Hisoblash'**
  String get detailCalculate;

  /// No description provided for @detailRemoveFavorite.
  ///
  /// In uz, this message translates to:
  /// **'Sevimlilardan o\'chirish'**
  String get detailRemoveFavorite;

  /// No description provided for @detailAddFavorite.
  ///
  /// In uz, this message translates to:
  /// **'Sevimlilarga qo\'shish'**
  String get detailAddFavorite;

  /// No description provided for @period7d.
  ///
  /// In uz, this message translates to:
  /// **'7 kun'**
  String get period7d;

  /// No description provided for @period1m.
  ///
  /// In uz, this message translates to:
  /// **'1 oy'**
  String get period1m;

  /// No description provided for @period3m.
  ///
  /// In uz, this message translates to:
  /// **'3 oy'**
  String get period3m;

  /// No description provided for @period1y.
  ///
  /// In uz, this message translates to:
  /// **'1 yil'**
  String get period1y;

  /// No description provided for @periodSemantic.
  ///
  /// In uz, this message translates to:
  /// **'{label} davr'**
  String periodSemantic(String label);

  /// No description provided for @chartMin.
  ///
  /// In uz, this message translates to:
  /// **'Minimal'**
  String get chartMin;

  /// No description provided for @chartCurrent.
  ///
  /// In uz, this message translates to:
  /// **'Hozirgi'**
  String get chartCurrent;

  /// No description provided for @chartMax.
  ///
  /// In uz, this message translates to:
  /// **'Maksimal'**
  String get chartMax;

  /// No description provided for @chartDuringPeriod.
  ///
  /// In uz, this message translates to:
  /// **'davr davomida'**
  String get chartDuringPeriod;

  /// No description provided for @uzsName.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbekiston so\'mi'**
  String get uzsName;

  /// No description provided for @uzsUnit.
  ///
  /// In uz, this message translates to:
  /// **'so\'m'**
  String get uzsUnit;

  /// No description provided for @unitSuffix.
  ///
  /// In uz, this message translates to:
  /// **'birlik'**
  String get unitSuffix;

  /// No description provided for @unitsFor.
  ///
  /// In uz, this message translates to:
  /// **'{count} birlik uchun'**
  String unitsFor(int count);

  /// No description provided for @perNominal.
  ///
  /// In uz, this message translates to:
  /// **'{nominal} birlik'**
  String perNominal(int nominal);

  /// No description provided for @settingsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'rinish'**
  String get settingsAppearance;

  /// No description provided for @settingsData.
  ///
  /// In uz, this message translates to:
  /// **'Ma\'lumotlar'**
  String get settingsData;

  /// No description provided for @settingsAbout.
  ///
  /// In uz, this message translates to:
  /// **'Ilova haqida'**
  String get settingsAbout;

  /// No description provided for @settingsLegal.
  ///
  /// In uz, this message translates to:
  /// **'Huquqiy'**
  String get settingsLegal;

  /// No description provided for @settingsSupport.
  ///
  /// In uz, this message translates to:
  /// **'Qo\'llab-quvvatlash'**
  String get settingsSupport;

  /// No description provided for @settingsLanguage.
  ///
  /// In uz, this message translates to:
  /// **'Til'**
  String get settingsLanguage;

  /// No description provided for @settingsContact.
  ///
  /// In uz, this message translates to:
  /// **'Bog\'lanish'**
  String get settingsContact;

  /// No description provided for @settingsClearCacheQuestion.
  ///
  /// In uz, this message translates to:
  /// **'Keshni tozalash?'**
  String get settingsClearCacheQuestion;

  /// No description provided for @settingsClearCacheBody.
  ///
  /// In uz, this message translates to:
  /// **'Keshlangan kurslar o\'chiriladi va CBU serveridan qayta yuklanadi.'**
  String get settingsClearCacheBody;

  /// No description provided for @settingsRefreshError.
  ///
  /// In uz, this message translates to:
  /// **'Yangilashda xatolik yuz berdi'**
  String get settingsRefreshError;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In uz, this message translates to:
  /// **'Kesh tozalandi va yangilandi'**
  String get settingsCacheCleared;

  /// No description provided for @settingsUrlOpenError.
  ///
  /// In uz, this message translates to:
  /// **'Havolani ochib bo\'lmadi'**
  String get settingsUrlOpenError;

  /// No description provided for @settingsNeverUpdated.
  ///
  /// In uz, this message translates to:
  /// **'Hali yangilanmagan'**
  String get settingsNeverUpdated;

  /// No description provided for @settingsLastUpdate.
  ///
  /// In uz, this message translates to:
  /// **'Oxirgi yangilanish'**
  String get settingsLastUpdate;

  /// No description provided for @settingsClearCache.
  ///
  /// In uz, this message translates to:
  /// **'Keshni tozalash'**
  String get settingsClearCache;

  /// No description provided for @settingsVersion.
  ///
  /// In uz, this message translates to:
  /// **'Versiya'**
  String get settingsVersion;

  /// No description provided for @settingsDataSource.
  ///
  /// In uz, this message translates to:
  /// **'Ma\'lumot manbasi'**
  String get settingsDataSource;

  /// No description provided for @settingsDataSourceValue.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbekiston Markaziy Banki'**
  String get settingsDataSourceValue;

  /// No description provided for @settingsDeveloper.
  ///
  /// In uz, this message translates to:
  /// **'Dasturchi'**
  String get settingsDeveloper;

  /// No description provided for @settingsTerms.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanish shartlari'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiylik siyosati'**
  String get settingsPrivacy;

  /// No description provided for @themeSystem.
  ///
  /// In uz, this message translates to:
  /// **'Tizim'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In uz, this message translates to:
  /// **'Yorug\''**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In uz, this message translates to:
  /// **'Qorong\'i'**
  String get themeDark;

  /// No description provided for @langUzLatin.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbekcha'**
  String get langUzLatin;

  /// No description provided for @langUzCyrillic.
  ///
  /// In uz, this message translates to:
  /// **'Ўзбекча'**
  String get langUzCyrillic;

  /// No description provided for @langRussian.
  ///
  /// In uz, this message translates to:
  /// **'Русский'**
  String get langRussian;

  /// No description provided for @langEnglish.
  ///
  /// In uz, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @errorNoInternet.
  ///
  /// In uz, this message translates to:
  /// **'Internet aloqasi yo\'q'**
  String get errorNoInternet;

  /// No description provided for @errorServer.
  ///
  /// In uz, this message translates to:
  /// **'Server xatosi'**
  String get errorServer;

  /// No description provided for @errorRequestTimeout.
  ///
  /// In uz, this message translates to:
  /// **'So\'rov vaqti tugadi'**
  String get errorRequestTimeout;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In uz, this message translates to:
  /// **'Noto\'g\'ri javob formati'**
  String get errorInvalidResponse;

  /// No description provided for @errorUnexpected.
  ///
  /// In uz, this message translates to:
  /// **'Kutilmagan xato'**
  String get errorUnexpected;

  /// No description provided for @errorCacheFallback.
  ///
  /// In uz, this message translates to:
  /// **'Internet aloqasi yo\'q. Keshdan ma\'lumotlar ko\'rsatilmoqda'**
  String get errorCacheFallback;

  /// No description provided for @errorServerRetry.
  ///
  /// In uz, this message translates to:
  /// **'Server xatosi. Keyinroq urinib ko\'ring'**
  String get errorServerRetry;

  /// No description provided for @errorNoInternetCheck.
  ///
  /// In uz, this message translates to:
  /// **'Internet aloqasi yo\'q. Internet aloqasini tekshiring.'**
  String get errorNoInternetCheck;

  /// No description provided for @errorLoadRates.
  ///
  /// In uz, this message translates to:
  /// **'Kurslarni yuklashda xatolik yuz berdi. Internet aloqasini tekshiring.'**
  String get errorLoadRates;

  /// No description provided for @errorLoadHistory.
  ///
  /// In uz, this message translates to:
  /// **'Tarixni yuklashda xatolik yuz berdi'**
  String get errorLoadHistory;

  /// No description provided for @errorNoRate.
  ///
  /// In uz, this message translates to:
  /// **'Valyuta kursi mavjud emas'**
  String get errorNoRate;

  /// No description provided for @adFreeActivated.
  ///
  /// In uz, this message translates to:
  /// **'Rahmat! 24 soat reklamasiz rejim faollashdi'**
  String get adFreeActivated;

  /// No description provided for @adFreeRemaining.
  ///
  /// In uz, this message translates to:
  /// **'Rahmat! Yana {remaining} ta ko\'ring'**
  String adFreeRemaining(int remaining);

  /// No description provided for @adLoadFailed.
  ///
  /// In uz, this message translates to:
  /// **'Reklama yuklanmadi, keyinroq urinib ko\'ring'**
  String get adLoadFailed;

  /// No description provided for @adFreeActive.
  ///
  /// In uz, this message translates to:
  /// **'Reklamasiz rejim faol!'**
  String get adFreeActive;

  /// No description provided for @adFreeCountdown.
  ///
  /// In uz, this message translates to:
  /// **'Qolgan vaqt: {hours} soat {minutes} daqiqa'**
  String adFreeCountdown(int hours, int minutes);

  /// No description provided for @adFreeThanks.
  ///
  /// In uz, this message translates to:
  /// **'Rahmat! Sizning qo\'llab-quvvatlashingiz\ndasturchiga katta yordam!'**
  String get adFreeThanks;

  /// No description provided for @adFreeSupportTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dasturchini qo\'llab-quvvatlang!'**
  String get adFreeSupportTitle;

  /// No description provided for @adFreeDescription.
  ///
  /// In uz, this message translates to:
  /// **'{max} ta reklama ko\'ring va 24 soat\nreklamasiz foydalaning'**
  String adFreeDescription(int max);

  /// No description provided for @adFreeProgress.
  ///
  /// In uz, this message translates to:
  /// **'{max} tadan {used} ta ko\'rildi'**
  String adFreeProgress(int max, int used);

  /// No description provided for @adButtonLoading.
  ///
  /// In uz, this message translates to:
  /// **'Yuklanmoqda...'**
  String get adButtonLoading;

  /// No description provided for @adButtonWatch.
  ///
  /// In uz, this message translates to:
  /// **'Reklama ko\'rish ({remaining} ta qoldi)'**
  String adButtonWatch(int remaining);

  /// No description provided for @adButtonAdLoading.
  ///
  /// In uz, this message translates to:
  /// **'Reklama yuklanmoqda...'**
  String get adButtonAdLoading;

  /// No description provided for @selectCurrencyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Valyutani tanlang'**
  String get selectCurrencyTitle;

  /// No description provided for @selectCurrencySearch.
  ///
  /// In uz, this message translates to:
  /// **'Qidirish...'**
  String get selectCurrencySearch;

  /// No description provided for @selectCurrencyNotFound.
  ///
  /// In uz, this message translates to:
  /// **'Topilmadi'**
  String get selectCurrencyNotFound;

  /// No description provided for @selectCurrencySelected.
  ///
  /// In uz, this message translates to:
  /// **'{code} — {name}, tanlangan'**
  String selectCurrencySelected(String code, String name);

  /// No description provided for @semanticFlag.
  ///
  /// In uz, this message translates to:
  /// **'{code} bayrog\'i'**
  String semanticFlag(String code);

  /// No description provided for @semanticRateNoChange.
  ///
  /// In uz, this message translates to:
  /// **'O\'zgarish yo\'q'**
  String get semanticRateNoChange;

  /// No description provided for @semanticRateUp.
  ///
  /// In uz, this message translates to:
  /// **'Kurs {percent} foizga oshdi'**
  String semanticRateUp(String percent);

  /// No description provided for @semanticRateDown.
  ///
  /// In uz, this message translates to:
  /// **'Kurs {percent} foizga tushdi'**
  String semanticRateDown(String percent);

  /// No description provided for @semanticHeroRate.
  ///
  /// In uz, this message translates to:
  /// **'{unit}{units}'**
  String semanticHeroRate(String unit, String units);

  /// No description provided for @currencyUSD.
  ///
  /// In uz, this message translates to:
  /// **'AQSh dollari'**
  String get currencyUSD;

  /// No description provided for @currencyEUR.
  ///
  /// In uz, this message translates to:
  /// **'Yevro'**
  String get currencyEUR;

  /// No description provided for @currencyRUB.
  ///
  /// In uz, this message translates to:
  /// **'Rus rubli'**
  String get currencyRUB;

  /// No description provided for @currencyGBP.
  ///
  /// In uz, this message translates to:
  /// **'Funt sterling'**
  String get currencyGBP;

  /// No description provided for @currencyJPY.
  ///
  /// In uz, this message translates to:
  /// **'Yapon iyenasi'**
  String get currencyJPY;

  /// No description provided for @currencyCHF.
  ///
  /// In uz, this message translates to:
  /// **'Shveysariya franki'**
  String get currencyCHF;

  /// No description provided for @currencyCNY.
  ///
  /// In uz, this message translates to:
  /// **'Xitoy yuani'**
  String get currencyCNY;

  /// No description provided for @currencyKRW.
  ///
  /// In uz, this message translates to:
  /// **'Koreya voni'**
  String get currencyKRW;

  /// No description provided for @currencyAED.
  ///
  /// In uz, this message translates to:
  /// **'BAA dirhami'**
  String get currencyAED;

  /// No description provided for @currencyXAU.
  ///
  /// In uz, this message translates to:
  /// **'Oltin (g)'**
  String get currencyXAU;

  /// No description provided for @currencyXAG.
  ///
  /// In uz, this message translates to:
  /// **'Kumush (g)'**
  String get currencyXAG;

  /// No description provided for @currencyXPT.
  ///
  /// In uz, this message translates to:
  /// **'Platina (g)'**
  String get currencyXPT;

  /// No description provided for @currencyXPD.
  ///
  /// In uz, this message translates to:
  /// **'Palladiy (g)'**
  String get currencyXPD;

  /// No description provided for @currencyUZS.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbekiston so\'mi'**
  String get currencyUZS;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'uz':
      {
        switch (locale.scriptCode) {
          case 'Cyrl':
            return AppLocalizationsUzCyrl();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
