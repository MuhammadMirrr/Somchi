import 'package:flutter/foundation.dart';
import '../../data/models/currency.dart';

class CalculatorProvider extends ChangeNotifier {
  List<Currency> _rates = [];

  String _sourceCurrency = 'USD';
  String _targetCurrency = 'UZS';
  String _sourceAmount = '';
  String _targetAmount = '';
  bool _isSourceEditing = true;
  bool _hasConversionError = false;

  String get sourceCurrency => _sourceCurrency;
  String get targetCurrency => _targetCurrency;
  String get sourceAmount => _sourceAmount;
  String get targetAmount => _targetAmount;
  bool get hasConversionError => _hasConversionError;

  void setRates(List<Currency> rates) {
    if (rates.isEmpty) return;
    if (_rates.length == rates.length && _rates.isNotEmpty) {
      bool hasChanges = false;
      for (int i = 0; i < rates.length; i++) {
        if (_rates[i].rate != rates[i].rate ||
            _rates[i].code != rates[i].code) {
          hasChanges = true;
          break;
        }
      }
      if (!hasChanges) return;
    }
    _rates = rates;
    _recalculate();
    notifyListeners();
  }

  void setSourceCurrency(String code) {
    if (code == _sourceCurrency) return;
    _sourceCurrency = code;
    _recalculate();
    notifyListeners();
  }

  void setTargetCurrency(String code) {
    if (code == _targetCurrency) return;
    _targetCurrency = code;
    _recalculate();
    notifyListeners();
  }

  void setSourceAmount(String amount) {
    _sourceAmount = _sanitizeInput(amount);
    _isSourceEditing = true;
    _recalculate();
    notifyListeners();
  }

  void setTargetAmount(String amount) {
    _targetAmount = _sanitizeInput(amount);
    _isSourceEditing = false;
    _recalculate();
    notifyListeners();
  }

  void swap() {
    final temp = _sourceCurrency;
    _sourceCurrency = _targetCurrency;
    _targetCurrency = temp;

    final tempAmount = _sourceAmount;
    _sourceAmount = _targetAmount;
    _targetAmount = tempAmount;

    _isSourceEditing = !_isSourceEditing;
    _recalculate();
    notifyListeners();
  }

  String _sanitizeInput(String input) {
    if (input.isEmpty) return input;
    var sanitized = input.replaceAll(RegExp(r'[^0-9.]'), '');
    // Allow only one decimal point — keep the first, discard the rest
    final dotIndex = sanitized.indexOf('.');
    if (dotIndex != -1) {
      sanitized = sanitized.substring(0, dotIndex + 1) +
          sanitized.substring(dotIndex + 1).replaceAll('.', '');
    }
    if (sanitized.length > 15) sanitized = sanitized.substring(0, 15);
    return sanitized;
  }

  void _recalculate() {
    if (_isSourceEditing) {
      _targetAmount =
          _convert(_sourceAmount, _sourceCurrency, _targetCurrency);
    } else {
      _sourceAmount =
          _convert(_targetAmount, _targetCurrency, _sourceCurrency);
    }
  }

  String _convert(String amountStr, String from, String to) {
    final amount = double.tryParse(amountStr);
    if (amount == null) return '';
    if (amount == 0) {
      _hasConversionError = false;
      return '0';
    }

    final sourceRate = _getRateForCode(from);
    final targetRate = _getRateForCode(to);

    if (sourceRate == null || targetRate == null) {
      _hasConversionError = true;
      return '';
    }
    if (sourceRate.nominal == 0 ||
        targetRate.nominal == 0 ||
        targetRate.rate == 0) {
      _hasConversionError = true;
      return '';
    }

    _hasConversionError = false;

    final sourceInUzs = amount * sourceRate.rate / sourceRate.nominal;
    final result = sourceInUzs * targetRate.nominal / targetRate.rate;

    if (result.isNaN || result.isInfinite) return '';

    if ((result - result.roundToDouble()).abs() < 0.001) {
      return result.round().toString();
    }
    return result.toStringAsFixed(2);
  }

  _CurrencyRate? _getRateForCode(String code) {
    if (code == 'UZS') {
      return _CurrencyRate(rate: 1, nominal: 1);
    }
    try {
      final currency = _rates.firstWhere((c) => c.code == code);
      return _CurrencyRate(rate: currency.rate, nominal: currency.nominal);
    } catch (_) {
      return null;
    }
  }
}

class _CurrencyRate {
  final double rate;
  final int nominal;

  _CurrencyRate({required this.rate, required this.nominal});
}
