import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/utils/constants.dart';
import 'package:zadana_delivery/features/driver_tracking/data/data_source/driver_tracking_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/entities/driver_tracking_state_entity.dart';

class DriverTrackingRemoteDataSourceImpl
    implements DriverTrackingRemoteDataSource {
  DriverTrackingRemoteDataSourceImpl(this._permissionService);

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
        autoStartOnBoot: false,
        notificationChannelId: _trackingChannelId,
        initialNotificationTitle: 'Zadana Delivery',
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
      _stateController.add(_stateFromMap(map));
    });

    _backgroundService.on('tracking_error').listen((event) {
      final map = _normalizeMap(event);
      if (map.isEmpty) return;
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
  Future<void> startTracking(DriverTrackingCommandEntity command) async {
    await initialize();
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
  DriverTrackingCommandEntity? command;
  Position? latestEligiblePosition;
  DateTime? lastSentAt;
  double? lastSentLatitude;
  double? lastSentLongitude;
  double? lastSentAccuracyMeters;
  bool isTracking = false;

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
    final accuracy = position.accuracy.toDouble();

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

    return movedMeters >= 10;
  }

  Future<void> pushPosition(Position position, {bool force = false}) async {
    if (!force && !shouldSend(position)) return;

    final token = await readAccessToken();
    if (token == null || token.trim().isEmpty) {
      await emitError('Access token is not available for location tracking.');
      return;
    }

    latestEligiblePosition = position;

    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post<dynamic>(
        EndPoints.driverLocation,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracyMeters': position.accuracy.toDouble(),
        },
      );

      lastSentLatitude = position.latitude;
      lastSentLongitude = position.longitude;
      lastSentAccuracyMeters = position.accuracy.toDouble();
      lastSentAt = DateTime.now();
      await emitState();
    } catch (error) {
      await emitError(error.toString());
    }
  }

  Future<void> restartLocationStream() async {
    final activeCommand = command;
    if (activeCommand == null || !isTracking) return;

    await positionSubscription?.cancel();

    if (service is AndroidServiceInstance) {
      await (service).setForegroundNotificationInfo(
        title: 'Zadana Delivery',
        content: 'Sharing your location during delivery',
      );
    }

    try {
      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: activeCommand.useHighAccuracy
              ? LocationAccuracy.high
              : LocationAccuracy.medium,
          distanceFilter: 10,
        ),
      );
      await pushPosition(currentPosition, force: true);
    } catch (_) {}

    positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: activeCommand.useHighAccuracy
                ? LocationAccuracy.high
                : LocationAccuracy.medium,
            distanceFilter: 10,
          ),
        ).listen((position) async {
          latestEligiblePosition = position;

          final previousSentAt = lastSentAt;
          final minimumInterval = Duration(
            seconds: activeCommand.intervalSeconds,
          );
          if (previousSentAt != null &&
              DateTime.now().difference(previousSentAt) < minimumInterval) {
            return;
          }

          await pushPosition(position);
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
      intervalSeconds: (map['intervalSeconds'] as num?)?.toInt() ?? 15,
      useHighAccuracy: map['useHighAccuracy'] == true,
    );
    await emitState();
  });

  service.on('startTracking').listen((_) async {
    isTracking = true;
    await restartLocationStream();
  });

  service.on('pushLocation').listen((_) async {
    final position = latestEligiblePosition;
    if (position == null) return;
    await pushPosition(position, force: true);
  });

  service.on('stopTracking').listen((_) async {
    isTracking = false;
    command = null;
    latestEligiblePosition = null;
    await positionSubscription?.cancel();
    positionSubscription = null;
    await emitState();
    await service.stopSelf();
  });
}
