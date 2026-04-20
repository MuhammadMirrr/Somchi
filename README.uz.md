# Somchi — Valyuta kurslari

**🌐 Tillar:** [English](README.md) · [O'zbek](README.uz.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

O'zbekiston Markaziy Banki (CBU) rasmiy valyuta kurslari uchun Flutter ilovasi. Asosiy platforma — Android.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)
![Version](https://img.shields.io/badge/version-1.2.0-blue)

## Xususiyatlar

- 💱 **Real vaqtli kurslar** — CBU rasmiy API'sidan har kuni yangilanadigan kurslar
- 📊 **Kurs tarixi grafigi** — har bir valyuta uchun kurs o'zgarish tarixi (`fl_chart`)
- 🧮 **Kalkulyator** — UZS orqali valyutalar o'rtasida konvertatsiya
- ⭐ **Sevimlilar** — tez-tez ishlatiladigan valyutalarni belgilash
- 🔍 **Qidiruv va saralash** — kategoriya (asosiy/metall/boshqa), narx, o'zgarish bo'yicha
- 🌓 **Mavzular** — yorug', qorong'i va tizim rejimlari
- 🌐 **Uch til** — O'zbek (Lotin/Kirill), Rus, Ingliz
- 📴 **Offline rejim** — SharedPreferences orqali keshlash, internetsiz ham ishlaydi
- ♿ **Accessibility** — "reduce motion" va screen reader qo'llab-quvvatlovchi
- 🚫 **Reklamasiz rejim** — rewarded ads orqali vaqtincha yoqish

## Ekranlar

Ilovada uchta asosiy tab:
- **Kurslar** — valyutalar ro'yxati, qidiruv, saralash, detal ekrani (grafik bilan)
- **Hisoblash** — ikki valyuta orasida konvertatsiya
- **Sozlamalar** — til, mavzu, reklamasiz rejim, dasturchi ma'lumotlari

## Texnologik stack

| Qatlam | Paket/Texnologiya |
|---|---|
| State management | `provider` |
| HTTP | `http` |
| Grafiklar | `fl_chart` |
| Lokal saqlash | `shared_preferences` |
| Typography | `google_fonts` (Inter, Rubik) |
| Formatlash | `intl` |
| Reklama | `google_mobile_ads` |
| Loading animatsiya | `shimmer` |
| Lokalizatsiya | `flutter_localizations` + ARB fayllar |

## Arxitektura

Clean Architecture, 3 qatlam:

```
lib/
├── core/           # Konstantlar, mavzu, utilitalar, exception'lar
├── data/           # Modellar, servislar (CBU API, cache), repozitoriy
├── presentation/   # Screen'lar, widget'lar, provider'lar
├── l10n/           # ARB fayllar (uz, uz_Cyrl, ru, en)
├── main.dart       # DI setup
└── app.dart        # MaterialApp + bottom navigation
```

**Ma'lumot oqimi:** Screen → Provider → Repository → (API yoki Cache). Repository avval API'ga urinadi, muvaffaqiyatsizlikda keshga qaytadi.

**Keshlash strategiyasi:**
- Bugungi kurslar — sana asosida, kuniga bir marta API chaqiruvi
- Tarix — valyuta kodi + kunlar soni bo'yicha
- Avtomatik yangilash — ilova ochilganda (5+ daqiqa o'tgan bo'lsa)

Batafsil: [CLAUDE.md](CLAUDE.md) va [AGENTS.md](AGENTS.md)

## Boshlash

### Talablar

- Flutter SDK 3.10.7+
- Dart 3.x
- Android Studio / VS Code
- Android SDK (API 21+)

### O'rnatish

```bash
git clone https://github.com/MuhammadMirrr/Somchi.git
cd Somchi
flutter pub get
flutter run
```

### Release build

**Keystore sozlash:**

`android/key.properties` fayli yarating (git'ga commit qilinmaydi):

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=somchi
storeFile=somchi-release.jks
```

Va `android/app/` papkaga `somchi-release.jks` keystore faylini joylashtiring.

**Build:**

```bash
# Play Store uchun App Bundle
flutter build appbundle --release

# APK
flutter build apk --release
```

## Skriptlar

```bash
flutter pub get          # Bog'liqliklarni o'rnatish
flutter run              # Debug rejimda ishga tushirish
flutter analyze          # Statik tahlil
flutter test             # Testlarni ishga tushirish
flutter clean            # Build artefaktlarni tozalash
```

## API

Ilova CBU rasmiy API'sidan foydalanadi:
- Bugungi kurslar: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/`
- Tarix: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/{CODE}/{YYYY-MM-DD}/`

API kalitga ehtiyoj yo'q — ochiq.

## Xavfsizlik

- 🔒 HTTPS-only (`network_security_config.xml`)
- 🔐 ProGuard + R8 minifikatsiya (release)
- 🚫 Keystore fayllari git'ga tushmaydi (`android/.gitignore`)

## Loyiha holati

- Versiya: **1.2.0** (build 3)
- Platform: Android (web/windows scaffold mavjud, asosiy emas)
- Holat: Ishlab chiqarishda, Play Store'da

## Litsenziya

[MIT Litsenziya](LICENSE) ostida taqdim etilgan. Batafsil [LICENSE](LICENSE) faylida.

## Dasturchi

**Muhammad Mirqobilov**
- Telegram: [@mirqobilov_mm](https://t.me/mirqobilov_mm)
- LinkedIn: [muhammad-mirqobilov](https://www.linkedin.com/in/muhammad-mirqobilov-97056034b/)
- Email: muhammadmirqobilov@gmail.com
