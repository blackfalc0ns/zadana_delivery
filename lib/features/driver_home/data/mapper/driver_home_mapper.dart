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
      commitment: commitment.toEntity(),
      profileReadiness: profileReadiness.toEntity(),
    );
  }
}

extension DriverHomeOperationalStatusModelMapper
    on DriverHomeOperationalStatusModelDto {
  DriverHomeOperationalStatusEntity toEntity() {
    return DriverHomeOperationalStatusEntity(
      driverId: driverId,
      gateStatus: gateStatus,
      isOperational: isOperational,
      canReceiveOrders: canReceiveOrders,
      isAvailable: isAvailable,
      canGoAvailable: canGoAvailable,
      verificationStatus: verificationStatus,
      accountStatus: accountStatus,
      zoneName: zoneName,
      commitmentScore: commitmentScore,
      dailyRejections: dailyRejections,
      weeklyRejections: weeklyRejections,
      enforcementLevel: enforcementLevel,
      canReceiveOffers: canReceiveOffers,
      restrictionMessage: restrictionMessage,
      reviewedAtUtc: reviewedAtUtc,
      reviewNote: reviewNote,
      suspensionReason: suspensionReason,
      message: message,
      policyIsFrozen: policyIsFrozen,
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
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      codAmount: codAmount,
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
      vendorImageUrl: vendorImageUrl,
      pickupAddress: pickupAddress,
      deliveryAddress: deliveryAddress,
      pickupLatitude: pickupLatitude,
      pickupLongitude: pickupLongitude,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
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

extension DriverHomeCommitmentModelMapper on DriverHomeCommitmentModelDto {
  DriverHomeCommitmentEntity toEntity() {
    return DriverHomeCommitmentEntity(
      acceptedOffers: acceptedOffers,
      rejectedOffers: rejectedOffers,
      timedOutOffers: timedOutOffers,
      dailyRejections: dailyRejections,
      weeklyRejections: weeklyRejections,
      commitmentScore: commitmentScore,
      enforcementLevel: enforcementLevel,
      canReceiveOffers: canReceiveOffers,
      restrictionMessage: restrictionMessage,
      lastOfferResponseAtUtc: lastOfferResponseAtUtc,
    );
  }
}

extension DriverProfileReadinessModelMapper on DriverProfileReadinessModelDto {
  DriverProfileReadinessEntity toEntity() {
    return DriverProfileReadinessEntity(
      isProfileComplete: isProfileComplete,
      completionPercent: completionPercent,
      missingRequirements: missingRequirements,
      canSubmitForReview: canSubmitForReview,
      checklist: checklist
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }
}

extension DriverProfileChecklistItemModelMapper
    on DriverProfileChecklistItemModelDto {
  DriverProfileChecklistItemEntity toEntity() {
    return DriverProfileChecklistItemEntity(
      code: code,
      completed: completed,
      note: note,
      critical: critical,
    );
  }
}
