import '../../domain/entities/driver_account_status_entity.dart';
import '../models/driver_account_status_model_dto.dart';

extension DriverAccountStatusMapper on DriverAccountStatusModelDto {
  DriverAccountStatusEntity toEntity() {
    return DriverAccountStatusEntity(
      driverId: driverId.trim(),
      gateStatus: gateStatus.trim(),
      isOperational: isOperational,
      canReceiveOrders: canReceiveOrders,
      canReceiveOffers: canReceiveOffers,
      canGoAvailable: canGoAvailable,
      isAvailable: isAvailable,
      verificationStatus: verificationStatus.trim(),
      accountStatus: accountStatus.trim(),
      enforcementLevel: enforcementLevel.trim(),
      reviewedAtUtc: reviewedAtUtc,
      reviewNote: reviewNote,
      reviewNoteAr: reviewNoteAr,
      reviewNoteEn: reviewNoteEn,
      suspensionReason: suspensionReason,
      restrictionMessage: restrictionMessage,
      restrictionMessageAr: restrictionMessageAr,
      restrictionMessageEn: restrictionMessageEn,
      region: region,
      primaryZoneId: primaryZoneId,
      zoneName: zoneName,
      message: message.trim(),
      messageAr: messageAr,
      messageEn: messageEn,
      policyIsFrozen: policyIsFrozen,
      supportCta: supportCta == null
          ? null
          : DriverAccountSupportCtaEntity(
              endpoint: supportCta!.endpoint.trim(),
              reasonType: supportCta!.reasonType.trim(),
              labelAr: supportCta!.labelAr?.trim(),
              labelEn: supportCta!.labelEn?.trim(),
            ),
    );
  }
}
