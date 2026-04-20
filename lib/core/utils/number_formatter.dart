import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  static final _rateFormat = NumberFormat('#,##0.00', 'uz');
  static final _amountFormat = NumberFormat('#,##0.##', 'uz');

  /// Kursni formatlash: 12 179,87
  static String formatRate(double rate) {
    return _rateFormat.format(rate);
  }

  /// Summani formatlash
  static String formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return NumberFormat('#,##0', 'uz').format(amount);
    }
    return _amountFormat.format(amount);
  }

  /// Diff ni formatlash: +8.26 yoki -8.26
  static String formatDiff(double diff) {
    final prefix = diff >= 0 ? '+' : '';
    return '$prefix${_rateFormat.format(diff)}';
  }

  /// String dan double ga parse
  static double parseRate(String rate) {
    return double.tryParse(rate) ?? 0.0;
  }
}
