import 'package:flutter/material.dart';
import '../../data/repositories/currency_repository.dart';

class ThemeProvider extends ChangeNotifier {
  final CurrencyRepository _repository;

  ThemeProvider(this._repository, {int? initialThemeMode})
      : _themeModeIndex = initialThemeMode ?? 0;

  int _themeModeIndex; // 0=system, 1=light, 2=dark

  ThemeMode get themeMode {
    switch (_themeModeIndex) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  int get themeModeIndex => _themeModeIndex;

  Future<void> setThemeMode(int index) async {
    _themeModeIndex = index;
    await _repository.saveThemeMode(index);
    notifyListeners();
  }
}
