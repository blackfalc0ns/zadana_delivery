import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_marker_factory.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_screen_data.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_accept_order_dialog.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_connection_switch.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_overlay.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_view.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_orders_sheet.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final _locationPermissionService = LocationPermissionService();
  final Map<String, BitmapDescriptor> _pickupMarkerIcons = {};
  GoogleMapController? _mapController;
  BitmapDescriptor? _driverMarkerIcon;
  late List<DriverOrderPreview> _orders;
  bool _isOnline = true;
  bool _isMyLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _orders = driverHomeMockOrders;
    _loadMarkers();
    _loadDriverMarker();
    _enableMyLocation();
  }

  Future<void> _loadDriverMarker() async {
    final icon = await DriverHomeMarkerFactory.buildDriverMarker();
    if (!mounted) return;
    setState(() => _driverMarkerIcon = icon);
  }

  Future<void> _enableMyLocation() async {
    try {
      await _locationPermissionService.checkAndRequestPermission();
      if (!mounted) return;
      setState(() => _isMyLocationEnabled = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isMyLocationEnabled = false);
    }
  }

  Future<void> _loadMarkers() async {
    if (_orders.isEmpty) {
      if (!mounted) return;
      setState(_pickupMarkerIcons.clear);
      return;
    }
    final icons = <String, BitmapDescriptor>{};
    for (final order in _orders) {
      icons[order.id] = await DriverHomeMarkerFactory.buildPickupMarker(
        marketName: order.vendorName,
      );
    }
    if (!mounted) return;
    setState(() {
      _pickupMarkerIcons
        ..clear()
        ..addAll(icons);
    });
  }

  void _removeOrder(String id) {
    setState(() {
      _orders = _orders.where((order) => order.id != id).toList();
      _pickupMarkerIcons.remove(id);
    });
  }

  Future<bool> _showAcceptOrderDialog(DriverOrderPreview order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DriverHomeAcceptOrderDialog(
        order: order,
        dialogContext: dialogContext,
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _acceptOrderFromCard(DriverOrderPreview order) async {
    final confirmed = await _showAcceptOrderDialog(order);
    if (!mounted || !confirmed) return;
    await _openOrderDetails(order, startAccepted: true);
  }

  Future<void> _openOrderDetails(
    DriverOrderPreview order, {
    bool startAccepted = false,
  }) async {
    final result = await context.pushNamed(
      AppRoutes.orderDetails,
      arguments: {
        'order': order,
        'driverLocation': driverHomeMockDriverLocation,
        'startAccepted': startAccepted,
      },
    );
    if (!mounted || result is! String) return;
    if (result == 'accept' || result == 'reject') _removeOrder(order.id);
  }

  void _onMapCreated(GoogleMapController controller) =>
      _mapController = controller;

  Future<void> _animateToLocation(LatLng location) async {
    if (_mapController == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16.5, tilt: 45.0),
      ),
    );
  }

  Set<Marker> get _markers => {
    Marker(
      markerId: const MarkerId('driver_location'),
      position: driverHomeMockDriverLocation,
      icon:
          _driverMarkerIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'موقعي الحالي'),
    ),
    ..._orders.map(
      (order) => Marker(
        markerId: MarkerId('pickup_${order.id}'),
        position: LatLng(order.pickupLatitude, order.pickupLongitude),
        icon:
            _pickupMarkerIcons[order.id] ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: order.vendorName),
      ),
    ),
    ..._orders.map(
      (order) => Marker(
        markerId: MarkerId('delivery_${order.id}'),
        position: LatLng(order.deliveryLatitude, order.deliveryLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'توصيل: ${order.customerName}'),
      ),
    ),
  };

  Set<Circle> get _circles => {
    Circle(
      circleId: const CircleId('driver_area'),
      center: driverHomeMockDriverLocation,
      radius: 120,
      fillColor: context.colorScheme.primary.withValues(alpha: 0.16),
      strokeColor: context.colorScheme.primary.withValues(alpha: 0.34),
      strokeWidth: 2,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DriverHomeMapView(
            initialCameraPosition: driverHomeInitialCameraPosition,
            onMapCreated: _onMapCreated,
            markers: _markers,
            circles: _circles,
            isMyLocationEnabled: _isMyLocationEnabled,
          ),
          const DriverHomeMapOverlay(),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.sm),
                child: DriverHomeConnectionSwitch(
                  isOnline: _isOnline,
                  onChanged: (value) => setState(() => _isOnline = value),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.1,
            maxChildSize: 0.9,
            builder: (context, scrollController) => DriverHomeOrdersSheet(
              orders: _orders,
              scrollController: scrollController,
              onRemoveOrder: _removeOrder,
              onOpenOrder: _openOrderDetails,
              onAcceptOrder: _acceptOrderFromCard,
              onFocusLocation: (order) => _animateToLocation(
                LatLng(order.deliveryLatitude, order.deliveryLongitude),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
