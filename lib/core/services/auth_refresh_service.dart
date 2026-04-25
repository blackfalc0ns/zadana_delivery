import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../network/network_constants.dart';
import 'token_interceptor.dart';
import 'token_service.dart';

@injectable
class AuthRefreshService {
  AuthRefreshService(
    @Named('refreshDio') Dio dio,
    TokenService tokenService,
  ) : _dio = dio,
      _tokenService = tokenService;

  final Dio _dio;
  final TokenService _tokenService;

  Future<String?> refreshAccessToken() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      return null;
    }

    final response = await _dio.post<dynamic>(
      EndPoints.driverRefreshToken,
      data: {'refreshToken': refreshToken.trim()},
      options: Options(extra: {TokenInterceptor.skipAuthKey: true}),
    );

    final data = response.data;
    final map = data is Map<String, dynamic>
        ? data
        : data is Map
        ? Map<String, dynamic>.from(data)
        : const <String, dynamic>{};

    final newAccessToken = map['accessToken']?.toString().trim() ?? '';
    final newRefreshToken = map['refreshToken']?.toString().trim() ?? '';

    if (newAccessToken.isEmpty || newRefreshToken.isEmpty) {
      return null;
    }

    await _tokenService.saveAccessToken(newAccessToken);
    await _tokenService.saveRefreshToken(newRefreshToken);

    return newAccessToken;
  }
}
