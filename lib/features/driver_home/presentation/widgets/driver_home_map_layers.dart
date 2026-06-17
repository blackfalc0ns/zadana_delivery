import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';

class DriverHomeMapLayers {
  const DriverHomeMapLayers._();

  static Set<Marker> buildMarkers({
    required DriverHomeEntity home,
    required bool showOfferMarkers,
    required LatLng driverLocation,
    BitmapDescriptor? driverMarkerIcon,
    BitmapDescriptor? pickupMarkerIcon,
    BitmapDescriptor? deliveryMarkerIcon,
  }) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('driver_location'),
        position: driverLocation,
        icon:
            driverMarkerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };

    final offer = showOfferMarkers ? home.currentOffer : null;
    if (offer != null) {
      if (_hasValidCoordinates(offer.pickupLatitude, offer.pickupLongitude)) {
        markers.add(
          Marker(
            markerId: const MarkerId('offer_pickup'),
            position: LatLng(offer.pickupLatitude, offer.pickupLongitude),
            icon:
                pickupMarkerIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
            infoWindow: InfoWindow(title: offer.vendorName),
          ),
        );
      }
      if (_hasValidCoordinates(
        offer.deliveryLatitude,
        offer.deliveryLongitude,
      )) {
        markers.add(
          Marker(
            markerId: const MarkerId('offer_delivery'),
            position: LatLng(offer.deliveryLatitude, offer.deliveryLongitude),
            icon:
                deliveryMarkerIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
            infoWindow: InfoWindow(title: offer.customerName),
          ),
        );
      }
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
              pickupMarkerIcon ??
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
          icon:
              deliveryMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: assignment.orderNumber),
        ),
      );
    }

    return markers;
  }

  static Set<Circle> buildCircles({
    required BuildContext context,
    required LatLng driverLocation,
  }) {
    return {
      Circle(
        circleId: const CircleId('driver_area'),
        center: driverLocation,
        radius: 120,
        fillColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.16),
        strokeColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.34),
        strokeWidth: 2,
      ),
    };
  }

  static LatLng? activeMapTarget(
    DriverHomeEntity? home, {
    required LatLng? driverLocation,
    bool includeOfferTarget = true,
  }) {
    final offer = includeOfferTarget ? home?.currentOffer : null;
    if (offer != null &&
        _hasValidCoordinates(offer.pickupLatitude, offer.pickupLongitude)) {
      return LatLng(offer.pickupLatitude, offer.pickupLongitude);
    }

    final assignment = home?.currentAssignment;
    if (assignment != null) {
      return LatLng(assignment.pickupLatitude, assignment.pickupLongitude);
    }

    return driverLocation;
  }

  static bool _hasValidCoordinates(double latitude, double longitude) {
    return latitude != 0 || longitude != 0;
  }
}
