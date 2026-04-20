// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'Somchi';

  @override
  String get appTagline => 'Valyuta kurslari';

  @override
  String get splashSource =>
      'O\'zbekiston Markaziy Banki ma\'lumotlari asosida';

  @override
  String get navRates => 'Kurslar';

  @override
  String get navCalculator => 'Hisoblash';

  @override
  String get navSettings => 'Sozlamalar';

  @override
  String get ratesRefreshing => 'Kurslar yangilanmoqda...';

  @override
  String get ratesUpdated => 'Kurslar yangilandi';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get loading => 'Yuklanmoqda';

  @override
  String get cancel => 'Yo\'q';

  @override
  String get confirm => 'Ha';

  @override
  String get clear => 'Tozalash';

  @override
  String get close => 'Yopish';

  @override
  String get searchHint => 'Valyuta qidirish...';

  @override
  String searchNotFound(String query) {
    return '\'$query\' bo\'yicha valyuta topilmadi';
  }

  @override
  String get categoryEmpty => 'Bu kategoriyada valyuta topilmadi';

  @override
  String get offline => 'Oflayn';

  @override
  String lastPrefix(String time) {
    return 'Oxirgi: $time';
  }

  @override
  String get favoritesTitle => 'Sevimlilar';

  @override
  String get edit => 'Tahrirlash';

  @override
  String get done => 'Tayyor';

  @override
  String resultsCount(int count) {
    return 'Natijalar ($count)';
  }

  @override
  String categoryWithCount(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get allCurrencies => 'Barcha valyutalar';

  @override
  String get sort => 'Saralash';

  @override
  String favoriteRemoved(String code) {
    return '$code sevimlilardan o\'chirildi';
  }

  @override
  String get undo => 'Qaytarish';

  @override
  String get today => 'Bugun';

  @override
  String get yesterday => 'Kecha';

  @override
  String todayWithTime(String time) {
    return 'Bugun, $time';
  }

  @override
  String yesterdayWithTime(String time) {
    return 'Kecha, $time';
  }

  @override
  String get categoryAll => 'Barchasi';

  @override
  String get categoryMajor => 'Asosiy';

  @override
  String get categoryMinor => 'Boshqa';

  @override
  String get categoryMetals => 'Metallar';

  @override
  String get sortDefault => 'Standart';

  @override
  String get sortAlphabetical => 'A-Z';

  @override
  String get sortRateHighToLow => 'Kurs (yuqori→past)';

  @override
  String get sortRateLowToHigh => 'Kurs (past→yuqori)';

  @override
  String get sortChangePercent => 'O\'zgarish %';

  @override
  String get calcScreenTitle => 'Hisoblash';

  @override
  String get calcOffline => 'Oflayn kurslar';

  @override
  String get calcLoadError => 'Kurslarni yuklab bo\'lmadi';

  @override
  String get calcLoading => 'Kurslar yuklanmoqda...';

  @override
  String get calcAmount => 'Miqdor';

  @override
  String get calcResult => 'Natija';

  @override
  String get calcSelectCurrency => 'Valyuta tanlash';

  @override
  String get calcCopy => 'Nusxa olish';

  @override
  String get calcCopied => 'Nusxa olindi';

  @override
  String get calcSwap => 'Valyutalarni almashtirish';

  @override
  String get detailNotFound => 'Valyuta topilmadi';

  @override
  String get detailInfoNotFound => 'Ma\'lumot topilmadi';

  @override
  String get detailCalculate => 'Hisoblash';

  @override
  String get detailRemoveFavorite => 'Sevimlilardan o\'chirish';

  @override
  String get detailAddFavorite => 'Sevimlilarga qo\'shish';

  @override
  String get period7d => '7 kun';

  @override
  String get period1m => '1 oy';

  @override
  String get period3m => '3 oy';

  @override
  String get period1y => '1 yil';

  @override
  String periodSemantic(String label) {
    return '$label davr';
  }

  @override
  String get chartMin => 'Minimal';

  @override
  String get chartCurrent => 'Hozirgi';

  @override
  String get chartMax => 'Maksimal';

  @override
  String get chartDuringPeriod => 'davr davomida';

  @override
  String get uzsName => 'O\'zbekiston so\'mi';

  @override
  String get uzsUnit => 'so\'m';

  @override
  String get unitSuffix => 'birlik';

  @override
  String unitsFor(int count) {
    return '$count birlik uchun';
  }

  @override
  String perNominal(int nominal) {
    return '$nominal birlik';
  }

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsAppearance => 'Ko\'rinish';

  @override
  String get settingsData => 'Ma\'lumotlar';

  @override
  String get settingsAbout => 'Ilova haqida';

  @override
  String get settingsLegal => 'Huquqiy';

  @override
  String get settingsSupport => 'Qo\'llab-quvvatlash';

  @override
  String get settingsLanguage => 'Til';

  @override
  String get settingsContact => 'Bog\'lanish';

  @override
  String get settingsClearCacheQuestion => 'Keshni tozalash?';

  @override
  String get settingsClearCacheBody =>
      'Keshlangan kurslar o\'chiriladi va CBU serveridan qayta yuklanadi.';

  @override
  String get settingsRefreshError => 'Yangilashda xatolik yuz berdi';

  @override
  String get settingsCacheCleared => 'Kesh tozalandi va yangilandi';

  @override
  String get settingsUrlOpenError => 'Havolani ochib bo\'lmadi';

  @override
  String get settingsNeverUpdated => 'Hali yangilanmagan';

  @override
  String get settingsLastUpdate => 'Oxirgi yangilanish';

  @override
  String get settingsClearCache => 'Keshni tozalash';

  @override
  String get settingsVersion => 'Versiya';

  @override
  String get settingsDataSource => 'Ma\'lumot manbasi';

  @override
  String get settingsDataSourceValue => 'O\'zbekiston Markaziy Banki';

  @override
  String get settingsDeveloper => 'Dasturchi';

  @override
  String get settingsTerms => 'Foydalanish shartlari';

  @override
  String get settingsPrivacy => 'Maxfiylik siyosati';

  @override
  String get themeSystem => 'Tizim';

  @override
  String get themeLight => 'Yorug\'';

  @override
  String get themeDark => 'Qorong\'i';

  @override
  String get langUzLatin => 'O\'zbekcha';

  @override
  String get langUzCyrillic => 'Ўзбекча';

  @override
  String get langRussian => 'Русский';

  @override
  String get langEnglish => 'English';

  @override
  String get errorNoInternet => 'Internet aloqasi yo\'q';

  @override
  String get errorServer => 'Server xatosi';

  @override
  String get errorRequestTimeout => 'So\'rov vaqti tugadi';

  @override
  String get errorInvalidResponse => 'Noto\'g\'ri javob formati';

  @override
  String get errorUnexpected => 'Kutilmagan xato';

  @override
  String get errorCacheFallback =>
      'Internet aloqasi yo\'q. Keshdan ma\'lumotlar ko\'rsatilmoqda';

  @override
  String get errorServerRetry => 'Server xatosi. Keyinroq urinib ko\'ring';

  @override
  String get errorNoInternetCheck =>
      'Internet aloqasi yo\'q. Internet aloqasini tekshiring.';

  @override
  String get errorLoadRates =>
      'Kurslarni yuklashda xatolik yuz berdi. Internet aloqasini tekshiring.';

  @override
  String get errorLoadHistory => 'Tarixni yuklashda xatolik yuz berdi';

  @override
  String get errorNoRate => 'Valyuta kursi mavjud emas';

  @override
  String get adFreeActivated => 'Rahmat! 24 soat reklamasiz rejim faollashdi';

  @override
  String adFreeRemaining(int remaining) {
    return 'Rahmat! Yana $remaining ta ko\'ring';
  }

  @override
  String get adLoadFailed => 'Reklama yuklanmadi, keyinroq urinib ko\'ring';

  @override
  String get adFreeActive => 'Reklamasiz rejim faol!';

  @override
  String adFreeCountdown(int hours, int minutes) {
    return 'Qolgan vaqt: $hours soat $minutes daqiqa';
  }

  @override
  String get adFreeThanks =>
      'Rahmat! Sizning qo\'llab-quvvatlashingiz\ndasturchiga katta yordam!';

  @override
  String get adFreeSupportTitle => 'Dasturchini qo\'llab-quvvatlang!';

  @override
  String adFreeDescription(int max) {
    return '$max ta reklama ko\'ring va 24 soat\nreklamasiz foydalaning';
  }

  @override
  String adFreeProgress(int max, int used) {
    return '$max tadan $used ta ko\'rildi';
  }

  @override
  String get adButtonLoading => 'Yuklanmoqda...';

  @override
  String adButtonWatch(int remaining) {
    return 'Reklama ko\'rish ($remaining ta qoldi)';
  }

  @override
  String get adButtonAdLoading => 'Reklama yuklanmoqda...';

  @override
  String get selectCurrencyTitle => 'Valyutani tanlang';

  @override
  String get selectCurrencySearch => 'Qidirish...';

  @override
  String get selectCurrencyNotFound => 'Topilmadi';

  @override
  String selectCurrencySelected(String code, String name) {
    return '$code — $name, tanlangan';
  }

  @override
  String semanticFlag(String code) {
    return '$code bayrog\'i';
  }

  @override
  String get semanticRateNoChange => 'O\'zgarish yo\'q';

  @override
  String semanticRateUp(String percent) {
    return 'Kurs $percent foizga oshdi';
  }

  @override
  String semanticRateDown(String percent) {
    return 'Kurs $percent foizga tushdi';
  }

  @override
  String semanticHeroRate(String unit, String units) {
    return '$unit$units';
  }

  @override
  String get currencyUSD => 'AQSh dollari';

  @override
  String get currencyEUR => 'Yevro';

  @override
  String get currencyRUB => 'Rus rubli';

  @override
  String get currencyGBP => 'Funt sterling';

  @override
  String get currencyJPY => 'Yapon iyenasi';

  @override
  String get currencyCHF => 'Shveysariya franki';

  @override
  String get currencyCNY => 'Xitoy yuani';

  @override
  String get currencyKRW => 'Koreya voni';

  @override
  String get currencyAED => 'BAA dirhami';

  @override
  String get currencyXAU => 'Oltin (g)';

  @override
  String get currencyXAG => 'Kumush (g)';

  @override
  String get currencyXPT => 'Platina (g)';

  @override
  String get currencyXPD => 'Palladiy (g)';

  @override
  String get currencyUZS => 'O\'zbekiston so\'mi';
}

