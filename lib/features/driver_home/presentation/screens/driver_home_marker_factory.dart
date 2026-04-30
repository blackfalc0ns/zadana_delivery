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

  static Future<BitmapDescriptor> buildDriverMarker() {
    return DriverHomeMarkerPainter.buildDriverMarker(accent: AppColors.primary);
  }
}
