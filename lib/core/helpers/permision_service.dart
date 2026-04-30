import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationPermissionService {
  Future<void>? _foregroundPermissionRequest;
  Future<void>? _backgroundPermissionRequest;

  Future<LocationPermissionSnapshot> getPermissionSnapshot() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationPermissionSnapshot(
        status: LocationPermissionStatus.serviceDisabled,
      );
    }

    final permission = await Geolocator.checkPermission();
    return LocationPermissionSnapshot(
      status: _mapPermissionToStatus(permission),
    );
  }

  Future<void> ensureForegroundPermission() async {
    final pendingRequest = _foregroundPermissionRequest;
    if (pendingRequest != null) {
      return pendingRequest;
    }

    final request = _ensureForegroundPermissionInternal();
    _foregroundPermissionRequest = request;
    try {
      await request;
    } finally {
      if (identical(_foregroundPermissionRequest, request)) {
        _foregroundPermissionRequest = null;
      }
    }
  }

  Future<void> _ensureForegroundPermissionInternal() async {
    final snapshot = await getPermissionSnapshot();
    if (snapshot.status == LocationPermissionStatus.serviceDisabled) {
      throw const LocationServiceException(
        'Location services are disabled. Please enable them and try again.',
        LocationErrorType.serviceDisabled,
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        'Location permission was denied. Please allow location access to continue.',
        LocationErrorType.permissionDenied,
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permission is permanently denied. Please enable it from app settings.',
        LocationErrorType.permissionDeniedForever,
      );
    }
  }

  Future<void> ensureBackgroundPermission() async {
    final pendingRequest = _backgroundPermissionRequest;
    if (pendingRequest != null) {
      return pendingRequest;
    }

    final request = _ensureBackgroundPermissionInternal();
    _backgroundPermissionRequest = request;
    try {
      await request;
    } finally {
      if (identical(_backgroundPermissionRequest, request)) {
        _backgroundPermissionRequest = null;
      }
    }
  }

  Future<void> _ensureBackgroundPermissionInternal() async {
    await ensureForegroundPermission();

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        'Background location permission was denied. Please allow all-the-time access to continue tracking.',
        LocationErrorType.permissionDenied,
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Background location permission is permanently denied. Please enable it from app settings.',
        LocationErrorType.permissionDeniedForever,
      );
    }
  }

  Future<void> checkAndRequestPermission() async {
    await ensureForegroundPermission();
  }

  Future<void> checkAndRequestBackgroundPermission() async {
    await ensureBackgroundPermission();
  }

  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  LocationPermissionStatus _mapPermissionToStatus(
    LocationPermission permission,
  ) {
    switch (permission) {
      case LocationPermission.always:
        return LocationPermissionStatus.grantedAlways;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.grantedWhileInUse;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }
}

class LocationPermissionSnapshot {
  const LocationPermissionSnapshot({required this.status});

  final LocationPermissionStatus status;

  bool get isGranted =>
      status == LocationPermissionStatus.grantedAlways ||
      status == LocationPermissionStatus.grantedWhileInUse;
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

enum LocationPermissionStatus {
  serviceDisabled,
  denied,
  deniedForever,
  grantedWhileInUse,
  grantedAlways,
}
