class DriverPayoutMethodUpsertRequestEntity {
  const DriverPayoutMethodUpsertRequestEntity({
    required this.type,
    required this.accountHolderName,
    required this.accountIdentifier,
    required this.providerName,
    this.isPrimary,
  });

  final String type;
  final String accountHolderName;
  final String accountIdentifier;
  final String providerName;
  final bool? isPrimary;
}
