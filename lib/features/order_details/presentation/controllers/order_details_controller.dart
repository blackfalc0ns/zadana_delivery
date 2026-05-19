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
  bool _hasArrivedAtCustomerOverride = false;

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
    if (details == null || _isPastMerchantPickupStep) return false;
    if (canVerifyPickupOtp || canMarkPickedUp || hasPickupOtpCode) return false;

    final assignmentStatus = details.assignmentStatus.trim().toLowerCase();
    final otpStatus = details.pickupOtpStatus.trim().toLowerCase();
    final arrivedAtVendor =
        hasArrivedAtVendor ||
        assignmentStatus.contains('arrivedatvendor') ||
        assignmentStatus.contains('arrived_at_vendor');

    return arrivedAtVendor && otpStatus == 'pending';
  }

  bool get canMarkPickedUp =>
      stage == OrderDeliveryStage.arrivedAtVendor &&
      (!pickupOtpRequired || _normalizedAllowedActions.contains('mark_picked_up'));

  bool get canShowPickupOtpSheet =>
      stage == OrderDeliveryStage.arrivedAtVendor && hasPickupOtpCode;

  bool get canVerifyPickupOtp =>
      stage == OrderDeliveryStage.arrivedAtVendor &&
      pickupOtpRequired &&
      (hasPickupOtpCode || _normalizedAllowedActions.contains('verify_pickup_otp'));

  bool get canMarkArrivedAtVendor => stage == OrderDeliveryStage.accepted;

  bool get canMarkArrivedAtCustomer =>
      stage == OrderDeliveryStage.onTheWay && !hasArrivedAtCustomer;

  bool get hasArrivedAtVendor =>
      stage.index >= OrderDeliveryStage.arrivedAtVendor.index ||
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
      _hasArrivedAtCustomerOverride ||
      stage == OrderDeliveryStage.delivered ||
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

  /// Server-localized payment method label (e.g. "الدفع عند الاستلام").
  /// Falls back to empty string if not available.
  String get paymentMethodLabel => _details?.paymentMethodLabel ?? '';

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
      vendorImageUrl: details.vendorImageUrl,
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
              displaySize: item.displaySize,
              unit: item.unit,
              storeName: item.storeName,
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
    _hasArrivedAtCustomerOverride =
        _stage == OrderDeliveryStage.delivered ||
        details.driverArrivalState.trim().toLowerCase().contains(
          'arrived_at_customer',
        );
    _loadMarkerIcons();
    notifyListeners();
  }

  void updateStage(OrderDeliveryStage value) {
    if (_stage == value) return;
    _stage = value;
    if (value.index < OrderDeliveryStage.onTheWay.index) {
      _hasArrivedAtCustomerOverride = false;
    }
    if (value == OrderDeliveryStage.delivered) {
      _hasArrivedAtCustomerOverride = true;
    }
    notifyListeners();
  }

  void applyLocalStageTransition(OrderDeliveryStage nextStage) {
    if (_details != null) {
      switch (nextStage) {
        case OrderDeliveryStage.pending:
          break;
        case OrderDeliveryStage.accepted:
          _details = _details!.copyWith(
            assignmentStatus: 'accepted',
            driverArrivalState: '',
            allowedActions: const <String>['arrived_at_vendor'],
          );
          break;
        case OrderDeliveryStage.arrivedAtVendor:
          _details = _details!.copyWith(
            assignmentStatus: 'arrived_at_vendor',
            driverArrivalState: 'arrived_at_vendor',
            allowedActions: pickupOtpRequired
                ? (hasPickupOtpCode
                      ? const <String>['verify_pickup_otp']
                      : const <String>[])
                : const <String>['mark_picked_up'],
          );
          break;
        case OrderDeliveryStage.pickedUp:
          _details = _details!.copyWith(
            assignmentStatus: 'picked_up',
            pickupOtpStatus: pickupOtpRequired
                ? 'verified'
                : _details!.pickupOtpStatus,
            allowedActions: const <String>['mark_on_the_way'],
          );
          break;
        case OrderDeliveryStage.onTheWay:
          _details = _details!.copyWith(
            assignmentStatus: 'on_the_way',
            driverArrivalState: 'en_route_to_customer',
            allowedActions: const <String>['arrived_at_customer'],
          );
          break;
        case OrderDeliveryStage.delivered:
          _details = _details!.copyWith(
            assignmentStatus: 'delivered',
            deliveryOtpStatus: deliveryOtpRequired
                ? 'verified'
                : _details!.deliveryOtpStatus,
            allowedActions: const <String>[],
          );
          break;
      }
    }
    _stage = nextStage;
    if (nextStage.index < OrderDeliveryStage.onTheWay.index) {
      _hasArrivedAtCustomerOverride = false;
    }
    if (nextStage == OrderDeliveryStage.delivered) {
      _hasArrivedAtCustomerOverride = true;
    }
    notifyListeners();
  }

  void markArrivedAtCustomer() {
    if (_details != null) {
      _details = _details!.copyWith(
        driverArrivalState: 'arrived_at_customer',
        allowedActions: deliveryOtpRequired
            ? const <String>['verify_delivery_otp']
            : const <String>['confirm_delivery'],
      );
    }
    _hasArrivedAtCustomerOverride = true;
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

  String _normalizeStatusToken(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  bool _hasNormalizedStatus(String value, Set<String> candidates) {
    return candidates.contains(value);
  }

  OrderDeliveryStage _resolveStageFromDetails(
    OrderAssignmentDetailsEntity details,
  ) {
    final assignmentStatus = details.assignmentStatus.trim().toLowerCase();
    final normalizedAssignmentStatus = _normalizeStatusToken(
      details.assignmentStatus,
    );
    final homeState = details.homeState.trim().toLowerCase();
    final pickupOtpStatus = details.pickupOtpStatus.trim().toLowerCase();
    final deliveryOtpStatus = details.deliveryOtpStatus.trim().toLowerCase();
    final arrivalState = details.driverArrivalState.trim().toLowerCase();
    final allowedActions = details.allowedActions
        .map((action) => action.trim().toLowerCase())
        .toSet();
    final isOnMission =
        homeState.contains('onmission') ||
        assignmentStatus.contains('onmission');
    final hasOfferDecision =
        allowedActions.contains('accept_offer') ||
        allowedActions.contains('reject_offer') ||
        assignmentStatus.contains('offersent') ||
        assignmentStatus.contains('offer_sent');

    if (_hasNormalizedStatus(normalizedAssignmentStatus, const {
          'delivered',
          'deliveryfailed',
          'failed',
          'cancelled',
          'canceled',
          'completed',
        }) ||
        assignmentStatus.contains('deliver') ||
        assignmentStatus.contains('fail') ||
        assignmentStatus.contains('cancel') ||
        assignmentStatus.contains('complete')) {
      return OrderDeliveryStage.delivered;
    }

    final hasCustomerDeliveryStep =
        allowedActions.contains('arrived_at_customer') ||
        allowedActions.contains('verify_delivery_otp') ||
        allowedActions.contains('confirm_delivery') ||
        allowedActions.contains('delivery_otp') ||
        deliveryOtpStatus == 'pending' ||
        _hasNormalizedStatus(normalizedAssignmentStatus, const {
          'ontheway',
          'outfordelivery',
          'arrivedatcustomer',
        }) ||
        assignmentStatus.contains('arrivedatcustomer') ||
        assignmentStatus.contains('arrived_at_customer') ||
        arrivalState.contains('arrived_at_customer');
    if (hasCustomerDeliveryStep ||
        (arrivalState == 'en_route' &&
            allowedActions.contains('arrived_at_customer'))) {
      return OrderDeliveryStage.onTheWay;
    }

    final hasArrivedAtVendor =
        arrivalState.contains('arrived_at_vendor') ||
        _hasNormalizedStatus(normalizedAssignmentStatus, const {
          'arrivedatvendor',
        }) ||
        assignmentStatus.contains('arrived_at_vendor') ||
        assignmentStatus.contains('arrivedatvendor');
    if (hasArrivedAtVendor ||
        allowedActions.contains('verify_pickup_otp') ||
        allowedActions.contains('mark_picked_up')) {
      return OrderDeliveryStage.arrivedAtVendor;
    }

    if (allowedActions.contains('mark_on_the_way') ||
        _hasNormalizedStatus(normalizedAssignmentStatus, const {'pickedup'}) ||
        assignmentStatus.contains('pickedup') ||
        assignmentStatus.contains('picked_up') ||
        assignmentStatus.contains('ontheway') ||
        assignmentStatus.contains('on_the_way') ||
        pickupOtpStatus == 'verified' ||
        pickupOtpStatus == 'completed') {
      return OrderDeliveryStage.pickedUp;
    }

    if (hasOfferDecision) {
      return OrderDeliveryStage.pending;
    }

    if (allowedActions.contains('arrived_at_vendor') ||
        _hasNormalizedStatus(normalizedAssignmentStatus, const {
          'accepted',
          'driverassigned',
          'preparing',
        }) ||
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
