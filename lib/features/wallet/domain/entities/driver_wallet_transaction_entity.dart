class DriverWalletTransactionEntity {
  const DriverWalletTransactionEntity({
    required this.id,
    required this.type,
    required this.direction,
    required this.amount,
    required this.description,
    required this.referenceType,
    required this.referenceId,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String direction;
  final double amount;
  final String description;
  final String referenceType;
  final String? referenceId;
  final DateTime createdAt;

  bool get isIncoming => direction.trim().toUpperCase() == 'IN';
}
