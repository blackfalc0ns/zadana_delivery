import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/constants/app_constants.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';

/// System-level overlay service that displays a trip-request bottom sheet
/// above all other applications — even when the app is fully backgrounded
/// or the screen is locked.
///
/// Uses Android's `WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY`
/// through a Flutter MethodChannel bridge.
@lazySingleton
class TripRequestOverlayService {
  TripRequestOverlayService(this._prefs);

  final SharedPreferences _prefs;

  static const MethodChannel _channel = MethodChannel(
    NetworkConstants.tripOverlayChannel,
  );

  /// Whether the driver has the background trip overlay feature enabled.
  bool get isEnabled =>
      _prefs.getBool(AppConstants.tripOverlayEnabledKey) ?? true;

  /// Toggle the feature on/off. Automatically closes the overlay when disabled.
  Future<void> setEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.tripOverlayEnabledKey, enabled);
    if (!enabled) {
      await closeOverlay();
    }
  }

  /// Check if the OS overlay permission (`SYSTEM_ALERT_WINDOW`) is granted.
  Future<bool> hasPermission() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('canDrawOverlays');
      return result ?? false;
    } catch (error) {
      developer.log(
        'TripRequestOverlayService.hasPermission failed: $error',
        name: 'TripOverlay',
      );
      return false;
    }
  }

  /// Opens the OS "Display over other apps" settings page if permission
  /// is not already granted. Returns `true` if permission is already granted.
  Future<bool> requestPermission() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final alreadyGranted = await hasPermission();
      if (alreadyGranted) return true;
      await _channel.invokeMethod<void>('openOverlaySettings');
      return false;
    } catch (error) {
      developer.log(
        'TripRequestOverlayService.requestPermission failed: $error',
        name: 'TripOverlay',
      );
      return false;
    }
  }

  /// Show the system overlay for an incoming delivery offer.
  ///
  /// [offerData] should contain the offer fields from SignalR/push payload.
  /// Returns `true` if the overlay was successfully shown.
  Future<bool> showForOffer(Map<String, dynamic> offerData) async {
    if (kIsWeb || !Platform.isAndroid) return false;
    if (!isEnabled) {
      developer.log(
        'TripRequestOverlayService.showForOffer skipped: feature disabled',
        name: 'TripOverlay',
      );
      return false;
    }

    final hasOverlayPermission = await hasPermission();
    if (!hasOverlayPermission) {
      developer.log(
        'TripRequestOverlayService.showForOffer skipped: no overlay permission',
        name: 'TripOverlay',
      );
      return false;
    }

    try {
      final data = <String, dynamic>{
        'assignment_id': _str(
          offerData['assignmentId'] ?? offerData['assignment_id'],
        ),
        'order_id': _str(offerData['orderId'] ?? offerData['order_id']),
        'order_number': _str(
          offerData['orderNumber'] ?? offerData['order_number'],
        ),
        'vendor_name': _str(
          offerData['vendorName'] ?? offerData['vendor_name'],
        ),
        'pickup_address': _str(
          offerData['pickupAddress'] ??
              offerData['pickup_address'] ??
              offerData['vendorAddress'] ??
              '',
        ),
        'delivery_address': _str(
          offerData['deliveryAddress'] ??
              offerData['delivery_address'] ??
              offerData['customerAddress'] ??
              '',
        ),
        'distance_km': _toDouble(
          offerData['estimatedDistanceKm'] ?? offerData['distanceKm'] ?? 0,
        ),
        'eta': _str(offerData['estimatedEta'] ?? offerData['eta'] ?? ''),
        'payout': _toDouble(
          offerData['payout'] ?? offerData['deliveryFee'] ?? 0,
        ),
        'total_amount': _toDouble(offerData['totalAmount'] ?? 0),
        'payment_method': _str(offerData['paymentMethod'] ?? ''),
        'countdown_seconds': _toInt(offerData['countdownSeconds'] ?? 30),
        'customer_name': _str(
          offerData['customerName'] ?? offerData['customer_name'] ?? '',
        ),
      };

      final result = await _channel.invokeMethod<bool>('showOverlay', data);
      developer.log(
        'TripRequestOverlayService.showForOffer result=$result '
        'assignmentId=${data['assignment_id']}',
        name: 'TripOverlay',
      );
      return result ?? false;
    } catch (error) {
      developer.log(
        'TripRequestOverlayService.showForOffer failed: $error',
        name: 'TripOverlay',
      );
      return false;
    }
  }

  /// Show overlay with sample/test data for debugging.
  Future<bool> showForTest() async {
    return showForOffer(const <String, dynamic>{
      'assignmentId': 'test-assignment-001',
      'orderId': 'test-order-001',
      'orderNumber': '#12345',
      'vendorName': 'مطعم تجريبي',
      'pickupAddress': 'شارع الملك فهد، الرياض',
      'deliveryAddress': 'حي النزهة، شارع الأمير سلطان',
      'estimatedDistanceKm': 5.2,
      'estimatedEta': '12 دقيقة',
      'payout': 15.0,
      'totalAmount': 85.0,
      'paymentMethod': 'cash',
      'countdownSeconds': 30,
      'customerName': 'أحمد محمد',
    });
  }

  /// Dismiss the overlay.
  Future<void> closeOverlay() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('hideOverlay');
    } catch (error) {
      developer.log(
        'TripRequestOverlayService.closeOverlay failed: $error',
        name: 'TripOverlay',
      );
    }
  }

  /// Cleanup (injectable @disposeMethod placeholder).
  Future<void> dispose() async {
    await closeOverlay();
  }

  String _str(dynamic value) => value?.toString() ?? '';

  double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
