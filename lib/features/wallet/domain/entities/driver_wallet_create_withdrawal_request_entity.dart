class DriverWalletCreateWithdrawalRequestEntity {
  const DriverWalletCreateWithdrawalRequestEntity({
    required this.amount,
    this.paymentMethodId,
  });

  final String? paymentMethodId;
  final double amount;
}
