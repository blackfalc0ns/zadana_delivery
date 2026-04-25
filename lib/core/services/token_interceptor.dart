import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/services/auth_refresh_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import '../di/di.dart';
import '../network/network_constants.dart';

@injectable
class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor(this.tokenService, this._authRefreshService);

  static const String skipAuthKey = 'skipAuth';
  static const String retryAttemptedKey = 'retryAttempted';

  final TokenService tokenService;
  final AuthRefreshService _authRefreshService;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] == true) {
      options.headers.remove(NetworkConstants.authorization);
      handler.next(options);
      return;
    }

    final String? token = await tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers[NetworkConstants.authorization] =
          "${NetworkConstants.bearer} $token";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    if (!_shouldRefresh(err)) {
      handler.next(err);
      return;
    }

    requestOptions.extra[retryAttemptedKey] = true;

    try {
      final newAccessToken = await _authRefreshService.refreshAccessToken();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        await tokenService.clearTokens();
        handler.next(err);
        return;
      }

      final response = await _retryRequest(
        requestOptions,
        accessToken: newAccessToken,
      );
      handler.resolve(response);
    } on DioException catch (refreshError) {
      await tokenService.clearTokens();
      handler.next(refreshError);
    } catch (_) {
      await tokenService.clearTokens();
      handler.next(err);
    }
  }

  bool _shouldRefresh(DioException err) {
    final requestOptions = err.requestOptions;
    final path = requestOptions.path;

    return err.response?.statusCode == 401 &&
        requestOptions.extra[skipAuthKey] != true &&
        requestOptions.extra[retryAttemptedKey] != true &&
        !path.contains(EndPoints.driverLogin) &&
        !path.contains(EndPoints.driverRegister) &&
        !path.contains(EndPoints.driverForgotPassword) &&
        !path.contains(EndPoints.driverResetPassword) &&
        !path.contains(EndPoints.driverRefreshToken) &&
        !path.contains(EndPoints.driverLogout);
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions, {
    required String accessToken,
  }) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers[NetworkConstants.authorization] =
        '${NetworkConstants.bearer} $accessToken';

    return getIt<Dio>().fetch<dynamic>(
      requestOptions.copyWith(
        headers: headers,
        extra: Map<String, dynamic>.from(requestOptions.extra)
          ..[retryAttemptedKey] = true,
      ),
    );
  }
}
