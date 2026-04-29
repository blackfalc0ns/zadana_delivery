import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_runtime_services_controller.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/accept_driver_offer_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/refresh_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/reject_driver_offer_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/update_driver_availability_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/watch_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_event.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_state.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_marker_factory.dart';

@injectable
class DriverHomeCubit extends Cubit<DriverHomeState> {
  DriverHomeCubit(
    this._watchDriverHomeUseCase,
    this._refreshDriverHomeUseCase,
    this._updateDriverAvailabilityUseCase,
    this._acceptDriverOfferUseCase,
    this._rejectDriverOfferUseCase,
  ) : super(const DriverHomeState()) {
    _homeSubscription = _watchDriverHomeUseCase.call().listen(_onHomeUpdated);
  }

  final WatchDriverHomeUseCase _watchDriverHomeUseCase;
  final RefreshDriverHomeUseCase _refreshDriverHomeUseCase;
  final UpdateDriverAvailabilityUseCase _updateDriverAvailabilityUseCase;
  final AcceptDriverOfferUseCase _acceptDriverOfferUseCase;
  final RejectDriverOfferUseCase _rejectDriverOfferUseCase;
  final LocationPermissionService _locationPermissionService =
      getIt<LocationPermissionService>();
  final DriverRuntimeServicesController _driverRuntimeServicesController =
      getIt<DriverRuntimeServicesController>();
  late final StreamSubscription<DriverHomeEntity> _homeSubscription;

  Future<bool> doIntent(DriverHomeEvent event) async {
    switch (event) {
      case DriverHomeInitializeEvent():
        await _initialize();
        return true;
      case DriverHomeLoadEvent():
        await _loadHome(refresh: event.refresh);
        return true;
      case DriverHomeClearErrorEvent():
        _clearError();
        return true;
      case DriverHomeToggleAvailabilityEvent():
        return _toggleAvailability(event.isAvailable);
      case DriverHomeAcceptOfferEvent():
        return _acceptOffer(event.assignmentId);
      case DriverHomeRejectOfferEvent():
        return _rejectOffer(event.assignmentId, reason: event.reason);
    }
  }

  Future<void> _initialize() async {
    await Future.wait<void>([_loadHome(), _loadDriverMarker()]);
    unawaited(_bootstrapActiveSession());
  }

  Future<void> _loadHome({bool refresh = false}) async {
    emit(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearFailure: true,
      ),
    );

