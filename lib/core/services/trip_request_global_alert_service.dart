import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/app_navigator_service.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/trip_request_overlay_service.dart';
import 'package:zadana_delivery/features/driver_home/data/data_source/driver_home_remote_data_source.dart';

/// Bridges incoming delivery offers from SignalR/OneSignal to the system overlay.
///
/// When the app is in the background, this service triggers the native
/// system overlay. It also listens for accept/reject/tap callbacks from
/// the native overlay and routes them to the appropriate API calls.
@lazySingleton
class TripRequestGlobalAlertService with WidgetsBindingObserver {
  TripRequestGlobalAlertService(
    this._overlayService,
    this._realtimeService,
    this._homeDataSource,
    this._navigatorService,
  );

  final TripRequestOverlayService _overlayService;
  final DriverRealtimeService _realtimeService;
  final DriverHomeRemoteDataSource _homeDataSource;
  final AppNavigatorService _navigatorService;

  static const MethodChannel _channel = MethodChannel(
    NetworkConstants.tripOverlayChannel,
  );

  StreamSubscription<Map<String, dynamic>>? _deliveryOfferSubscription;
  bool _isStarted = false;
  bool _isAppInForeground = true;

  /// Start listening for delivery offers and lifecycle changes.
  void startListening() {
    if (_isStarted) return;
    _isStarted = true;

    WidgetsBinding.instance.addObserver(this);

    // Listen for native overlay callbacks (accept/reject/tap)
    _channel.setMethodCallHandler(_handleNativeCallback);

    // Listen for delivery offers from SignalR
    _deliveryOfferSubscription = _realtimeService.deliveryOffers.listen(
      _handleDeliveryOffer,
    );

    developer.log(
      'TripRequestGlobalAlertService started listening',
      name: 'TripGlobalAlert',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppInForeground = state == AppLifecycleState.resumed;
    developer.log(
      'App lifecycle: $state, isAppInForeground=$_isAppInForeground',
      name: 'TripGlobalAlert',
    );
  }

  Future<void> _handleDeliveryOffer(Map<String, dynamic> payload) async {
    if (payload.isEmpty) return;

    final assignmentId =
        payload['assignmentId']?.toString() ??
        payload['assignment_id']?.toString() ??
        '';

    developer.log(
      'Delivery offer received: assignmentId=$assignmentId, '
      'isAppInForeground=$_isAppInForeground',
      name: 'TripGlobalAlert',
    );

    // Show system overlay when app is in background
    // (In foreground, the in-app offer UI handles it)
    if (!_isAppInForeground) {
      await _overlayService.showForOffer(payload);
    }
  }

  /// Handle callbacks from the native overlay (accept/reject/tap).
  Future<dynamic> _handleNativeCallback(MethodCall call) async {
    final args = call.arguments as Map<dynamic, dynamic>? ?? {};
    final assignmentId = args['assignment_id']?.toString() ?? '';

    developer.log(
      'Native overlay callback: ${call.method}, assignmentId=$assignmentId',
      name: 'TripGlobalAlert',
    );

    switch (call.method) {
      case 'onAccept':
        if (assignmentId.isNotEmpty) {
          try {
            await _homeDataSource.acceptOffer(assignmentId);
            developer.log(
              'Offer accepted via overlay: $assignmentId',
              name: 'TripGlobalAlert',
            );
            // Refresh home so the accepted order appears in the UI
            unawaited(_homeDataSource.getHome().then(_homeDataSource.emitHome));
            // Navigate to order details screen
            unawaited(
              _navigatorService.pushNamedWhenReady(
                AppRoutes.orderDetails,
                arguments: <String, dynamic>{'assignmentId': assignmentId},
              ),
            );
          } catch (error) {
            developer.log(
              'Failed to accept offer via overlay: $error',
              name: 'TripGlobalAlert',
            );
          }
        }
        break;

      case 'onReject':
        if (assignmentId.isNotEmpty) {
          try {
            await _homeDataSource.rejectOffer(assignmentId);
            developer.log(
              'Offer rejected via overlay: $assignmentId',
              name: 'TripGlobalAlert',
            );
          } catch (error) {
            developer.log(
              'Failed to reject offer via overlay: $error',
              name: 'TripGlobalAlert',
            );
          }
        }
        break;

      case 'onTap':
        // The native side already brings the app to foreground.
        // The in-app UI will show the offer details from the home state.
        developer.log(
          'Overlay tapped — app brought to foreground for assignment: $assignmentId',
          name: 'TripGlobalAlert',
        );
        break;
    }
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _deliveryOfferSubscription?.cancel();
    _deliveryOfferSubscription = null;
    _isStarted = false;
  }
}
