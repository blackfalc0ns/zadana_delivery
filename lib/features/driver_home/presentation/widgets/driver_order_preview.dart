class DriverOrderPreview {
  const DriverOrderPreview({
    required this.id,
    required this.title,
    required this.vendorName,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.customerName,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.distance,
    required this.eta,
    required this.payout,
    required this.vendorInitials,
    required this.customerInitials,
    this.orderItems = const [],
    this.packageNote,
    this.countdownSeconds = 60,
    this.orderId = '',
    this.storePhone = '',
    this.customerPhone = '',
    this.paymentMethod = '',
    this.pickupOtpRequired = false,
    this.deliveryOtpRequired = false,
  });

  final String id;
  final String title;
  final String vendorName;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String customerName;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String distance;
  final String eta;
  final String payout;
  final String vendorInitials;
  final String customerInitials;
  final List<DriverOrderItemPreview> orderItems;
  final String? packageNote;
  final int countdownSeconds;
  final String orderId;
  final String storePhone;
  final String customerPhone;
  final String paymentMethod;
  final bool pickupOtpRequired;
  final bool deliveryOtpRequired;

  DriverOrderPreview copyWith({
    String? id,
    String? title,
    String? vendorName,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? customerName,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? distance,
    String? eta,
    String? payout,
    String? vendorInitials,
    String? customerInitials,
    List<DriverOrderItemPreview>? orderItems,
    String? packageNote,
    int? countdownSeconds,
    String? orderId,
    String? storePhone,
    String? customerPhone,
    String? paymentMethod,
    bool? pickupOtpRequired,
    bool? deliveryOtpRequired,
  }) {
    return DriverOrderPreview(
      id: id ?? this.id,
      title: title ?? this.title,
      vendorName: vendorName ?? this.vendorName,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      customerName: customerName ?? this.customerName,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      distance: distance ?? this.distance,
      eta: eta ?? this.eta,
      payout: payout ?? this.payout,
      vendorInitials: vendorInitials ?? this.vendorInitials,
      customerInitials: customerInitials ?? this.customerInitials,
      orderItems: orderItems ?? this.orderItems,
      packageNote: packageNote ?? this.packageNote,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      orderId: orderId ?? this.orderId,
      storePhone: storePhone ?? this.storePhone,
      customerPhone: customerPhone ?? this.customerPhone,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupOtpRequired: pickupOtpRequired ?? this.pickupOtpRequired,
      deliveryOtpRequired: deliveryOtpRequired ?? this.deliveryOtpRequired,
    );
  }
}

class DriverOrderItemPreview {
  const DriverOrderItemPreview({
    required this.name,
    required this.quantity,
    this.note,
    this.unitPrice,
    this.lineTotal,
    this.imageUrl,
  });

  final String name;
  final int quantity;
  final String? note;
  final double? unitPrice;
  final double? lineTotal;
  final String? imageUrl;
}
