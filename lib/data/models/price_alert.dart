class PriceAlert {
  final String currencyCode;
  final double targetRate;
  final bool isEnabled;
  final DateTime createdAt;

  const PriceAlert({
    required this.currencyCode,
    required this.targetRate,
    required this.isEnabled,
    required this.createdAt,
  });

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(
      currencyCode: (json['currencyCode'] as String?) ?? '',
      targetRate: (json['targetRate'] as num?)?.toDouble() ?? 0,
      isEnabled: (json['isEnabled'] as bool?) ?? true,
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencyCode': currencyCode,
      'targetRate': targetRate,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PriceAlert copyWith({
    String? currencyCode,
    double? targetRate,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return PriceAlert(
      currencyCode: currencyCode ?? this.currencyCode,
      targetRate: targetRate ?? this.targetRate,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
