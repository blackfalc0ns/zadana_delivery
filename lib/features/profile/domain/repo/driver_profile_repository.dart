import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_unified_profile_entity.dart';
import '../entities/update_driver_documents_request_entity.dart';
import '../entities/update_driver_personal_request_entity.dart';
import '../entities/update_driver_vehicle_request_entity.dart';

abstract class DriverProfileRepository {
  Future<ApiResult<DriverUnifiedProfileEntity>> getProfile();

  Future<ApiResult<DriverUnifiedProfileEntity>> updatePersonal(
    UpdateDriverPersonalRequestEntity request,
  );

  Future<ApiResult<DriverUnifiedProfileEntity>> updateVehicle(
    UpdateDriverVehicleRequestEntity request,
  );

  Future<ApiResult<DriverUnifiedProfileEntity>> updateDocuments(
    UpdateDriverDocumentsRequestEntity request,
  );

  Future<ApiResult<DriverUnifiedProfileEntity>> updateProfilePhoto(
    String photoPathOrUrl,
  );

  Future<ApiResult<DriverUnifiedProfileEntity>> deleteProfilePhoto();
}
