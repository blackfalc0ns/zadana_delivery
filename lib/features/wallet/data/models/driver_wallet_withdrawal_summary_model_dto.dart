class DriverWalletWithdrawalSummaryModelDto {
  const DriverWalletWithdrawalSummaryModelDto({
    required this.pendingCount,
    required this.pendingAmount,
    required this.totalRequests,
  });

  factory DriverWalletWithdrawalSummaryModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverWalletWithdrawalSummaryModelDto(
      pendingCount: _toInt(json['pendingCount']),
      pendingAmount: _toDouble(json['pendingAmount']),
      totalRequests: _toInt(json['totalRequests']),
    );
  }

  final int pendingCount;
  final double pendingAmount;
  final int totalRequests;

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
