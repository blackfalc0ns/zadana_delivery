import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    this.noticeMessage,
    this.isMyLocationEnabled = false,
    this.driverLocation,
    this.driverMarkerIcon,
    this.pickupMarkerIcon,
    this.pickupMarkerLabel,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isAvailabilityUpdating;
  final bool isOfferActionLoading;
  final String? activeOfferActionId;
  final DriverHomeEntity? home;
  final Failure? failure;
  final String? noticeMessage;
  final bool isMyLocationEnabled;
  final LatLng? driverLocation;
  final BitmapDescriptor? driverMarkerIcon;
  final BitmapDescriptor? pickupMarkerIcon;
  final String? pickupMarkerLabel;

  DriverHomeState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isAvailabilityUpdating,
    bool? isOfferActionLoading,
    String? activeOfferActionId,
    DriverHomeEntity? home,
    Failure? failure,
    String? noticeMessage,
    bool? isMyLocationEnabled,
    LatLng? driverLocation,
    BitmapDescriptor? driverMarkerIcon,
    BitmapDescriptor? pickupMarkerIcon,
    String? pickupMarkerLabel,
    bool clearFailure = false,
    bool clearNoticeMessage = false,
    bool clearActiveOfferActionId = false,
    bool clearDriverLocation = false,
    bool clearPickupMarkerIcon = false,
    bool clearPickupMarkerLabel = false,
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
      noticeMessage: clearNoticeMessage
          ? null
          : noticeMessage ?? this.noticeMessage,
      isMyLocationEnabled: isMyLocationEnabled ?? this.isMyLocationEnabled,
      driverLocation: clearDriverLocation
          ? null
          : driverLocation ?? this.driverLocation,
      driverMarkerIcon: driverMarkerIcon ?? this.driverMarkerIcon,
      pickupMarkerIcon: clearPickupMarkerIcon
          ? null
          : pickupMarkerIcon ?? this.pickupMarkerIcon,
      pickupMarkerLabel: clearPickupMarkerLabel
          ? null
          : pickupMarkerLabel ?? this.pickupMarkerLabel,
    );
  }
}
