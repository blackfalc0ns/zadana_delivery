import '../../domain/entities/driver_account_status_entity.dart';
import '../models/driver_account_status_model_dto.dart';

extension DriverAccountStatusMapper on DriverAccountStatusModelDto {
  DriverAccountStatusEntity toEntity() {
    return DriverAccountStatusEntity(
      driverId: driverId.trim(),
      isOperational: isOperational,
      canReceiveOrders: canReceiveOrders,
      canGoAvailable: canGoAvailable,
      isAvailable: isAvailable,
      verificationStatus: verificationStatus.trim(),
      accountStatus: accountStatus.trim(),
      reviewedAtUtc: reviewedAtUtc,
      reviewNote: reviewNote,
      suspensionReason: suspensionReason,
      primaryZoneId: primaryZoneId,
      zoneName: zoneName,
      message: message.trim(),
    );
  }
}
