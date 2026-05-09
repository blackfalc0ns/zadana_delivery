class DriverWalletTransactionModelDto {
  const DriverWalletTransactionModelDto({
    required this.id,
    required this.type,
    required this.direction,
    required this.amount,
    required this.description,
    required this.referenceType,
    required this.referenceId,
    required this.createdAtUtc,
  });

  factory DriverWalletTransactionModelDto.fromJson(Map<String, dynamic> json) {
    return DriverWalletTransactionModelDto(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      direction: json['direction'] as String? ?? '',
      amount: _toDouble(json['amount']),
      description: json['description'] as String? ?? '',
      referenceType: json['referenceType'] as String? ?? '',
      referenceId: json['referenceId'] as String?,
      createdAtUtc: json['createdAtUtc'] as String? ?? '',
    );
  }

  final String id;
  final String type;
  final String direction;
  final double amount;
  final String description;
  final String referenceType;
  final String? referenceId;
  final String createdAtUtc;

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
