import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transactions_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

class GetDriverWalletTransactionsUseCase {
  const GetDriverWalletTransactionsUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<DriverWalletTransactionsPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getTransactions(page: page, pageSize: pageSize);
  }
}
