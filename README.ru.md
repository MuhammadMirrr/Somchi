# Somchi — Курсы валют

**🌐 Языки:** [English](README.md) · [O'zbek](README.uz.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

Flutter-приложение официальных курсов валют Центрального банка Узбекистана (ЦБУ). Основная платформа — Android.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)
![Version](https://img.shields.io/badge/version-1.2.0-blue)

## Возможности

- 💱 **Курсы в реальном времени** — ежедневно обновляемые курсы из официального API ЦБУ
- 📊 **График истории курса** — динамика курса каждой валюты (`fl_chart`)
- 🧮 **Калькулятор** — конвертация валют через UZS
- ⭐ **Избранное** — закрепление часто используемых валют
- 🔍 **Поиск и сортировка** — по категории (основные/металлы/прочие), цене, изменению
- 🌓 **Темы** — светлая, тёмная и системная
- 🌐 **Три языка** — узбекский (лат./кир.), русский, английский
- 📴 **Офлайн-режим** — работа без интернета через кэш SharedPreferences
- ♿ **Доступность** — поддержка "reduce motion" и screen reader
- 🚫 **Режим без рекламы** — временное включение через rewarded ads

## Экраны

Три основные вкладки:
- **Курсы** — список валют, поиск, сортировка, экран деталей (с графиком)
- **Калькулятор** — конвертация между двумя валютами
- **Настройки** — язык, тема, режим без рекламы, данные разработчика

## Технологии

| Слой | Пакет/Технология |
|---|---|
| Управление состоянием | `provider` |
| HTTP | `http` |
| Графики | `fl_chart` |
| Локальное хранилище | `shared_preferences` |
| Типографика | `google_fonts` (Inter, Rubik) |
| Форматирование | `intl` |
| Реклама | `google_mobile_ads` |
| Анимация загрузки | `shimmer` |
| Локализация | `flutter_localizations` + ARB-файлы |

## Архитектура

Чистая архитектура, 3 слоя:

```
lib/
├── core/           # Константы, темы, утилиты, исключения
├── data/           # Модели, сервисы (CBU API, кэш), репозиторий
├── presentation/   # Экраны, виджеты, провайдеры
├── l10n/           # ARB-файлы (uz, uz_Cyrl, ru, en)
├── main.dart       # DI setup
└── app.dart        # MaterialApp + нижняя навигация
```

**Поток данных:** Screen → Provider → Repository → (API или кэш). Repository сначала обращается к API, при сбое переходит на кэш.

**Стратегия кэширования:**
- Сегодняшние курсы — по дате, один вызов API в день
- История — по коду валюты + количеству дней
- Автообновление — при возобновлении приложения (спустя 5+ минут)

Подробнее: [CLAUDE.md](CLAUDE.md) и [AGENTS.md](AGENTS.md)

## Начало работы

### Требования

- Flutter SDK 3.10.7+
- Dart 3.x
- Android Studio / VS Code
- Android SDK (API 21+)

### Установка

```bash
git clone https://github.com/MuhammadMirrr/Somchi.git
cd Somchi
flutter pub get
flutter run
```

### Release-сборка

**Настройка keystore:**

Создайте файл `android/key.properties` (не коммитится в git):

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=somchi
storeFile=somchi-release.jks
```

Поместите `somchi-release.jks` в `android/app/`.

**Сборка:**

```bash
# App Bundle для Play Store
flutter build appbundle --release

# APK
flutter build apk --release
```

## Скрипты

```bash
flutter pub get          # Установить зависимости
flutter run              # Запустить в режиме отладки
flutter analyze          # Статический анализ
flutter test             # Запустить тесты
flutter clean            # Очистить артефакты сборки
```

## API

Приложение использует официальный API ЦБУ:
- Сегодняшние курсы: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/`
- История: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/{CODE}/{YYYY-MM-DD}/`

API-ключ не требуется — открытый.

## Безопасность

- 🔒 Только HTTPS (`network_security_config.xml`)
- 🔐 ProGuard + R8 минификация (release)
- 🚫 Keystore-файлы исключены из git (`android/.gitignore`)

## Статус

- Версия: **1.2.0** (build 3)
- Платформа: Android (web/windows scaffold есть, не основной)
- Статус: в продакшене, в Play Store

## Лицензия

Распространяется под [лицензией MIT](LICENSE). Подробности в файле [LICENSE](LICENSE).

## Разработчик

**Muhammad Mirqobilov**
- Telegram: [@mirqobilov_mm](https://t.me/mirqobilov_mm)
- LinkedIn: [muhammad-mirqobilov](https://www.linkedin.com/in/muhammad-mirqobilov-97056034b/)
- Email: muhammadmirqobilov@gmail.com
