import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
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
      unawaited(
        doIntent(DriverTrackingAssignmentChangedEvent(home.currentAssignment)),
      );
    });
    _trackingSubscription = _repository.watchState().listen(
      _applyTrackingState,
    );
  }

  final WatchDriverHomeUseCase _watchDriverHomeUseCase;
  final StartDriverTrackingUseCase _startDriverTrackingUseCase;
  final StopDriverTrackingUseCase _stopDriverTrackingUseCase;
  final SyncDriverTrackingStatusUseCase _syncDriverTrackingStatusUseCase;
  final PushDriverLocationUseCase _pushDriverLocationUseCase;
  final DriverTrackingRepository _repository;
  final DriverRuntimeServicesController _driverRuntimeServicesController =
      getIt<DriverRuntimeServicesController>();

  late final StreamSubscription<DriverHomeEntity> _homeSubscription;
  late final StreamSubscription<DriverTrackingStateEntity>
  _trackingSubscription;

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

    await _syncDriverTrackingStatusUseCase.call(command);
    await _startDriverTrackingUseCase.call(command);
    emit(
      state.copyWith(
        isTracking: true,
        isStarting: false,
        isStopping: false,
        activeOrderId: command.orderId,
        activePhase: command.phase,
      ),
    );
  }

  Future<bool> _ensureRuntimeServicesInitialized() async {
    try {
      await _driverRuntimeServicesController.initializeDriverRuntimeServices();
      return true;
    } catch (error) {
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
        status.contains('cancel')) {
      return null;
    }

    if (status.contains('pickedup') || status.contains('ontheway')) {
      return DriverTrackingCommandEntity(
        orderId: assignment.orderId,
        phase: assignment.status,
        intervalSeconds: 10,
        useHighAccuracy: true,
      );
    }

    if (status.contains('accepted') ||
        status.contains('arrivedatvendor') ||
        status.contains('arrivedatcustomer')) {
      return DriverTrackingCommandEntity(
        orderId: assignment.orderId,
        phase: assignment.status,
        intervalSeconds: 15,
        useHighAccuracy: false,
      );
    }

    return null;
  }

  @override
  Future<void> close() async {
    await _homeSubscription.cancel();
    await _trackingSubscription.cancel();
    return super.close();
  }
}
