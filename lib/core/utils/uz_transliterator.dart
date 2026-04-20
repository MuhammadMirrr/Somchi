/// O'zbek lotin alifbosidan kirill alifbosiga transliteratsiya.
///
/// CBU API faqat lotin alifbosida o'zbek nomlarini beradi.
/// Kirill versiyasi uchun oddiy harf-harf ko'chirish yordamida nomlar
/// hosil qilinadi. Qo'lda tarjima topilmagan hollarda fallback sifatida
/// ishlatiladi.
class UzTransliterator {
  UzTransliterator._();

  /// Multigraph'lar (uzunroq birikmalar oldin tekshiriladi).
  static const List<MapEntry<String, String>> _multigraphs = [
    MapEntry("o'", 'ў'),
    MapEntry("O'", 'Ў'),
    MapEntry("g'", 'ғ'),
    MapEntry("G'", 'Ғ'),
    MapEntry('sh', 'ш'),
    MapEntry('Sh', 'Ш'),
    MapEntry('SH', 'Ш'),
    MapEntry('ch', 'ч'),
    MapEntry('Ch', 'Ч'),
    MapEntry('CH', 'Ч'),
    MapEntry('ng', 'нг'),
    MapEntry('Ng', 'Нг'),
    MapEntry('NG', 'НГ'),
    MapEntry('yo', 'ё'),
    MapEntry('Yo', 'Ё'),
    MapEntry('YO', 'Ё'),
    MapEntry('yu', 'ю'),
    MapEntry('Yu', 'Ю'),
    MapEntry('YU', 'Ю'),
    MapEntry('ya', 'я'),
    MapEntry('Ya', 'Я'),
    MapEntry('YA', 'Я'),
    MapEntry('ye', 'е'),
    MapEntry('Ye', 'Е'),
    MapEntry('YE', 'Е'),
    MapEntry('ts', 'ц'),
    MapEntry('Ts', 'Ц'),
  ];

  /// Bitta harflar.
  static const Map<String, String> _singleChars = {
    'a': 'а', 'A': 'А',
    'b': 'б', 'B': 'Б',
    'c': 'с', 'C': 'С',
    'd': 'д', 'D': 'Д',
    'e': 'е', 'E': 'Е',
    'f': 'ф', 'F': 'Ф',
    'g': 'г', 'G': 'Г',
    'h': 'ҳ', 'H': 'Ҳ',
    'i': 'и', 'I': 'И',
    'j': 'ж', 'J': 'Ж',
    'k': 'к', 'K': 'К',
    'l': 'л', 'L': 'Л',
    'm': 'м', 'M': 'М',
    'n': 'н', 'N': 'Н',
    'o': 'о', 'O': 'О',
    'p': 'п', 'P': 'П',
    'q': 'қ', 'Q': 'Қ',
    'r': 'р', 'R': 'Р',
    's': 'с', 'S': 'С',
    't': 'т', 'T': 'Т',
    'u': 'у', 'U': 'У',
    'v': 'в', 'V': 'В',
    'w': 'в', 'W': 'В',
    'x': 'х', 'X': 'Х',
    'y': 'й', 'Y': 'Й',
    'z': 'з', 'Z': 'З',
    "'": 'ъ',
    'ʻ': 'ъ',
  };

  /// Lotin matnni kirillga o'tkazish.
  static String toCyrillic(String latin) {
    if (latin.isEmpty) return latin;

    final buffer = StringBuffer();
    int i = 0;
    while (i < latin.length) {
      // Multigraph'ni tekshirib ko'ramiz
      bool matched = false;
      for (final entry in _multigraphs) {
        if (latin.startsWith(entry.key, i)) {
          buffer.write(entry.value);
          i += entry.key.length;
          matched = true;
          break;
        }
      }
      if (matched) continue;

      // Bitta harf
      final ch = latin[i];
      buffer.write(_singleChars[ch] ?? ch);
      i++;
    }

    return buffer.toString();
  }
}
