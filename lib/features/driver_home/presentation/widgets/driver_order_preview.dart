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
}

class DriverOrderItemPreview {
  const DriverOrderItemPreview({
    required this.name,
    required this.quantity,
    this.note,
  });

  final String name;
  final int quantity;
  final String? note;
}
