import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_notification_session_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/auth/login/data/mapper/mapper_login.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/login_response_entity.dart';

import '../../domain/entities/resend_driver_otp_request_entity.dart';
import '../../domain/entities/resend_driver_otp_response_entity.dart';
import '../../domain/entities/verify_driver_otp_request_entity.dart';
import '../../domain/repo/driver_verify_otp_repository.dart';
import '../data_source/driver_verify_otp_remote_data_source.dart';
import '../models/resend_driver_otp_request_model_dto.dart';
import '../models/verify_driver_otp_request_model_dto.dart';

@Injectable(as: DriverVerifyOtpRepository)
class DriverVerifyOtpRepositoryImpl implements DriverVerifyOtpRepository {
  const DriverVerifyOtpRepositoryImpl(
    this._remoteDataSource,
    this._tokenService,
    this._identityService,
  );

  final DriverVerifyOtpRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final DriverIdentityService _identityService;

  @override
  Future<ApiResult<LoginResponseEntity>> verify(
    VerifyDriverOtpRequestEntity request,
  ) {
    return safeApiCall(() async {
      final result = await _remoteDataSource.verify(
        VerifyDriverOtpRequestModelDto(
          identifier: request.identifier.trim(),
          otpCode: request.otpCode.trim(),
        ),
      );
      final accessToken = result.tokens.accessToken.trim();
      final refreshToken = result.tokens.refreshToken.trim();

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        throw const ApiException(
          errorType: ApiErrorType.unauthorized,
          message: 'auth_verify_otp_missing_tokens',
          isTranslationKey: true,
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
          profilePhotoUrl: entity.user.profilePhotoUrl,
          lastIdentifier: request.identifier.trim(),
        ),
      );
      await _tokenService.saveCurrentUserId(entity.user.id);
      try {
        await getIt<DriverNotificationSessionService>()
            .handleSuccessfulAuthentication(entity.user.id);
      } catch (_) {
        // Non-critical.
      }

      return entity;
    });
  }

  @override
  Future<ApiResult<ResendDriverOtpResponseEntity>> resend(
    ResendDriverOtpRequestEntity request,
  ) {
    return safeApiCall(() async {
      final result = await _remoteDataSource.resend(
        ResendDriverOtpRequestModelDto(identifier: request.identifier.trim()),
      );
      return ResendDriverOtpResponseEntity(message: result.message);
    });
  }
}
