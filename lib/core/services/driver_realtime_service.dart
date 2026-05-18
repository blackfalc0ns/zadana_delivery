import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/widgets.dart';
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
  final StreamController<Map<String, dynamic>> _deliveryOfferController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _orderStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _arrivalStateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _assignmentUpdatedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _supportCaseChangedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _driverHomeUpdatedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _driverWalletUpdatedController =
      StreamController<Map<String, dynamic>>.broadcast();

  HubConnection? _hubConnection;
  bool _isInitialized = false;
  bool _isConnecting = false;
  bool _disconnectRequested = false;
  DateTime? _retryAfter;
  Timer? _reconnectTimer;

  Stream<Map<String, dynamic>> get notifications =>
      _notificationController.stream;
  Stream<Map<String, dynamic>> get deliveryOffers =>
      _deliveryOfferController.stream;
  Stream<Map<String, dynamic>> get orderStatusChanged =>
      _orderStatusController.stream;
  Stream<Map<String, dynamic>> get arrivalStateChanged =>
      _arrivalStateController.stream;
  Stream<Map<String, dynamic>> get assignmentUpdated =>
      _assignmentUpdatedController.stream;
  Stream<Map<String, dynamic>> get supportCaseChanged =>
      _supportCaseChangedController.stream;
  Stream<Map<String, dynamic>> get driverHomeUpdated =>
      _driverHomeUpdatedController.stream;
  Stream<Map<String, dynamic>> get driverWalletUpdated =>
      _driverWalletUpdatedController.stream;

  Future<void> handleAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _log('App resumed; ensuring SignalR connection is active');
      // ensureConnected is called here but also sequenced from main.dart's
      // _handleAppResumed — the guard (_isConnecting) prevents double work.
      await ensureConnected();
      return;
    }

    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _log('App ${state.name}; clearing pending reconnect timer');
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }
  }

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
    _disconnectRequested = false;
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

      connection.on(NetworkConstants.driverDeliveryOfferEvent, (arguments) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Delivery offer stream event ignored: payload is empty');
          return;
        }
        _log(
          'Delivery offer stream event received: '
          'assignmentId=${payload['assignmentId'] ?? 'n/a'}, '
          'orderId=${payload['orderId'] ?? 'n/a'}',
        );
        _deliveryOfferController.add(payload);
      });

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

      connection.on(NetworkConstants.driverAssignmentUpdatedEvent, (arguments) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Assignment updated stream event ignored: payload is empty');
          return;
        }
        _log(
          'Assignment updated stream event received: '
          'assignmentId=${payload['assignmentId'] ?? 'n/a'}, '
          'assignmentStatus=${payload['assignmentStatus'] ?? 'unknown'}, '
          'orderId=${payload['orderId'] ?? 'n/a'}',
        );
        _assignmentUpdatedController.add(payload);
      });

      connection.on(NetworkConstants.driverOrderSupportCaseChangedEvent, (
        arguments,
      ) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Support case stream event ignored: payload is empty');
          return;
        }
        _log(
          'Support case stream event received: '
          'supportCaseId=${payload['supportCaseId'] ?? payload['caseId'] ?? 'n/a'}, '
          'orderId=${payload['orderId'] ?? 'n/a'}',
        );
        _supportCaseChangedController.add(payload);
      });

      connection.on(NetworkConstants.driverHomeUpdatedEvent, (arguments) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Driver home stream event ignored: payload is empty');
          return;
        }
        _log(
          'Driver home stream event received: '
          'homeState=${payload['homeState'] ?? 'unknown'}',
        );
        _driverHomeUpdatedController.add(payload);
      });

      connection.on(NetworkConstants.driverWalletUpdatedEvent, (arguments) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Driver wallet stream event ignored: payload is empty');
          return;
        }
        _log(
          'Driver wallet stream event received: '
          'currentBalance=${payload['currentBalance'] ?? 'n/a'}, '
          'pendingBalance=${payload['pendingBalance'] ?? 'n/a'}',
        );
        _driverWalletUpdatedController.add(payload);
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
        if (_disconnectRequested) {
          _log('SignalR disconnect was requested manually; reconnect skipped');
          return;
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

  Future<void> disconnect() async {
    _disconnectRequested = true;
    _retryAfter = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    final connection = _hubConnection;
    _hubConnection = null;
    if (connection == null) {
      return;
    }

    try {
      await connection.stop();
    } catch (error) {
      _log('SignalR disconnect ignored an error: $error');
    }
  }

  Future<void> _ensureHostReachable() async {
    final host = Uri.parse(NetworkConstants.baseUrl).host;
    if (host.isEmpty) {
      throw const SocketException('Missing API host');
    }

    final lookup = await compute(
      _dnsLookup,
      host,
    ).timeout(const Duration(seconds: 3), onTimeout: () => <String>[]);
    if (lookup.isEmpty) {
      throw SocketException('Failed host lookup: $host');
    }
  }

  /// Runs DNS lookup on a separate isolate to avoid blocking the UI thread.
  static Future<List<String>> _dnsLookup(String host) async {
    final results = await InternetAddress.lookup(host);
    return results.map((r) => r.address).toList();
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
    if (map.containsKey('type') ||
        map.containsKey('titleAr') ||
        map.containsKey('screen') ||
        map.containsKey('event') ||
        map.containsKey('withdrawalId')) {
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
