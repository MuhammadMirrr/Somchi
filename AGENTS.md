# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project Overview

Somchi — O'zbekiston Markaziy Banki (CBU) valyuta kurslari ilovasi. Flutter (Dart) da yozilgan, Android platformasi uchun mo'ljallangan (web/windows scaffolding mavjud lekin asosiy target Android).

## Common Commands

```bash
# Dependencies
flutter pub get

# Run (debug)
flutter run

# Build release AAB (Play Store)
flutter build appbundle --release

# Build APK
flutter build apk

# Analyze
flutter analyze

# Run all tests
flutter test

# Run single test
flutter test test/widget_test.dart

# Clean build
flutter clean && flutter pub get
```

## Architecture

Clean Architecture with Provider state management. Three layers:

**Data Layer** (`lib/data/`)
- `services/cbu_api_service.dart` — HTTP client for CBU API (`cbu.uz/uz/arkhiv-kursov-valyut/json`). Throws `NetworkException` or `ApiException` on failure.
- `services/cache_service.dart` — SharedPreferences wrapper for offline caching and user preferences
- `repositories/currency_repository.dart` — Orchestrates API and cache with automatic fallback (API fails -> cached data). Exposes `lastFetchError` for error type distinction.
- `models/` — `Currency` and `RateHistory` with JSON serialization

**Presentation Layer** (`lib/presentation/`)
- `providers/currency_provider.dart` — Main state: rates, search/filter, sort (`SortType` enum), category filter (`CurrencyCategory` enum), favorites, history
- `providers/theme_provider.dart` — Light/dark/system theme
- `providers/calculator_provider.dart` — Currency conversion logic (UZS as base)
- `screens/` — HomeScreen, CalculatorScreen, SettingsScreen, CurrencyDetailScreen, SplashScreen
- `widgets/` — Reusable UI components (HeroCurrencyCard, CurrencyListItem, CurrencyHistoryChart, AnimatedRate, SegmentedControl, ShimmerLoading, etc.)

**Core Layer** (`lib/core/`)
- `constants/app_constants.dart` — API URL, SharedPreferences keys, default favorites, currency emoji flags, AdMob IDs, spacing/sizing tokens, `majorCurrencies` and `metalCurrencies` category lists
- `theme/` — AppTheme and AppColors definitions (light + dark)
- `utils/number_formatter.dart` — Number formatting helpers
- `utils/exceptions.dart` — `NetworkException` and `ApiException` custom exceptions

**Entry points:**
- `main.dart` — DI setup: creates services -> repository -> providers via MultiProvider
- `app.dart` — MaterialApp config + bottom navigation (IndexedStack with 3 tabs: Kurslar, Hisoblash, Sozlamalar). Handles auto-refresh on app resume with snackbar notification.

## Data Flow

Screens consume Providers via `Consumer` widgets -> Providers call CurrencyRepository -> Repository tries CbuApiService first, falls back to CacheService on failure. Error types (`NetworkException` vs `ApiException`) propagate to the UI for distinct error messages.

## Filtering & Sorting

`CurrencyProvider.filteredRates` applies a 3-step pipeline: category filter (`CurrencyCategory`) -> search query filter -> sort (`SortType`). Categories are defined via `AppConstants.majorCurrencies` and `AppConstants.metalCurrencies`; everything else is "minor".

## Caching Strategy

- **Today's rates**: cached via SharedPreferences with date-based validity (`isRatesCacheValid()`). API is called once per day; subsequent loads use cache unless `forceRefresh: true`.
- **History data**: cached per currency code + day count with date prefix keys (`history_{code}_{days}`, `history_date_{code}_{days}`). Falls back to expired cache if API fails.
- **Auto-refresh**: `app.dart` triggers `refreshRates()` on app resume if last update was 5+ minutes ago.
- **Last updated display**: Shows "Bugun, HH:mm" / "Kecha, HH:mm" / "dd.MM.yyyy, HH:mm" depending on age.

## Calculator Conversion Model

All conversions go through UZS as the intermediary: `source -> UZS -> target`. UZS itself is represented as `rate: 1, nominal: 1`. The `nominal` field matters — some currencies (e.g., KRW, VND) have nominal > 1 (rate is per 100 or 1000 units).

## CBU API JSON Field Mapping

The CBU API returns non-standard field names that are mapped in `Currency.fromJson`:
- `Ccy` -> code, `CcyNm_UZ/RU/EN` -> localized names, `Nominal` -> nominal, `Rate` -> rate, `Diff` -> daily change
- All values come as strings from the API and are parsed with null-safe helpers (`_parseInt`, `_parseDouble`)

## Accessibility

All animations respect `MediaQuery.of(context).disableAnimations`. When the device has "reduce motion" enabled, animations skip to their final state (Duration.zero or immediate value). This is implemented across: AnimatedRate, HeroCurrencyCard, CurrencyListItem, SegmentedControl, SplashScreen, HomeScreen staggered items, CalculatorScreen swap animation, and ShimmerLoading.

## Release Build

- **Keystore**: `android/app/somchi-release.jks` (signing config loaded from `android/key.properties`, gitignored)
- **ProGuard**: `android/app/proguard-rules.pro` with rules for Flutter, AdMob, and Play Core
- **R8 minification**: enabled in release build (`isMinifyEnabled = true`, `isShrinkResources = true`)
- **Network security**: `android/app/src/main/res/xml/network_security_config.xml` enforces HTTPS-only

## Key Dependencies

- `provider` — State management
- `http` — Network requests
- `fl_chart` — Charts/graphs
- `shared_preferences` — Local persistence
- `google_fonts` — Typography (Inter for UI, Rubik for logo)
- `intl` — Date/number formatting
- `google_mobile_ads` — AdMob integration
- `shimmer` — Loading skeleton animations

## Language

App UI is in Uzbek. Currency names exist in three locales (UZ, RU, EN) from the CBU API.
