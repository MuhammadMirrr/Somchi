import 'package:flutter/material.dart';
import '../../data/repositories/currency_repository.dart';

/// Til tanlovi: 0=uz (lotin), 1=uz_Cyrl, 2=ru, 3=en
class LanguageProvider extends ChangeNotifier {
  final CurrencyRepository _repository;
  int _languageIndex;

  LanguageProvider(this._repository, {int? initialLanguageIndex})
      : _languageIndex = initialLanguageIndex ?? 0;

  int get languageIndex => _languageIndex;

  Locale get locale {
    switch (_languageIndex) {
      case 1:
        return const Locale.fromSubtags(
          languageCode: 'uz',
          scriptCode: 'Cyrl',
        );
      case 2:
        return const Locale('ru');
      case 3:
        return const Locale('en');
      default:
        return const Locale('uz');
    }
  }

  Future<void> setLanguage(int index) async {
    if (index == _languageIndex) return;
    _languageIndex = index;
    await _repository.saveLanguageIndex(index);
    notifyListeners();
  }
}
