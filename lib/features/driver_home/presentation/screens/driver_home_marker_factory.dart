import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_marker_painter.dart';

class DriverHomeMarkerFactory {
  const DriverHomeMarkerFactory._();

  static Future<BitmapDescriptor> buildStoreMarker({
    required String storeName,
    required String markerLabel,
  }) {
    return DriverHomeMarkerPainter.buildCompactMarker(
      markerLabel: markerLabel,
      accent: AppColors.secondary,
      iconData: DriverHomeMarkerPainter.storeIcon,
    );
  }

  static Future<BitmapDescriptor> buildCustomerMarker({
    required String customerName,
    required String markerLabel,
  }) {
    return DriverHomeMarkerPainter.buildCompactMarker(
      markerLabel: markerLabel,
      accent: AppColors.primary,
      iconData: DriverHomeMarkerPainter.customerIcon,
    );
  }

  static Future<BitmapDescriptor> buildPickupMarker({
    required String marketName,
    required String markerLabel,
  }) {
    return DriverHomeMarkerPainter.buildCompactMarker(
      markerLabel: markerLabel,
      accent: AppColors.secondary,
      iconData: DriverHomeMarkerPainter.storeIcon,
    );
  }

  /// Builds a pickup marker with the vendor's logo loaded from a network URL.
  /// Falls back to the generic store icon marker if the image fails to load.
  static Future<BitmapDescriptor> buildPickupMarkerWithLogo({
    required String imageUrl,
    required String markerLabel,
  }) {
    return DriverHomeMarkerPainter.buildImageMarker(
      imageUrl: imageUrl,
      markerLabel: markerLabel,
      accent: AppColors.secondary,
    );
  }

  /// Builds a delivery marker with a house icon.
  static Future<BitmapDescriptor> buildDeliveryMarker({
    required String markerLabel,
  }) {
    return DriverHomeMarkerPainter.buildCompactMarker(
      markerLabel: markerLabel,
      accent: AppColors.primary,
      iconData: DriverHomeMarkerPainter.homeIcon,
    );
  }

  static Future<BitmapDescriptor> buildDriverMarker() {
    return DriverHomeMarkerPainter.buildDriverMarker(accent: AppColors.primary);
  }
}
