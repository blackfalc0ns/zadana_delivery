class DriverHomeModelDto {
  const DriverHomeModelDto({
    required this.homeState,
    required this.operationalStatus,
    required this.currentOffer,
    required this.currentAssignment,
    required this.earningsSummaryToday,
    required this.unreadAlerts,
    required this.commitment,
    required this.profileReadiness,
  });

  factory DriverHomeModelDto.fromJson(Map<String, dynamic> json) {
    final currentOfferJson = _asMap(json['currentOffer']);
    final currentAssignmentJson = _resolveCurrentAssignmentJson(json);
    final earningsJson = _asMap(
      json['earningsSummaryToday'] ?? json['earnings'],
    );
    return DriverHomeModelDto(
      homeState: json['homeState']?.toString() ?? '',
      operationalStatus: DriverHomeOperationalStatusModelDto.fromJson(
        _asMap(json['operationalStatus']),
      ),
      currentOffer: currentOfferJson.isEmpty
          ? null
          : DriverHomeOfferModelDto.fromJson(currentOfferJson),
      currentAssignment: currentAssignmentJson.isEmpty
          ? null
          : DriverHomeAssignmentModelDto.fromJson(currentAssignmentJson),
      earningsSummaryToday: earningsJson.isEmpty
          ? null
          : DriverHomeEarningsModelDto.fromJson(earningsJson),
      unreadAlerts: _asInt(json['unreadAlerts']),
      commitment: DriverHomeCommitmentModelDto.fromJson(
        _asMap(json['commitment']),
      ),
      profileReadiness: DriverProfileReadinessModelDto.fromJson(
        _asMap(json['profileReadiness']),
      ),
    );
  }

  final String homeState;
  final DriverHomeOperationalStatusModelDto operationalStatus;
  final DriverHomeOfferModelDto? currentOffer;
  final DriverHomeAssignmentModelDto? currentAssignment;
  final DriverHomeEarningsModelDto? earningsSummaryToday;
  final int unreadAlerts;
  final DriverHomeCommitmentModelDto commitment;
  final DriverProfileReadinessModelDto profileReadiness;
}

Map<String, dynamic> _resolveCurrentAssignmentJson(Map<String, dynamic> json) {
  for (final key in const [
    'currentAssignment',
    'activeAssignment',
    'assignment',
    'currentMission',
    'activeMission',
  ]) {
    final map = _asMap(json[key]);
    if (map.isNotEmpty) return map;
  }
  return const <String, dynamic>{};
}

class DriverHomeOperationalStatusModelDto {
  const DriverHomeOperationalStatusModelDto({
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
    required this.policyIsFrozen,
    this.canGoAvailable,
  });

  factory DriverHomeOperationalStatusModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    final rejectionPolicy = _asMap(json['rejectionPolicy']);
    return DriverHomeOperationalStatusModelDto(
      driverId: json['driverId']?.toString() ?? '',
      gateStatus: json['gateStatus']?.toString() ?? '',
      isOperational: _asBool(json['isOperational']),
      canReceiveOrders: _asBool(json['canReceiveOrders']),
      isAvailable: _asBool(json['isAvailable']),
      canGoAvailable: json['canGoAvailable'] == null
          ? null
          : _asBool(json['canGoAvailable']),
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      accountStatus: json['accountStatus']?.toString() ?? '',
      zoneName: json['zoneName']?.toString() ?? '',
      commitmentScore: _asDoubleOrNull(json['commitmentScore']),
      dailyRejections: _asInt(json['dailyRejections']),
      weeklyRejections: _asInt(json['weeklyRejections']),
      enforcementLevel: json['enforcementLevel']?.toString() ?? '',
      canReceiveOffers: _asBool(json['canReceiveOffers']),
      restrictionMessage:
          json['restrictionMessage']?.toString() ??
          rejectionPolicy['restrictionMessage']?.toString(),
      reviewedAtUtc: json['reviewedAtUtc']?.toString(),
      reviewNote: json['reviewNote']?.toString(),
      suspensionReason: json['suspensionReason']?.toString(),
      message: json['message']?.toString() ?? '',
      policyIsFrozen: rejectionPolicy['isFrozen'] == true,
    );
  }

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
  final bool policyIsFrozen;
}

