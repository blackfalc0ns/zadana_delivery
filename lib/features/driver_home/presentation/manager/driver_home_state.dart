import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';

class DriverHomeState {
  const DriverHomeState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isAvailabilityUpdating = false,
    this.isOfferActionLoading = false,
    this.activeOfferActionId,
    this.home,
    this.failure,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isAvailabilityUpdating;
  final bool isOfferActionLoading;
  final String? activeOfferActionId;
  final DriverHomeEntity? home;
  final Failure? failure;

  DriverHomeState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isAvailabilityUpdating,
    bool? isOfferActionLoading,
    String? activeOfferActionId,
    DriverHomeEntity? home,
    Failure? failure,
    bool clearFailure = false,
    bool clearActiveOfferActionId = false,
  }) {
    return DriverHomeState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isAvailabilityUpdating:
          isAvailabilityUpdating ?? this.isAvailabilityUpdating,
      isOfferActionLoading: isOfferActionLoading ?? this.isOfferActionLoading,
      activeOfferActionId: clearActiveOfferActionId
          ? null
          : activeOfferActionId ?? this.activeOfferActionId,
      home: home ?? this.home,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
