import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_marker_factory.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

class OrderDetailsController extends ChangeNotifier {
  OrderDetailsController({
    required DriverOrderPreview order,
    required this.driverLocation,
    required bool startAccepted,
    required this.storeMarkerLabel,
    required this.customerMarkerLabel,
  }) : _order = order,
       _stage = startAccepted
           ? OrderDeliveryStage.accepted
           : OrderDeliveryStage.pending {
    _loadMarkerIcons();
  }

  final LatLng driverLocation;
  final String storeMarkerLabel;
  final String customerMarkerLabel;
  DriverOrderPreview _order;
  OrderAssignmentDetailsEntity? _details;
  BitmapDescriptor? _storeMarkerIcon;
  BitmapDescriptor? _customerMarkerIcon;
  bool _isDisposed = false;
  int _markerLoadVersion = 0;
  String? _lastStoreMarkerKey;
  String? _lastCustomerMarkerKey;

  OrderDeliveryStage _stage;

  DriverOrderPreview get order => _order;
  OrderDeliveryStage get stage => _stage;

  LatLng get storeLocation =>
      LatLng(order.pickupLatitude, order.pickupLongitude);

  LatLng get customerLocation =>
      LatLng(order.deliveryLatitude, order.deliveryLongitude);

  bool get isCashPayment => (order.codAmount > 0);

  bool get pickupOtpRequired =>
      _details?.pickupOtpRequired ?? order.pickupOtpRequired;

  bool get deliveryOtpRequired =>
      _details?.deliveryOtpRequired ?? order.deliveryOtpRequired;

  String? get pickupOtpCode =>
      _details != null ? _details!.pickupOtpCode : order.pickupOtpCode;

  bool get hasPickupOtpCode => (pickupOtpCode ?? '').trim().isNotEmpty;

  bool get isWaitingForMerchantConfirmation {
    final details = _details;
    if (details == null) return false;
    if (_isPastMerchantPickupStep) return false;

    final assignmentStatus = details.assignmentStatus.trim().toLowerCase();
    final otpStatus = details.pickupOtpStatus.trim().toLowerCase();
    final arrivedAtVendor =
        hasArrivedAtVendor ||
        assignmentStatus.contains('arrivedatvendor') ||
        assignmentStatus.contains('arrived_at_vendor');

    if (!arrivedAtVendor) {
      return false;
    }

    return otpStatus == 'pending' || (!canMarkPickedUp && hasPickupOtpCode);
  }

  bool get canMarkPickedUp =>
      _normalizedAllowedActions.contains('mark_picked_up');

  bool get canShowPickupOtpSheet =>
      !_isPastMerchantPickupStep && hasPickupOtpCode && !canMarkPickedUp;

  bool get canVerifyPickupOtp =>
      !_isPastMerchantPickupStep &&
      pickupOtpRequired &&
      _normalizedAllowedActions.contains('verify_pickup_otp');

  bool get canMarkArrivedAtVendor =>
      _normalizedAllowedActions.contains('arrived_at_vendor');

  bool get canMarkArrivedAtCustomer =>
      _normalizedAllowedActions.contains('arrived_at_customer');

