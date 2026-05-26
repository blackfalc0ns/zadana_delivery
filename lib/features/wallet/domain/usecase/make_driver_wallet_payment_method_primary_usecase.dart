import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

@injectable
class MakeDriverWalletPaymentMethodPrimaryUseCase {
  const MakeDriverWalletPaymentMethodPrimaryUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<DriverPayoutMethodEntity>> call(String id) {
    return _repository.makePaymentMethodPrimary(id);
  }
}
