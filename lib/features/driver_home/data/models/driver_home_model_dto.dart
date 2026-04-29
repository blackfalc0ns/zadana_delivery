class DriverHomeModelDto {
  const DriverHomeModelDto({
    required this.homeState,
    required this.operationalStatus,
    required this.currentOffer,
    required this.currentAssignment,
    required this.earningsSummaryToday,
    required this.unreadAlerts,
  });

  factory DriverHomeModelDto.fromJson(Map<String, dynamic> json) {
    final currentOfferJson = _asMap(json['currentOffer']);
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
      currentAssignment: json['currentAssignment'] == null
          ? null
          : DriverHomeAssignmentModelDto.fromJson(
              _asMap(json['currentAssignment']),
            ),
      earningsSummaryToday: earningsJson.isEmpty
          ? null
          : DriverHomeEarningsModelDto.fromJson(earningsJson),
      unreadAlerts: _asInt(json['unreadAlerts']),
    );
  }

  final String homeState;
  final DriverHomeOperationalStatusModelDto operationalStatus;
  final DriverHomeOfferModelDto? currentOffer;
  final DriverHomeAssignmentModelDto? currentAssignment;
  final DriverHomeEarningsModelDto? earningsSummaryToday;
  final int unreadAlerts;
}

class DriverHomeOperationalStatusModelDto {
  const DriverHomeOperationalStatusModelDto({
    required this.isOperational,
    required this.canReceiveOrders,
    required this.isAvailable,
    required this.verificationStatus,
    required this.accountStatus,
    required this.zoneName,
    required this.commitmentScore,
    required this.canReceiveOffers,
    required this.restrictionMessage,
    required this.message,
    this.canGoAvailable,
  });

  factory DriverHomeOperationalStatusModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverHomeOperationalStatusModelDto(
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
      canReceiveOffers: _asBool(json['canReceiveOffers']),
      restrictionMessage: json['restrictionMessage']?.toString(),
      message: json['message']?.toString() ?? '',
    );
  }

  final bool isOperational;
  final bool canReceiveOrders;
  final bool isAvailable;
  final bool? canGoAvailable;
  final String verificationStatus;
  final String accountStatus;
  final String zoneName;
  final double? commitmentScore;
  final bool canReceiveOffers;
  final String? restrictionMessage;
  final String message;
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
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
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
      status: json['status']?.toString() ?? '',
      vendorName: json['vendorName']?.toString() ?? '',
      pickupAddress: json['pickupAddress']?.toString() ?? '',
      deliveryAddress: json['deliveryAddress']?.toString() ?? '',
      pickupLatitude: _asDouble(json['pickupLatitude']),
      pickupLongitude: _asDouble(json['pickupLongitude']),
      deliveryLatitude: _asDouble(json['deliveryLatitude']),
      deliveryLongitude: _asDouble(json['deliveryLongitude']),
      codAmount: _asDouble(json['codAmount']),
      createdAtUtc: json['createdAtUtc']?.toString() ?? '',
      merchantContact: json['merchantContact']?.toString() ?? '',
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
  final String pickupAddress;
  final String deliveryAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final double deliveryLatitude;
  final double deliveryLongitude;
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
