<div dir="rtl">

# Somchi — أسعار الصرف

**🌐 اللغات:** [English](README.md) · [O'zbek](README.uz.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

تطبيق Flutter لأسعار الصرف الرسمية للبنك المركزي لأوزبكستان (CBU). المنصة الأساسية — أندرويد.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)
![Version](https://img.shields.io/badge/version-1.2.0-blue)

## الميزات

- 💱 **أسعار آنية** — أسعار يومية محدّثة من واجهة برمجة التطبيقات الرسمية للبنك المركزي
- 📊 **مخطط تاريخ السعر** — بيانات تاريخية لكل عملة (`fl_chart`)
- 🧮 **آلة حاسبة** — تحويل بين العملات عبر الـ UZS
- ⭐ **المفضلة** — تثبيت العملات المستخدمة بكثرة
- 🔍 **البحث والفرز** — حسب الفئة (رئيسية/معادن/أخرى) والسعر والتغير
- 🌓 **السمات** — فاتح، داكن، ووضع النظام
- 🌐 **ثلاث لغات** — الأوزبكية (لاتيني/سيريلي)، الروسية، الإنجليزية
- 📴 **وضع بدون إنترنت** — يعمل عبر التخزين المحلي (SharedPreferences)
- ♿ **إمكانية الوصول** — يدعم "تقليل الحركة" وقارئات الشاشة
- 🚫 **وضع بدون إعلانات** — تفعيل مؤقت عبر إعلانات مكافأة

## الشاشات

ثلاث علامات تبويب رئيسية:
- **الأسعار** — قائمة العملات، البحث، الفرز، شاشة التفاصيل (مع المخطط)
- **الآلة الحاسبة** — تحويل بين عملتين
- **الإعدادات** — اللغة، السمة، وضع بدون إعلانات، معلومات المطوّر

## التقنيات

| الطبقة | الحزمة/التقنية |
|---|---|
| إدارة الحالة | `provider` |
| HTTP | `http` |
| المخططات | `fl_chart` |
| التخزين المحلي | `shared_preferences` |
| الخطوط | `google_fonts` (Inter, Rubik) |
| التنسيق | `intl` |
| الإعلانات | `google_mobile_ads` |
| رسوم التحميل | `shimmer` |
| التعريب | `flutter_localizations` + ملفات ARB |

## البنية

Clean Architecture، ثلاث طبقات:

```
lib/
├── core/           # الثوابت، السمات، الأدوات، الاستثناءات
├── data/           # النماذج، الخدمات (CBU API, cache)، المستودع
├── presentation/   # الشاشات، الودجات، مزوّدو الحالة
├── l10n/           # ملفات ARB (uz, uz_Cyrl, ru, en)
├── main.dart       # إعداد الـ DI
└── app.dart        # MaterialApp + التنقل السفلي
```

**تدفّق البيانات:** Screen ← Provider ← Repository ← (API أو Cache). يحاول المستودع الوصول إلى الـ API أولًا، ثم يعود إلى الذاكرة المؤقتة عند الفشل.

**استراتيجية التخزين المؤقت:**
- أسعار اليوم — حسب التاريخ، مكالمة واحدة يوميًا للـ API
- التاريخ — حسب رمز العملة + عدد الأيام
- التحديث التلقائي — عند استئناف التطبيق (بعد 5+ دقائق)

التفاصيل: [CLAUDE.md](CLAUDE.md) و [AGENTS.md](AGENTS.md)

## البدء

### المتطلبات

- Flutter SDK 3.10.7+
- Dart 3.x
- Android Studio / VS Code
- Android SDK (API 21+)

### التثبيت

```bash
git clone https://github.com/MuhammadMirrr/Somchi.git
cd Somchi
flutter pub get
flutter run
```

### بناء الإصدار

**إعداد الـ keystore:**

أنشئ ملف `android/key.properties` (لا يُرفع إلى git):

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=somchi
storeFile=somchi-release.jks
```

ضع `somchi-release.jks` في `android/app/`.

**البناء:**

```bash
# App Bundle لـ Play Store
flutter build appbundle --release

# APK
flutter build apk --release
```

## الأوامر

```bash
flutter pub get          # تثبيت الاعتماديات
flutter run              # التشغيل في وضع التصحيح
flutter analyze          # التحليل الساكن
flutter test             # تشغيل الاختبارات
flutter clean            # تنظيف ملفات البناء
```

## واجهة برمجة التطبيقات

يستخدم التطبيق الـ API الرسمي للبنك المركزي:
- أسعار اليوم: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/`
- التاريخ: `https://cbu.uz/uz/arkhiv-kursov-valyut/json/{CODE}/{YYYY-MM-DD}/`

لا حاجة لمفتاح API — عامّ.

## الأمان

- 🔒 HTTPS فقط (`network_security_config.xml`)
- 🔐 ProGuard + R8 minification (release)
- 🚫 ملفات الـ keystore مستثناة من git (`android/.gitignore`)

## الحالة

- الإصدار: **1.2.0** (build 3)
- المنصة: Android (هيكل web/windows متوفر، ليس الأساس)
- الحالة: في الإنتاج، على Play Store

## الترخيص

مُرخَّص تحت [رخصة MIT](LICENSE). انظر ملف [LICENSE](LICENSE) للتفاصيل.

## المطوّر

**Muhammad Mirqobilov**
- Telegram: [@mirqobilov_mm](https://t.me/mirqobilov_mm)
- LinkedIn: [muhammad-mirqobilov](https://www.linkedin.com/in/muhammad-mirqobilov-97056034b/)
- Email: muhammadmirqobilov@gmail.com

</div>
