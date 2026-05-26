import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_summary_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

@injectable
class GetDriverWalletSummaryUseCase {
  const GetDriverWalletSummaryUseCase(this._repository);

  final WalletRepository _repository;

  Future<ApiResult<DriverWalletSummaryEntity>> call() {
    return _repository.getWalletSummary();
  }
}
