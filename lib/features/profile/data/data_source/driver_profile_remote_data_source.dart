import '../models/driver_unified_profile_model_dto.dart';
import '../models/update_driver_documents_request_model_dto.dart';
import '../models/update_driver_personal_request_model_dto.dart';
import '../models/update_driver_vehicle_request_model_dto.dart';

abstract class DriverProfileRemoteDataSource {
  Future<DriverUnifiedProfileModelDto> getProfile();

  Future<DriverUnifiedProfileModelDto> updatePersonal(
    UpdateDriverPersonalRequestModelDto request,
  );

  Future<DriverUnifiedProfileModelDto> updateVehicle(
    UpdateDriverVehicleRequestModelDto request,
  );

  Future<DriverUnifiedProfileModelDto> updateDocuments(
    UpdateDriverDocumentsRequestModelDto request,
  );

  Future<void> updateProfilePhoto(String profilePhotoUrl);

  Future<void> deleteProfilePhoto();

  Future<void> closeAccount({required String password, String? reason});
}
