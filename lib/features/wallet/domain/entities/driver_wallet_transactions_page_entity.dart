import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transaction_entity.dart';

class DriverWalletTransactionsPageEntity {
  const DriverWalletTransactionsPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  final List<DriverWalletTransactionEntity> items;
  final int page;
  final int pageSize;
  final int totalCount;

  bool get hasMore => items.length < totalCount;
}
