import '../models/driver_account_status_model_dto.dart';

abstract class DriverAccountStatusRemoteDataSource {
  Future<DriverAccountStatusModelDto> getStatus();
}
