import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

class OrderDetailsController extends ChangeNotifier {
  OrderDetailsController({
    required DriverOrderPreview order,
    required this.driverLocation,
    required bool startAccepted,
  }) : _order = order,
       _stage = startAccepted
           ? OrderDeliveryStage.accepted
           : OrderDeliveryStage.pending;

  final LatLng driverLocation;
  DriverOrderPreview _order;
  OrderAssignmentDetailsEntity? _details;

  OrderDeliveryStage _stage;

  DriverOrderPreview get order => _order;
  OrderDeliveryStage get stage => _stage;

  LatLng get storeLocation =>
      LatLng(order.pickupLatitude, order.pickupLongitude);

  LatLng get customerLocation =>
      LatLng(order.deliveryLatitude, order.deliveryLongitude);

  bool get isCashPayment =>
      _normalizedPaymentMethod == 'cashondelivery' ||
      _normalizedPaymentMethod == 'cash_on_delivery';

  bool get pickupOtpRequired =>
      _details?.pickupOtpRequired ?? order.pickupOtpRequired;

  bool get deliveryOtpRequired =>
      _details?.deliveryOtpRequired ?? order.deliveryOtpRequired;

  String? get pickupOtpCode => _details?.pickupOtpCode ?? order.pickupOtpCode;

  bool get hasPickupOtpCode => (pickupOtpCode ?? '').trim().isNotEmpty;

  bool get isWaitingForMerchantConfirmation {
    final details = _details;
    if (details == null) return false;

    final assignmentStatus = details.assignmentStatus.trim().toLowerCase();
    final allowedActions = _normalizedAllowedActions;
    final otpStatus = details.pickupOtpStatus.trim().toLowerCase();

    return assignmentStatus.contains('arrivedatvendor') ||
        assignmentStatus.contains('arrived_at_vendor') ||
        allowedActions.isEmpty && hasPickupOtpCode ||
        otpStatus == 'pending' && !canMarkPickedUp;
  }

  bool get canMarkPickedUp =>
      _normalizedAllowedActions.contains('mark_picked_up');

  bool get canShowPickupOtpSheet => hasPickupOtpCode && !canMarkPickedUp;

  bool get canMarkArrivedAtVendor =>
      _normalizedAllowedActions.contains('arrived_at_vendor');

  bool get canMarkArrivedAtCustomer =>
      _normalizedAllowedActions.contains('arrived_at_customer');

  bool get hasArrivedAtVendor =>
      _normalizedArrivalState.contains('arrived_at_vendor');

  bool get hasArrivedAtCustomer =>
      _normalizedArrivalState.contains('arrived_at_customer');

  bool get isHeadingToCustomer =>
      _normalizedArrivalState.contains('en_route_to_customer') ||
      _normalizedArrivalState.contains('customer');

  String get assignmentId => _details?.assignmentId ?? order.id;

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

  String get storePhone => order.storePhone;
  String get customerPhone => order.customerPhone;

  String get paymentMethodCode => order.paymentMethod;

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

  void applyAssignmentDetails(OrderAssignmentDetailsEntity details) {
    _details = details;
    _order = _order.copyWith(
      id: details.assignmentId,
      orderId: details.orderId,
      title: details.orderNumber,
      vendorName: details.vendorName,
      pickupAddress: details.pickupAddress,
      pickupLatitude: details.pickupLatitude,
      pickupLongitude: details.pickupLongitude,
      customerName: details.customerName,
      deliveryAddress: details.deliveryAddress,
      deliveryLatitude: details.deliveryLatitude,
      deliveryLongitude: details.deliveryLongitude,
      eta: details.assignmentStatus,
      payout: details.codAmount.toStringAsFixed(2),
      vendorInitials: _resolveInitials(details.vendorName),
      customerInitials: _resolveInitials(details.customerName),
      orderItems: details.orderItems
          .map(
            (item) => DriverOrderItemPreview(
              name: item.name,
              quantity: item.quantity,
              note: _resolveItemNote(item),
              unitPrice: item.unitPrice,
              lineTotal: item.lineTotal,
              imageUrl: item.imageUrl,
            ),
          )
          .toList(growable: false),
      storePhone: details.storePhone,
      customerPhone: details.customerPhone,
      paymentMethod: details.paymentMethod,
      pickupOtpRequired: details.pickupOtpRequired,
      deliveryOtpRequired: details.deliveryOtpRequired,
      pickupOtpCode: details.pickupOtpCode,
    );
    _stage = _resolveStageFromDetails(details);
    notifyListeners();
  }

  void updateStage(OrderDeliveryStage value) {
    if (_stage == value) return;
    _stage = value;
    notifyListeners();
  }

  String get _normalizedPaymentMethod =>
      paymentMethodCode.trim().toLowerCase().replaceAll('_', '');

  String get _normalizedArrivalState =>
      (_details?.driverArrivalState ?? '').trim().toLowerCase();

  Set<String> get _normalizedAllowedActions =>
      (_details?.allowedActions ?? const <String>[])
          .map((action) => action.trim().toLowerCase())
          .toSet();

  String _resolveItemNote(OrderAssignmentItemEntity item) {
    if (item.quantity <= 0) return '';

    final unit = item.unitPrice.toStringAsFixed(2);
    final total = item.lineTotal.toStringAsFixed(2);
    return '$unit x ${item.quantity} = $total';
  }

  String _resolveInitials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  OrderDeliveryStage _resolveStageFromDetails(
    OrderAssignmentDetailsEntity details,
  ) {
    final assignmentStatus = details.assignmentStatus.trim().toLowerCase();
    final pickupOtpStatus = details.pickupOtpStatus.trim().toLowerCase();
    final deliveryOtpStatus = details.deliveryOtpStatus.trim().toLowerCase();
    final arrivalState = details.driverArrivalState.trim().toLowerCase();
    final allowedActions = details.allowedActions
        .map((action) => action.trim().toLowerCase())
        .toSet();

    if (assignmentStatus.contains('deliver') ||
        assignmentStatus.contains('complete')) {
      return OrderDeliveryStage.delivered;
    }

    if (allowedActions.contains('confirm_delivery') ||
        allowedActions.contains('delivery_otp') ||
        allowedActions.contains('verify_delivery_otp') ||
        allowedActions.contains('mark_delivered') ||
        deliveryOtpStatus == 'pending' ||
        arrivalState.contains('customer')) {
      return OrderDeliveryStage.onTheWay;
    }

    if (allowedActions.contains('mark_on_the_way') ||
        allowedActions.contains('start_delivery') ||
        allowedActions.contains('picked_up') ||
        assignmentStatus.contains('pickedup') ||
        assignmentStatus.contains('picked_up') ||
        assignmentStatus.contains('ontheway') ||
        assignmentStatus.contains('on_the_way') ||
        pickupOtpStatus == 'verified' ||
        pickupOtpStatus == 'completed') {
      return OrderDeliveryStage.pickedUp;
    }

    if (allowedActions.contains('arrived_at_vendor') ||
        allowedActions.contains('mark_picked_up') ||
        allowedActions.isEmpty &&
            (details.pickupOtpCode ?? '').trim().isNotEmpty ||
        details.pickupOtpRequired) {
      return OrderDeliveryStage.accepted;
    }

    return OrderDeliveryStage.pending;
  }
}

enum OrderDeliveryStage { pending, accepted, pickedUp, onTheWay, delivered }
