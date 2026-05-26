import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/services/driver_runtime_services_controller.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/watch_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/entities/driver_tracking_state_entity.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/push_driver_location_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/start_driver_tracking_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/stop_driver_tracking_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/sync_driver_tracking_status_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/presentation/manager/driver_tracking_event.dart';
import 'package:zadana_delivery/features/driver_tracking/presentation/manager/driver_tracking_state.dart';

@injectable
class DriverTrackingCubit extends Cubit<DriverTrackingState> {
  DriverTrackingCubit(
    this._watchDriverHomeUseCase,
    this._startDriverTrackingUseCase,
    this._stopDriverTrackingUseCase,
    this._syncDriverTrackingStatusUseCase,
    this._pushDriverLocationUseCase,
    this._repository,
  ) : super(const DriverTrackingState()) {
    _homeSubscription = _watchDriverHomeUseCase.call().listen((home) {
      _syncAvailabilityLocationPush(home);
      unawaited(
        doIntent(DriverTrackingAssignmentChangedEvent(home.currentAssignment)),
      );
    });
    _trackingSubscription = _repository.watchState().listen(
      _applyTrackingState,
    );
  }

  final WatchDriverHomeUseCase _watchDriverHomeUseCase;
  // ignore: unused_field
  final StartDriverTrackingUseCase _startDriverTrackingUseCase;
  final StopDriverTrackingUseCase _stopDriverTrackingUseCase;
  final SyncDriverTrackingStatusUseCase _syncDriverTrackingStatusUseCase;
  final PushDriverLocationUseCase _pushDriverLocationUseCase;
  final DriverTrackingRepository _repository;
  final DriverRuntimeServicesController _driverRuntimeServicesController =
      getIt<DriverRuntimeServicesController>();
  static const String _logTag = 'DriverTrackingCubit';
  static const Duration _availableLocationInterval = Duration(seconds: 30);
  static const int _locationPushMaxRetries = 2;

  late final StreamSubscription<DriverHomeEntity> _homeSubscription;
  late final StreamSubscription<DriverTrackingStateEntity>
  _trackingSubscription;
  Timer? _availableLocationTimer;
  bool _isDriverAvailable = false;

  Future<void> doIntent(DriverTrackingEvent event) async {
    switch (event) {
      case DriverTrackingBootstrapEvent():
        await _bootstrap();
      case DriverTrackingAssignmentChangedEvent():
        await _syncAssignment(event.assignment);
      case DriverTrackingStartRequestedEvent():
        if (!await _ensureRuntimeServicesInitialized()) return;
        await _pushDriverLocationUseCase.call();
      case DriverTrackingStopRequestedEvent():
        if (!_driverRuntimeServicesController.isInitialized) {
          emit(
            state.copyWith(
              isTracking: false,
              isStopping: false,
              clearFailure: true,
            ),
          );
          return;
        }
        await _stopDriverTrackingUseCase.call();
        emit(
          state.copyWith(
            isTracking: false,
            isStopping: false,
            clearFailure: true,
          ),
        );
      case DriverTrackingLocationReceivedEvent():
        emit(state.copyWith(clearFailure: true));
      case DriverTrackingLocationFailedEvent():
        emit(state.copyWith(failure: event.message));
      case DriverTrackingPermissionSyncEvent():
        if (!await _ensureRuntimeServicesInitialized()) return;
        await _pushDriverLocationUseCase.call();
    }
  }

  Future<void> _bootstrap() async {
    emit(state.copyWith(isStarting: true, clearFailure: true));
    emit(state.copyWith(isStarting: false));
  }

  Future<void> _syncAssignment(DriverHomeAssignmentEntity? assignment) async {
    final command = _resolveCommand(assignment);
    _log(
      '_syncAssignment'
      ' assignmentStatus=${assignment?.status ?? '-'}'
      ' orderId=${assignment?.orderId ?? '-'}'
      ' hasCommand=${command != null}'
      ' fg=${command?.foregroundIntervalSeconds ?? '-'}'
      ' bg=${command?.backgroundIntervalSeconds ?? '-'}',
    );
    emit(
      state.copyWith(
        isStarting: command != null,
        isStopping: command == null,
        activeOrderId: command?.orderId ?? assignment?.orderId,
        activePhase: command?.phase,
        clearFailure: true,
      ),
    );

    if (command == null) {
      _log('No active tracking command. Stopping tracking if needed.');
      if (_driverRuntimeServicesController.isInitialized) {
        await _stopDriverTrackingUseCase.call();
      }
      emit(
        state.copyWith(
          isTracking: false,
          isStarting: false,
          isStopping: false,
          activeOrderId: assignment?.orderId,
          clearActivePhase: true,
        ),
      );
      return;
    }

    if (!await _ensureRuntimeServicesInitialized()) {
      emit(state.copyWith(isStarting: false, isStopping: false));
      return;
    }

    try {
      _log(
        'Starting/syncing tracking'
        ' orderId=${command.orderId}'
        ' phase=${command.phase}',
      );
      await _syncDriverTrackingStatusUseCase.call(command);
      emit(
        state.copyWith(
          isTracking: true,
          isStarting: false,
          isStopping: false,
          activeOrderId: command.orderId,
          activePhase: command.phase,
          clearFailure: true,
        ),
      );
    } catch (error) {
      _log('Tracking sync failed: $error');
      emit(
        state.copyWith(
          isTracking: false,
          isStarting: false,
          isStopping: false,
          activeOrderId: command.orderId,
          activePhase: command.phase,
          failure: error.toString(),
        ),
      );
    }
  }

