import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

class OrderDetailsController extends ChangeNotifier {
  OrderDetailsController({
    required this.order,
    required this.driverLocation,
    required bool startAccepted,
  }) : _stage = startAccepted
           ? OrderDeliveryStage.accepted
           : OrderDeliveryStage.pending;

  final DriverOrderPreview order;
  final LatLng driverLocation;

  OrderDeliveryStage _stage;

  OrderDeliveryStage get stage => _stage;

  LatLng get storeLocation =>
      LatLng(order.pickupLatitude, order.pickupLongitude);

  LatLng get customerLocation =>
      LatLng(order.deliveryLatitude, order.deliveryLongitude);

  bool get isCashPayment =>
      int.tryParse(order.id) == null ? false : int.parse(order.id).isOdd;

  String get pickupOtp {
    final orderNumber = int.tryParse(order.id) ?? 1234;
    return (((orderNumber * 37) % 9000) + 1000).toString();
  }

  List<DriverOrderItemPreview> get orderItems {
    if (order.orderItems.isNotEmpty) return order.orderItems;
    return [
      DriverOrderItemPreview(
        name: 'طلب جاهز من ${order.vendorName}',
        quantity: 1,
        note: 'التسليم حسب الفاتورة من المتجر',
      ),
      const DriverOrderItemPreview(name: 'شنطة تغليف', quantity: 1),
    ];
  }

  String get storePhone => '01012345678';
  String get customerPhone => '01098765432';

  bool get showStoreRouteFirst =>
      stage.index < OrderDeliveryStage.onTheWay.index;

  int get activeStatusIndex => switch (stage) {
    OrderDeliveryStage.pending => -1,
    OrderDeliveryStage.accepted => 0,
    OrderDeliveryStage.pickedUp => 1,
    OrderDeliveryStage.onTheWay => 2,
    OrderDeliveryStage.delivered => 3,
  };

  Set<Marker> get markers => {
    Marker(
      markerId: const MarkerId('store'),
      position: storeLocation,
      infoWindow: InfoWindow(title: order.vendorName),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
    Marker(
      markerId: const MarkerId('customer'),
      position: customerLocation,
      infoWindow: InfoWindow(title: order.customerName),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  };

  void updateStage(OrderDeliveryStage value) {
    if (_stage == value) return;
    _stage = value;
    notifyListeners();
  }
}

enum OrderDeliveryStage { pending, accepted, pickedUp, onTheWay, delivered }
