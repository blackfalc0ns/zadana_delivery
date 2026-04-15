import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeMapView extends StatelessWidget {
  const DriverHomeMapView({
    super.key,
    required this.initialCameraPosition,
    required this.onMapCreated,
    required this.markers,
    required this.circles,
    required this.isMyLocationEnabled,
  });

  final CameraPosition initialCameraPosition;
  final void Function(GoogleMapController) onMapCreated;
  final Set<Marker> markers;
  final Set<Circle> circles;
  final bool isMyLocationEnabled;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: onMapCreated,
        markers: markers,
        circles: circles,
        myLocationEnabled: isMyLocationEnabled,
        gestureRecognizers: const {
          Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
        },
        myLocationButtonEnabled: isMyLocationEnabled,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }
}