  Future<bool> _ensureRuntimeServicesInitialized() async {
    try {
      _log('Ensuring runtime services are initialized');
      await _driverRuntimeServicesController.initializeDriverRuntimeServices();
      _log('Runtime services initialized successfully');
      return true;
    } catch (error) {
      _log('Runtime services initialization failed: $error');
      emit(
        state.copyWith(
          isStarting: false,
          isStopping: false,
          failure: error.toString(),
        ),
      );
      return false;
    }
  }

  void _applyTrackingState(DriverTrackingStateEntity trackingState) {
    _log(
      '_applyTrackingState'
      ' isTracking=${trackingState.isTracking}'
      ' orderId=${trackingState.activeOrderId ?? '-'}'
      ' phase=${trackingState.activePhase ?? '-'}'
      ' lat=${trackingState.lastSentLatitude?.toString() ?? '-'}'
      ' lng=${trackingState.lastSentLongitude?.toString() ?? '-'}'
      ' acc=${trackingState.lastSentAccuracyMeters?.toString() ?? '-'}'
      ' sentAt=${trackingState.lastSentAt?.toIso8601String() ?? '-'}'
      ' failure=${trackingState.failure ?? '-'}',
    );
    emit(
      state.copyWith(
        isTracking: trackingState.isTracking,
        isStarting: trackingState.isStarting,
        isStopping: trackingState.isStopping,
        lastSentLatitude: trackingState.lastSentLatitude,
        lastSentLongitude: trackingState.lastSentLongitude,
        lastSentAccuracyMeters: trackingState.lastSentAccuracyMeters,
        lastSentAt: trackingState.lastSentAt,
        activeOrderId: trackingState.activeOrderId,
        activePhase: trackingState.activePhase,
        failure: trackingState.failure,
        clearFailure: trackingState.failure == null,
      ),
    );
  }

  DriverTrackingCommandEntity? _resolveCommand(
    DriverHomeAssignmentEntity? assignment,
  ) {
    if (assignment == null || assignment.orderId.trim().isEmpty) return null;

    final status = assignment.status.trim().toLowerCase().replaceAll('_', '');
    if (status.contains('delivered') ||
        status.contains('deliveryfailed') ||
        status.contains('cancel') ||
        status.contains('pickedup')) {
      // PickedUp: driver has collected the order from the store.
      // No need to track until the driver starts delivery (OnTheWay).
      return null;
    }

    if (status.contains('ontheway') || status.contains('arrivedatcustomer')) {
      return DriverTrackingCommandEntity(
        orderId: assignment.orderId,
        phase: assignment.status,
        foregroundIntervalSeconds: 5,
        backgroundIntervalSeconds: 10,
        useHighAccuracy: true,
      );
    }

    if (status.contains('accepted') || status.contains('arrivedatvendor')) {
      return DriverTrackingCommandEntity(
        orderId: assignment.orderId,
        phase: assignment.status,
        foregroundIntervalSeconds: 5,
        backgroundIntervalSeconds: 10,
        useHighAccuracy: true,
      );
    }

    return null;
  }

  @override
  Future<void> close() async {
    _availableLocationTimer?.cancel();
    await _homeSubscription.cancel();
    await _trackingSubscription.cancel();
    return super.close();
  }

  /// Starts or stops periodic location pushes based on driver availability.
  /// When the driver is available but has no active assignment, we push
  /// location every [_availableLocationInterval] so the backend always has
  /// a recent position for distance calculation when an offer is accepted.
  void _syncAvailabilityLocationPush(DriverHomeEntity home) {
    final isAvailable = home.operationalStatus.isAvailable;
    final hasAssignment = home.currentAssignment != null;

    // If the driver has an active assignment, the normal tracking handles it.
    final shouldPushWhileIdle = isAvailable && !hasAssignment;

    if (shouldPushWhileIdle && !_isDriverAvailable) {
      _isDriverAvailable = true;
      _startAvailableLocationTimer();
    } else if (!shouldPushWhileIdle && _isDriverAvailable) {
      _isDriverAvailable = false;
      _stopAvailableLocationTimer();
    }
  }

  void _startAvailableLocationTimer() {
    _availableLocationTimer?.cancel();
    _log('Starting periodic location push for available driver');
    // Push immediately, then periodically.
    unawaited(_pushLocationWithRetry());
    _availableLocationTimer = Timer.periodic(
      _availableLocationInterval,
      (_) => unawaited(_pushLocationWithRetry()),
    );
  }

  void _stopAvailableLocationTimer() {
    _log('Stopping periodic location push (driver no longer idle-available)');
    _availableLocationTimer?.cancel();
    _availableLocationTimer = null;
  }

  /// Pushes the driver's location with simple retry on failure.
  Future<void> _pushLocationWithRetry() async {
    if (!_driverRuntimeServicesController.isInitialized) {
      try {
        await _driverRuntimeServicesController
            .initializeDriverRuntimeServices();
      } catch (_) {
        _log('Cannot push available location: runtime services not ready');
        return;
      }
    }

    for (var attempt = 0; attempt <= _locationPushMaxRetries; attempt++) {
      try {
        await _pushDriverLocationUseCase.call();
        _log('Available location push succeeded (attempt=$attempt)');
        return;
      } catch (error) {
        _log('Available location push failed (attempt=$attempt): $error');
        if (attempt < _locationPushMaxRetries) {
          await Future<void>.delayed(const Duration(seconds: 3));
        }
      }
    }
  }

  void _log(String message) {
    developer.log(message, name: _logTag);
  }
}
