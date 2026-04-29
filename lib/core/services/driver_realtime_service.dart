import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/token_service.dart';

class DriverRealtimeService {
  DriverRealtimeService(this._tokenService);

  static const Duration _retryCooldown = Duration(seconds: 30);
  static const Duration _retryDelay = Duration(seconds: 5);
  static const Duration _missingTokenRetryDelay = Duration(seconds: 2);
  static const String _logTag = '[DriverRealtime]';

  final TokenService _tokenService;

  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _orderStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _arrivalStateController =
      StreamController<Map<String, dynamic>>.broadcast();

  HubConnection? _hubConnection;
  bool _isInitialized = false;
  bool _isConnecting = false;
  DateTime? _retryAfter;
  Timer? _reconnectTimer;

  Stream<Map<String, dynamic>> get notifications =>
      _notificationController.stream;
  Stream<Map<String, dynamic>> get orderStatusChanged =>
      _orderStatusController.stream;
  Stream<Map<String, dynamic>> get arrivalStateChanged =>
      _arrivalStateController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> ensureConnected() async {
    if (_isConnecting) {
      _logConnectionStatus(
        'CONNECTING',
        details: 'ensureConnected skipped: connection already in progress',
      );
      return;
    }
    final retryAfter = _retryAfter;
    if (retryAfter != null && DateTime.now().isBefore(retryAfter)) {
      _logConnectionStatus(
        'WAITING',
        details: 'ensureConnected skipped: cooldown active until $retryAfter',
      );
      final remainingDelay = retryAfter.difference(DateTime.now());
      _scheduleReconnect(
        remainingDelay.isNegative ? _retryDelay : remainingDelay,
      );
      return;
    }

    final existingConnection = _hubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      _logConnectionStatus(
        _connectionStateLabel(existingConnection?.state),
        details:
            'ensureConnected skipped: existing state is ${existingConnection?.state}',
      );
      return;
    }

    final token = (await _tokenService.getToken())?.trim() ?? '';
    if (token.isEmpty) {
      _logConnectionStatus(
        'WAITING',
        details: 'ensureConnected skipped: auth token is empty',
      );
      _scheduleReconnect(_missingTokenRetryDelay);
      return;
    }

