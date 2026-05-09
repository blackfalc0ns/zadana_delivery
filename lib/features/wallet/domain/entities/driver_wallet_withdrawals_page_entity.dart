import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';

class DriverWalletWithdrawalsPageEntity {
  const DriverWalletWithdrawalsPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  final List<DriverWalletWithdrawalRequestEntity> items;
  final int page;
  final int pageSize;
  final int totalCount;

  bool get hasMore => items.length < totalCount;
}
