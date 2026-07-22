import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/profile/domain/repo/driver_profile_repository.dart';

@injectable
class CloseDriverAccountUseCase {
  const CloseDriverAccountUseCase(this._repository);

  final DriverProfileRepository _repository;

  Future<ApiResult<void>> call({required String password, String? reason}) {
    return _repository.closeAccount(password: password, reason: reason);
  }
}
