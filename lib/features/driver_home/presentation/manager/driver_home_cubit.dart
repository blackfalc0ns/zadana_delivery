import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/accept_driver_offer_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/refresh_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/reject_driver_offer_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/update_driver_availability_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/watch_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_event.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_state.dart';

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
  late final StreamSubscription<DriverHomeEntity> _homeSubscription;

  Future<bool> doIntent(DriverHomeEvent event) async {
    switch (event) {
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
    emit(state.copyWith(isAvailabilityUpdating: true, clearFailure: true));

    final result = await _updateDriverAvailabilityUseCase.call(
      isAvailable: isAvailable,
    );
    switch (result) {
      case ApiSuccessResult():
        _applyAvailabilityOptimistically(isAvailable);
        return _refreshAfterAction(isAvailabilityUpdating: false);
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
    emit(
      state.copyWith(
        isLoading: false,
        isRefreshing: false,
        home: home,
        clearFailure: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _homeSubscription.cancel();
    return super.close();
  }
}
