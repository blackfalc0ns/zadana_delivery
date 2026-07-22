class DriverWalletCreateWithdrawalRequestEntity {
  const DriverWalletCreateWithdrawalRequestEntity({
    required this.amount,
    required this.paymentMethodId,
    required this.idempotencyKey,
  });

  final String paymentMethodId;
  final double amount;
  final String idempotencyKey;
}
