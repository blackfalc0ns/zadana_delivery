import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

@injectable
class CancelDriverWalletWithdrawalUseCase {
  const CancelDriverWalletWithdrawalUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<void>> call(String withdrawalId) =>
      _repository.cancelWithdrawal(withdrawalId);
}
