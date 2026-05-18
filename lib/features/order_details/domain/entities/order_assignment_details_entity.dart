class OrderAssignmentDetailsEntity {
  const OrderAssignmentDetailsEntity({
    required this.assignmentId,
    required this.orderId,
    required this.orderNumber,
    required this.assignmentStatus,
    this.assignmentStatusLabel = '',
    required this.homeState,
    this.homeStateLabel = '',
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
    this.paymentMethodLabel = '',
    required this.totalAmount,
    required this.codAmount,
    required this.pickupOtpRequired,
    required this.pickupOtpStatus,
    this.pickupOtpStatusLabel = '',
    required this.deliveryOtpRequired,
    required this.deliveryOtpStatus,
    this.deliveryOtpStatusLabel = '',
    required this.pickupOtpCode,
    required this.driverArrivalState,
    this.driverArrivalStateLabel = '',
    required this.orderItems,
  });

  final String assignmentId;
  final String orderId;
  final String orderNumber;
  final String assignmentStatus;
  final String assignmentStatusLabel;
  final String homeState;
  final String homeStateLabel;
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
  final String paymentMethodLabel;
  final double totalAmount;
  final double codAmount;
  final bool pickupOtpRequired;
  final String pickupOtpStatus;
  final String pickupOtpStatusLabel;
  final bool deliveryOtpRequired;
  final String deliveryOtpStatus;
  final String deliveryOtpStatusLabel;
  final String? pickupOtpCode;
  final String driverArrivalState;
  final String driverArrivalStateLabel;
  final List<OrderAssignmentItemEntity> orderItems;

  OrderAssignmentDetailsEntity copyWith({
    String? assignmentId,
    String? orderId,
    String? orderNumber,
    String? assignmentStatus,
    String? assignmentStatusLabel,
    String? homeState,
    String? homeStateLabel,
    List<String>? allowedActions,
    String? vendorName,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? storePhone,
    String? customerName,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? customerPhone,
    String? paymentMethod,
    String? paymentMethodLabel,
    double? totalAmount,
    double? codAmount,
    bool? pickupOtpRequired,
    String? pickupOtpStatus,
    String? pickupOtpStatusLabel,
    bool? deliveryOtpRequired,
    String? deliveryOtpStatus,
    String? deliveryOtpStatusLabel,
    String? pickupOtpCode,
    bool clearPickupOtpCode = false,
    String? driverArrivalState,
    String? driverArrivalStateLabel,
    List<OrderAssignmentItemEntity>? orderItems,
  }) {
    return OrderAssignmentDetailsEntity(
      assignmentId: assignmentId ?? this.assignmentId,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      assignmentStatusLabel:
          assignmentStatusLabel ?? this.assignmentStatusLabel,
      homeState: homeState ?? this.homeState,
      homeStateLabel: homeStateLabel ?? this.homeStateLabel,
      allowedActions: allowedActions ?? this.allowedActions,
      vendorName: vendorName ?? this.vendorName,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      storePhone: storePhone ?? this.storePhone,
      customerName: customerName ?? this.customerName,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      customerPhone: customerPhone ?? this.customerPhone,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodLabel: paymentMethodLabel ?? this.paymentMethodLabel,
      totalAmount: totalAmount ?? this.totalAmount,
      codAmount: codAmount ?? this.codAmount,
      pickupOtpRequired: pickupOtpRequired ?? this.pickupOtpRequired,
      pickupOtpStatus: pickupOtpStatus ?? this.pickupOtpStatus,
      pickupOtpStatusLabel: pickupOtpStatusLabel ?? this.pickupOtpStatusLabel,
      deliveryOtpRequired: deliveryOtpRequired ?? this.deliveryOtpRequired,
      deliveryOtpStatus: deliveryOtpStatus ?? this.deliveryOtpStatus,
      deliveryOtpStatusLabel:
          deliveryOtpStatusLabel ?? this.deliveryOtpStatusLabel,
      pickupOtpCode: clearPickupOtpCode
          ? null
          : pickupOtpCode ?? this.pickupOtpCode,
      driverArrivalState: driverArrivalState ?? this.driverArrivalState,
      driverArrivalStateLabel:
          driverArrivalStateLabel ?? this.driverArrivalStateLabel,
      orderItems: orderItems ?? this.orderItems,
    );
  }
}

class OrderAssignmentItemEntity {
  const OrderAssignmentItemEntity({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.imageUrl,
    this.displaySize = '',
    this.unit = '',
    this.storeName = '',
  });

  final String name;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String imageUrl;
  final String displaySize;
  final String unit;
  final String storeName;
}
