import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

@injectable
class GetDriverWalletPaymentMethodsUseCase {
  const GetDriverWalletPaymentMethodsUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<List<DriverPayoutMethodEntity>>> call() {
    return _repository.getPaymentMethods();
  }
}
