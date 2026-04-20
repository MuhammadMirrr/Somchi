import 'package:flutter/widgets.dart';
import '../../core/utils/uz_transliterator.dart';
import '../../l10n/app_localizations.dart';

class Currency {
  final int id;
  final String code;
  final String numericCode;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final int nominal;
  final double rate;
  final double diff;
  final String date;

  Currency({
    required this.id,
    required this.code,
    required this.numericCode,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.nominal,
    required this.rate,
    required this.diff,
    required this.date,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: _parseInt(json['id']) ?? 0,
      code: (json['Ccy'] as String?) ?? '',
      numericCode: (json['Code'] as String?) ?? '',
      nameUz: (json['CcyNm_UZ'] as String?) ?? '',
      nameRu: (json['CcyNm_RU'] as String?) ?? '',
      nameEn: (json['CcyNm_EN'] as String?) ?? '',
      nominal: _parseInt(json['Nominal']) ?? 1,
      rate: _parseDouble(json['Rate']) ?? 0.0,
      diff: _parseDouble(json['Diff']) ?? 0.0,
      date: (json['Date'] as String?) ?? '',
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Ccy': code,
      'Code': numericCode,
      'CcyNm_UZ': nameUz,
      'CcyNm_RU': nameRu,
      'CcyNm_EN': nameEn,
      'Nominal': nominal.toString(),
      'Rate': rate.toString(),
      'Diff': diff.toString(),
      'Date': date,
    };
  }

  /// 1 birlik uchun kurs (nominal hisobga olingan)
  double get ratePerUnit => nominal == 0 ? 0.0 : rate / nominal;

  /// Kurs oshganmi
  bool get isPositive => diff >= 0;

  /// Kechagiga nisbatan foizdagi o'zgarish
  double get diffPercent {
    final previousRate = rate - diff;
    if (previousRate.abs() < 0.0001) return 0.0;
    return (diff / previousRate) * 100;
  }
}

extension CurrencyLocalization on Currency {
  /// Joriy lokalga mos valyuta nomi.
  ///
  /// Tartib:
  /// 1. `.arb` faylidagi qo'lda yozilgan tarjima (asosiy valyutalar)
  /// 2. Fallback: ru/en uchun API'dan, kirill uchun transliteratsiya, lotin uchun nameUz
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final manual = _manualTranslation(l10n, code);
    if (manual != null) return manual;

    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'ru') return nameRu.isNotEmpty ? nameRu : nameUz;
    if (locale.languageCode == 'en') return nameEn.isNotEmpty ? nameEn : nameUz;
    if (locale.scriptCode == 'Cyrl') return UzTransliterator.toCyrillic(nameUz);
    return nameUz;
  }
}

String? _manualTranslation(AppLocalizations l10n, String code) {
  switch (code) {
    case 'USD':
      return l10n.currencyUSD;
    case 'EUR':
      return l10n.currencyEUR;
    case 'RUB':
      return l10n.currencyRUB;
    case 'GBP':
      return l10n.currencyGBP;
    case 'JPY':
      return l10n.currencyJPY;
    case 'CHF':
      return l10n.currencyCHF;
    case 'CNY':
      return l10n.currencyCNY;
    case 'KRW':
      return l10n.currencyKRW;
    case 'AED':
      return l10n.currencyAED;
    case 'XAU':
      return l10n.currencyXAU;
    case 'XAG':
      return l10n.currencyXAG;
    case 'XPT':
      return l10n.currencyXPT;
    case 'XPD':
      return l10n.currencyXPD;
    case 'UZS':
      return l10n.currencyUZS;
  }
  return null;
}
