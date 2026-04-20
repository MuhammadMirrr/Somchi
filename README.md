# Somchi — Currency Rates

**🌐 Languages:** [English](README.md) · [O'zbek](README.uz.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

Flutter application for the Central Bank of Uzbekistan (CBU) official exchange rates. Primary platform — Android.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)
![Version](https://img.shields.io/badge/version-1.2.0-blue)

## Features

- 💱 **Real-time rates** — Daily updated rates from the official CBU API
- 📊 **Rate history chart** — Historical rate data per currency (`fl_chart`)
- 🧮 **Calculator** — Convert between currencies via UZS
- ⭐ **Favorites** — Pin frequently used currencies
- 🔍 **Search & sort** — By category (major/metals/other), price, change
- 🌓 **Themes** — Light, dark, and system modes
- 🌐 **Trilingual** — Uzbek (Latin/Cyrillic), Russian, English
- 📴 **Offline mode** — Works without internet via SharedPreferences cache
- ♿ **Accessibility** — Supports "reduce motion" and screen readers
- 🚫 **Ad-free mode** — Temporarily enabled via rewarded ads

## Screens

Three main tabs:
- **Rates** — currency list, search, sort, detail screen (with chart)
- **Calculator** — two-currency conversion
- **Settings** — language, theme, ad-free mode, developer info

## Tech Stack

| Layer | Package/Technology |
|---|---|
| State management | `provider` |
| HTTP | `http` |
| Charts | `fl_chart` |
| Local storage | `shared_preferences` |
| Typography | `google_fonts` (Inter, Rubik) |
| Formatting | `intl` |
| Ads | `google_mobile_ads` |
| Loading animation | `shimmer` |
| Localization | `flutter_localizations` + ARB files |

## Architecture

Clean Architecture, 3 layers:

```
lib/
├── core/           # Constants, theme, utilities, exceptions
├── data/           # Models, services (CBU API, cache), repository
├── presentation/   # Screens, widgets, providers
├── l10n/           # ARB files (uz, uz_Cyrl, ru, en)
├── main.dart       # DI setup
└── app.dart        # MaterialApp + bottom navigation
```

**Data flow:** Screen → Provider → Repository → (API or Cache). Repository tries API first, falls back to cache on failure.

**Caching strategy:**
- Today's rates — date-based, one API call per day
- History — by currency code + day count
- Auto-refresh — on app resume (if 5+ minutes elapsed)

Details: [CLAUDE.md](CLAUDE.md) and [AGENTS.md](AGENTS.md)

## Getting Started

### Requirements

- Flutter SDK 3.10.7+
- Dart 3.x
- Android Studio / VS Code
- Android SDK (API 21+)

### Installation

```bash
git clone https://github.com/MuhammadMirrr/Somchi.git
cd Somchi
flutter pub get
flutter run
```

### Release Build

**Keystore setup:**

Create `android/key.properties` (not committed):

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=somchi
storeFile=somchi-release.jks
```

Place `somchi-release.jks` keystore in `android/app/`.

**Build:**

```bash
# Play Store App Bundle
flutter build appbundle --release

# APK
flutter build apk --release
```

## Scripts

```bash
flutter pub get          # Install dependencies
flutter run              # Run in debug mode
flutter analyze          # Static analysis
flutter test             # Run tests
flutter clean            # Clean build artifacts
```

## API

Uses the CBU official API:
- Today's rates: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/`
- History: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/{CODE}/{YYYY-MM-DD}/`

No API key required — public.

## Security

- 🔒 HTTPS-only (`network_security_config.xml`)
- 🔐 ProGuard + R8 minification (release)
- 🚫 Keystore files excluded from git (`android/.gitignore`)

## Status

- Version: **1.2.0** (build 3)
- Platform: Android (web/windows scaffold available, not primary)
- Status: In production, on Play Store

## License

Licensed under the [MIT License](LICENSE). See the [LICENSE](LICENSE) file for details.

## Developer

**Muhammad Mirqobilov**
- Telegram: [@mirqobilov_mm](https://t.me/mirqobilov_mm)
- LinkedIn: [muhammad-mirqobilov](https://www.linkedin.com/in/muhammad-mirqobilov-97056034b/)
- Email: muhammadmirqobilov@gmail.com
