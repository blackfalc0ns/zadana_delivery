class DriverHomeEntity {
  const DriverHomeEntity({
    required this.homeState,
    required this.operationalStatus,
    required this.currentOffer,
    required this.currentAssignment,
    required this.earningsSummaryToday,
    required this.unreadAlerts,
    required this.commitment,
    required this.profileReadiness,
  });

  final String homeState;
  final DriverHomeOperationalStatusEntity operationalStatus;
  final DriverHomeOfferEntity? currentOffer;
  final DriverHomeAssignmentEntity? currentAssignment;
  final DriverHomeEarningsEntity? earningsSummaryToday;
  final int unreadAlerts;
  final DriverHomeCommitmentEntity commitment;
  final DriverProfileReadinessEntity profileReadiness;
}

class DriverHomeOperationalStatusEntity {
  const DriverHomeOperationalStatusEntity({
    required this.driverId,
    required this.gateStatus,
    required this.isOperational,
    required this.canReceiveOrders,
    required this.isAvailable,
    required this.verificationStatus,
    required this.accountStatus,
    required this.zoneName,
    required this.commitmentScore,
    required this.dailyRejections,
    required this.weeklyRejections,
    required this.enforcementLevel,
    required this.canReceiveOffers,
    required this.restrictionMessage,
    required this.reviewedAtUtc,
    required this.reviewNote,
    required this.suspensionReason,
    required this.message,
    this.canGoAvailable,
  });

  final String driverId;
  final String gateStatus;
  final bool isOperational;
  final bool canReceiveOrders;
  final bool isAvailable;
  final bool? canGoAvailable;
  final String verificationStatus;
  final String accountStatus;
  final String zoneName;
  final double? commitmentScore;
  final int dailyRejections;
  final int weeklyRejections;
  final String enforcementLevel;
  final bool canReceiveOffers;
  final String? restrictionMessage;
  final String? reviewedAtUtc;
  final String? reviewNote;
  final String? suspensionReason;
  final String message;
}

class DriverHomeOfferEntity {
  const DriverHomeOfferEntity({
    required this.assignmentId,
    required this.orderId,
    required this.orderNumber,
    required this.vendorName,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.customerName,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.estimatedDistanceKm,
    required this.estimatedEta,
    required this.paymentMethod,
    required this.totalAmount,
    required this.codAmount,
    required this.payout,
    required this.countdownSeconds,
    required this.orderItems,
    this.vendorInitials,
    this.customerInitials,
    this.packageNote,
  });

  final String assignmentId;
  final String orderId;
  final String orderNumber;
  final String vendorName;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String customerName;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final double estimatedDistanceKm;
  final String estimatedEta;
  final String paymentMethod;
  final double totalAmount;
  final double codAmount;
  final double payout;
  final int countdownSeconds;
  final List<DriverHomeOfferItemEntity> orderItems;
  final String? vendorInitials;
  final String? customerInitials;
  final String? packageNote;
}

class DriverHomeOfferItemEntity {
  const DriverHomeOfferItemEntity({
    required this.name,
    required this.quantity,
    this.note,
  });

  final String name;
  final int quantity;
  final String? note;
}

class DriverHomeAssignmentEntity {
  const DriverHomeAssignmentEntity({
    required this.assignmentId,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.vendorName,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.paymentMethod,
    required this.totalAmount,
    required this.codAmount,
    required this.createdAtUtc,
    required this.merchantContact,
    required this.vehicleType,
    required this.plateNumber,
    required this.pickupOtpRequired,
    required this.deliveryOtpRequired,
    required this.pickupOtpCode,
  });

  final String assignmentId;
  final String orderId;
  final String orderNumber;
  final String status;
  final String vendorName;
  final String pickupAddress;
  final String deliveryAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String paymentMethod;
  final double totalAmount;
  final double codAmount;
  final String createdAtUtc;
  final String merchantContact;
  final String vehicleType;
  final String plateNumber;
  final bool pickupOtpRequired;
  final bool deliveryOtpRequired;
  final String? pickupOtpCode;
}

class DriverHomeEarningsEntity {
  const DriverHomeEarningsEntity({
    required this.earningsAmount,
    required this.completedTrips,
  });

  final double earningsAmount;
  final int completedTrips;
}

class DriverHomeCommitmentEntity {
  const DriverHomeCommitmentEntity({
    required this.acceptedOffers,
    required this.rejectedOffers,
    required this.timedOutOffers,
    required this.dailyRejections,
    required this.weeklyRejections,
    required this.commitmentScore,
    required this.enforcementLevel,
    required this.canReceiveOffers,
    required this.restrictionMessage,
    required this.lastOfferResponseAtUtc,
  });

  final int acceptedOffers;
  final int rejectedOffers;
  final int timedOutOffers;
  final int dailyRejections;
  final int weeklyRejections;
  final double? commitmentScore;
  final String enforcementLevel;
  final bool canReceiveOffers;
  final String? restrictionMessage;
  final String? lastOfferResponseAtUtc;
}

class DriverProfileReadinessEntity {
  const DriverProfileReadinessEntity({
    required this.isProfileComplete,
    required this.completionPercent,
    required this.missingRequirements,
    required this.canSubmitForReview,
    required this.checklist,
  });

  final bool isProfileComplete;
  final int completionPercent;
  final List<String> missingRequirements;
  final bool canSubmitForReview;
  final List<DriverProfileChecklistItemEntity> checklist;
}

class DriverProfileChecklistItemEntity {
  const DriverProfileChecklistItemEntity({
    required this.code,
    required this.completed,
    required this.note,
    required this.critical,
  });

  final String code;
  final bool completed;
  final String? note;
  final bool critical;
}
