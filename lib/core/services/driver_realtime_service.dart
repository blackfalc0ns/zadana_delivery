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
        details: _safeErrorString(error),
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
      final errorStr = _safeErrorString(error);
      _log(
        'Order tracking subscribe failed: orderId=$normalizedOrderId | $errorStr',
      );
      if (errorStr.contains('FORBIDDEN_ORDER_TRACKING')) {
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
    if (value is Map<String, dynamic>) return _fixUtf8Map(value);
    if (value is Map) return _fixUtf8Map(Map<String, dynamic>.from(value));
    return const <String, dynamic>{};
  }

  /// Fixes mojibake caused by SignalR Long Polling decoding UTF-8 bytes as
  /// Latin-1 or Windows-1256. Detects garbled strings and re-encodes them.
  Map<String, dynamic> _fixUtf8Map(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String && _looksLikeMojibake(value)) {
        return MapEntry(key, _fixMojibake(value));
      }
      if (value is Map) {
        return MapEntry(key, _fixUtf8Map(Map<String, dynamic>.from(value)));
      }
      if (value is List) {
        return MapEntry(key, _fixUtf8List(value));
      }
      return MapEntry(key, value);
    });
  }

  List<dynamic> _fixUtf8List(List<dynamic> list) {
    return list.map((item) {
      if (item is Map) {
        return _fixUtf8Map(Map<String, dynamic>.from(item));
      }
      if (item is String && _looksLikeMojibake(item)) {
        return _fixMojibake(item);
      }
      if (item is List) {
        return _fixUtf8List(item);
      }
      return item;
    }).toList();
  }

  /// Heuristic: strings containing sequences like "Ù" or "Ø" (common markers
  /// of UTF-8 Arabic bytes misinterpreted as Latin-1) are likely mojibake.
  /// Also detects Windows-1256 mojibake where UTF-8 Arabic bytes are decoded
  /// as Windows-1256, producing unusual combinations of Arabic characters.
  bool _looksLikeMojibake(String text) {
    if (text.isEmpty || text.length < 3) return false;
    var latin1SuspiciousCount = 0;
    var arabicTotal = 0;
    // "Suspicious" = characters that almost never appear in real-world Arabic
    // text from this app (store names, addresses): extended Arabic letters
    // (U+0670-06FF), Arabic-Indic digits mixed with letters (U+0660-0669),
    // and tatweel (U+0640).  Normal diacritics (U+064B-0652) are excluded
    // because they can appear in properly vocalized text.
    var suspiciousArabic = 0;
    final checkLength = text.length < 60 ? text.length : 60;
    for (var i = 0; i < checkLength; i++) {
      final c = text.codeUnitAt(i);
      if (c >= 0xC0 && c <= 0xFF) {
        latin1SuspiciousCount++;
      }
      if (c >= 0x0600 && c <= 0x06FF) {
        arabicTotal++;
        // Extended Arabic block (U+0670-06FF) — rarely used in store
        // names/addresses in Saudi Arabia.
        if (c >= 0x0670) {
          suspiciousArabic++;
        }
        // Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) appearing in text that
        // is supposed to be a name/address (not a number field).
        else if (c >= 0x0660 && c <= 0x0669) {
          suspiciousArabic++;
        }
        // Tatweel
        else if (c == 0x0640) {
          suspiciousArabic++;
        }
      }
    }
    if (latin1SuspiciousCount >= 3) return true;
    // In normal Arabic address/name text, extended Arabic and Arabic-Indic
    // digits are extremely rare (typically 0%). In Win-1256 mojibake they
    // make up a significant portion because UTF-8 continuation bytes
    // (0x80-0xBF) map to extended Arabic codepoints.
    if (arabicTotal >= 4 && suspiciousArabic >= 2 &&
        suspiciousArabic > arabicTotal * 0.2) {
      return true;
    }
    return false;
  }

  String _fixMojibake(String text) {
    // Try Latin-1 → UTF-8 decode first (most common case)
    try {
      final latin1Bytes = latin1.encode(text);
      final decoded = utf8.decode(latin1Bytes);
      if (decoded != text && !_looksLikeMojibake(decoded)) {
        return decoded;
      }
    } catch (_) {}
    // Try Windows-1256 → UTF-8 decode
    try {
      final win1256Bytes = _encodeWindows1256(text);
      if (win1256Bytes != null) {
        final decoded = utf8.decode(win1256Bytes);
        if (decoded != text) {
          return decoded;
        }
      }
    } catch (_) {}
    return text;
  }

  /// Encodes a string as Windows-1256 bytes. Returns null if any character
  /// cannot be mapped.
  List<int>? _encodeWindows1256(String text) {
    final bytes = <int>[];
    for (var i = 0; i < text.length; i++) {
      final c = text.codeUnitAt(i);
      if (c < 0x80) {
        bytes.add(c);
      } else {
        final byte = _win1256FromCodeUnit(c);
        if (byte == null) return null;
        bytes.add(byte);
      }
    }
    return bytes;
  }

  /// Maps a Unicode code unit back to its Windows-1256 byte value.
  static int? _win1256FromCodeUnit(int codeUnit) {
    // Build reverse lookup from the Windows-1256 high-byte table
    for (var i = 0; i < _win1256HighBytes.length; i++) {
      if (_win1256HighBytes[i] == codeUnit) {
        return 0x80 + i;
      }
    }
    return null;
  }

  /// Windows-1256 mapping for bytes 0x80-0xFF to Unicode code points.
  static const List<int> _win1256HighBytes = [
    0x20AC, 0x067E, 0x201A, 0x0192, 0x201E, 0x2026, 0x2020, 0x2021, // 80-87
    0x02C6, 0x2030, 0x0679, 0x2039, 0x0152, 0x0686, 0x0698, 0x0688, // 88-8F
    0x06AF, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014, // 90-97
    0x06A9, 0x2122, 0x0691, 0x203A, 0x0153, 0x200C, 0x200D, 0x06BA, // 98-9F
    0x00A0, 0x060C, 0x00A2, 0x00A3, 0x00A4, 0x00A5, 0x00A6, 0x00A7, // A0-A7
    0x00A8, 0x00A9, 0x06BE, 0x00AB, 0x00AC, 0x00AD, 0x00AE, 0x00AF, // A8-AF
    0x00B0, 0x00B1, 0x00B2, 0x00B3, 0x00B4, 0x00B5, 0x00B6, 0x00B7, // B0-B7
    0x00B8, 0x00B9, 0x061B, 0x00BB, 0x00BC, 0x00BD, 0x00BE, 0x061F, // B8-BF
    0x06C1, 0x0621, 0x0622, 0x0623, 0x0624, 0x0625, 0x0626, 0x0627, // C0-C7
    0x0628, 0x0629, 0x062A, 0x062B, 0x062C, 0x062D, 0x062E, 0x062F, // C8-CF
    0x0630, 0x0631, 0x0632, 0x0633, 0x0634, 0x0635, 0x0636, 0x00D7, // D0-D7
    0x0637, 0x0638, 0x0639, 0x063A, 0x0640, 0x0641, 0x0642, 0x0643, // D8-DF
    0x00E0, 0x0644, 0x00E2, 0x0645, 0x0646, 0x0647, 0x0648, 0x00E7, // E0-E7
    0x00E8, 0x00E9, 0x00EA, 0x00EB, 0x0649, 0x064A, 0x064E, 0x064F, // E8-EF
    0x0650, 0x0651, 0x0652, 0x00F3, 0x00F4, 0x200C, 0x200D, 0x00F7, // F0-F7
    0x00F8, 0x0652, 0x00FA, 0x00FB, 0x00FC, 0x200E, 0x200F, 0x06D2, // F8-FF
  ];

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
    debugPrint('$_logTag ${_redactSensitiveQueryValues(message)}');
  }

  String _redactSensitiveQueryValues(String message) {
    return message.replaceAllMapped(
      RegExp(r'([?&]access_token=)[^&\s]+', caseSensitive: false),
      (match) => '${match.group(1)}<redacted>',
    );
  }

  /// Safely converts an error to a string, guarding against third-party
  /// [toString] implementations that may themselves throw (e.g.
  /// [signalr_netcore] [GeneralError] with null fields).
  String _safeErrorString(Object error) {
    try {
      return error.toString();
    } catch (_) {
      return error.runtimeType.toString();
    }
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
        details: _safeErrorString(error),
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
      final errorStr = _safeErrorString(error);
      _log('Order tracking resubscribe failed: orderId=$orderId | $errorStr');
      if (errorStr.contains('FORBIDDEN_ORDER_TRACKING')) {
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
