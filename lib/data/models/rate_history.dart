class RateHistory {
  final DateTime date;
  final double rate;
  final int nominal;

  RateHistory({
    required this.date,
    required this.rate,
    required this.nominal,
  });

  double get ratePerUnit => nominal == 0 ? 0.0 : rate / nominal;
}
