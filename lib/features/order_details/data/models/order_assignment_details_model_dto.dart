class OrderAssignmentDetailsModelDto {
  const OrderAssignmentDetailsModelDto({
    required this.assignmentId,
    required this.orderId,
    required this.orderNumber,
    required this.assignmentStatus,
    required this.homeState,
    required this.allowedActions,
    required this.vendorName,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.storePhone,
    required this.customerName,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.customerPhone,
    required this.paymentMethod,
    required this.codAmount,
    required this.pickupOtpRequired,
    required this.pickupOtpStatus,
    required this.deliveryOtpRequired,
    required this.deliveryOtpStatus,
    required this.pickupOtpCode,
    required this.driverArrivalState,
    required this.orderItems,
  });

  factory OrderAssignmentDetailsModelDto.fromJson(Map<String, dynamic> json) {
    return OrderAssignmentDetailsModelDto(
      assignmentId: json['assignmentId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      assignmentStatus: json['assignmentStatus']?.toString() ?? '',
      homeState: json['homeState']?.toString() ?? '',
      allowedActions: _asList(
        json['allowedActions'],
      ).map((item) => item.toString()).toList(growable: false),
      vendorName: json['vendorName']?.toString() ?? '',
      pickupAddress: json['pickupAddress']?.toString() ?? '',
      pickupLatitude: _asDouble(json['pickupLatitude']),
      pickupLongitude: _asDouble(json['pickupLongitude']),
      storePhone: json['storePhone']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      deliveryAddress: json['deliveryAddress']?.toString() ?? '',
      deliveryLatitude: _asDouble(json['deliveryLatitude']),
      deliveryLongitude: _asDouble(json['deliveryLongitude']),
      customerPhone: json['customerPhone']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      codAmount: _asDouble(json['codAmount']),
      pickupOtpRequired: _asBool(json['pickupOtpRequired']),
      pickupOtpStatus: json['pickupOtpStatus']?.toString() ?? '',
      deliveryOtpRequired: _asBool(json['deliveryOtpRequired']),
      deliveryOtpStatus: json['deliveryOtpStatus']?.toString() ?? '',
      pickupOtpCode: json['pickupOtpCode']?.toString(),
      driverArrivalState: json['driverArrivalState']?.toString() ?? '',
      orderItems: _asList(json['orderItems'])
          .map((item) => OrderAssignmentItemModelDto.fromJson(_asMap(item)))
          .toList(growable: false),
    );
  }

  final String assignmentId;
  final String orderId;
  final String orderNumber;
  final String assignmentStatus;
  final String homeState;
  final List<String> allowedActions;
  final String vendorName;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String storePhone;
  final String customerName;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String customerPhone;
  final String paymentMethod;
  final double codAmount;
  final bool pickupOtpRequired;
  final String pickupOtpStatus;
  final bool deliveryOtpRequired;
  final String deliveryOtpStatus;
  final String? pickupOtpCode;
  final String driverArrivalState;
  final List<OrderAssignmentItemModelDto> orderItems;
}

class OrderAssignmentItemModelDto {
  const OrderAssignmentItemModelDto({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.imageUrl,
  });

  factory OrderAssignmentItemModelDto.fromJson(Map<String, dynamic> json) {
    return OrderAssignmentItemModelDto(
      name: json['name']?.toString() ?? '',
      quantity: _asInt(json['quantity']),
      unitPrice: _asDouble(json['unitPrice']),
      lineTotal: _asDouble(json['lineTotal']),
      imageUrl:
          json['imageUrl']?.toString() ??
          json['image']?.toString() ??
          json['thumbnailUrl']?.toString() ??
          json['photoUrl']?.toString() ??
          '',
    );
  }

  final String name;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String imageUrl;
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
