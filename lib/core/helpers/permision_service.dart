import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationPermissionService {
  Future<void> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const LocationServiceException(
        "خدمة الموقع غير مفعلة. يرجى تفعيل خدمة الموقع من الإعدادات.",
        LocationErrorType.serviceDisabled,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        "تم رفض إذن الوصول للموقع. يرجى السماح للتطبيق بالوصول للموقع.",
        LocationErrorType.permissionDenied,
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        "تم رفض إذن الوصول للموقع نهائياً. يرجى الذهاب للإعدادات وتفعيل إذن الموقع للتطبيق.",
        LocationErrorType.permissionDeniedForever,
      );
    }
  }
}

class LocationServiceException implements Exception {
  const LocationServiceException(this.message, this.type);
  final String message;
  final LocationErrorType type;

  @override
  String toString() => message;
}

enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}