/// The translations for Uzbek, using the Cyrillic script (`uz_Cyrl`).
class AppLocalizationsUzCyrl extends AppLocalizationsUz {
  AppLocalizationsUzCyrl() : super('uz_Cyrl');

  @override
  String get appName => 'Somchi';

  @override
  String get appTagline => 'Валюта курслари';

  @override
  String get splashSource => 'Ўзбекистон Марказий Банки маълумотлари асосида';

  @override
  String get navRates => 'Курслар';

  @override
  String get navCalculator => 'Ҳисоблаш';

  @override
  String get navSettings => 'Созламалар';

  @override
  String get ratesRefreshing => 'Курслар янгиланмоқда...';

  @override
  String get ratesUpdated => 'Курслар янгиланди';

  @override
  String get retry => 'Қайта уриниш';

  @override
  String get loading => 'Юкланмоқда';

  @override
  String get cancel => 'Йўқ';

  @override
  String get confirm => 'Ҳа';

  @override
  String get clear => 'Тозалаш';

  @override
  String get close => 'Ёпиш';

  @override
  String get searchHint => 'Валюта қидириш...';

  @override
  String searchNotFound(String query) {
    return '\'$query\' бўйича валюта топилмади';
  }

  @override
  String get categoryEmpty => 'Бу категорияда валюта топилмади';

