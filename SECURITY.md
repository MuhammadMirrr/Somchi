# Xavfsizlik siyosati

## Qo'llab-quvvatlanayotgan versiyalar

Xavfsizlik yangilanishlari quyidagi versiyalarga tarqatiladi:

| Versiya | Qo'llab-quvvatlanadi |
|---------|---------------------|
| 1.2.x   | ✅ Ha                |
| 1.1.x   | ⚠️ Faqat kritik      |
| < 1.1   | ❌ Yo'q              |

## Xavfsizlik nuqsonini xabar berish

Somchi'da xavfsizlik zaifligini topganingizdan **minnatdorchilik** bildiramiz.

### ⚠️ MUHIM: Umumiy issue ochmang

Xavfsizlik nuqsoni haqida **GitHub Issue** ochmang, chunki bu muammoni foydalanuvchilar yangilash imkoniyati bo'lmasdan omma joyga chiqaradi.

### To'g'ri usul

Xavfsizlik muammolarini quyidagi kanallar orqali shaxsiy ravishda xabar bering:

**📧 Email:** muhammadmirqobilov@gmail.com
**📱 Telegram:** [@mirqobilov_mm](https://t.me/mirqobilov_mm)

Yoki GitHub'ning [Private Vulnerability Reporting](https://github.com/MuhammadMirrr/Somchi/security/advisories/new) tizimidan foydalaning (repo'da yoqilgan bo'lsa).

### Xabarda nima yozish kerak

Iltimos, quyidagi ma'lumotlarni kiriting:

1. **Zaiflik turi** — masalan: ma'lumotlar oqib chiqishi, autentifikatsiya chetlab o'tilishi, XSS va h.k.
2. **Ta'sirlangan komponent** — qaysi fayl, funksiya yoki ekran
3. **Ta'sir darajasi** — nima noto'g'ri ketishi mumkin
4. **Qayta tiklash qadamlari** — aniq, qadamma-qadam
5. **Proof-of-Concept** (iloji bo'lsa) — skrinshot, video, kod
6. **Tuzatish taklifi** (iloji bo'lsa)
7. **Sizning aloqangiz** — sizga minnatdorchilik bildirishimiz yoki CVE uchun

## Javob vaqti

| Bosqich | Muddat |
|---------|--------|
| Dastlabki javob | 48 soat ichida |
| Nuqsonni tasdiqlash | 7 kun ichida |
| Patch chiqarish (high/critical) | 30 kun ichida |
| Patch chiqarish (medium/low) | Keyingi kichik reliz |
| Ommaviy oshkorlash | Patch chiqqandan keyin 7 kun |

## Nima xavfsizlik zaifligi hisoblanadi?

### ✅ Qabul qilamiz

- Foydalanuvchi ma'lumotlari oqib chiqishi (SharedPreferences, kesh)
- Man-in-the-middle hujumlar (noto'g'ri HTTPS konfiguratsiyasi)
- Buzilgan shifrlash yoki hashing
- Autentifikatsiya/avtorizatsiya chetlab o'tilishi
- Remote code execution
- Denial of service zaifliklari
- Ma'lumotlarni olish/manipulyatsiya qilish

### ❌ Qabul qilmaymiz

- Ijtimoiy muhandislik hujumlari
- Jismoniy hujumlar (qurilma o'g'irlash)
- Foydalanuvchining o'z qurilmasidagi "ildiz" / "jailbreak" holatlari
- Shartli bo'lmagan best-practice taklifi (aniq zaiflik bo'lmasa)
- Eski, allaqachon tuzatilgan zaifliklar

## Xavfsizlik amaliyotlarimiz

- 🔒 **HTTPS-only** — barcha tarmoq so'rovlari TLS orqali (`network_security_config.xml`)
- 🔐 **ProGuard + R8** — release build'lar obfuscate qilinadi
- 🔑 **Keystore** — signing kalitlari hech qachon git'da saqlanmaydi (`android/.gitignore`)
- 📦 **Minimal ruxsatlar** — ilovada faqat `INTERNET` ruxsati so'raladi
- 🔄 **Bog'liqliklar** — muntazam yangilab turiladi

## Minnatdorchilik

Xavfsizlik nuqsonlarini xabar qilgan tadqiqotchilarni CHANGELOG.md va release notes'da (ruxsat bilan) tan olamiz.

Rahmat! 🙏
