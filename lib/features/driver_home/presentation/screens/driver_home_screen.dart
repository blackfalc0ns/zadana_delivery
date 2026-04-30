import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_cubit.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_event.dart';
import 'package:zadana_delivery/features/driver_home/presentation/manager/driver_home_state.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_accept_order_dialog.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_error_state.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_loaded_view.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_loading_state.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  static const CameraPosition _fallbackCameraPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 11.8,
  );

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
    final message = _cubit.availabilityBlockedReason;
    if (message == null) return;
    CustomSnackbar.showWarning(context: context, message: message);
  }

  Future<void> _acceptCurrentOffer() async {
    final offer = _cubit.currentOffer;
    if (offer == null) return;

    final orderPreview = _cubit.previewFromOffer(offer);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DriverHomeAcceptOrderDialog(
        order: orderPreview,
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

    final assignment = _cubit.currentAssignment;
    await context.pushNamed(
      AppRoutes.orderDetails,
      rootNavigator: true,
      arguments: {
        'order': assignment != null
            ? _cubit.previewFromAssignment(assignment)
            : orderPreview,
        'driverLocation': _cubit.resolvedDriverLocation(
          _fallbackCameraPosition.target,
        ),
        'startAccepted': true,
      },
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
    final assignment = _cubit.currentAssignment;
    if (assignment == null) return;

    await context.pushNamed(
      AppRoutes.orderDetails,
      rootNavigator: true,
      arguments: {
        'order': _cubit.previewFromAssignment(assignment),
        'driverLocation': _cubit.resolvedDriverLocation(
          _fallbackCameraPosition.target,
        ),
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
        CameraPosition(target: location, zoom: 16.5, tilt: 45),
      ),
    );
  }

  void _handleStateSideEffects(DriverHomeState state) {
    unawaited(
      _cubit.syncLocalizedMarkers(
        storeMarkerLabel: context.localization.order_details_store_label,
      ),
    );

    final noticeMessage = state.noticeMessage?.trim() ?? '';
    if (noticeMessage.isNotEmpty) {
      CustomSnackbar.showWarning(context: context, message: noticeMessage);
      _cubit.clearNotice();
    }

    if (_cubit.shouldRedirectToBlocked) {
      if (_isRedirectingToBlocked) return;
      _isRedirectingToBlocked = true;
      context.pushNamedAndRemoveUntil(
        AppRoutes.accountBlocked,
        rootNavigator: true,
        predicate: (route) => false,
      );
      return;
    }

    final activeLocation = _cubit.activeMapTarget();
    if (activeLocation != null) {
      _animateToLocation(activeLocation);
    }

    if (state.failure != null && state.home != null) {
      CustomSnackbar.showError(
        context: context,
        message: ErrorMessagePresenter.snackBarMessage(
          context,
          state.failure!.asException,
        ),
      );
      _cubit.doIntent(const DriverHomeClearErrorEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverHomeCubit, DriverHomeState>(
        listener: (_, state) => _handleStateSideEffects(state),
        builder: (context, state) {
          if (state.home == null && state.isLoading) {
            return const DriverHomeLoadingState();
          }

          if (state.home == null && state.failure != null && !state.isLoading) {
            return DriverHomeErrorState(
              exception: state.failure!.asException,
              onRetry: () => _cubit.doIntent(const DriverHomeLoadEvent()),
              onGoBack: () =>
                  _cubit.doIntent(const DriverHomeClearErrorEvent()),
            );
          }

          return DriverHomeLoadedView(
            home: state.home!,
            state: state,
            driverLocation: _cubit.resolvedDriverLocation(
              _fallbackCameraPosition.target,
            ),
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
            toPreviewFromOffer: _cubit.previewFromOffer,
          );
        },
      ),
    );
  }
}
