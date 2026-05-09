import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

class DeleteDriverWalletPaymentMethodUseCase {
  const DeleteDriverWalletPaymentMethodUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<void>> call(String id) {
    return _repository.deletePaymentMethod(id);
  }
}