  bool get hasArrivedAtVendor =>
      _normalizedArrivalState.contains('arrived_at_vendor') ||
      (_details?.assignmentStatus.trim().toLowerCase().contains(
            'arrived_at_vendor',
          ) ??
          false) ||
      (_details?.assignmentStatus.trim().toLowerCase().contains(
            'arrivedatvendor',
          ) ??
          false);

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
    OrderDeliveryStage.arrivedAtVendor => 1,
    OrderDeliveryStage.pickedUp => 2,
    OrderDeliveryStage.onTheWay => 3,
    OrderDeliveryStage.delivered => 4,
  };

  Set<Marker> get markers => {
    Marker(
      markerId: const MarkerId('store'),
      position: storeLocation,
      infoWindow: InfoWindow(title: order.vendorName, snippet: 'Store'),
      icon:
          _storeMarkerIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
    Marker(
      markerId: const MarkerId('customer'),
      position: customerLocation,
      infoWindow: InfoWindow(title: order.customerName, snippet: 'Customer'),
      icon:
          _customerMarkerIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  };

  Future<void> _loadMarkerIcons() async {
    final storeKey = '${order.vendorName}|$storeMarkerLabel';
    final customerKey = '${order.customerName}|$customerMarkerLabel';
    final shouldReuseExistingIcons =
        _storeMarkerIcon != null &&
        _customerMarkerIcon != null &&
        storeKey == _lastStoreMarkerKey &&
        customerKey == _lastCustomerMarkerKey;
    if (shouldReuseExistingIcons) {
      return;
    }

    final requestVersion = ++_markerLoadVersion;
    final storeIcon = await DriverHomeMarkerFactory.buildStoreMarker(
      storeName: order.vendorName,
      markerLabel: storeMarkerLabel,
    );
    final customerIcon = await DriverHomeMarkerFactory.buildCustomerMarker(
      customerName: order.customerName,
      markerLabel: customerMarkerLabel,
    );

    if (_isDisposed || requestVersion != _markerLoadVersion) {
      return;
    }
    _storeMarkerIcon = storeIcon;
    _customerMarkerIcon = customerIcon;
    _lastStoreMarkerKey = storeKey;
    _lastCustomerMarkerKey = customerKey;
    notifyListeners();
  }

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
      totalAmount: details.totalAmount,
      codAmount: details.codAmount,
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
      clearPickupOtpCode: details.pickupOtpCode == null,
    );
    _stage = _resolveStageFromDetails(details);
    _loadMarkerIcons();
    notifyListeners();
  }

  void updateStage(OrderDeliveryStage value) {
    if (_stage == value) return;
    _stage = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  String get _normalizedArrivalState =>
      (_details?.driverArrivalState ?? '').trim().toLowerCase();

  Set<String> get _normalizedAllowedActions =>
      (_details?.allowedActions ?? const <String>[])
          .map((action) => action.trim().toLowerCase())
          .toSet();

  bool get _isPastMerchantPickupStep {
    return stage.index >= OrderDeliveryStage.pickedUp.index;
  }

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
    final homeState = details.homeState.trim().toLowerCase();
    final pickupOtpStatus = details.pickupOtpStatus.trim().toLowerCase();
    final deliveryOtpStatus = details.deliveryOtpStatus.trim().toLowerCase();
    final arrivalState = details.driverArrivalState.trim().toLowerCase();
    final allowedActions = details.allowedActions
        .map((action) => action.trim().toLowerCase())
        .toSet();
    final isOnMission =
        homeState.contains('onmission') || assignmentStatus.contains('onmission');
    final hasOfferDecision =
        allowedActions.contains('accept_offer') ||
        allowedActions.contains('reject_offer') ||
        assignmentStatus.contains('offersent') ||
        assignmentStatus.contains('offer_sent');

    if (assignmentStatus.contains('deliver') ||
        assignmentStatus.contains('fail') ||
        assignmentStatus.contains('cancel') ||
        assignmentStatus.contains('complete')) {
      return OrderDeliveryStage.delivered;
    }

    if (allowedActions.contains('arrived_at_customer') ||
        allowedActions.contains('verify_delivery_otp') ||
        allowedActions.contains('confirm_delivery') ||
        allowedActions.contains('delivery_otp') ||
        deliveryOtpStatus == 'pending' ||
        assignmentStatus.contains('arrivedatcustomer') ||
        assignmentStatus.contains('arrived_at_customer') ||
        arrivalState.contains('customer')) {
      return OrderDeliveryStage.onTheWay;
    }

    if (allowedActions.contains('mark_on_the_way') ||
        assignmentStatus.contains('pickedup') ||
        assignmentStatus.contains('picked_up') ||
        assignmentStatus.contains('ontheway') ||
        assignmentStatus.contains('on_the_way') ||
        pickupOtpStatus == 'verified' ||
        pickupOtpStatus == 'completed') {
      return OrderDeliveryStage.pickedUp;
    }

    if (arrivalState.contains('arrived_at_vendor') ||
        assignmentStatus.contains('arrived_at_vendor') ||
        (isOnMission &&
            (pickupOtpStatus == 'pending' || details.pickupOtpRequired)) ||
        assignmentStatus.contains('arrivedatvendor')) {
      return OrderDeliveryStage.arrivedAtVendor;
    }

    if (hasOfferDecision) {
      return OrderDeliveryStage.pending;
    }

    if (allowedActions.contains('arrived_at_vendor') ||
        assignmentStatus.contains('accepted') ||
        isOnMission ||
        details.pickupOtpRequired) {
      return OrderDeliveryStage.accepted;
    }

    return OrderDeliveryStage.pending;
  }
}

enum OrderDeliveryStage {
  pending,
  accepted,
  arrivedAtVendor,
  pickedUp,
  onTheWay,
  delivered,
}
