import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_account_status_entity.dart';
import '../repo/driver_account_status_repository.dart';

@injectable
class GetDriverAccountStatusUseCase {
  const GetDriverAccountStatusUseCase(this._repository);

  final DriverAccountStatusRepository _repository;

  Future<ApiResult<DriverAccountStatusEntity>> call() {
    return _repository.getStatus();
  }
}
