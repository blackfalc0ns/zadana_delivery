import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';

class DriverWalletWithdrawalRequestEntity {
  const DriverWalletWithdrawalRequestEntity({
    required this.id,
    required this.amount,
    required this.status,
    required this.transferReference,
    required this.failureReason,
    required this.createdAt,
    required this.processedAt,
    required this.paymentMethod,
  });

  final String id;
  final double amount;
  final String status;
  final String? transferReference;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime? processedAt;
  final DriverPayoutMethodEntity paymentMethod;
}