  @override
  String get offline => 'Офлайн';

  @override
  String lastPrefix(String time) {
    return 'Охирги: $time';
  }

  @override
  String get favoritesTitle => 'Севимлилар';

  @override
  String get edit => 'Таҳрирлаш';

  @override
  String get done => 'Тайёр';

  @override
  String resultsCount(int count) {
    return 'Натижалар ($count)';
  }

  @override
  String categoryWithCount(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get allCurrencies => 'Барча валюталар';

  @override
  String get sort => 'Саралаш';

  @override
  String favoriteRemoved(String code) {
    return '$code севимлилардан ўчирилди';
  }

  @override
  String get undo => 'Қайтариш';

  @override
  String get today => 'Бугун';

  @override
  String get yesterday => 'Кеча';

  @override
  String todayWithTime(String time) {
    return 'Бугун, $time';
  }

  @override
  String yesterdayWithTime(String time) {
    return 'Кеча, $time';
  }

  @override
  String get categoryAll => 'Барчаси';

  @override
  String get categoryMajor => 'Асосий';

  @override
  String get categoryMinor => 'Бошқа';

  @override
  String get categoryMetals => 'Металлар';

  @override
  String get sortDefault => 'Стандарт';

  @override
  String get sortAlphabetical => 'А-Я';

  @override
  String get sortRateHighToLow => 'Курс (юқори→паст)';

  @override
  String get sortRateLowToHigh => 'Курс (паст→юқори)';

  @override
  String get sortChangePercent => 'Ўзгариш %';

  @override
  String get calcScreenTitle => 'Ҳисоблаш';

  @override
  String get calcOffline => 'Офлайн курслар';

  @override
  String get calcLoadError => 'Курсларни юклаб бўлмади';

  @override
  String get calcLoading => 'Курслар юкланмоқда...';

  @override
  String get calcAmount => 'Миқдор';

  @override
  String get calcResult => 'Натижа';

  @override
  String get calcSelectCurrency => 'Валюта танлаш';

  @override
  String get calcCopy => 'Нусха олиш';

  @override
  String get calcCopied => 'Нусха олинди';

  @override
  String get calcSwap => 'Валюталарни алмаштириш';

  @override
  String get detailNotFound => 'Валюта топилмади';

  @override
  String get detailInfoNotFound => 'Маълумот топилмади';

  @override
  String get detailCalculate => 'Ҳисоблаш';

  @override
  String get detailRemoveFavorite => 'Севимлилардан ўчириш';

  @override
  String get detailAddFavorite => 'Севимлиларга қўшиш';

  @override
  String get period7d => '7 кун';

  @override
  String get period1m => '1 ой';

  @override
  String get period3m => '3 ой';

  @override
  String get period1y => '1 йил';

  @override
  String periodSemantic(String label) {
    return '$label давр';
  }

  @override
  String get chartMin => 'Минимал';

  @override
  String get chartCurrent => 'Ҳозирги';

  @override
  String get chartMax => 'Максимал';

  @override
  String get chartDuringPeriod => 'давр давомида';

  @override
  String get uzsName => 'Ўзбекистон сўми';

  @override
  String get uzsUnit => 'сўм';

  @override
  String get unitSuffix => 'бирлик';

  @override
  String unitsFor(int count) {
    return '$count бирлик учун';
  }

  @override
  String perNominal(int nominal) {
    return '$nominal бирлик';
  }

  @override
  String get settingsTitle => 'Созламалар';

  @override
  String get settingsAppearance => 'Кўриниш';

  @override
  String get settingsData => 'Маълумотлар';

  @override
  String get settingsAbout => 'Илова ҳақида';

  @override
  String get settingsLegal => 'Ҳуқуқий';

  @override
  String get settingsSupport => 'Қўллаб-қувватлаш';

  @override
  String get settingsLanguage => 'Тил';

  @override
  String get settingsContact => 'Боғланиш';

  @override
  String get settingsClearCacheQuestion => 'Кэшни тозалашми?';

  @override
  String get settingsClearCacheBody =>
      'Кэшланган курслар ўчирилади ва CBU серверидан қайта юкланади.';

  @override
  String get settingsRefreshError => 'Янгилашда хатолик юз берди';

  @override
  String get settingsCacheCleared => 'Кэш тозаланди ва янгиланди';

  @override
  String get settingsUrlOpenError => 'Ҳаволани очиб бўлмади';

  @override
  String get settingsNeverUpdated => 'Ҳали янгиланмаган';

  @override
  String get settingsLastUpdate => 'Охирги янгиланиш';

  @override
  String get settingsClearCache => 'Кэшни тозалаш';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsDataSource => 'Маълумот манбаси';

  @override
  String get settingsDataSourceValue => 'Ўзбекистон Марказий Банки';

  @override
  String get settingsDeveloper => 'Дастурчи';

  @override
  String get settingsTerms => 'Фойдаланиш шартлари';

  @override
  String get settingsPrivacy => 'Махфийлик сиёсати';

  @override
  String get themeSystem => 'Тизим';

  @override
  String get themeLight => 'Ёруғ';

  @override
  String get themeDark => 'Қоронғи';

  @override
  String get langUzLatin => 'O\'zbekcha';

  @override
  String get langUzCyrillic => 'Ўзбекча';

  @override
  String get langRussian => 'Русский';

  @override
  String get langEnglish => 'English';

  @override
  String get errorNoInternet => 'Интернет алоқаси йўқ';

  @override
  String get errorServer => 'Сервер хатоси';

  @override
  String get errorRequestTimeout => 'Сўров вақти тугади';

  @override
  String get errorInvalidResponse => 'Нотўғри жавоб формати';

  @override
  String get errorUnexpected => 'Кутилмаган хато';

  @override
  String get errorCacheFallback =>
      'Интернет алоқаси йўқ. Кэшдан маълумотлар кўрсатилмоқда';

  @override
  String get errorServerRetry => 'Сервер хатоси. Кейинроқ уриниб кўринг';

  @override
  String get errorNoInternetCheck =>
      'Интернет алоқаси йўқ. Интернет алоқасини текширинг.';

  @override
  String get errorLoadRates =>
      'Курсларни юклашда хатолик юз берди. Интернет алоқасини текширинг.';

  @override
  String get errorLoadHistory => 'Тарихни юклашда хатолик юз берди';

  @override
  String get errorNoRate => 'Валюта курси мавжуд эмас';

  @override
  String get adFreeActivated => 'Раҳмат! 24 соат реклама йўқ режим фаоллашди';

  @override
  String adFreeRemaining(int remaining) {
    return 'Раҳмат! Яна $remaining та кўринг';
  }

  @override
  String get adLoadFailed => 'Реклама юкланмади, кейинроқ уриниб кўринг';

  @override
  String get adFreeActive => 'Реклама йўқ режим фаол!';

  @override
  String adFreeCountdown(int hours, int minutes) {
    return 'Қолган вақт: $hours соат $minutes дақиқа';
  }

  @override
  String get adFreeThanks =>
      'Раҳмат! Сизнинг қўллаб-қувватлашингиз\nдастурчига катта ёрдам!';

  @override
  String get adFreeSupportTitle => 'Дастурчини қўллаб-қувватланг!';

  @override
  String adFreeDescription(int max) {
    return '$max та реклама кўринг ва 24 соат\nрекламасиз фойдаланинг';
  }

  @override
  String adFreeProgress(int max, int used) {
    return '$max тадан $used та кўрилди';
  }

  @override
  String get adButtonLoading => 'Юкланмоқда...';

  @override
  String adButtonWatch(int remaining) {
    return 'Реклама кўриш ($remaining та қолди)';
  }

  @override
  String get adButtonAdLoading => 'Реклама юкланмоқда...';

  @override
  String get selectCurrencyTitle => 'Валютани танланг';

  @override
  String get selectCurrencySearch => 'Қидириш...';

  @override
  String get selectCurrencyNotFound => 'Топилмади';

  @override
  String selectCurrencySelected(String code, String name) {
    return '$code — $name, танланган';
  }

  @override
  String semanticFlag(String code) {
    return '$code байроғи';
  }

  @override
  String get semanticRateNoChange => 'Ўзгариш йўқ';

  @override
  String semanticRateUp(String percent) {
    return 'Курс $percent фоизга ошди';
  }

  @override
  String semanticRateDown(String percent) {
    return 'Курс $percent фоизга тушди';
  }

  @override
  String semanticHeroRate(String unit, String units) {
    return '$unit$units';
  }

  @override
  String get currencyUSD => 'АҚШ доллари';

  @override
  String get currencyEUR => 'Евро';

  @override
  String get currencyRUB => 'Рус рубли';

  @override
  String get currencyGBP => 'Фунт стерлинг';

  @override
  String get currencyJPY => 'Япон иенаси';

  @override
  String get currencyCHF => 'Швейцария франки';

  @override
  String get currencyCNY => 'Хитой юани';

  @override
  String get currencyKRW => 'Корея вони';

  @override
  String get currencyAED => 'БАА диҳрами';

  @override
  String get currencyXAU => 'Олтин (г)';

  @override
  String get currencyXAG => 'Кумуш (г)';

  @override
  String get currencyXPT => 'Платина (г)';

  @override
  String get currencyXPD => 'Палладий (г)';

  @override
  String get currencyUZS => 'Ўзбекистон сўми';
}
