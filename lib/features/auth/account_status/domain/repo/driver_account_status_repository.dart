import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_account_status_entity.dart';

abstract class DriverAccountStatusRepository {
  Future<ApiResult<DriverAccountStatusEntity>> getStatus();
}
