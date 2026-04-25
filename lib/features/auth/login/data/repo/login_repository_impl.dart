import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repo/login_repository.dart';
import '../data_source/login_remote_data_source.dart';
import '../mapper/mapper_login.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  const LoginRepositoryImpl(
    this._remoteDataSource,
    this._tokenService,
    this._identityService,
  );

  final LoginRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final DriverIdentityService _identityService;

  @override
  Future<ApiResult<LoginResponseEntity>> login(LoginRequestEntity request) {
    return safeApiCall(() async {
      final result = await _remoteDataSource.login(request.toDto());
      final accessToken = result.tokens.accessToken.trim();
      final refreshToken = result.tokens.refreshToken.trim();

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        throw ApiException(
          errorType: ApiErrorType.unauthorized,
          message: result.message.trim().isNotEmpty
              ? result.message.trim()
              : 'Unable to sign in. Check your credentials and try again.',
        );
      }

      await _tokenService.saveAccessToken(accessToken);
      await _tokenService.saveRefreshToken(refreshToken);

      final entity = result.toEntity();

      await _identityService.saveIdentity(
        DriverIdentity(
          id: entity.user.id,
          fullName: entity.user.fullName,
          email: entity.user.email,
          phone: entity.user.phone,
          role: entity.user.role,
          lastIdentifier: request.identifier.trim(),
        ),
      );

      return LoginResponseEntity(
        tokens: entity.tokens,
        user: entity.user,
        message: entity.message,
        isVerified: entity.isVerified,
        driverStatus: entity.driverStatus,
      );
    });
  }
}
