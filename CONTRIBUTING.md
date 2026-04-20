# Somchi loyihasiga hissa qo'shish

Rahmat! Somchi'ga hissa qo'shish niyatingiz uchun minnatdormiz. Quyidagi qoidalar loyihani sog'lom saqlash uchun.

## Ishni boshlashdan oldin

1. [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) bilan tanishing
2. Issue'ni ochish yoki mavjud issue'ni tanlash — katta o'zgarishlardan oldin
3. `main` branchdan fork qiling

## Rivojlantirish muhiti

```bash
# Fork'dan klonlash
git clone https://github.com/YOUR_USERNAME/Somchi.git
cd Somchi

# Bog'liqliklar
flutter pub get

# Debug rejimda ishga tushirish
flutter run
```

**Talablar:**
- Flutter SDK 3.10.7+
- Dart 3.x
- Android SDK (API 21+)

## Hissa turi

### 🐛 Bug hisoboti

Bug topdingizmi? [Issue yarating](https://github.com/MuhammadMirrr/Somchi/issues/new?labels=bug) va kiriting:
- Bug qanday yuz beradi (qadamma-qadam)
- Kutilgan natija vs haqiqiy natija
- Qurilma/Android versiyasi
- Ilova versiyasi (Settings ekranidan)
- Skrinshot yoki video (iloji bo'lsa)

### ✨ Yangi funksiya

Yangi funksiya taklifi? Avval [Issue yarating](https://github.com/MuhammadMirrr/Somchi/issues/new?labels=enhancement) va muhokama qiling — PR yozishdan avval hamfikirlik muhim.

### 📝 Hujjatlar

Hujjatlardagi xatolar, noaniqliklar yoki tarjimalar (uz, ru, en, ar) — PR yuboring, issue shart emas.

## PR jarayoni

1. **Branch yarating:** `git checkout -b feat/new-feature` yoki `fix/bug-name`
2. **Kod yozing** — quyidagi qoidalarga amal qiling
3. **Analyze ishga tushiring:** `flutter analyze` — ogohlantirishlarsiz bo'lishi kerak
4. **Testlar:** `flutter test` — barchasi o'tsin
5. **Commit:** qisqa, aniq xabar (inglizcha yoki o'zbekcha)
6. **PR oching** — [shablonga](.github/PULL_REQUEST_TEMPLATE.md) amal qiling

### Commit xabarlari

Conventional Commits standartidan foydalanish tavsiya etiladi:

```
feat: add currency filter by region
fix: calculator crash on zero input
docs: update README installation steps
refactor: simplify rate caching logic
test: add widget tests for calculator
chore: bump Flutter SDK to 3.11
```

## Kod qoidalari

### Dart/Flutter uslubi

- `analysis_options.yaml` qoidalariga amal qiling (flutter_lints)
- `flutter analyze` — xatosiz bo'lishi shart
- Formatlash: `dart format .` (yoki IDE avtoformatti)

### Arxitektura

Clean Architecture ga rioya qiling:
- **Core** — konstantalar, mavzu, utilitalar
- **Data** — modellar, API, kesh, repozitoriy
- **Presentation** — ekranlar, widgetlar, provider'lar

State management — `provider` paketi orqali.

### Nomlash

- Dart: `lowerCamelCase` (o'zgaruvchilar), `UpperCamelCase` (klasslar), `snake_case` (fayllar)
- String kalitlar — `AppConstants`'da markazlashtirilgan
- Widget'lar — ishlatiladigan o'rniga yaqin joylashtirilsin

### Lokalizatsiya

Yangi matn qo'shayotganingizda `lib/l10n/app_uz.arb` dan boshlang, keyin ARB fayllarida boshqa tillarga tarjima qiling (`uz_Cyrl`, `ru`, `en`).

## Xavfsizlik

- API kalitlar, paroliar, `.jks` fayllar hech qachon commit qilinmasligi kerak
- `android/key.properties` va `android/app/*.jks` — `.gitignore`'da
- Xavfsizlik nuqsonlarini [SECURITY.md](SECURITY.md) orqali xabar bering, issue emas

## Savol-javob

Savollar uchun:
- Telegram: [@mirqobilov_mm](https://t.me/mirqobilov_mm)
- Email: muhammadmirqobilov@gmail.com
- Yoki [Discussions](https://github.com/MuhammadMirrr/Somchi/discussions) (agar yoqilgan bo'lsa)

Yana bir bor rahmat! 🙏