class DriverHomeOfferModelDto {
  const DriverHomeOfferModelDto({
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

  factory DriverHomeOfferModelDto.fromJson(Map<String, dynamic> json) {
    final orderItems = _asList(json['orderItems'] ?? json['items']);
    return DriverHomeOfferModelDto(
      assignmentId: json['assignmentId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      vendorName: json['vendorName']?.toString() ?? '',
      pickupAddress:
          json['pickupAddress']?.toString() ??
          json['vendorAddress']?.toString() ??
          '',
      pickupLatitude: _asDouble(
        json['pickupLatitude'] ?? json['vendorLatitude'],
      ),
      pickupLongitude: _asDouble(
        json['pickupLongitude'] ?? json['vendorLongitude'],
      ),
      customerName: json['customerName']?.toString() ?? '',
      deliveryAddress:
          json['deliveryAddress']?.toString() ??
          json['customerAddress']?.toString() ??
          '',
      deliveryLatitude: _asDouble(
        json['deliveryLatitude'] ?? json['customerLatitude'],
      ),
      deliveryLongitude: _asDouble(
        json['deliveryLongitude'] ?? json['customerLongitude'],
      ),
      estimatedDistanceKm: _asDouble(
        json['estimatedDistanceKm'] ?? json['distanceKm'],
      ),
      estimatedEta: json['estimatedEta']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      totalAmount: _asDouble(json['totalAmount']),
      codAmount: _asDouble(json['codAmount']),
      payout: _asDouble(json['payout'] ?? json['deliveryFee']),
      countdownSeconds: _asInt(json['countdownSeconds']),
      orderItems: orderItems
          .map((item) => DriverHomeOfferItemModelDto.fromJson(_asMap(item)))
          .toList(),
      vendorInitials: json['vendorInitials']?.toString(),
      customerInitials: json['customerInitials']?.toString(),
      packageNote: json['packageNote']?.toString() ?? json['notes']?.toString(),
    );
  }

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
  final List<DriverHomeOfferItemModelDto> orderItems;
  final String? vendorInitials;
  final String? customerInitials;
  final String? packageNote;
}

class DriverHomeOfferItemModelDto {
  const DriverHomeOfferItemModelDto({
    required this.name,
    required this.quantity,
    this.note,
  });

  factory DriverHomeOfferItemModelDto.fromJson(Map<String, dynamic> json) {
    return DriverHomeOfferItemModelDto(
      name: json['name']?.toString() ?? json['productName']?.toString() ?? '',
      quantity: _asInt(json['quantity']),
      note: json['note']?.toString() ?? json['notes']?.toString(),
    );
  }

  final String name;
  final int quantity;
  final String? note;
}

class DriverHomeAssignmentModelDto {
  const DriverHomeAssignmentModelDto({
    required this.assignmentId,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.vendorName,
    required this.vendorImageUrl,
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

  factory DriverHomeAssignmentModelDto.fromJson(Map<String, dynamic> json) {
    return DriverHomeAssignmentModelDto(
      assignmentId: json['assignmentId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      status:
          json['status']?.toString() ??
          json['assignmentStatus']?.toString() ??
          '',
      vendorName: json['vendorName']?.toString() ?? '',
      vendorImageUrl:
          json['vendorImageUrl']?.toString() ??
          json['vendorLogo']?.toString() ??
          json['storeImageUrl']?.toString() ??
          '',
      pickupAddress: json['pickupAddress']?.toString() ?? '',
      deliveryAddress: json['deliveryAddress']?.toString() ?? '',
      pickupLatitude: _asDouble(json['pickupLatitude']),
      pickupLongitude: _asDouble(json['pickupLongitude']),
      deliveryLatitude: _asDouble(json['deliveryLatitude']),
      deliveryLongitude: _asDouble(json['deliveryLongitude']),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      totalAmount: _asDouble(json['totalAmount'] ?? json['grandTotal']),
      codAmount: _asDouble(json['codAmount']),
      createdAtUtc: json['createdAtUtc']?.toString() ?? '',
      merchantContact:
          json['merchantContact']?.toString() ??
          json['storePhone']?.toString() ??
          '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      plateNumber: json['plateNumber']?.toString() ?? '',
      pickupOtpRequired: _asBool(json['pickupOtpRequired']),
      deliveryOtpRequired: _asBool(json['deliveryOtpRequired']),
      pickupOtpCode: json['pickupOtpCode']?.toString(),
    );
  }

  final String assignmentId;
  final String orderId;
  final String orderNumber;
  final String status;
  final String vendorName;
  final String vendorImageUrl;
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

class DriverHomeEarningsModelDto {
  const DriverHomeEarningsModelDto({
    required this.earningsAmount,
    required this.completedTrips,
  });

  factory DriverHomeEarningsModelDto.fromJson(Map<String, dynamic> json) {
    return DriverHomeEarningsModelDto(
      earningsAmount: _asDouble(
        json['earningsAmount'] ?? json['earningsToday'],
      ),
      completedTrips: _asInt(json['completedTrips']),
    );
  }

  final double earningsAmount;
  final int completedTrips;
}

class DriverHomeCommitmentModelDto {
  const DriverHomeCommitmentModelDto({
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

  factory DriverHomeCommitmentModelDto.fromJson(Map<String, dynamic> json) {
    return DriverHomeCommitmentModelDto(
      acceptedOffers: _asInt(json['acceptedOffers']),
      rejectedOffers: _asInt(json['rejectedOffers']),
      timedOutOffers: _asInt(json['timedOutOffers']),
      dailyRejections: _asInt(json['dailyRejections']),
      weeklyRejections: _asInt(json['weeklyRejections']),
      commitmentScore: _asDoubleOrNull(json['commitmentScore']),
      enforcementLevel: json['enforcementLevel']?.toString() ?? '',
      canReceiveOffers: _asBool(json['canReceiveOffers']),
      restrictionMessage: json['restrictionMessage']?.toString(),
      lastOfferResponseAtUtc: json['lastOfferResponseAtUtc']?.toString(),
    );
  }

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

class DriverProfileReadinessModelDto {
  const DriverProfileReadinessModelDto({
    required this.isProfileComplete,
    required this.completionPercent,
    required this.missingRequirements,
    required this.canSubmitForReview,
    required this.checklist,
  });

  factory DriverProfileReadinessModelDto.fromJson(Map<String, dynamic> json) {
    return DriverProfileReadinessModelDto(
      isProfileComplete: _asBool(json['isProfileComplete']),
      completionPercent: _asInt(json['completionPercent']),
      missingRequirements: _asList(
        json['missingRequirements'],
      ).map((item) => item.toString()).toList(growable: false),
      canSubmitForReview: _asBool(json['canSubmitForReview']),
      checklist: _asList(json['checklist'])
          .map(
            (item) => DriverProfileChecklistItemModelDto.fromJson(_asMap(item)),
          )
          .toList(growable: false),
    );
  }

  final bool isProfileComplete;
  final int completionPercent;
  final List<String> missingRequirements;
  final bool canSubmitForReview;
  final List<DriverProfileChecklistItemModelDto> checklist;
}

class DriverProfileChecklistItemModelDto {
  const DriverProfileChecklistItemModelDto({
    required this.code,
    required this.completed,
    required this.note,
    required this.critical,
  });

  factory DriverProfileChecklistItemModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverProfileChecklistItemModelDto(
      code: json['code']?.toString() ?? '',
      completed: _asBool(json['completed']),
      note: json['note']?.toString(),
      critical: _asBool(json['critical']),
    );
  }

  final String code;
  final bool completed;
  final String? note;
  final bool critical;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return const <dynamic>[];
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  if (value is num) return value != 0;
  return false;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _asDoubleOrNull(dynamic value) {
  if (value == null) return null;
  return _asDouble(value);
}
