import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/driver_account_status_entity.dart';
import '../../domain/repo/driver_account_status_repository.dart';
import '../data_source/driver_account_status_remote_data_source.dart';
import '../mapper/driver_account_status_mapper.dart';

@Injectable(as: DriverAccountStatusRepository)
class DriverAccountStatusRepositoryImpl
    implements DriverAccountStatusRepository {
  const DriverAccountStatusRepositoryImpl(this._remoteDataSource);

  final DriverAccountStatusRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<DriverAccountStatusEntity>> getStatus() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getStatus();
      return response.toEntity();
    });
  }
}
