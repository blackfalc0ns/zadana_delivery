class DriverPayoutMethodEntity {
  const DriverPayoutMethodEntity({
    required this.id,
    required this.type,
    required this.accountHolderName,
    required this.providerName,
    required this.maskedLabel,
    required this.isPrimary,
    required this.isVerified,
  });

  final String id;
  final String type;
  final String accountHolderName;
  final String providerName;
  final String maskedLabel;
  final bool isPrimary;
  final bool isVerified;
}
