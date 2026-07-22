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
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      direction: json['direction']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      description: json['description']?.toString() ?? '',
      referenceType: json['referenceType']?.toString() ?? '',
      referenceId: json['referenceId']?.toString(),
      createdAtUtc:
          json['createdAtUtc']?.toString() ??
          json['createdAt']?.toString() ??
          '',
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
