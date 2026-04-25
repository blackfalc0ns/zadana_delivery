import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

class VehicleInfoInitialData {
  const VehicleInfoInitialData({
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
  });

  final String vehicleType;
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
}

@injectable
class VehicleInfoController {
  VehicleInfoController(this._draftService);

  final DriverProfileDraftService _draftService;

  VehicleInfoInitialData get initialData {
    final draft = _draftService.profileDraft;

    return VehicleInfoInitialData(
      vehicleType: draft.vehicleType,
      vehicleBrand: draft.vehicleBrand,
      vehicleModel: draft.vehicleModel,
      plateNumber: draft.plateNumber,
    );
  }

  Future<void> save({
    required String vehicleType,
    required String vehicleBrand,
    required String vehicleModel,
    required String plateNumber,
  }) async {
    final draft = _draftService.profileDraft.copyWith(
      vehicleType: vehicleType,
      vehicleBrand: vehicleBrand.trim(),
      vehicleModel: vehicleModel.trim(),
      plateNumber: plateNumber.trim(),
    );

    await _draftService.saveProfileDraft(draft);
  }
}
