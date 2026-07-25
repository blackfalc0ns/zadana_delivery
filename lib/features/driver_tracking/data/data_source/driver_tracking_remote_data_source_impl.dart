import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/utils/constants.dart';
import 'package:zadana_delivery/features/driver_tracking/data/data_source/driver_tracking_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/entities/driver_tracking_state_entity.dart';

@LazySingleton(as: DriverTrackingRemoteDataSource)
class DriverTrackingRemoteDataSourceImpl
    implements DriverTrackingRemoteDataSource {
  DriverTrackingRemoteDataSourceImpl(this._permissionService);

  static const String _logTag = 'DriverTracking';
  static const String _trackingChannelId = 'driver_tracking_channel';
  static const String _trackingChannelName = 'Driver Tracking';
  static const String _trackingChannelDescription =
      'Shows delivery tracking status while the app shares location.';
  static const int _notificationId = 7412;

  final LocationPermissionService _permissionService;
  final FlutterBackgroundService _backgroundService =
      FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<DriverTrackingStateEntity> _stateController =
      StreamController<DriverTrackingStateEntity>.broadcast();

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _initializeForegroundNotification();
    await _backgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _driverTrackingServiceEntrypoint,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: _trackingChannelId,
        initialNotificationTitle: 'Zadna Delivery',
        initialNotificationContent: 'Sharing your location during delivery',
        foregroundServiceNotificationId: _notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _driverTrackingServiceEntrypoint,
        onBackground: _driverTrackingIosBackground,
      ),
    );

    _backgroundService.on('tracking_state').listen((event) {
      final map = _normalizeMap(event);
      if (map.isEmpty) return;
      _logTracking(
        'tracking_state event'
        ' isTracking=${map['isTracking']}'
        ' orderId=${map['activeOrderId'] ?? '-'}'
        ' phase=${map['activePhase'] ?? '-'}'
        ' lat=${map['lastSentLatitude'] ?? '-'}'
        ' lng=${map['lastSentLongitude'] ?? '-'}'
        ' acc=${map['lastSentAccuracyMeters'] ?? '-'}'
        ' sentAt=${map['lastSentAt'] ?? '-'}'
        ' failure=${map['failure'] ?? '-'}',
      );
      _stateController.add(_stateFromMap(map));
    });

    _backgroundService.on('tracking_error').listen((event) {
      final map = _normalizeMap(event);
      if (map.isEmpty) return;
      _logTracking(
        'tracking_error event'
        ' orderId=${map['activeOrderId'] ?? '-'}'
        ' failure=${map['failure'] ?? '-'}',
      );
      _stateController.add(_stateFromMap(map));
    });

    _isInitialized = true;
  }

  @override
  Future<void> pushDriverLocation() async {
    await initialize();
    _backgroundService.invoke('pushLocation');
  }

  @override
  Future<void> syncAppLifecycleState(bool isForeground) async {
    await initialize();
    _backgroundService.invoke('syncAppLifecycleState', {
      'isForeground': isForeground,
    });
  }

  @override
  Future<void> startTracking(DriverTrackingCommandEntity command) async {
    await initialize();
    _logTracking(
      'startTracking requested'
      ' orderId=${command.orderId}'
      ' phase=${command.phase}'
      ' fg=${command.foregroundIntervalSeconds}s'
      ' bg=${command.backgroundIntervalSeconds}s',
    );
    // A delivery can continue after the UI is backgrounded. Do not start the
    // native service with only foreground access.
    await _permissionService.checkAndRequestBackgroundPermission();

    final isRunning = await _backgroundService.isRunning();
    if (!isRunning) {
      await _backgroundService.startService();
    }

    _backgroundService.invoke('configureTracking', command.toMap());
    _backgroundService.invoke('startTracking');
  }

  @override
  Future<void> stopTracking() async {
    await initialize();
    _logTracking('stopTracking requested');
    _backgroundService.invoke('stopTracking');
  }

  @override
  Future<void> syncTrackingStatus(DriverTrackingCommandEntity? command) async {
    if (command == null) {
      await stopTracking();
      return;
    }
    await startTracking(command);
  }

  @override
  Stream<DriverTrackingStateEntity> watchState() => _stateController.stream;

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  DriverTrackingStateEntity _stateFromMap(Map<String, dynamic> map) {
    return DriverTrackingStateEntity(
      isTracking: map['isTracking'] == true,
      isStarting: false,
      isStopping: false,
      lastSentLatitude: _asDoubleOrNull(map['lastSentLatitude']),
      lastSentLongitude: _asDoubleOrNull(map['lastSentLongitude']),
      lastSentAccuracyMeters: _asDoubleOrNull(map['lastSentAccuracyMeters']),
      lastSentAt: _asDateTime(map['lastSentAt']),
      activeOrderId: map['activeOrderId']?.toString(),
      activePhase: map['activePhase']?.toString(),
      failure: map['failure']?.toString(),
    );
  }

  Future<void> _initializeForegroundNotification() async {
    const androidSettings = AndroidInitializationSettings(
      'ic_bg_service_small',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    await _localNotifications.initialize(initializationSettings);

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _trackingChannelId,
        _trackingChannelName,
        description: _trackingChannelDescription,
        importance: Importance.low,
      ),
    );
    await androidPlugin.requestNotificationsPermission();
  }
}

