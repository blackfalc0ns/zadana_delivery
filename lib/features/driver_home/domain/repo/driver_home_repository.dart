import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';

abstract class DriverHomeRepository {
  Stream<DriverHomeEntity> watchHome();

  Future<ApiResult<DriverHomeEntity>> refreshHome();

  Future<ApiResult<void>> updateAvailability({required bool isAvailable});

  Future<ApiResult<void>> acceptOffer(String assignmentId);

  Future<ApiResult<void>> rejectOffer(String assignmentId, {String? reason});
}
