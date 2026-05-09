class DriverWalletWithdrawalSummaryEntity {
  const DriverWalletWithdrawalSummaryEntity({
    required this.pendingCount,
    required this.pendingAmount,
    required this.totalRequests,
  });

  final int pendingCount;
  final double pendingAmount;
  final int totalRequests;
}