double? _asDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime? _asDateTime(dynamic value) {
  final raw = value?.toString() ?? '';
  if (raw.trim().isEmpty) return null;
  return DateTime.tryParse(raw);
}

LocationSettings buildTrackingLocationSettings(
  DriverTrackingCommandEntity activeCommand,
) {
  final accuracy = activeCommand.useHighAccuracy
      ? LocationAccuracy.high
      : LocationAccuracy.medium;

  if (Platform.isIOS) {
    return AppleSettings(
      accuracy: accuracy,
      distanceFilter: 10,
      activityType: ActivityType.automotiveNavigation,
      showBackgroundLocationIndicator: true,
    );
  }

  return LocationSettings(accuracy: accuracy, distanceFilter: 10);
}

@pragma('vm:entry-point')
Future<bool> _driverTrackingIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void _driverTrackingServiceEntrypoint(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  const storage = FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();
  final dio = Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  StreamSubscription<Position>? positionSubscription;
  Timer? pushTimer;
  DriverTrackingCommandEntity? command;
  Position? latestEligiblePosition;
  DateTime? lastSentAt;
  double? lastSentLatitude;
  double? lastSentLongitude;
  double? lastSentAccuracyMeters;
  DateTime? lastMovementDetectedAt;
  bool isTracking = false;
  bool isForeground = true;

  Future<String?> readAccessToken() async {
    final isSaved =
        sharedPreferences.getBool(AppConstants.isAccessTokenSaved) ?? false;
    if (!isSaved) return null;
    return storage.read(key: AppConstants.accessToken);
  }

  Future<void> emitState({String? failure}) async {
    service.invoke('tracking_state', {
      'isTracking': isTracking,
      'activeOrderId': command?.orderId,
      'activePhase': command?.phase,
      'lastSentLatitude': lastSentLatitude,
      'lastSentLongitude': lastSentLongitude,
      'lastSentAccuracyMeters': lastSentAccuracyMeters,
      'lastSentAt': lastSentAt?.toIso8601String(),
      'failure': failure,
    });
  }

  Future<void> emitError(String message) async {
    service.invoke('tracking_error', {
      'isTracking': isTracking,
      'activeOrderId': command?.orderId,
      'activePhase': command?.phase,
      'lastSentLatitude': lastSentLatitude,
      'lastSentLongitude': lastSentLongitude,
      'lastSentAccuracyMeters': lastSentAccuracyMeters,
      'lastSentAt': lastSentAt?.toIso8601String(),
      'failure': message,
    });
  }

  bool shouldSend(Position position) {
    final previousSentAt = lastSentAt;
    final previousLatitude = lastSentLatitude;
    final previousLongitude = lastSentLongitude;
    final accuracy = _resolveAccuracyMeters(position);

    if (accuracy > 100) {
      if (previousSentAt == null) return true;
      if (DateTime.now().difference(previousSentAt) >
          const Duration(seconds: 60)) {
        return true;
      }
      return false;
    }

    if (previousLatitude == null || previousLongitude == null) {
      return true;
    }

    final movedMeters = Geolocator.distanceBetween(
      previousLatitude,
      previousLongitude,
      position.latitude,
      position.longitude,
    );

    if (movedMeters >= 5) {
      lastMovementDetectedAt = DateTime.now();
      return true;
    }

    final stationarySince = lastMovementDetectedAt ?? previousSentAt;
    if (stationarySince == null) {
      return true;
    }

    return DateTime.now().difference(stationarySince) >=
        const Duration(seconds: 30);
  }

  Future<void> pushPosition(Position position, {bool force = false}) async {
    if (!force && !shouldSend(position)) return;

    final token = await readAccessToken();
    if (token == null || token.trim().isEmpty) {
      await emitError('Access token is not available for location tracking.');
      return;
    }

    latestEligiblePosition = position;
    final accuracyMeters = _resolveAccuracyMeters(position);

    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      _logTracking(
        'pushPosition request'
        ' force=$force'
        ' lat=${position.latitude}'
        ' lng=${position.longitude}'
        ' acc=$accuracyMeters'
        ' phase=${command?.phase ?? '-'}'
        ' orderId=${command?.orderId ?? '-'}',
      );
      await dio.post<dynamic>(
        EndPoints.driverLocation,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracyMeters': accuracyMeters,
        },
      );

      lastSentLatitude = position.latitude;
      lastSentLongitude = position.longitude;
      lastSentAccuracyMeters = accuracyMeters;
      lastSentAt = DateTime.now();
      _logTracking(
        'pushPosition success'
        ' sentAt=${lastSentAt!.toIso8601String()}'
        ' lat=$lastSentLatitude'
        ' lng=$lastSentLongitude'
        ' acc=$lastSentAccuracyMeters',
      );
      await emitState();
    } catch (error) {
      _logTracking('pushPosition failure error=$error');
      await emitError(error.toString());
    }
  }

  Future<void> restartLocationStream() async {
    final activeCommand = command;
    if (activeCommand == null || !isTracking) return;

    await positionSubscription?.cancel();
    pushTimer?.cancel();
    pushTimer = null;

    if (service is AndroidServiceInstance) {
      await (service).setForegroundNotificationInfo(
        title: 'Zadna Delivery',
        content: 'Sharing your location during delivery',
      );
    }

    try {
      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: buildTrackingLocationSettings(activeCommand),
      );
      latestEligiblePosition = currentPosition;
      _logPositionSample(
        source: 'initial-current-position',
        position: currentPosition,
      );
      await pushPosition(currentPosition, force: true);
    } catch (_) {}

    final interval = Duration(
      seconds: isForeground
          ? activeCommand.foregroundIntervalSeconds
          : activeCommand.backgroundIntervalSeconds,
    );
    pushTimer = Timer.periodic(interval, (_) async {
      Position? position = latestEligiblePosition;
      position ??= await _safeGetCurrentPosition(activeCommand);
      if (position == null) {
        _logTracking('periodic tick skipped: no current position available');
        await emitError(
          'Unable to resolve current location for periodic tracking update.',
        );
        return;
      }
      latestEligiblePosition = position;
      _logPositionSample(source: 'periodic-tick', position: position);
      await pushPosition(position, force: true);
    });

    positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: buildTrackingLocationSettings(activeCommand),
        ).listen((position) async {
          latestEligiblePosition = position;
          _logPositionSample(source: 'position-stream', position: position);
          final previousLatitude = lastSentLatitude;
          final previousLongitude = lastSentLongitude;
          if (previousLatitude == null || previousLongitude == null) {
            lastMovementDetectedAt = DateTime.now();
            return;
          }

          final movedMeters = Geolocator.distanceBetween(
            previousLatitude,
            previousLongitude,
            position.latitude,
            position.longitude,
          );
          if (movedMeters >= 5) {
            lastMovementDetectedAt = DateTime.now();
          }
        });
  }

  service.on('configureTracking').listen((payload) async {
    final map = payload == null
        ? null
        : Map<String, dynamic>.from(Map<dynamic, dynamic>.from(payload as Map));
    if (map == null || map.isEmpty) return;

    command = DriverTrackingCommandEntity(
      orderId: map['orderId']?.toString() ?? '',
      phase: map['phase']?.toString() ?? '',
      foregroundIntervalSeconds:
          (map['foregroundIntervalSeconds'] as num?)?.toInt() ?? 5,
      backgroundIntervalSeconds:
          (map['backgroundIntervalSeconds'] as num?)?.toInt() ?? 10,
      useHighAccuracy: map['useHighAccuracy'] == true,
    );
    _logTracking(
      'configureTracking'
      ' orderId=${command?.orderId ?? '-'}'
      ' phase=${command?.phase ?? '-'}'
      ' fg=${command?.foregroundIntervalSeconds}s'
      ' bg=${command?.backgroundIntervalSeconds}s'
      ' highAccuracy=${command?.useHighAccuracy}',
    );
    await emitState();
  });

  service.on('syncAppLifecycleState').listen((payload) async {
    final map = payload == null
        ? const <String, dynamic>{}
        : Map<String, dynamic>.from(Map<dynamic, dynamic>.from(payload as Map));
    final nextIsForeground = map['isForeground'] == true;
    if (isForeground == nextIsForeground) {
      return;
    }
    isForeground = nextIsForeground;
    _logTracking('syncAppLifecycleState isForeground=$isForeground');
    if (isTracking) {
      await restartLocationStream();
    }
  });

  service.on('startTracking').listen((_) async {
    isTracking = true;
    _logTracking('startTracking');
    await restartLocationStream();
  });

  service.on('pushLocation').listen((_) async {
    final position = latestEligiblePosition;
    if (position == null) return;
    await pushPosition(position, force: true);
  });

  service.on('stopTracking').listen((_) async {
    isTracking = false;
    _logTracking('stopTracking');
    command = null;
    latestEligiblePosition = null;
    await positionSubscription?.cancel();
    positionSubscription = null;
    pushTimer?.cancel();
    pushTimer = null;
    await emitState();
    await service.stopSelf();
  });
}

double _resolveAccuracyMeters(Position position) {
  return math.max(position.accuracy.abs().toDouble(), 1);
}

Future<Position?> _safeGetCurrentPosition(
  DriverTrackingCommandEntity activeCommand,
) async {
  try {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: buildTrackingLocationSettings(activeCommand),
    );
    _logPositionSample(source: 'fallback-current-position', position: position);
    return position;
  } catch (_) {
    return null;
  }
}

void _logTracking(String message) {
  developer.log(message, name: DriverTrackingRemoteDataSourceImpl._logTag);
}

void _logPositionSample({required String source, required Position position}) {
  _logTracking(
    '$source'
    ' lat=${position.latitude}'
    ' lng=${position.longitude}'
    ' acc=${_resolveAccuracyMeters(position)}'
    ' speed=${position.speed}'
    ' heading=${position.heading}'
    ' ts=${position.timestamp.toIso8601String()}',
  );
}
