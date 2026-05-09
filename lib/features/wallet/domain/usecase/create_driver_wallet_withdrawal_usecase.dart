import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

class CreateDriverWalletWithdrawalUseCase {
  const CreateDriverWalletWithdrawalUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<DriverWalletWithdrawalRequestEntity>> call(
    DriverWalletCreateWithdrawalRequestEntity request,
  ) {
    return _repository.createWithdrawal(request);
  }
}
