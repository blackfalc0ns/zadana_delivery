import 'dart:async';
import 'dart:convert';

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

@Injectable(as: DriverHomeRemoteDataSource)
class DriverHomeRemoteDataSourceImpl implements DriverHomeRemoteDataSource {
  DriverHomeRemoteDataSourceImpl(this._apiServices)
    : _homeController = StreamController<DriverHomeModelDto>.broadcast(
        onListen: _connectSignalRIfNeeded,
      );

  final ApiServices _apiServices;
  final StreamController<DriverHomeModelDto> _homeController;
  HubConnection? _hubConnection;
  bool _isConnecting = false;
  bool _signalRUnavailable = false;
  static DriverHomeRemoteDataSourceImpl? _instanceForStreamCallback;

  static void _connectSignalRIfNeeded() {
    unawaited(_instanceForStreamCallback?._ensureSignalRConnected());
  }

  @override
  Future<DriverHomeModelDto> getHome() async {
    try {
      final response = await _apiServices.getDriverHome();
      return DriverHomeModelDto.fromJson(_normalizeMap(response));
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
  Stream<DriverHomeModelDto> watchHome() {
    _instanceForStreamCallback = this;
    unawaited(_ensureSignalRConnected());
    return _homeController.stream;
  }

  @override
  void emitHome(DriverHomeModelDto home) {
    if (_homeController.isClosed) return;
    _homeController.add(home);
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  Future<void> _ensureSignalRConnected() async {
    if (_signalRUnavailable) return;
    if (_isConnecting) return;
    final existingConnection = _hubConnection;
    if (existingConnection?.state == HubConnectionState.Connected ||
        existingConnection?.state == HubConnectionState.Connecting ||
        existingConnection?.state == HubConnectionState.Reconnecting) {
      return;
    }

    _isConnecting = true;
    try {
      await _connectToNotificationsHub();
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> _connectToNotificationsHub() async {
    const hubPath = NetworkConstants.notificationsHub;
    final connection = HubConnectionBuilder()
        .withUrl(
          _resolveHubUrl(hubPath),
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

    connection.on(NetworkConstants.driverNotificationEvent, (arguments) {
      final payload = (arguments?.isNotEmpty ?? false)
          ? arguments!.first
          : null;
      unawaited(_handleNotificationPayload(payload));
    });

    connection.onreconnected(({String? connectionId}) {
      debugPrint('DriverHome SignalR reconnected: $connectionId');
      unawaited(_refreshHomeFromApi());
    });

    connection.onclose(({Exception? error}) {
      debugPrint('DriverHome SignalR closed: $error');
      if (identical(_hubConnection, connection)) {
        _hubConnection = null;
      }
    });

    try {
      await connection.start();
      _hubConnection = connection;
      debugPrint('DriverHome SignalR connected on $hubPath');
    } catch (error) {
      debugPrint('DriverHome SignalR failed on $hubPath: $error');
      _signalRUnavailable = true;
      try {
        await connection.stop();
      } catch (_) {}
    }
  }

  Future<void> _handleNotificationPayload(dynamic payload) async {
    final notification = _normalizeNotification(payload);
    if (notification.isEmpty) return;

    final type = notification['type']?.toString().trim().toLowerCase() ?? '';
    if (type == NetworkConstants.driverOfferNotificationType) {
      await _refreshHomeFromApi();
      return;
    }

    debugPrint(
      'DriverHome notification received: ${notification['type']} / ${notification['titleAr'] ?? notification['titleEn']}',
    );
  }

  Future<void> _refreshHomeFromApi() async {
    try {
      final home = await getHome();
      emitHome(home);
    } catch (error) {
      debugPrint('DriverHome refresh after notification failed: $error');
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

  String _resolveHubUrl(String hubPath) {
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

    return apiUri.replace(pathSegments: resolvedSegments).toString();
  }
}
