import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

class UpdateDriverWalletPaymentMethodUseCase {
  const UpdateDriverWalletPaymentMethodUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<DriverPayoutMethodEntity>> call(
    String id,
    DriverPayoutMethodUpsertRequestEntity request,
  ) {
    return _repository.updatePaymentMethod(id, request);
  }
}
