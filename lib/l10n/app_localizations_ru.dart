// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Somchi';

  @override
  String get appTagline => 'Курсы валют';

  @override
  String get splashSource => 'На основе данных Центрального Банка Узбекистана';

  @override
  String get navRates => 'Курсы';

  @override
  String get navCalculator => 'Калькулятор';

  @override
  String get navSettings => 'Настройки';

  @override
  String get ratesRefreshing => 'Курсы обновляются...';

  @override
  String get ratesUpdated => 'Курсы обновлены';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка';

  @override
  String get cancel => 'Нет';

  @override
  String get confirm => 'Да';

  @override
  String get clear => 'Очистить';

  @override
  String get close => 'Закрыть';

  @override
  String get searchHint => 'Поиск валюты...';

  @override
  String searchNotFound(String query) {
    return 'По запросу \'$query\' валюта не найдена';
  }

  @override
  String get categoryEmpty => 'В этой категории нет валют';

  @override
  String get offline => 'Офлайн';

  @override
  String lastPrefix(String time) {
    return 'Последнее: $time';
  }

  @override
  String get favoritesTitle => 'Избранные';

  @override
  String get edit => 'Редактировать';

  @override
  String get done => 'Готово';

  @override
  String resultsCount(int count) {
    return 'Результаты ($count)';
  }

  @override
  String categoryWithCount(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get allCurrencies => 'Все валюты';

  @override
  String get sort => 'Сортировка';

  @override
  String favoriteRemoved(String code) {
    return '$code удалена из избранного';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String todayWithTime(String time) {
    return 'Сегодня, $time';
  }

  @override
  String yesterdayWithTime(String time) {
    return 'Вчера, $time';
  }

  @override
  String get categoryAll => 'Все';

  @override
  String get categoryMajor => 'Основные';

  @override
  String get categoryMinor => 'Прочие';

  @override
  String get categoryMetals => 'Металлы';

  @override
  String get sortDefault => 'По умолчанию';

  @override
  String get sortAlphabetical => 'А-Я';

  @override
  String get sortRateHighToLow => 'Курс (выше→ниже)';

  @override
  String get sortRateLowToHigh => 'Курс (ниже→выше)';

  @override
  String get sortChangePercent => 'Изменение %';

  @override
  String get calcScreenTitle => 'Калькулятор';

  @override
  String get calcOffline => 'Офлайн курсы';

  @override
  String get calcLoadError => 'Не удалось загрузить курсы';

  @override
  String get calcLoading => 'Загрузка курсов...';

  @override
  String get calcAmount => 'Сумма';

  @override
  String get calcResult => 'Результат';

  @override
  String get calcSelectCurrency => 'Выбор валюты';

  @override
  String get calcCopy => 'Копировать';

  @override
  String get calcCopied => 'Скопировано';

  @override
  String get calcSwap => 'Поменять валюты местами';

  @override
  String get detailNotFound => 'Валюта не найдена';

  @override
  String get detailInfoNotFound => 'Нет данных';

  @override
  String get detailCalculate => 'Калькулятор';

  @override
  String get detailRemoveFavorite => 'Удалить из избранного';

  @override
  String get detailAddFavorite => 'Добавить в избранное';

  @override
  String get period7d => '7 дней';

  @override
  String get period1m => '1 месяц';

  @override
  String get period3m => '3 месяца';

  @override
  String get period1y => '1 год';

  @override
  String periodSemantic(String label) {
    return 'Период $label';
  }

  @override
  String get chartMin => 'Минимум';

  @override
  String get chartCurrent => 'Текущий';

  @override
  String get chartMax => 'Максимум';

  @override
  String get chartDuringPeriod => 'за период';

  @override
  String get uzsName => 'Узбекский сум';

  @override
  String get uzsUnit => 'сум';

  @override
  String get unitSuffix => 'ед.';

  @override
  String unitsFor(int count) {
    return 'за $count ед.';
  }

  @override
  String perNominal(int nominal) {
    return '$nominal ед.';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAppearance => 'Внешний вид';

  @override
  String get settingsData => 'Данные';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get settingsLegal => 'Юридическая информация';

  @override
  String get settingsSupport => 'Поддержка';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsContact => 'Связь';

  @override
  String get settingsClearCacheQuestion => 'Очистить кэш?';

  @override
  String get settingsClearCacheBody =>
      'Кэшированные курсы будут удалены и перезагружены с сервера CBU.';

  @override
  String get settingsRefreshError => 'Ошибка при обновлении';

  @override
  String get settingsCacheCleared => 'Кэш очищен и обновлён';

  @override
  String get settingsUrlOpenError => 'Не удалось открыть ссылку';

  @override
  String get settingsNeverUpdated => 'Ещё не обновлялось';

  @override
  String get settingsLastUpdate => 'Последнее обновление';

  @override
  String get settingsClearCache => 'Очистить кэш';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsDataSource => 'Источник данных';

  @override
  String get settingsDataSourceValue => 'Центральный Банк Узбекистана';

  @override
  String get settingsDeveloper => 'Разработчик';

  @override
  String get settingsTerms => 'Условия использования';

  @override
  String get settingsPrivacy => 'Политика конфиденциальности';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get langUzLatin => 'O\'zbekcha';

  @override
  String get langUzCyrillic => 'Ўзбекча';

  @override
  String get langRussian => 'Русский';

  @override
  String get langEnglish => 'English';

  @override
  String get errorNoInternet => 'Нет соединения с интернетом';

  @override
  String get errorServer => 'Ошибка сервера';

  @override
  String get errorRequestTimeout => 'Время ожидания истекло';

  @override
  String get errorInvalidResponse => 'Неверный формат ответа';

  @override
  String get errorUnexpected => 'Неизвестная ошибка';

  @override
  String get errorCacheFallback => 'Нет интернета. Показаны данные из кэша';

  @override
  String get errorServerRetry => 'Ошибка сервера. Повторите позже';

  @override
  String get errorNoInternetCheck => 'Нет интернета. Проверьте подключение.';

  @override
  String get errorLoadRates =>
      'Ошибка загрузки курсов. Проверьте подключение к интернету.';

  @override
  String get errorLoadHistory => 'Ошибка загрузки истории';

  @override
  String get errorNoRate => 'Курс валюты отсутствует';

  @override
  String get adFreeActivated =>
      'Спасибо! Режим без рекламы активирован на 24 часа';

  @override
  String adFreeRemaining(int remaining) {
    return 'Спасибо! Ещё $remaining шт.';
  }

  @override
  String get adLoadFailed => 'Реклама не загрузилась, попробуйте позже';

  @override
  String get adFreeActive => 'Режим без рекламы активен!';

  @override
  String adFreeCountdown(int hours, int minutes) {
    return 'Осталось: $hours ч $minutes мин';
  }

  @override
  String get adFreeThanks =>
      'Спасибо! Ваша поддержка\n— большая помощь разработчику!';

  @override
  String get adFreeSupportTitle => 'Поддержите разработчика!';

  @override
  String adFreeDescription(int max) {
    return 'Посмотрите $max рекламы и\n24 часа без рекламы';
  }

  @override
  String adFreeProgress(int max, int used) {
    return '$used из $max просмотрено';
  }

  @override
  String get adButtonLoading => 'Загрузка...';

  @override
  String adButtonWatch(int remaining) {
    return 'Смотреть рекламу (осталось $remaining)';
  }

  @override
  String get adButtonAdLoading => 'Реклама загружается...';

  @override
  String get selectCurrencyTitle => 'Выберите валюту';

  @override
  String get selectCurrencySearch => 'Поиск...';

  @override
  String get selectCurrencyNotFound => 'Не найдено';

  @override
  String selectCurrencySelected(String code, String name) {
    return '$code — $name, выбрано';
  }

  @override
  String semanticFlag(String code) {
    return 'Флаг $code';
  }

  @override
  String get semanticRateNoChange => 'Без изменений';

  @override
  String semanticRateUp(String percent) {
    return 'Курс вырос на $percent процентов';
  }

  @override
  String semanticRateDown(String percent) {
    return 'Курс упал на $percent процентов';
  }

  @override
  String semanticHeroRate(String unit, String units) {
    return '$unit$units';
  }

  @override
  String get currencyUSD => 'Доллар США';

  @override
  String get currencyEUR => 'Евро';

  @override
  String get currencyRUB => 'Российский рубль';

  @override
  String get currencyGBP => 'Фунт стерлингов';

  @override
  String get currencyJPY => 'Японская иена';

  @override
  String get currencyCHF => 'Швейцарский франк';

  @override
  String get currencyCNY => 'Китайский юань';

  @override
  String get currencyKRW => 'Корейская вона';

  @override
  String get currencyAED => 'Дирхам ОАЭ';

  @override
  String get currencyXAU => 'Золото (г)';

  @override
  String get currencyXAG => 'Серебро (г)';

  @override
  String get currencyXPT => 'Платина (г)';

  @override
  String get currencyXPD => 'Палладий (г)';

  @override
  String get currencyUZS => 'Узбекский сум';
}
