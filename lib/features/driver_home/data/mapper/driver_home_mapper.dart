import 'package:zadana_delivery/features/driver_home/data/models/driver_home_model_dto.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';

extension DriverHomeModelMapper on DriverHomeModelDto {
  DriverHomeEntity toEntity() {
    return DriverHomeEntity(
      homeState: homeState,
      operationalStatus: operationalStatus.toEntity(),
      currentOffer: currentOffer?.toEntity(),
      currentAssignment: currentAssignment?.toEntity(),
      earningsSummaryToday: earningsSummaryToday?.toEntity(),
      unreadAlerts: unreadAlerts,
    );
  }
}

extension DriverHomeOperationalStatusModelMapper
    on DriverHomeOperationalStatusModelDto {
  DriverHomeOperationalStatusEntity toEntity() {
    return DriverHomeOperationalStatusEntity(
      isOperational: isOperational,
      canReceiveOrders: canReceiveOrders,
      isAvailable: isAvailable,
      canGoAvailable: canGoAvailable,
      verificationStatus: verificationStatus,
      accountStatus: accountStatus,
      zoneName: zoneName,
      commitmentScore: commitmentScore,
      canReceiveOffers: canReceiveOffers,
      restrictionMessage: restrictionMessage,
      message: message,
    );
  }
}

extension DriverHomeOfferModelMapper on DriverHomeOfferModelDto {
  DriverHomeOfferEntity toEntity() {
    return DriverHomeOfferEntity(
      assignmentId: assignmentId,
      orderId: orderId,
      orderNumber: orderNumber,
      vendorName: vendorName,
      pickupAddress: pickupAddress,
      pickupLatitude: pickupLatitude,
      pickupLongitude: pickupLongitude,
      customerName: customerName,
      deliveryAddress: deliveryAddress,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      estimatedDistanceKm: estimatedDistanceKm,
      estimatedEta: estimatedEta,
      payout: payout,
      countdownSeconds: countdownSeconds,
      orderItems: orderItems.map((item) => item.toEntity()).toList(),
      vendorInitials: vendorInitials,
      customerInitials: customerInitials,
      packageNote: packageNote,
    );
  }
}

extension DriverHomeOfferItemModelMapper on DriverHomeOfferItemModelDto {
  DriverHomeOfferItemEntity toEntity() {
    return DriverHomeOfferItemEntity(
      name: name,
      quantity: quantity,
      note: note,
    );
  }
}

extension DriverHomeAssignmentModelMapper on DriverHomeAssignmentModelDto {
  DriverHomeAssignmentEntity toEntity() {
    return DriverHomeAssignmentEntity(
      assignmentId: assignmentId,
      orderId: orderId,
      orderNumber: orderNumber,
      status: status,
      vendorName: vendorName,
      pickupAddress: pickupAddress,
      deliveryAddress: deliveryAddress,
      pickupLatitude: pickupLatitude,
      pickupLongitude: pickupLongitude,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      codAmount: codAmount,
      createdAtUtc: createdAtUtc,
      merchantContact: merchantContact,
      vehicleType: vehicleType,
      plateNumber: plateNumber,
      pickupOtpRequired: pickupOtpRequired,
      deliveryOtpRequired: deliveryOtpRequired,
      pickupOtpCode: pickupOtpCode,
    );
  }
}

extension DriverHomeEarningsModelMapper on DriverHomeEarningsModelDto {
  DriverHomeEarningsEntity toEntity() {
    return DriverHomeEarningsEntity(
      earningsAmount: earningsAmount,
      completedTrips: completedTrips,
    );
  }
}