    _isConnecting = true;
    try {
      await _ensureHostReachable();
      final hubUrl = _resolveHubUrl(
        NetworkConstants.notificationsHub,
        accessToken: token,
      );
      _logConnectionStatus(
        'CONNECTING',
        hubPath: NetworkConstants.notificationsHub,
        details: hubUrl,
      );
      final connection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.WebSockets,
              accessTokenFactory: () async =>
                  (await _tokenService.getToken())?.trim() ?? '',
              requestTimeout: 10000,
            ),
          )
          .withAutomaticReconnect(
            retryDelays: const [0, 2000, 5000, 10000, 20000],
          )
          .build();

      connection.on(NetworkConstants.driverNotificationEvent, (arguments) {
        final payload = _extractFirstArgument(arguments);
        final notification = _normalizeNotification(payload);
        if (notification.isEmpty) {
          _log(
            'Notification stream event ignored: payload could not be parsed',
          );
          return;
        }
        _log(
          'Notification stream event received: type=${notification['type'] ?? 'unknown'}, '
          'referenceId=${notification['referenceId'] ?? notification['assignmentId'] ?? 'n/a'}',
        );
        _notificationController.add(notification);
      });

      connection.on(NetworkConstants.driverOrderStatusChangedEvent, (
        arguments,
      ) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Order status stream event ignored: payload is empty');
          return;
        }
        _log(
          'Order status stream event received: orderId=${payload['orderId'] ?? 'n/a'}, '
          'status=${payload['status'] ?? payload['newStatus'] ?? 'unknown'}',
        );
        _orderStatusController.add(payload);
      });

      connection.on(NetworkConstants.driverArrivalStateChangedEvent, (
        arguments,
      ) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Arrival state stream event ignored: payload is empty');
          return;
        }
        _log(
          'Arrival state stream event received: orderId=${payload['orderId'] ?? 'n/a'}, '
          'arrivalState=${payload['arrivalState'] ?? payload['state'] ?? 'unknown'}',
        );
        _arrivalStateController.add(payload);
      });

      connection.onreconnected(({String? connectionId}) {
        _logConnectionStatus(
          'RECONNECTED',
          hubPath: NetworkConstants.notificationsHub,
          details: 'connectionId=$connectionId',
        );
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
      });

      connection.onclose(({Exception? error}) {
        _logConnectionStatus(
          'DISCONNECTED',
          hubPath: NetworkConstants.notificationsHub,
          details: 'error=$error',
        );
        if (identical(_hubConnection, connection)) {
          _hubConnection = null;
        }
        _scheduleReconnect();
      });

      await connection.start();
      _hubConnection = connection;
      _retryAfter = null;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _logConnectionStatus(
        'CONNECTED',
        hubPath: NetworkConstants.notificationsHub,
      );
    } catch (error) {
      _retryAfter = DateTime.now().add(_retryCooldown);
      _logConnectionStatus(
        'FAILED',
        hubPath: NetworkConstants.notificationsHub,
        details: error.toString(),
      );
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _scheduleReconnect([Duration delay = _retryDelay]) {
    final existingConnection = _hubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      return;
    }
    if (_reconnectTimer?.isActive == true) {
      return;
    }
    _log('Scheduling realtime reconnect in ${delay.inSeconds}s');
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      unawaited(ensureConnected());
    });
  }

  Future<void> _ensureHostReachable() async {
    final host = Uri.parse(NetworkConstants.baseUrl).host;
    if (host.isEmpty) {
      throw const SocketException('Missing API host');
    }

    final lookup = await InternetAddress.lookup(host);
    if (lookup.isEmpty) {
      throw SocketException('Failed host lookup: $host');
    }
  }

  dynamic _extractFirstArgument(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) return null;
    return arguments.first;
  }

  Map<String, dynamic> _normalizeNotification(dynamic payload) {
    if (payload == null) return const <String, dynamic>{};

    if (payload is String) {
      try {
        return _normalizeNotification(jsonDecode(payload));
      } catch (_) {
        return const <String, dynamic>{};
      }
    }

    final map = _normalizeMap(payload);
    if (map.isEmpty) return const <String, dynamic>{};
    if (map.containsKey('type') || map.containsKey('titleAr')) {
      return map;
    }

    for (final key in const ['notification', 'dataObject', 'payload', 'data']) {
      final nested = _normalizeNotification(map[key]);
      if (nested.isNotEmpty) return nested;
    }

    return const <String, dynamic>{};
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  String _resolveHubUrl(String hubPath, {String? accessToken}) {
    final apiUri = Uri.parse(NetworkConstants.baseUrl);
    final baseSegments = List<String>.from(apiUri.pathSegments);
    if (baseSegments.isNotEmpty && baseSegments.last == 'api') {
      baseSegments.removeLast();
    }

    final pathSegments = hubPath
        .split('/')
        .where((segment) => segment.trim().isNotEmpty)
        .toList();

    final resolvedSegments =
        pathSegments.isNotEmpty && pathSegments.first == 'api'
        ? pathSegments
        : <String>[...baseSegments, ...pathSegments];

    final queryParameters = <String, String>{
      ...apiUri.queryParameters,
      if ((accessToken ?? '').trim().isNotEmpty)
        'access_token': accessToken!.trim(),
    };

    return apiUri
        .replace(
          pathSegments: resolvedSegments,
          queryParameters: queryParameters.isEmpty ? null : queryParameters,
        )
        .toString();
  }

  void _log(String message) {
    debugPrint('$_logTag $message');
  }

  void _logConnectionStatus(String status, {String? hubPath, String? details}) {
    final activeHubPath = (hubPath ?? NetworkConstants.notificationsHub).trim();
    final suffix = (details ?? '').trim();
    _log(
      'SignalR[$status] hub=$activeHubPath state=${_connectionStateLabel(_hubConnection?.state)}'
      '${suffix.isEmpty ? '' : ' | $suffix'}',
    );
  }

  String _connectionStateLabel(HubConnectionState? state) {
    switch (state) {
      case HubConnectionState.Connected:
        return 'CONNECTED';
      case HubConnectionState.Connecting:
        return 'CONNECTING';
      case HubConnectionState.Reconnecting:
        return 'RECONNECTING';
      case HubConnectionState.Disconnecting:
        return 'DISCONNECTING';
      case HubConnectionState.Disconnected:
        return 'DISCONNECTED';
      case null:
        return 'NULL';
    }
  }
}
