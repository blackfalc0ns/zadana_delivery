import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/token_service.dart';

@lazySingleton
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
  final StreamController<Map<String, dynamic>>
  _orderTrackingStatusChangedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>>
  _orderTrackingArrivalStateController =
      StreamController<Map<String, dynamic>>.broadcast();

  HubConnection? _notificationsHubConnection;
  HubConnection? _orderTrackingHubConnection;
  bool _isInitialized = false;
  bool _isConnectingNotificationsHub = false;
  bool _isConnectingOrderTrackingHub = false;
  bool _notificationsDisconnectRequested = false;
  bool _orderTrackingDisconnectRequested = false;
  DateTime? _notificationsRetryAfter;
  DateTime? _orderTrackingRetryAfter;
  Timer? _notificationsReconnectTimer;
  Timer? _orderTrackingReconnectTimer;
  String? _subscribedOrderTrackingOrderId;

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
  Stream<Map<String, dynamic>> get orderTrackingStatusChanged =>
      _orderTrackingStatusChangedController.stream;
  Stream<Map<String, dynamic>> get orderTrackingArrivalStateChanged =>
      _orderTrackingArrivalStateController.stream;

  Future<void> handleAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _log('App resumed; ensuring SignalR connection is active');
      // ensureConnected is called here but also sequenced from main.dart's
      // _handleAppResumed — the guard (_isConnecting) prevents double work.
      await ensureConnected();
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _log('App ${state.name}; clearing pending reconnect timer');
      _notificationsReconnectTimer?.cancel();
      _notificationsReconnectTimer = null;
      _orderTrackingReconnectTimer?.cancel();
      _orderTrackingReconnectTimer = null;
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> ensureConnected() async {
    if (_isConnectingNotificationsHub) {
      _logConnectionStatus(
        'CONNECTING',
        details: 'ensureConnected skipped: connection already in progress',
        activeState: _notificationsHubConnection?.state,
      );
      return;
    }
    final retryAfter = _notificationsRetryAfter;
    if (retryAfter != null && DateTime.now().isBefore(retryAfter)) {
      _logConnectionStatus(
        'WAITING',
        details: 'ensureConnected skipped: cooldown active until $retryAfter',
        activeState: _notificationsHubConnection?.state,
      );
      final remainingDelay = retryAfter.difference(DateTime.now());
      _scheduleNotificationsReconnect(
        remainingDelay.isNegative ? _retryDelay : remainingDelay,
      );
      return;
    }

    final existingConnection = _notificationsHubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      _logConnectionStatus(
        _connectionStateLabel(existingConnection?.state),
        details:
            'ensureConnected skipped: existing state is ${existingConnection?.state}',
        activeState: existingConnection?.state,
      );
      return;
    }

    final token = (await _tokenService.getToken())?.trim() ?? '';
    if (token.isEmpty) {
      _logConnectionStatus(
        'WAITING',
        details: 'ensureConnected skipped: auth token is empty',
        activeState: _notificationsHubConnection?.state,
      );
      _scheduleNotificationsReconnect(_missingTokenRetryDelay);
      return;
    }

    _isConnectingNotificationsHub = true;
    _notificationsDisconnectRequested = false;
    try {
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
              transport: HttpTransportType.LongPolling,
              skipNegotiation: false,
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
            'Notification stream event ignored: payload could not be parsed '
            '| raw=${_debugValueSummary(payload)}',
          );
          return;
        }
        _log(
          'Notification stream event received: type=${notification['type'] ?? 'unknown'}, '
          'referenceId=${notification['referenceId'] ?? notification['assignmentId'] ?? 'n/a'}, '
          'screen=${notification['screen'] ?? 'n/a'}, '
          'event=${notification['event'] ?? 'n/a'}, '
          'summary=${_debugMapSummary(notification)}',
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
        _handleSupportCaseChangedEvent(
          arguments,
          sourceEvent: NetworkConstants.driverOrderSupportCaseChangedEvent,
        );
      });

      connection.on(NetworkConstants.driverSupportCaseChangedEvent, (
        arguments,
      ) {
        _handleSupportCaseChangedEvent(
          arguments,
          sourceEvent: NetworkConstants.driverSupportCaseChangedEvent,
        );
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
          activeState: connection.state,
        );
        _notificationsReconnectTimer?.cancel();
        _notificationsReconnectTimer = null;
      });

      connection.onclose(({Exception? error}) {
        _logConnectionStatus(
          'DISCONNECTED',
          hubPath: NetworkConstants.notificationsHub,
          details: 'error=$error',
          activeState: connection.state,
        );
        if (identical(_notificationsHubConnection, connection)) {
          _notificationsHubConnection = null;
        }
        if (_notificationsDisconnectRequested) {
          _log('SignalR disconnect was requested manually; reconnect skipped');
          return;
        }
        _scheduleNotificationsReconnect();
      });

      await connection.start();
      _notificationsHubConnection = connection;
      _notificationsRetryAfter = null;
      _notificationsReconnectTimer?.cancel();
      _notificationsReconnectTimer = null;
      _logConnectionStatus(
        'CONNECTED',
        hubPath: NetworkConstants.notificationsHub,
        activeState: connection.state,
      );
    } catch (error) {
      _notificationsRetryAfter = DateTime.now().add(_retryCooldown);
      _logConnectionStatus(
        'FAILED',
        hubPath: NetworkConstants.notificationsHub,
        details: error.toString(),
        activeState: _notificationsHubConnection?.state,
      );
      _scheduleNotificationsReconnect();
    } finally {
      _isConnectingNotificationsHub = false;
    }
  }

  Future<void> subscribeToOrderTracking(String orderId) async {
    final normalizedOrderId = orderId.trim();
    if (normalizedOrderId.isEmpty) {
      return;
    }

    if (_subscribedOrderTrackingOrderId == normalizedOrderId &&
        _orderTrackingHubConnection?.state == HubConnectionState.Connected) {
      return;
    }

    if (_subscribedOrderTrackingOrderId != null &&
        _subscribedOrderTrackingOrderId != normalizedOrderId) {
      await unsubscribeFromOrderTracking();
    }

    await _ensureOrderTrackingConnected();
    final connection = _orderTrackingHubConnection;
    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      _log(
        'Order tracking subscribe skipped: hub is not connected '
        '| orderId=$normalizedOrderId',
      );
      return;
    }

    try {
      await connection.invoke('SubscribeToOrder', args: [normalizedOrderId]);
      _subscribedOrderTrackingOrderId = normalizedOrderId;
      _log('Order tracking subscribe succeeded: orderId=$normalizedOrderId');
    } catch (error) {
      _log(
        'Order tracking subscribe failed: orderId=$normalizedOrderId | $error',
      );
      if (error.toString().contains('FORBIDDEN_ORDER_TRACKING')) {
        _subscribedOrderTrackingOrderId = null;
      }
    }
  }

  Future<void> unsubscribeFromOrderTracking() async {
    final orderId = _subscribedOrderTrackingOrderId?.trim() ?? '';
    if (orderId.isEmpty) {
      return;
    }

    final connection = _orderTrackingHubConnection;
    _subscribedOrderTrackingOrderId = null;
    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      return;
    }

    try {
      await connection.invoke('UnsubscribeFromOrder', args: [orderId]);
      _log('Order tracking unsubscribe succeeded: orderId=$orderId');
    } catch (error) {
      _log('Order tracking unsubscribe failed: orderId=$orderId | $error');
    }
  }

  void _scheduleNotificationsReconnect([Duration delay = _retryDelay]) {
    final existingConnection = _notificationsHubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      return;
    }
    if (_notificationsReconnectTimer?.isActive == true) {
      return;
    }
    _log('Scheduling notifications realtime reconnect in ${delay.inSeconds}s');
    _notificationsReconnectTimer = Timer(delay, () {
      _notificationsReconnectTimer = null;
      unawaited(ensureConnected());
    });
  }

  Future<void> disconnect() async {
    _notificationsDisconnectRequested = true;
    _orderTrackingDisconnectRequested = true;
    _notificationsRetryAfter = null;
    _orderTrackingRetryAfter = null;
    _notificationsReconnectTimer?.cancel();
    _notificationsReconnectTimer = null;
    _orderTrackingReconnectTimer?.cancel();
    _orderTrackingReconnectTimer = null;
    await unsubscribeFromOrderTracking();
    final notificationsConnection = _notificationsHubConnection;
    final orderTrackingConnection = _orderTrackingHubConnection;
    _notificationsHubConnection = null;
    _orderTrackingHubConnection = null;

    if (notificationsConnection != null) {
      try {
        await notificationsConnection.stop();
      } catch (error) {
        _log('SignalR disconnect ignored an error: $error');
      }
    }

    if (orderTrackingConnection != null) {
      try {
        await orderTrackingConnection.stop();
      } catch (error) {
        _log('Order tracking disconnect ignored an error: $error');
      }
    }
  }

  dynamic _extractFirstArgument(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) return null;
    return arguments.first;
  }

  void _handleSupportCaseChangedEvent(
    List<Object?>? arguments, {
    required String sourceEvent,
  }) {
    final payload = _normalizeSupportCasePayload(
      _extractFirstArgument(arguments),
    );
    if (payload.isEmpty) {
      _log('$sourceEvent ignored: support payload is empty');
      return;
    }
    _log(
      '$sourceEvent received: '
      'supportCaseId=${payload['supportCaseId'] ?? payload['caseId'] ?? 'n/a'}, '
      'orderId=${payload['orderId'] ?? 'n/a'}, '
      'type=${payload['type'] ?? 'unknown'}, '
      'action=${payload['action'] ?? 'unknown'}, '
      'summary=${_debugMapSummary(payload)}',
    );
    _supportCaseChangedController.add(payload);
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

  Map<String, dynamic> _normalizeSupportCasePayload(dynamic payload) {
    if (payload == null) return const <String, dynamic>{};

    if (payload is String) {
      try {
        return _normalizeSupportCasePayload(jsonDecode(payload));
      } catch (_) {
        return const <String, dynamic>{};
      }
    }

    final map = _normalizeMap(payload);
    if (map.isEmpty) return const <String, dynamic>{};

    final supportCaseId =
        map['supportCaseId']?.toString().trim() ??
        map['caseId']?.toString().trim() ??
        '';
    final orderId = map['orderId']?.toString().trim() ?? '';
    final type = map['type']?.toString().trim() ?? '';

    return <String, dynamic>{
      ...map,
      if (supportCaseId.isNotEmpty) 'supportCaseId': supportCaseId,
      if (supportCaseId.isNotEmpty) 'caseId': supportCaseId,
      if (orderId.isNotEmpty) 'orderId': orderId,
      if (type.isNotEmpty) 'caseType': type,
      'screen': 'support_case_detail',
    };
  }

  String _debugMapSummary(Map<String, dynamic> payload) {
    return <String>[
      'keys=${payload.keys.take(10).join('|')}',
      'screen=${payload['screen'] ?? '-'}',
      'event=${payload['event'] ?? '-'}',
      'type=${payload['type'] ?? '-'}',
      'caseId=${payload['supportCaseId'] ?? payload['caseId'] ?? '-'}',
      'orderId=${payload['orderId'] ?? '-'}',
      'action=${payload['action'] ?? '-'}',
      'targetUrl=${payload['targetUrl'] ?? '-'}',
    ].join(', ');
  }

  String _debugValueSummary(dynamic value) {
    if (value == null) return '<null>';
    if (value is Map) {
      return 'map(keys=${value.keys.take(10).join('|')})';
    }
    if (value is List) {
      return 'list(length=${value.length})';
    }
    final text = value.toString().replaceAll('\n', ' ').trim();
    if (text.length <= 220) {
      return text;
    }
    return '${text.substring(0, 220)}...';
  }

  String _resolveHubUrl(String hubPath, {String? accessToken}) {
    final apiUri = Uri.parse(NetworkConstants.baseUrl);

    // Build origin without port — avoids the :0 bug when port is unset.
    final origin = '${apiUri.scheme}://${apiUri.host}';

    final query = (accessToken ?? '').trim().isNotEmpty
        ? '?access_token=${Uri.encodeComponent(accessToken!.trim())}'
        : '';

    // hubPath already starts with '/' (e.g. '/hubs/notifications')
    return '$origin$hubPath$query';
  }

  void _log(String message) {
    debugPrint('$_logTag $message');
  }

  void _logConnectionStatus(
    String status, {
    String? hubPath,
    String? details,
    HubConnectionState? activeState,
  }) {
    _logConnectionStatusWithState(
      status,
      hubPath: hubPath,
      details: details,
      activeState: activeState ?? _notificationsHubConnection?.state,
    );
  }

  Future<void> _ensureOrderTrackingConnected() async {
    if (_isConnectingOrderTrackingHub) {
      _logConnectionStatusWithState(
        'CONNECTING',
        hubPath: NetworkConstants.orderTrackingHub,
        details:
            'ensureOrderTrackingConnected skipped: connection already in progress',
        activeState: _orderTrackingHubConnection?.state,
      );
      return;
    }

    final retryAfter = _orderTrackingRetryAfter;
    if (retryAfter != null && DateTime.now().isBefore(retryAfter)) {
      _logConnectionStatusWithState(
        'WAITING',
        hubPath: NetworkConstants.orderTrackingHub,
        details:
            'ensureOrderTrackingConnected skipped: cooldown active until $retryAfter',
        activeState: _orderTrackingHubConnection?.state,
      );
      final remainingDelay = retryAfter.difference(DateTime.now());
      _scheduleOrderTrackingReconnect(
        remainingDelay.isNegative ? _retryDelay : remainingDelay,
      );
      return;
    }

    final existingConnection = _orderTrackingHubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      _logConnectionStatusWithState(
        _connectionStateLabel(existingConnection?.state),
        hubPath: NetworkConstants.orderTrackingHub,
        details:
            'ensureOrderTrackingConnected skipped: existing state is ${existingConnection?.state}',
        activeState: existingConnection?.state,
      );
      return;
    }

    final token = (await _tokenService.getToken())?.trim() ?? '';
    if (token.isEmpty) {
      _logConnectionStatusWithState(
        'WAITING',
        hubPath: NetworkConstants.orderTrackingHub,
        details: 'ensureOrderTrackingConnected skipped: auth token is empty',
        activeState: _orderTrackingHubConnection?.state,
      );
      _scheduleOrderTrackingReconnect(_missingTokenRetryDelay);
      return;
    }

    _isConnectingOrderTrackingHub = true;
    _orderTrackingDisconnectRequested = false;
    try {
      final hubUrl = _resolveHubUrl(
        NetworkConstants.orderTrackingHub,
        accessToken: token,
      );
      _logConnectionStatusWithState(
        'CONNECTING',
        hubPath: NetworkConstants.orderTrackingHub,
        details: hubUrl,
        activeState: _orderTrackingHubConnection?.state,
      );
      final connection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.LongPolling,
              skipNegotiation: false,
              accessTokenFactory: () async =>
                  (await _tokenService.getToken())?.trim() ?? '',
              requestTimeout: 10000,
            ),
          )
          .withAutomaticReconnect(
            retryDelays: const [0, 2000, 5000, 10000, 20000],
          )
          .build();

      connection.on(NetworkConstants.orderTrackingStatusChangedEvent, (
        arguments,
      ) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Order tracking status event ignored: payload is empty');
          return;
        }
        _log(
          'Order tracking status event received: '
          'orderId=${payload['orderId'] ?? 'n/a'}, '
          'newStatus=${payload['newStatus'] ?? 'unknown'}, '
          'actorRole=${payload['actorRole'] ?? 'unknown'}',
        );
        _orderTrackingStatusChangedController.add(payload);
      });

      connection.on(NetworkConstants.orderTrackingArrivalStateEvent, (
        arguments,
      ) {
        final payload = _normalizeMap(_extractFirstArgument(arguments));
        if (payload.isEmpty) {
          _log('Order tracking arrival state event ignored: payload is empty');
          return;
        }
        _log(
          'Order tracking arrival state event received: '
          'orderId=${payload['orderId'] ?? 'n/a'}, '
          'arrivalState=${payload['arrivalState'] ?? 'unknown'}, '
          'actorRole=${payload['actorRole'] ?? 'unknown'}',
        );
        _orderTrackingArrivalStateController.add(payload);
      });

      connection.onreconnected(({String? connectionId}) {
        _logConnectionStatusWithState(
          'RECONNECTED',
          hubPath: NetworkConstants.orderTrackingHub,
          details: 'connectionId=$connectionId',
          activeState: connection.state,
        );
        _orderTrackingReconnectTimer?.cancel();
        _orderTrackingReconnectTimer = null;
        final orderId = _subscribedOrderTrackingOrderId?.trim() ?? '';
        if (orderId.isEmpty) {
          return;
        }
        unawaited(_resubscribeToOrderTracking(connection, orderId));
      });

      connection.onclose(({Exception? error}) {
        _logConnectionStatusWithState(
          'DISCONNECTED',
          hubPath: NetworkConstants.orderTrackingHub,
          details: 'error=$error',
          activeState: connection.state,
        );
        if (identical(_orderTrackingHubConnection, connection)) {
          _orderTrackingHubConnection = null;
        }
        if (_orderTrackingDisconnectRequested) {
          _log(
            'Order tracking disconnect was requested manually; reconnect skipped',
          );
          return;
        }
        if ((_subscribedOrderTrackingOrderId ?? '').trim().isNotEmpty) {
          _scheduleOrderTrackingReconnect();
        }
      });

      await connection.start();
      _orderTrackingHubConnection = connection;
      _orderTrackingRetryAfter = null;
      _orderTrackingReconnectTimer?.cancel();
      _orderTrackingReconnectTimer = null;
      _logConnectionStatusWithState(
        'CONNECTED',
        hubPath: NetworkConstants.orderTrackingHub,
        activeState: connection.state,
      );
    } catch (error) {
      _orderTrackingRetryAfter = DateTime.now().add(_retryCooldown);
      _logConnectionStatusWithState(
        'FAILED',
        hubPath: NetworkConstants.orderTrackingHub,
        details: error.toString(),
        activeState: _orderTrackingHubConnection?.state,
      );
      _scheduleOrderTrackingReconnect();
    } finally {
      _isConnectingOrderTrackingHub = false;
    }
  }

  Future<void> _resubscribeToOrderTracking(
    HubConnection connection,
    String orderId,
  ) async {
    try {
      await connection.invoke('SubscribeToOrder', args: [orderId]);
      _log('Order tracking resubscribe succeeded: orderId=$orderId');
    } catch (error) {
      _log('Order tracking resubscribe failed: orderId=$orderId | $error');
      if (error.toString().contains('FORBIDDEN_ORDER_TRACKING')) {
        _subscribedOrderTrackingOrderId = null;
      }
    }
  }

  void _scheduleOrderTrackingReconnect([Duration delay = _retryDelay]) {
    if ((_subscribedOrderTrackingOrderId ?? '').trim().isEmpty) {
      return;
    }
    final existingConnection = _orderTrackingHubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      return;
    }
    if (_orderTrackingReconnectTimer?.isActive == true) {
      return;
    }
    _log('Scheduling order tracking realtime reconnect in ${delay.inSeconds}s');
    _orderTrackingReconnectTimer = Timer(delay, () {
      _orderTrackingReconnectTimer = null;
      unawaited(_ensureOrderTrackingConnected());
    });
  }

  void _logConnectionStatusWithState(
    String status, {
    String? hubPath,
    String? details,
    HubConnectionState? activeState,
  }) {
    final activeHubPath = (hubPath ?? NetworkConstants.notificationsHub).trim();
    final suffix = (details ?? '').trim();
    _log(
      'SignalR[$status] hub=$activeHubPath state=${_connectionStateLabel(activeState)}'
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
