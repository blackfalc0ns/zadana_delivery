import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawals_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

class GetDriverWalletWithdrawalsUseCase {
  const GetDriverWalletWithdrawalsUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<DriverWalletWithdrawalsPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getWithdrawals(page: page, pageSize: pageSize);
  }
}
