import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_cubit.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_event.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_state.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_marker_factory.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_accept_order_dialog.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_connection_switch.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_overlay.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_view.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_status_panel.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  static const CameraPosition _fallbackCameraPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 11.8,
  );
  static const double _topContentOffset = 18;

  final _locationPermissionService = LocationPermissionService();
  late final DriverHomeCubit _cubit;
  GoogleMapController? _mapController;
  BitmapDescriptor? _driverMarkerIcon;
  BitmapDescriptor? _pickupMarkerIcon;
  bool _isMyLocationEnabled = false;
  LatLng? _driverLocation;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverHomeCubit>()..doIntent(const DriverHomeLoadEvent());
    _loadDriverMarker();
    _enableMyLocation();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _loadDriverMarker() async {
    final icon = await DriverHomeMarkerFactory.buildDriverMarker();
    if (!mounted) return;
    setState(() => _driverMarkerIcon = icon);
  }

  Future<void> _loadPickupMarker(String marketName) async {
    final icon = await DriverHomeMarkerFactory.buildPickupMarker(
      marketName: marketName,
    );
    if (!mounted) return;
    setState(() => _pickupMarkerIcon = icon);
  }

  Future<void> _enableMyLocation() async {
    try {
      await _locationPermissionService.checkAndRequestPermission();
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      final location = LatLng(position.latitude, position.longitude);
      setState(() {
        _isMyLocationEnabled = true;
        _driverLocation = location;
      });
      await _animateToLocation(location);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isMyLocationEnabled = false);
    }
  }

  Future<void> _toggleAvailability(bool value) async {
    final changed = await _cubit.doIntent(
      DriverHomeToggleAvailabilityEvent(value),
    );
    if (!mounted || !changed) return;
    CustomSnackbar.showSuccess(
      context: context,
      message: value
          ? context.localization.driver_home_connection_online_title
          : context.localization.driver_home_connection_offline_title,
    );
  }

  Future<void> _acceptCurrentOffer() async {
    final offer = _cubit.currentOffer;
    if (offer == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DriverHomeAcceptOrderDialog(
        order: _toPreviewFromOffer(offer),
        dialogContext: dialogContext,
      ),
    );

    if (!mounted || confirmed != true) return;
    final accepted = await _cubit.doIntent(
      DriverHomeAcceptOfferEvent(offer.assignmentId),
    );
    if (!mounted || !accepted) return;
    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.driver_home_accept,
    );
  }

  Future<void> _rejectCurrentOffer() async {
    final offer = _cubit.currentOffer;
    if (offer == null) return;
    final rejected = await _cubit.doIntent(
      DriverHomeRejectOfferEvent(offer.assignmentId),
    );
    if (!mounted || !rejected) return;
    CustomSnackbar.showInfo(
      context: context,
      message: context.localization.driver_home_reject,
    );
  }

  Future<void> _openMissionDetails() async {
    final assignment = _cubit.currentAssignment;
    if (assignment == null) return;

    await context.pushNamed(
      AppRoutes.orderDetails,
      arguments: {
        'order': _toPreviewFromAssignment(assignment),
        'driverLocation': _resolvedDriverLocation(),
        'startAccepted': true,
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _animateToLocation(LatLng location) async {
    if (_mapController == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16.5, tilt: 45.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverHomeCubit, DriverHomeState>(
        listener: (context, state) {
          final home = state.home;
          final canShowOffer =
              home?.operationalStatus.isAvailable == true &&
              home?.operationalStatus.canReceiveOrders == true &&
              home?.operationalStatus.canReceiveOffers == true;
          final activeName = canShowOffer
              ? home?.currentOffer?.vendorName ??
                    home?.currentAssignment?.vendorName
              : home?.currentAssignment?.vendorName;
          if ((activeName ?? '').trim().isNotEmpty) {
            _loadPickupMarker(activeName!);
          }
          final activeLocation = _activeMapTarget(
            home,
            includeOfferTarget: canShowOffer,
          );
          if (activeLocation != null) {
            _animateToLocation(activeLocation);
          }

          if (state.failure != null && state.home != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.failure!.errorMessage,
            );
            _cubit.doIntent(const DriverHomeClearErrorEvent());
          }
        },
        builder: (context, state) {
          if (state.home == null && state.isLoading) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.home == null && state.failure != null && !state.isLoading) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget.fromFailure(
                  state.failure!,
                  onRetry: () => _cubit.doIntent(const DriverHomeLoadEvent()),
                  onGoBack: () =>
                      _cubit.doIntent(const DriverHomeClearErrorEvent()),
                ),
              ),
            );
          }

          final home = state.home!;
          final isDriverOnline = home.operationalStatus.isAvailable;
          final canReceiveLiveOffers =
              home.operationalStatus.canReceiveOrders &&
              home.operationalStatus.canReceiveOffers;
          final currentOffer = home.currentOffer;
          final currentAssignment = home.currentAssignment;
          final showIncomingOffer =
              isDriverOnline && canReceiveLiveOffers && currentOffer != null;
          final canToggle =
              (home.operationalStatus.canGoAvailable ??
                  home.operationalStatus.isOperational) &&
              !state.isAvailabilityUpdating;

          return Scaffold(
            body: Stack(
              children: [
                DriverHomeMapView(
                  initialCameraPosition: CameraPosition(
                    target:
                        _activeMapTarget(
                          home,
                          includeOfferTarget: showIncomingOffer,
                        ) ??
                        _resolvedDriverLocation(),
                    zoom: _fallbackCameraPosition.zoom,
                  ),
                  onMapCreated: _onMapCreated,
                  markers: _buildMarkers(
                    home,
                    showOfferMarkers: showIncomingOffer,
                  ),
                  circles: _buildCircles(context),
                  isMyLocationEnabled: _isMyLocationEnabled,
                ),
                const DriverHomeMapOverlay(),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: _topContentOffset),
                      child: DriverHomeConnectionSwitch(
                        isOnline: isDriverOnline,
                        isEnabled: canToggle,
                        isLoading: state.isAvailabilityUpdating,
                        onChanged: _toggleAvailability,
                      ),
                    ),
                  ),
                ),
                if (state.isRefreshing)
                  const SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 108),
                        child: LinearProgressIndicator(),
                      ),
                    ),
                  ),
                _DriverHomeSheet(
                  initiallyExpanded: showIncomingOffer,
                  child: showIncomingOffer
                      ? IgnorePointer(
                          ignoring: state.isOfferActionLoading,
                          child: Opacity(
                            opacity: state.isOfferActionLoading ? 0.72 : 1,
                            child: IncomingOrderCard(
                              order: _toPreviewFromOffer(currentOffer),
                              onTap: () => _animateToLocation(
                                LatLng(
                                  currentOffer.deliveryLatitude,
                                  currentOffer.deliveryLongitude,
                                ),
                              ),
                              onAccept: _acceptCurrentOffer,
                              onReject: _rejectCurrentOffer,
                              onExpired: () => _cubit.doIntent(
                                const DriverHomeLoadEvent(refresh: true),
                              ),
                              onLocationTap: () => _animateToLocation(
                                LatLng(
                                  currentOffer.deliveryLatitude,
                                  currentOffer.deliveryLongitude,
                                ),
                              ),
                            ),
                          ),
                        )
                      : DriverHomeStatusPanel(
                          home: home,
                          isOnline: isDriverOnline,
                          canReceiveOffers: canReceiveLiveOffers,
                          onOpenMission: currentAssignment == null
                              ? () {}
                              : _openMissionDetails,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Set<Marker> _buildMarkers(
    DriverHomeEntity home, {
    required bool showOfferMarkers,
  }) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('driver_location'),
        position: _resolvedDriverLocation(),
        icon:
            _driverMarkerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };

    final offer = showOfferMarkers ? home.currentOffer : null;
    if (offer != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('offer_pickup'),
          position: LatLng(offer.pickupLatitude, offer.pickupLongitude),
          icon:
              _pickupMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: offer.vendorName),
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('offer_delivery'),
          position: LatLng(offer.deliveryLatitude, offer.deliveryLongitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: offer.customerName),
        ),
      );
    }

    final assignment = home.currentAssignment;
    if (assignment != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('assignment_pickup'),
          position: LatLng(
            assignment.pickupLatitude,
            assignment.pickupLongitude,
          ),
          icon:
              _pickupMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: assignment.vendorName),
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('assignment_delivery'),
          position: LatLng(
            assignment.deliveryLatitude,
            assignment.deliveryLongitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: assignment.orderNumber),
        ),
      );
    }

    return markers;
  }

  Set<Circle> _buildCircles(BuildContext context) {
    return {
      Circle(
        circleId: const CircleId('driver_area'),
        center: _resolvedDriverLocation(),
        radius: 120,
        fillColor: context.colorScheme.primary.withValues(alpha: 0.16),
        strokeColor: context.colorScheme.primary.withValues(alpha: 0.34),
        strokeWidth: 2,
      ),
    };
  }

  DriverOrderPreview _toPreviewFromOffer(DriverHomeOfferEntity offer) {
    return DriverOrderPreview(
      id: offer.assignmentId,
      title: offer.orderNumber,
      vendorName: offer.vendorName,
      pickupAddress: offer.pickupAddress,
      pickupLatitude: offer.pickupLatitude,
      pickupLongitude: offer.pickupLongitude,
      customerName: offer.customerName,
      deliveryAddress: offer.deliveryAddress,
      deliveryLatitude: offer.deliveryLatitude,
      deliveryLongitude: offer.deliveryLongitude,
      distance: offer.estimatedDistanceKm.toStringAsFixed(1),
      eta: offer.estimatedEta,
      payout: offer.payout.toStringAsFixed(2),
      vendorInitials: _resolveInitials(offer.vendorName, offer.vendorInitials),
      customerInitials: _resolveInitials(
        offer.customerName,
        offer.customerInitials,
      ),
      packageNote: offer.packageNote,
      countdownSeconds: offer.countdownSeconds,
      orderItems: offer.orderItems
          .map(
            (item) => DriverOrderItemPreview(
              name: item.name,
              quantity: item.quantity,
              note: item.note,
            ),
          )
          .toList(),
    );
  }

  DriverOrderPreview _toPreviewFromAssignment(
    DriverHomeAssignmentEntity assignment,
  ) {
    return DriverOrderPreview(
      id: assignment.assignmentId,
      title: assignment.orderNumber,
      vendorName: assignment.vendorName,
      pickupAddress: assignment.pickupAddress,
      pickupLatitude: assignment.pickupLatitude,
      pickupLongitude: assignment.pickupLongitude,
      customerName: assignment.orderNumber,
      deliveryAddress: assignment.deliveryAddress,
      deliveryLatitude: assignment.deliveryLatitude,
      deliveryLongitude: assignment.deliveryLongitude,
      distance: '0.0',
      eta: assignment.status,
      payout: assignment.codAmount.toStringAsFixed(2),
      vendorInitials: _resolveInitials(assignment.vendorName, null),
      customerInitials: _resolveInitials(assignment.orderNumber, null),
      countdownSeconds: 3600,
    );
  }

  String _resolveInitials(String source, String? preferred) {
    final preferredTrimmed = (preferred ?? '').trim();
    if (preferredTrimmed.isNotEmpty) return preferredTrimmed;

    final parts = source
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) return '--';
    return parts.map((part) => part.substring(0, 1)).join().toUpperCase();
  }

  LatLng _resolvedDriverLocation() {
    return _driverLocation ?? _fallbackCameraPosition.target;
  }

  LatLng? _activeMapTarget(
    DriverHomeEntity? home, {
    bool includeOfferTarget = true,
  }) {
    final offer = includeOfferTarget ? home?.currentOffer : null;
    if (offer != null) {
      return LatLng(offer.pickupLatitude, offer.pickupLongitude);
    }

    final assignment = home?.currentAssignment;
    if (assignment != null) {
      return LatLng(assignment.pickupLatitude, assignment.pickupLongitude);
    }

    return _driverLocation;
  }
}

class _DriverHomeSheet extends StatelessWidget {
  const _DriverHomeSheet({
    required this.child,
    required this.initiallyExpanded,
  });

  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initiallyExpanded ? 0.27 : 0.21,
      minChildSize: 0.17,
      maxChildSize: 0.52,
      snap: true,
      snapSizes: const [0.21, 0.35, 0.52],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              Spacing.base,
              Spacing.sm,
              Spacing.base,
              Spacing.base,
            ),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: Spacing.base),
                  decoration: BoxDecoration(
                    color: context.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}
