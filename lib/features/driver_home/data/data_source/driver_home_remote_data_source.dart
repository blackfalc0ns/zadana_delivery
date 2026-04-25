import 'package:zadana_delivery/features/driver_home/data/models/driver_home_model_dto.dart';

abstract class DriverHomeRemoteDataSource {
  Future<DriverHomeModelDto> getHome();

  Future<void> updateAvailability({required bool isAvailable});

  Future<void> acceptOffer(String assignmentId);

  Future<void> rejectOffer(String assignmentId, {String? reason});

  Stream<DriverHomeModelDto> watchHome();

  void emitHome(DriverHomeModelDto home);
}
