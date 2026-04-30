import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/driver_home/data/data_source/driver_home_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_home/data/models/driver_home_model_dto.dart';

@LazySingleton(as: DriverHomeRemoteDataSource)
class DriverHomeRemoteDataSourceImpl implements DriverHomeRemoteDataSource {
  DriverHomeRemoteDataSourceImpl(this._apiServices)
    : _homeController = StreamController<DriverHomeModelDto>.broadcast(
        onListen: _connectSignalRIfNeeded,
      );

  static const Duration _delayedOfferRefresh = Duration(milliseconds: 1200);
  static const Duration _initialHomeRefreshDebounce = Duration(seconds: 3);
  static const Duration _homeRefreshThrottleWindow = Duration(
    milliseconds: 900,
  );
  static const Duration _signalRRetryCooldown = Duration(seconds: 30);
  static const Duration _signalRRetryDelay = Duration(seconds: 5);
  static const Duration _missingTokenRetryDelay = Duration(seconds: 2);
  static const String _logTag = '[DriverHomeRealtime]';

  final ApiServices _apiServices;
  final StreamController<DriverHomeModelDto> _homeController;
  DriverHomeModelDto? _latestHome;
  DateTime? _lastHomeFetchedAt;
  HubConnection? _hubConnection;
  bool _isConnecting = false;
  bool _isHomeRefreshInFlight = false;
  DateTime? _retryAfter;
  Timer? _reconnectTimer;
  DateTime? _lastHomeRefreshStartedAt;
  static DriverHomeRemoteDataSourceImpl? _instanceForStreamCallback;

  static void _connectSignalRIfNeeded() {
    debugPrint(
      '$_logTag watchHome listener attached; ensuring SignalR connection',
    );
    unawaited(_instanceForStreamCallback?._ensureSignalRConnected());
  }

