import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

@injectable
class CreateDriverWalletPaymentMethodUseCase {
  const CreateDriverWalletPaymentMethodUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<DriverPayoutMethodEntity>> call(
    DriverPayoutMethodUpsertRequestEntity request,
  ) {
    return _repository.createPaymentMethod(request);
  }
}
