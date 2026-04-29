import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_home/data/data_source/driver_home_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_home/data/mapper/driver_home_mapper.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/domain/repo/driver_home_repository.dart';

@LazySingleton(as: DriverHomeRepository)
class DriverHomeRepositoryImpl implements DriverHomeRepository {
  const DriverHomeRepositoryImpl(this._remoteDataSource);

  final DriverHomeRemoteDataSource _remoteDataSource;

  @override
  Stream<DriverHomeEntity> watchHome() {
    return _remoteDataSource.watchHome().map((event) => event.toEntity());
  }

  @override
  Future<ApiResult<DriverHomeEntity>> refreshHome() {
    return safeApiCall(() async {
      final home = await _remoteDataSource.getHome();
      _remoteDataSource.emitHome(home);
      return home.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> updateAvailability({required bool isAvailable}) {
    return safeApiCall(() async {
      await _remoteDataSource.updateAvailability(isAvailable: isAvailable);
    });
  }

  @override
  Future<ApiResult<void>> acceptOffer(String assignmentId) {
    return safeApiCall(() async {
      await _remoteDataSource.acceptOffer(assignmentId);
    });
  }

  @override
  Future<ApiResult<void>> rejectOffer(String assignmentId, {String? reason}) {
    return safeApiCall(() async {
      await _remoteDataSource.rejectOffer(assignmentId, reason: reason);
    });
  }
}