  @override
  Future<DriverHomeModelDto> getHome() async {
    try {
      final response = await _apiServices.getDriverHome();
      final home = DriverHomeModelDto.fromJson(_normalizeMap(response));
      _cacheHome(home);
      return home;
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> updateAvailability({required bool isAvailable}) async {
    try {
      await _apiServices.updateDriverAvailability({'isAvailable': isAvailable});
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> acceptOffer(String assignmentId) async {
    try {
      await _apiServices.acceptDriverOffer(assignmentId);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> rejectOffer(String assignmentId, {String? reason}) async {
    try {
      await _apiServices.rejectDriverOffer(
        assignmentId,
        (reason ?? '').trim().isEmpty
            ? const <String, dynamic>{}
            : {'reason': reason},
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Stream<DriverHomeModelDto> watchHome() async* {
    _instanceForStreamCallback = this;
    _log('watchHome subscribed');
    final latestHome = _latestHome;
    if (latestHome != null) {
      _log(
        'watchHome emitting cached home: state=${latestHome.homeState}, '
        'hasOffer=${latestHome.currentOffer != null}, unreadAlerts=${latestHome.unreadAlerts}',
      );
      yield latestHome;
    }
    yield* _homeController.stream;
  }

  @override
  void emitHome(DriverHomeModelDto home) {
    if (_homeController.isClosed) return;
    _cacheHome(home);
    _log(
      'emitHome: state=${home.homeState}, hasOffer=${home.currentOffer != null}, '
      'offerId=${home.currentOffer?.assignmentId ?? 'n/a'}, unreadAlerts=${home.unreadAlerts}',
    );
    _homeController.add(home);
  }

  void _cacheHome(DriverHomeModelDto home) {
    _latestHome = home;
    _lastHomeFetchedAt = DateTime.now();
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  Future<void> _ensureSignalRConnected() async {
    if (_isConnecting) {
      _logConnectionStatus(
        'CONNECTING',
        details: 'connect skipped: already connecting',
      );
      return;
    }
    final retryAfter = _retryAfter;
    if (retryAfter != null && DateTime.now().isBefore(retryAfter)) {
      _logConnectionStatus(
        'WAITING',
        details: 'connect skipped: cooldown active until $retryAfter',
      );
      final remainingDelay = retryAfter.difference(DateTime.now());
      _scheduleReconnect(
        remainingDelay.isNegative ? _signalRRetryDelay : remainingDelay,
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
            'connect skipped: existing state is ${existingConnection?.state}',
      );
      return;
    }

    _isConnecting = true;
    try {
      final token = (await getIt<TokenService>().getToken())?.trim() ?? '';
      if (token.isEmpty) {
        _logConnectionStatus(
          'WAITING',
          details: 'connect skipped: auth token is empty',
        );
        _scheduleReconnect(_missingTokenRetryDelay);
        return;
      }
      await _connectToNotificationsHub(token);
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> _connectToNotificationsHub(String token) async {
    const hubPath = NetworkConstants.notificationsHub;
    await _ensureHostReachable();
    final hubUrl = _resolveHubUrl(hubPath, accessToken: token);
    _logConnectionStatus('CONNECTING', hubPath: hubPath, details: hubUrl);
    final connection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
            accessTokenFactory: () async =>
                (await getIt<TokenService>().getToken())?.trim() ?? '',
            requestTimeout: 10000,
          ),
        )
        .withAutomaticReconnect(
          retryDelays: const [0, 2000, 5000, 10000, 20000],
        )
        .build();

    void handleOfferEvent(List<Object?>? arguments) {
      final payload = (arguments?.isNotEmpty ?? false)
          ? arguments!.first
          : null;
      final offerEvent = _normalizeMap(payload);
      _log(
        'Delivery offer event received: '
        'assignmentId=${offerEvent['assignmentId'] ?? 'n/a'}, '
        'orderId=${offerEvent['orderId'] ?? 'n/a'}, '
        'countdown=${offerEvent['countdownSeconds'] ?? 'n/a'}',
      );
      final emitted = _emitOfferFromDeliveryOfferEvent(offerEvent);
      if (!emitted) {
        _log(
          'Delivery offer event could not fully update home; syncing fallback',
        );
      }
      unawaited(_refreshHomeFromApi(reason: 'delivery offer event'));
    }

    connection.on(NetworkConstants.driverDeliveryOfferEvent, handleOfferEvent);

    connection.on(NetworkConstants.driverNotificationEvent, (arguments) {
      final payload = (arguments?.isNotEmpty ?? false)
          ? arguments!.first
          : null;
      _log('Raw notification event received from SignalR');
      unawaited(_handleNotificationPayload(payload));
    });

    connection.on(NetworkConstants.driverOrderStatusChangedEvent, (arguments) {
      final payload = (arguments?.isNotEmpty ?? false)
          ? arguments!.first
          : null;
      final event = _normalizeMap(payload);
      _log(
        'Order status refresh signal received: '
        'orderId=${event['orderId'] ?? 'n/a'}, status=${event['status'] ?? event['newStatus'] ?? 'unknown'}',
      );
      unawaited(_refreshHomeFromApi(reason: 'order status event'));
    });

    connection.on(NetworkConstants.driverArrivalStateChangedEvent, (arguments) {
      final payload = (arguments?.isNotEmpty ?? false)
          ? arguments!.first
          : null;
      final event = _normalizeMap(payload);
      _log(
        'Arrival state refresh signal received: '
        'orderId=${event['orderId'] ?? 'n/a'}, arrivalState=${event['arrivalState'] ?? event['state'] ?? 'unknown'}',
      );
      unawaited(_refreshHomeFromApi(reason: 'arrival state event'));
    });

    connection.onreconnected(({String? connectionId}) {
      _logConnectionStatus(
        'RECONNECTED',
        hubPath: hubPath,
        details: 'connectionId=$connectionId',
      );
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      unawaited(_refreshHomeFromApi(reason: 'signalr reconnected'));
    });

    connection.onclose(({Exception? error}) {
      _logConnectionStatus(
        'DISCONNECTED',
        hubPath: hubPath,
        details: 'error=$error',
      );
      if (identical(_hubConnection, connection)) {
        _hubConnection = null;
      }
      _scheduleReconnect();
    });

    try {
      await connection.start();
      _hubConnection = connection;
      _retryAfter = null;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _logConnectionStatus('CONNECTED', hubPath: hubPath);
      unawaited(_refreshHomeAfterInitialConnect());
    } catch (error) {
      _logConnectionStatus(
        'FAILED',
        hubPath: hubPath,
        details: error.toString(),
      );
      _retryAfter = DateTime.now().add(_signalRRetryCooldown);
      _scheduleReconnect();
      try {
        await connection.stop();
      } catch (_) {}
    }
  }

  Future<void> _refreshHomeAfterInitialConnect() async {
    final lastHomeFetchedAt = _lastHomeFetchedAt;
    final hasFreshHome =
        _latestHome != null &&
        lastHomeFetchedAt != null &&
        DateTime.now().difference(lastHomeFetchedAt) <
            _initialHomeRefreshDebounce;
    if (hasFreshHome) {
      _log(
        'Skipping initial SignalR home refresh because a recent home snapshot is already available',
      );
      return;
    }

    _log('Refreshing /drivers/home after initial SignalR connect');
    await _refreshHomeFromApi(reason: 'initial SignalR connect');
    Future<void>.delayed(_delayedOfferRefresh, () {
      _log('Running delayed home refresh after initial SignalR connect');
      return _refreshHomeFromApi(reason: 'delayed initial SignalR sync');
    });
  }

  void _scheduleReconnect([Duration delay = _signalRRetryDelay]) {
    if (!_homeController.hasListener) {
      _log('Reconnect skipped: no active home listeners');
      return;
    }
    final existingConnection = _hubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      return;
    }
    if (_reconnectTimer?.isActive == true) {
      return;
    }
    _log('Scheduling home realtime reconnect in ${delay.inSeconds}s');
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      unawaited(_ensureSignalRConnected());
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

  Future<void> _handleNotificationPayload(dynamic payload) async {
    final notification = _normalizeNotification(payload);
    if (notification.isEmpty) {
      _log('Notification ignored: payload could not be normalized');
      return;
    }

    _log(
      'Notification parsed: type=${notification['type'] ?? 'unknown'}, '
      'referenceId=${notification['referenceId'] ?? notification['assignmentId'] ?? 'n/a'}',
    );

    if (_shouldRefreshHomeForNotification(notification)) {
      _log('Notification matched home refresh rules; refreshing home now');
      await _refreshHomeFromApi(reason: 'notification event');
      Future<void>.delayed(_delayedOfferRefresh, () {
        _log('Running delayed home refresh after notification');
        return _refreshHomeFromApi(reason: 'delayed notification sync');
      });
      return;
    }

    _log(
      'Notification received without home refresh trigger: '
      '${notification['type']} / ${notification['titleAr'] ?? notification['titleEn']}',
    );
  }

  bool _emitOfferFromDeliveryOfferEvent(Map<String, dynamic> payload) {
    if (payload.isEmpty) {
      return false;
    }

    final assignmentId = _firstNonEmptyString([
      payload['assignmentId'],
      payload['assignment_id'],
    ]);
    if (assignmentId == null) {
      _log('Delivery offer event missing assignmentId; skipping direct emit');
      return false;
    }

    final latestHome = _latestHome;
    if (latestHome == null) {
      _log(
        'Realtime offer arrived before initial home cache; waiting for sync',
      );
      return false;
    }

    final offer = DriverHomeOfferModelDto.fromJson(<String, dynamic>{
      ...payload,
      'assignmentId': assignmentId,
      'pickupAddress':
          payload['pickupAddress'] ?? payload['vendorAddress'] ?? '',
      'deliveryAddress':
          payload['deliveryAddress'] ?? payload['customerAddress'] ?? '',
      'pickupLatitude':
          payload['pickupLatitude'] ?? payload['vendorLatitude'] ?? 0,
      'pickupLongitude':
          payload['pickupLongitude'] ?? payload['vendorLongitude'] ?? 0,
      'deliveryLatitude':
          payload['deliveryLatitude'] ?? payload['customerLatitude'] ?? 0,
      'deliveryLongitude':
          payload['deliveryLongitude'] ?? payload['customerLongitude'] ?? 0,
      'estimatedDistanceKm':
          payload['estimatedDistanceKm'] ?? payload['distanceKm'] ?? 0,
      'estimatedEta': payload['estimatedEta'] ?? payload['eta'] ?? '',
      'paymentMethod': payload['paymentMethod'] ?? '',
      'totalAmount': payload['totalAmount'] ?? 0,
      'codAmount': payload['codAmount'] ?? 0,
      'payout': payload['payout'] ?? payload['deliveryFee'] ?? 0,
      'orderItems': payload['orderItems'] ?? payload['items'] ?? const [],
    });

    emitHome(
      DriverHomeModelDto(
        homeState: _firstNonEmptyString([
          payload['homeState'],
          'HasOffer',
          latestHome.homeState,
        ])!,
        operationalStatus: latestHome.operationalStatus,
        currentOffer: offer,
        currentAssignment: latestHome.currentAssignment,
        earningsSummaryToday: latestHome.earningsSummaryToday,
        unreadAlerts: latestHome.unreadAlerts,
        commitment: latestHome.commitment,
        profileReadiness: latestHome.profileReadiness,
      ),
    );
    return true;
  }

  Future<void> _refreshHomeFromApi({required String reason}) async {
    final lastRefreshStartedAt = _lastHomeRefreshStartedAt;
    if (_isHomeRefreshInFlight) {
      _log(
        'Skipping /drivers/home refresh for $reason: refresh already in flight',
      );
      return;
    }
    if (lastRefreshStartedAt != null &&
        DateTime.now().difference(lastRefreshStartedAt) <
            _homeRefreshThrottleWindow) {
      _log(
        'Skipping /drivers/home refresh for $reason: '
        'throttled within ${_homeRefreshThrottleWindow.inMilliseconds}ms window',
      );
      return;
    }

    _isHomeRefreshInFlight = true;
    _lastHomeRefreshStartedAt = DateTime.now();
    try {
      _log('Refreshing /drivers/home after $reason');
      final home = await getHome();
      _log(
        'Home refresh result: state=${home.homeState}, '
        'hasOffer=${home.currentOffer != null}, '
        'offerId=${home.currentOffer?.assignmentId ?? 'n/a'}',
      );
      emitHome(home);
    } catch (error) {
      _log('Home refresh after notification failed: $error');
    } finally {
      _isHomeRefreshInFlight = false;
    }
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

  bool _shouldRefreshHomeForNotification(Map<String, dynamic> notification) {
    final type = notification['type']?.toString().trim().toLowerCase() ?? '';
    if (type == NetworkConstants.driverOfferNotificationType) {
      return true;
    }

    final referenceId = notification['referenceId']?.toString().trim() ?? '';
    final dataObject = _normalizeMap(notification['dataObject']);
    final dataMap = _normalizeMap(notification['data']);
    final nestedPayload = dataObject.isNotEmpty ? dataObject : dataMap;
    final orderId = _firstNonEmptyString([
      notification['orderId'],
      notification['order_id'],
      nestedPayload['orderId'],
      nestedPayload['order_id'],
    ]);
    final assignmentId = _firstNonEmptyString([
      notification['assignmentId'],
      notification['assignment_id'],
      nestedPayload['assignmentId'],
      nestedPayload['assignment_id'],
      referenceId,
    ]);
    final title = _firstNonEmptyString([
      notification['titleAr'],
      notification['titleEn'],
      nestedPayload['titleAr'],
      nestedPayload['titleEn'],
    ]);
    final body = _firstNonEmptyString([
      notification['bodyAr'],
      notification['bodyEn'],
      nestedPayload['bodyAr'],
      nestedPayload['bodyEn'],
      notification['data'],
    ]);
    final searchableText = '$type ${title ?? ''} ${body ?? ''}'
        .trim()
        .toLowerCase();

    if (assignmentId != null || orderId != null) {
      return true;
    }

    return searchableText.contains('offer') ||
        searchableText.contains('order') ||
        searchableText.contains('طلب') ||
        searchableText.contains('عرض');
  }

  String? _firstNonEmptyString(Iterable<dynamic> values) {
    for (final value in values) {
      final normalized = value?.toString().trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }
    return null;
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

    final needsApiPrefix =
        pathSegments.isNotEmpty && pathSegments.first == 'api';
    final resolvedSegments = needsApiPrefix
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