    final result = await _refreshDriverHomeUseCase.call();
    switch (result) {
      case ApiSuccessResult(data: final home):
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            home: home,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            failure: result.failure,
          ),
        );
    }
  }

  void _clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }

  Future<bool> _toggleAvailability(bool isAvailable) async {
    emit(
      state.copyWith(
        isAvailabilityUpdating: true,
        clearFailure: true,
        clearNoticeMessage: true,
      ),
    );

    final result = await _updateDriverAvailabilityUseCase.call(
      isAvailable: isAvailable,
    );
    switch (result) {
      case ApiSuccessResult():
        _applyAvailabilityOptimistically(isAvailable);
        emit(
          state.copyWith(isAvailabilityUpdating: false, clearFailure: true),
        );
        unawaited(_refreshHomeAfterAvailabilityChange());
        if (isAvailable) {
          unawaited(_startOnlineRuntimeServices());
        }
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isAvailabilityUpdating: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  void _applyAvailabilityOptimistically(bool isAvailable) {
    final currentHome = state.home;
    if (currentHome == null) return;

    emit(
      state.copyWith(
        home: DriverHomeEntity(
          homeState: _resolveHomeStateAfterAvailabilityChange(
            currentHome,
            isAvailable,
          ),
          operationalStatus: DriverHomeOperationalStatusEntity(
            isOperational: currentHome.operationalStatus.isOperational,
            canReceiveOrders: currentHome.operationalStatus.canReceiveOrders,
            isAvailable: isAvailable,
            canGoAvailable: currentHome.operationalStatus.canGoAvailable,
            verificationStatus:
                currentHome.operationalStatus.verificationStatus,
            accountStatus: currentHome.operationalStatus.accountStatus,
            zoneName: currentHome.operationalStatus.zoneName,
            commitmentScore: currentHome.operationalStatus.commitmentScore,
            canReceiveOffers: currentHome.operationalStatus.canReceiveOffers,
            restrictionMessage:
                currentHome.operationalStatus.restrictionMessage,
            message: currentHome.operationalStatus.message,
          ),
          currentOffer: currentHome.currentOffer,
          currentAssignment: currentHome.currentAssignment,
          earningsSummaryToday: currentHome.earningsSummaryToday,
          unreadAlerts: currentHome.unreadAlerts,
        ),
        clearFailure: true,
      ),
    );
  }

  String _resolveHomeStateAfterAvailabilityChange(
    DriverHomeEntity currentHome,
    bool isAvailable,
  ) {
    if (currentHome.currentAssignment != null) {
      return currentHome.homeState;
    }
    return isAvailable ? 'WaitingForOffer' : 'Offline';
  }

  Future<bool> _acceptOffer(String assignmentId) async {
    emit(
      state.copyWith(
        isOfferActionLoading: true,
        activeOfferActionId: assignmentId,
        clearFailure: true,
      ),
    );

    final result = await _acceptDriverOfferUseCase.call(assignmentId);
    switch (result) {
      case ApiSuccessResult():
        return _refreshAfterAction(
          isOfferActionLoading: false,
          clearActiveOfferActionId: true,
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isOfferActionLoading: false,
            clearActiveOfferActionId: true,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _rejectOffer(String assignmentId, {String? reason}) async {
    emit(
      state.copyWith(
        isOfferActionLoading: true,
        activeOfferActionId: assignmentId,
        clearFailure: true,
      ),
    );

    final result = await _rejectDriverOfferUseCase.call(
      assignmentId,
      reason: reason,
    );
    switch (result) {
      case ApiSuccessResult():
        return _refreshAfterAction(
          isOfferActionLoading: false,
          clearActiveOfferActionId: true,
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isOfferActionLoading: false,
            clearActiveOfferActionId: true,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  DriverHomeOfferEntity? get currentOffer => state.home?.currentOffer;

  DriverHomeAssignmentEntity? get currentAssignment =>
      state.home?.currentAssignment;

  Future<void> _loadDriverMarker() async {
    final icon = await DriverHomeMarkerFactory.buildDriverMarker();
    if (isClosed) return;
    emit(state.copyWith(driverMarkerIcon: icon));
  }

  Future<void> _loadPickupMarker(String marketName) async {
    final normalizedName = marketName.trim();
    if (normalizedName.isEmpty || state.pickupMarkerLabel == normalizedName) {
      return;
    }
    final icon = await DriverHomeMarkerFactory.buildPickupMarker(
      marketName: normalizedName,
    );
    if (isClosed) return;
    emit(
      state.copyWith(pickupMarkerIcon: icon, pickupMarkerLabel: normalizedName),
    );
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (isClosed) return;
      emit(
        state.copyWith(
          isMyLocationEnabled: true,
          driverLocation: LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(isMyLocationEnabled: false, clearDriverLocation: true),
      );
    }
  }

  Future<void> _startOnlineRuntimeServices() async {
    try {
      await _locationPermissionService.ensureForegroundPermission();
      await _driverRuntimeServicesController.initializeDriverRuntimeServices();
      await _loadCurrentLocation();
    } on LocationServiceException catch (_) {
      return;
    } catch (_) {
      return;
    }
  }

  Future<void> _bootstrapActiveSession() async {
    final home = state.home;
    if (home == null) return;

    final shouldBootstrapRuntime =
        home.operationalStatus.isAvailable ||
        home.currentAssignment != null ||
        home.currentOffer != null;
    if (!shouldBootstrapRuntime) return;

    try {
      await _driverRuntimeServicesController.initializeDriverRuntimeServices();
      if (home.operationalStatus.isAvailable) {
        await _loadCurrentLocation();
      }
    } catch (_) {
      // Keep the screen usable even if runtime services fail to start.
    }

    if (isClosed) return;
    await _loadHome(refresh: true);
  }

  void clearNotice() {
    if (state.noticeMessage == null) return;
    emit(state.copyWith(clearNoticeMessage: true));
  }

  Future<void> _refreshHomeAfterAvailabilityChange() async {
    await _refreshAfterAction(isAvailabilityUpdating: false);
  }

  Future<bool> _refreshAfterAction({
    bool? isAvailabilityUpdating,
    bool? isOfferActionLoading,
    bool clearActiveOfferActionId = false,
  }) async {
    final result = await _refreshDriverHomeUseCase.call();
    switch (result) {
      case ApiSuccessResult(data: final home):
        emit(
          state.copyWith(
            isAvailabilityUpdating: isAvailabilityUpdating ?? false,
            isOfferActionLoading: isOfferActionLoading ?? false,
            clearActiveOfferActionId: clearActiveOfferActionId,
            home: home,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isAvailabilityUpdating: isAvailabilityUpdating ?? false,
            isOfferActionLoading: isOfferActionLoading ?? false,
            clearActiveOfferActionId: clearActiveOfferActionId,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  void _onHomeUpdated(DriverHomeEntity home) {
    final canShowOffer =
        home.operationalStatus.isAvailable &&
        home.operationalStatus.canReceiveOrders &&
        home.operationalStatus.canReceiveOffers;
    final activeName = canShowOffer
        ? home.currentOffer?.vendorName ?? home.currentAssignment?.vendorName
        : home.currentAssignment?.vendorName;

    emit(
      state.copyWith(
        isLoading: false,
        isRefreshing: false,
        home: home,
        clearFailure: true,
      ),
    );

    if ((activeName ?? '').trim().isNotEmpty) {
      unawaited(_loadPickupMarker(activeName!));
    } else if (state.pickupMarkerIcon != null ||
        state.pickupMarkerLabel != null) {
      emit(
        state.copyWith(
          clearPickupMarkerIcon: true,
          clearPickupMarkerLabel: true,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _homeSubscription.cancel();
    return super.close();
  }
}
