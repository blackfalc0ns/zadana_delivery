import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_cubit.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_event.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_state.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_accept_order_dialog.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_loaded_view.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_map_layers.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_order_preview_mapper.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  static const CameraPosition _fallbackCameraPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 11.8,
  );
  static const Set<String> _blockedHomeStates = {
    'banned',
    'suspended',
    'inactive',
    'unavailable',
    'rejected',
  };

  late final DriverHomeCubit _cubit;
  GoogleMapController? _mapController;
  bool _isRedirectingToBlocked = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverHomeCubit>()
      ..doIntent(const DriverHomeInitializeEvent());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _toggleAvailability(bool value) async {
    final changed = await _cubit.doIntent(
      DriverHomeToggleAvailabilityEvent(value),
    );
    if (!mounted || !changed) return;
    CustomSnackbar.showSuccess(
      context: context,
      message: value
          ? context.localization.driver_home_connection_online_title
          : context.localization.driver_home_connection_offline_title,
    );
  }

  void _showAvailabilityBlockedReason() {
    final home = _cubit.state.home;
    if (home == null) return;

    final status = home.operationalStatus;
    final message = [
      status.restrictionMessage,
      status.message,
      if (status.canGoAvailable == false)
        'This account cannot go online right now.',
    ].where((value) => (value ?? '').trim().isNotEmpty).firstOrNull;

    if (message == null) return;

    CustomSnackbar.showWarning(context: context, message: message);
  }

  Future<void> _acceptCurrentOffer() async {
    final offer = _cubit.currentOffer;
    if (offer == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DriverHomeAcceptOrderDialog(
        order: _toPreviewFromOffer(offer),
        dialogContext: dialogContext,
      ),
    );

    if (!mounted || confirmed != true) return;
    final accepted = await _cubit.doIntent(
      DriverHomeAcceptOfferEvent(offer.assignmentId),
    );
    if (!mounted || !accepted) return;
    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.driver_home_accept,
    );
  }

  Future<void> _rejectCurrentOffer() async {
    final offer = _cubit.currentOffer;
    if (offer == null) return;
    final rejected = await _cubit.doIntent(
      DriverHomeRejectOfferEvent(offer.assignmentId),
    );
    if (!mounted || !rejected) return;
    CustomSnackbar.showInfo(
      context: context,
      message: context.localization.driver_home_reject,
    );
  }

  Future<void> _openMissionDetails() async {
    final assignment = _cubit.state.home?.currentAssignment;
    if (assignment == null) return;

    await context.pushNamed(
      AppRoutes.orderDetails,
      rootNavigator: true,
      arguments: {
        'order': _toPreviewFromAssignment(assignment),
        'driverLocation': _resolvedDriverLocation(_cubit.state),
        'startAccepted': true,
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _animateToLocation(LatLng location) async {
    if (_mapController == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16.5, tilt: 45.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverHomeCubit, DriverHomeState>(
        listener: (context, state) {
          final noticeMessage = state.noticeMessage?.trim() ?? '';
          if (noticeMessage.isNotEmpty) {
            CustomSnackbar.showWarning(
              context: context,
              message: noticeMessage,
            );
            _cubit.clearNotice();
          }

          final home = state.home;
          if (home != null && _shouldRedirectToBlocked(home)) {
            if (!_isRedirectingToBlocked) {
              _isRedirectingToBlocked = true;
              context.pushNamedAndRemoveUntil(
                AppRoutes.accountBlocked,
                rootNavigator: true,
                predicate: (route) => false,
              );
            }
            return;
          }
          final canShowOffer =
              home?.operationalStatus.isAvailable == true &&
              home?.operationalStatus.canReceiveOrders == true &&
              home?.operationalStatus.canReceiveOffers == true;
          final activeLocation = _activeMapTarget(
            state,
            home,
            includeOfferTarget: canShowOffer,
          );
          if (activeLocation != null) {
            _animateToLocation(activeLocation);
          }

          if (state.failure != null && state.home != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.failure!.errorMessage,
            );
            _cubit.doIntent(const DriverHomeClearErrorEvent());
          }
        },
        builder: (context, state) {
          if (state.home == null && state.isLoading) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: const Center(child: CustomProgressIndicator()),
            );
          }

          if (state.home == null && state.failure != null && !state.isLoading) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: state.failure!.asException,
                  onRetry: () => _cubit.doIntent(const DriverHomeLoadEvent()),
                  onGoBack: () =>
                      _cubit.doIntent(const DriverHomeClearErrorEvent()),
                ),
              ),
            );
          }

          return DriverHomeLoadedView(
            home: state.home!,
            state: state,
            driverLocation: _resolvedDriverLocation(state),
            fallbackZoom: _fallbackCameraPosition.zoom,
            isMyLocationEnabled: state.isMyLocationEnabled,
            driverMarkerIcon: state.driverMarkerIcon,
            pickupMarkerIcon: state.pickupMarkerIcon,
            onMapCreated: _onMapCreated,
            onToggleAvailability: _toggleAvailability,
            onDisabledAvailabilityTap: _showAvailabilityBlockedReason,
            onAcceptOffer: _acceptCurrentOffer,
            onRejectOffer: _rejectCurrentOffer,
            onOfferExpired: () =>
                _cubit.doIntent(const DriverHomeLoadEvent(refresh: true)),
            onAnimateToLocation: _animateToLocation,
            onOpenMission: _openMissionDetails,
            toPreviewFromOffer: _toPreviewFromOffer,
          );
        },
      ),
    );
  }

  DriverOrderPreview _toPreviewFromOffer(DriverHomeOfferEntity offer) {
    return DriverHomeOrderPreviewMapper.fromOffer(offer);
  }

  DriverOrderPreview _toPreviewFromAssignment(
    DriverHomeAssignmentEntity assignment,
  ) {
    return DriverHomeOrderPreviewMapper.fromAssignment(assignment);
  }

  LatLng _resolvedDriverLocation(DriverHomeState state) {
    return state.driverLocation ?? _fallbackCameraPosition.target;
  }

  LatLng? _activeMapTarget(
    DriverHomeState state,
    DriverHomeEntity? home, {
    bool includeOfferTarget = true,
  }) {
    return DriverHomeMapLayers.activeMapTarget(
      home,
      driverLocation: state.driverLocation,
      includeOfferTarget: includeOfferTarget,
    );
  }

  bool _shouldRedirectToBlocked(DriverHomeEntity home) {
    final normalizedHomeState = home.homeState.trim().toLowerCase();
    if (_blockedHomeStates.contains(normalizedHomeState)) {
      return true;
    }

    final restrictionMessage =
        home.operationalStatus.restrictionMessage?.trim().toLowerCase() ?? '';
    if (restrictionMessage.isEmpty) return false;

    return restrictionMessage.contains('block') ||
        restrictionMessage.contains('blocked') ||
        restrictionMessage.contains('suspend') ||
        restrictionMessage.contains('banned') ||
        restrictionMessage.contains('محظور') ||
        restrictionMessage.contains('موقوف') ||
        restrictionMessage.contains('بلوك');
  }
}
