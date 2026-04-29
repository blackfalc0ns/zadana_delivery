class OrderAssignmentDetailsEntity {
  const OrderAssignmentDetailsEntity({
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
  final List<OrderAssignmentItemEntity> orderItems;
}

class OrderAssignmentItemEntity {
  const OrderAssignmentItemEntity({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.imageUrl,
  });

  final String name;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String imageUrl;
}
