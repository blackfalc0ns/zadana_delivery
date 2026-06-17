import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_state.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_connection_switch.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_layers.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_overlay.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_view.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_sheet.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_status_panel.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card_widget.dart';

class DriverHomeLoadedView extends StatelessWidget {
  const DriverHomeLoadedView({
    super.key,
    required this.home,
    required this.state,
    required this.driverLocation,
    required this.fallbackZoom,
    required this.isMyLocationEnabled,
    required this.driverMarkerIcon,
    required this.pickupMarkerIcon,
    required this.deliveryMarkerIcon,
    required this.onMapCreated,
    required this.onToggleAvailability,
    required this.onDisabledAvailabilityTap,
    required this.onAcceptOffer,
    required this.onRejectOffer,
    required this.onOfferExpired,
    required this.onAnimateToLocation,
    required this.onOpenOfferDetails,
    required this.onOpenMission,
    required this.toPreviewFromOffer,
  });

  static const double _topContentOffset = 18;

  final DriverHomeEntity home;
  final DriverHomeState state;
  final LatLng driverLocation;
  final double fallbackZoom;
  final bool isMyLocationEnabled;
  final BitmapDescriptor? driverMarkerIcon;
  final BitmapDescriptor? pickupMarkerIcon;
  final BitmapDescriptor? deliveryMarkerIcon;
  final void Function(GoogleMapController controller) onMapCreated;
  final ValueChanged<bool> onToggleAvailability;
  final VoidCallback onDisabledAvailabilityTap;
  final VoidCallback onAcceptOffer;
  final VoidCallback onRejectOffer;
  final VoidCallback onOfferExpired;
  final ValueChanged<LatLng> onAnimateToLocation;
  final VoidCallback onOpenOfferDetails;
  final VoidCallback onOpenMission;
  final DriverOrderPreview Function(DriverHomeOfferEntity offer)
  toPreviewFromOffer;

  @override
  Widget build(BuildContext context) {
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
                  DriverHomeMapLayers.activeMapTarget(
                    home,
                    driverLocation: driverLocation,
                    includeOfferTarget: showIncomingOffer,
                  ) ??
                  driverLocation,
              zoom: fallbackZoom,
            ),
            onMapCreated: onMapCreated,
            markers: DriverHomeMapLayers.buildMarkers(
              home: home,
              showOfferMarkers: showIncomingOffer,
              driverLocation: driverLocation,
              driverMarkerIcon: driverMarkerIcon,
              pickupMarkerIcon: pickupMarkerIcon,
              deliveryMarkerIcon: deliveryMarkerIcon,
            ),
            circles: DriverHomeMapLayers.buildCircles(
              context: context,
              driverLocation: driverLocation,
            ),
            isMyLocationEnabled: isMyLocationEnabled,
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
                  onChanged: onToggleAvailability,
                  onDisabledTap: onDisabledAvailabilityTap,
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
                  child: CustomProgressIndicator.compact(size: 24),
                ),
              ),
            ),
          if (state.isAvailabilityUpdating) ...[
            Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(color: Colors.black.withValues(alpha: 0.12)),
              ),
            ),
            const Positioned.fill(
              child: Center(child: CustomProgressIndicator()),
            ),
          ],
          DriverHomeSheet(
            key: ValueKey(
              'driver_home_sheet_${showIncomingOffer ? 'offer' : 'status'}',
            ),
            initiallyExpanded: showIncomingOffer,
            child: KeyedSubtree(
              key: ValueKey(
                'driver_home_sheet_child_${showIncomingOffer ? 'offer' : 'status'}',
              ),
              child: showIncomingOffer
                  ? IgnorePointer(
                      ignoring: state.isOfferActionLoading,
                      child: Opacity(
                        opacity: state.isOfferActionLoading ? 0.72 : 1,
                        child: IncomingOrderCard(
                          key: ValueKey(
                            'incoming_order_${currentOffer.assignmentId}_${currentOffer.countdownSeconds}',
                          ),
                          order: toPreviewFromOffer(currentOffer),
                          onTap: onOpenOfferDetails,
                          onAccept: onAcceptOffer,
                          onReject: onRejectOffer,
                          onExpired: onOfferExpired,
                          onLocationTap: () =>
                              _animateToPickupLocation(currentOffer),
                        ),
                      ),
                    )
                  : DriverHomeStatusPanel(
                      key: const ValueKey('driver_home_status_panel'),
                      home: home,
                      isOnline: isDriverOnline,
                      canReceiveOffers: canReceiveLiveOffers,
                      onToggleAvailability: () =>
                          onToggleAvailability(!isDriverOnline),
                      onDisabledToggleTap: onDisabledAvailabilityTap,
                      isToggleEnabled: canToggle,
                      onOpenMission: currentAssignment == null
                          ? () {}
                          : onOpenMission,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _animateToPickupLocation(DriverHomeOfferEntity offer) {
    final location = _resolvePickupLocation(offer);
    if (location == null) return;
    onAnimateToLocation(location);
  }

  LatLng? _resolveOfferLocation(DriverHomeOfferEntity offer) {
    if (_hasValidCoordinates(offer.deliveryLatitude, offer.deliveryLongitude)) {
      return LatLng(offer.deliveryLatitude, offer.deliveryLongitude);
    }
    if (_hasValidCoordinates(offer.pickupLatitude, offer.pickupLongitude)) {
      return LatLng(offer.pickupLatitude, offer.pickupLongitude);
    }
    return null;
  }

  LatLng? _resolvePickupLocation(DriverHomeOfferEntity offer) {
    if (_hasValidCoordinates(offer.pickupLatitude, offer.pickupLongitude)) {
      return LatLng(offer.pickupLatitude, offer.pickupLongitude);
    }
    return _resolveOfferLocation(offer);
  }

  bool _hasValidCoordinates(double latitude, double longitude) {
    return latitude != 0 || longitude != 0;
  }
}
