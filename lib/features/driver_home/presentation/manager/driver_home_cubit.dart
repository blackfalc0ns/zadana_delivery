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
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_layers.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_order_preview_mapper.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

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

  static const Set<String> _blockedAccountStatuses = {
    'banned',
    'suspended',
    'inactive',
    'rejected',
    'blocked',
  };
  static const Set<String> _blockedVerificationStatuses = {
    'rejected',
    'suspended',
    'banned',
    'blocked',
  };

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

  DriverHomeOfferEntity? get currentOffer => state.home?.currentOffer;

  DriverHomeAssignmentEntity? get currentAssignment =>
      state.home?.currentAssignment;

  bool get canShowOffer {
    final home = state.home;
    return home?.operationalStatus.isAvailable == true &&
        home?.operationalStatus.canReceiveOrders == true &&
        home?.operationalStatus.canReceiveOffers == true;
  }

  String? get availabilityBlockedReason {
    final home = state.home;
    if (home == null) return null;

    final status = home.operationalStatus;
    return [
      status.restrictionMessage,
      status.suspensionReason,
      status.reviewNote,
      status.message,
      if (status.canGoAvailable == false)
        'This account cannot go online right now.',
    ].where((value) => (value ?? '').trim().isNotEmpty).firstOrNull;
  }

  bool get shouldRedirectToBlocked {
    final home = state.home;
    if (home == null) return false;

    final status = home.operationalStatus;
    final normalizedAccountStatus = status.accountStatus.trim().toLowerCase();
    final normalizedVerificationStatus = status.verificationStatus
        .trim()
        .toLowerCase();
    final normalizedGateStatus = status.gateStatus.trim().toLowerCase();

    if (!status.isOperational) {
      return true;
    }

    if ({
      'rejected',
      'suspended',
      'locked',
    }.contains(normalizedGateStatus)) {
      return true;
    }

    if (_blockedAccountStatuses.contains(normalizedAccountStatus)) {
      return true;
    }

    if (_blockedVerificationStatuses.contains(normalizedVerificationStatus)) {
      return true;
    }

    return false;
  }

  LatLng resolvedDriverLocation(LatLng fallback) {
    return state.driverLocation ?? fallback;
  }

  LatLng? activeMapTarget() {
    return DriverHomeMapLayers.activeMapTarget(
      state.home,
      driverLocation: state.driverLocation,
      includeOfferTarget: canShowOffer,
    );
  }

  DriverOrderPreview previewFromOffer(DriverHomeOfferEntity offer) {
    return DriverHomeOrderPreviewMapper.fromOffer(offer);
  }

  DriverOrderPreview previewFromAssignment(
    DriverHomeAssignmentEntity assignment,
  ) {
    return DriverHomeOrderPreviewMapper.fromAssignment(assignment);
  }

  void _emitIfOpen(DriverHomeState nextState) {
    if (isClosed) return;
    emit(nextState);
  }

  void clearNotice() {
    if (state.noticeMessage == null) return;
    _emitIfOpen(state.copyWith(clearNoticeMessage: true));
  }

  Future<void> _initialize() async {
    await Future.wait<void>([_loadHome(), _loadDriverMarker()]);
    unawaited(_bootstrapActiveSession());
  }

  Future<void> _loadHome({bool refresh = false}) async {
    _emitIfOpen(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearFailure: true,
      ),
    );

    final result = await _refreshDriverHomeUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        _emitIfOpen(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        _emitIfOpen(
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
    _emitIfOpen(state.copyWith(clearFailure: true));
  }

  Future<bool> _toggleAvailability(bool isAvailable) async {
    _emitIfOpen(
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
        _emitIfOpen(
          state.copyWith(isAvailabilityUpdating: false, clearFailure: true),
        );
        unawaited(_refreshHomeAfterAvailabilityChange());
        if (isAvailable) {
          unawaited(_startOnlineRuntimeServices());
        }
        return true;
      case ApiErrorResult():
        _emitIfOpen(
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

    _emitIfOpen(
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
            driverId: currentHome.operationalStatus.driverId,
            gateStatus: currentHome.operationalStatus.gateStatus,
            verificationStatus:
                currentHome.operationalStatus.verificationStatus,
            accountStatus: currentHome.operationalStatus.accountStatus,
            zoneName: currentHome.operationalStatus.zoneName,
            commitmentScore: currentHome.operationalStatus.commitmentScore,
            dailyRejections: currentHome.operationalStatus.dailyRejections,
            weeklyRejections: currentHome.operationalStatus.weeklyRejections,
            enforcementLevel: currentHome.operationalStatus.enforcementLevel,
            canReceiveOffers: currentHome.operationalStatus.canReceiveOffers,
            restrictionMessage:
                currentHome.operationalStatus.restrictionMessage,
            reviewedAtUtc: currentHome.operationalStatus.reviewedAtUtc,
            reviewNote: currentHome.operationalStatus.reviewNote,
            suspensionReason: currentHome.operationalStatus.suspensionReason,
            message: currentHome.operationalStatus.message,
          ),
          currentOffer: currentHome.currentOffer,
          currentAssignment: currentHome.currentAssignment,
          earningsSummaryToday: currentHome.earningsSummaryToday,
          unreadAlerts: currentHome.unreadAlerts,
          commitment: currentHome.commitment,
          profileReadiness: currentHome.profileReadiness,
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
    return isAvailable ? 'Idle' : 'Idle';
  }

  Future<bool> _acceptOffer(String assignmentId) async {
    _emitIfOpen(
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
        _emitIfOpen(
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
    _emitIfOpen(
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
        _emitIfOpen(
          state.copyWith(
            isOfferActionLoading: false,
            clearActiveOfferActionId: true,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<void> _loadDriverMarker() async {
    final icon = await DriverHomeMarkerFactory.buildDriverMarker();
    if (isClosed) return;
    _emitIfOpen(state.copyWith(driverMarkerIcon: icon));
  }

  Future<void> _loadPickupMarker(
    String marketName,
    String markerLabel,
  ) async {
    final normalizedName = marketName.trim();
    if (normalizedName.isEmpty || state.pickupMarkerLabel == normalizedName) {
      return;
    }

    final icon = await DriverHomeMarkerFactory.buildPickupMarker(
      marketName: normalizedName,
      markerLabel: markerLabel,
    );
    if (isClosed) return;

    _emitIfOpen(
      state.copyWith(pickupMarkerIcon: icon, pickupMarkerLabel: normalizedName),
    );
  }

  Future<void> syncLocalizedMarkers({
    required String storeMarkerLabel,
  }) async {
    final activeName =
        canShowOffer
            ? state.home?.currentOffer?.vendorName ??
                state.home?.currentAssignment?.vendorName
            : state.home?.currentAssignment?.vendorName;
    if ((activeName ?? '').trim().isEmpty) return;
    await _loadPickupMarker(activeName!, storeMarkerLabel);
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (isClosed) return;

      _emitIfOpen(
        state.copyWith(
          isMyLocationEnabled: true,
          driverLocation: LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (_) {
      if (isClosed) return;
      _emitIfOpen(
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
      case ApiSuccessResult():
        _emitIfOpen(
          state.copyWith(
            isAvailabilityUpdating: isAvailabilityUpdating ?? false,
            isOfferActionLoading: isOfferActionLoading ?? false,
            clearActiveOfferActionId: clearActiveOfferActionId,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        _emitIfOpen(
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
    final canShowOfferForHome =
        home.operationalStatus.isAvailable &&
        home.operationalStatus.canReceiveOrders &&
        home.operationalStatus.canReceiveOffers;
    final activeName = canShowOfferForHome
        ? home.currentOffer?.vendorName ?? home.currentAssignment?.vendorName
        : home.currentAssignment?.vendorName;
    final shouldClearPickupMarker =
        (activeName ?? '').trim().isEmpty &&
        (state.pickupMarkerIcon != null || state.pickupMarkerLabel != null);
    final isDuplicateHomeSnapshot =
        state.home != null &&
        _homeFingerprint(state.home!) == _homeFingerprint(home);

    if (isDuplicateHomeSnapshot &&
        !state.isLoading &&
        !state.isRefreshing &&
        state.failure == null &&
        !shouldClearPickupMarker) {
      return;
    }

    _emitIfOpen(
      state.copyWith(
        isLoading: false,
        isRefreshing: false,
        home: home,
        clearFailure: true,
      ),
    );

    if ((activeName ?? '').trim().isNotEmpty) {
      return;
    }

    if (shouldClearPickupMarker) {
      _emitIfOpen(
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

  int _homeFingerprint(DriverHomeEntity home) {
    return Object.hash(
      home.homeState,
      _operationalStatusFingerprint(home.operationalStatus),
      _offerFingerprint(home.currentOffer),
      _assignmentFingerprint(home.currentAssignment),
      _earningsFingerprint(home.earningsSummaryToday),
      home.unreadAlerts,
      _commitmentFingerprint(home.commitment),
      _profileReadinessFingerprint(home.profileReadiness),
    );
  }

  int _operationalStatusFingerprint(DriverHomeOperationalStatusEntity status) {
    return Object.hash(
      status.driverId,
      status.gateStatus,
      status.isOperational,
      status.canReceiveOrders,
      status.isAvailable,
      status.canGoAvailable,
      status.verificationStatus,
      status.accountStatus,
      status.zoneName,
      status.commitmentScore,
      status.dailyRejections,
      status.weeklyRejections,
      status.enforcementLevel,
      status.canReceiveOffers,
      status.restrictionMessage,
      status.reviewedAtUtc,
      status.reviewNote,
      status.suspensionReason,
      status.message,
    );
  }

  int? _offerFingerprint(DriverHomeOfferEntity? offer) {
    if (offer == null) return null;
    return Object.hashAll([
      offer.assignmentId,
      offer.orderId,
      offer.orderNumber,
      offer.vendorName,
      offer.pickupAddress,
      offer.pickupLatitude,
      offer.pickupLongitude,
      offer.customerName,
      offer.deliveryAddress,
      offer.deliveryLatitude,
      offer.deliveryLongitude,
      offer.estimatedDistanceKm,
      offer.estimatedEta,
      offer.paymentMethod,
      offer.totalAmount,
      offer.codAmount,
      offer.payout,
      offer.countdownSeconds,
      Object.hashAll(offer.orderItems.map(_offerItemFingerprint)),
      offer.vendorInitials,
      offer.customerInitials,
      offer.packageNote,
    ]);
  }

  int _offerItemFingerprint(DriverHomeOfferItemEntity item) {
    return Object.hash(item.name, item.quantity, item.note);
  }

  int? _assignmentFingerprint(DriverHomeAssignmentEntity? assignment) {
    if (assignment == null) return null;
    return Object.hashAll([
      assignment.assignmentId,
      assignment.orderId,
      assignment.orderNumber,
      assignment.status,
      assignment.vendorName,
      assignment.pickupAddress,
      assignment.deliveryAddress,
      assignment.pickupLatitude,
      assignment.pickupLongitude,
      assignment.deliveryLatitude,
      assignment.deliveryLongitude,
      assignment.paymentMethod,
      assignment.totalAmount,
      assignment.codAmount,
      assignment.createdAtUtc,
      assignment.merchantContact,
      assignment.vehicleType,
      assignment.plateNumber,
      assignment.pickupOtpRequired,
      assignment.deliveryOtpRequired,
      assignment.pickupOtpCode,
    ]);
  }

  int? _earningsFingerprint(DriverHomeEarningsEntity? earnings) {
    if (earnings == null) return null;
    return Object.hash(earnings.earningsAmount, earnings.completedTrips);
  }

  int _commitmentFingerprint(DriverHomeCommitmentEntity commitment) {
    return Object.hash(
      commitment.acceptedOffers,
      commitment.rejectedOffers,
      commitment.timedOutOffers,
      commitment.dailyRejections,
      commitment.weeklyRejections,
      commitment.commitmentScore,
      commitment.enforcementLevel,
      commitment.canReceiveOffers,
      commitment.restrictionMessage,
      commitment.lastOfferResponseAtUtc,
    );
  }

  int _profileReadinessFingerprint(DriverProfileReadinessEntity readiness) {
    return Object.hash(
      readiness.isProfileComplete,
      readiness.completionPercent,
      Object.hashAll(readiness.missingRequirements),
      readiness.canSubmitForReview,
      Object.hashAll(readiness.checklist.map(_profileChecklistItemFingerprint)),
    );
  }

  int _profileChecklistItemFingerprint(DriverProfileChecklistItemEntity item) {
    return Object.hash(item.code, item.completed, item.note, item.critical);
  }
}
