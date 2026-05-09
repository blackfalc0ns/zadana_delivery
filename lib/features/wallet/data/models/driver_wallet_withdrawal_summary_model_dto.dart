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
      pendingCount: json['pendingCount'] as int? ?? 0,
      pendingAmount: _toDouble(json['pendingAmount']),
      totalRequests: json['totalRequests'] as int? ?? 0,
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
}
