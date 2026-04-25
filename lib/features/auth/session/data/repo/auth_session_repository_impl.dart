import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

import '../../domain/entities/auth_session_user_entity.dart';
import '../../domain/entities/refresh_token_request_entity.dart';
import '../../domain/entities/refresh_token_response_entity.dart';
import '../../domain/entities/update_current_driver_request_entity.dart';
import '../../domain/repo/auth_session_repository.dart';
import '../data_source/auth_session_remote_data_source.dart';
import '../mapper/mapper_auth_session.dart';

@Injectable(as: AuthSessionRepository)
class AuthSessionRepositoryImpl implements AuthSessionRepository {
  const AuthSessionRepositoryImpl(
    this._dataSource,
    this._tokenService,
    this._identityService,
    this._draftService,
  );

  final AuthSessionRemoteDataSource _dataSource;
  final TokenService _tokenService;
  final DriverIdentityService _identityService;
  final DriverProfileDraftService _draftService;

  @override
  Future<ApiResult<AuthSessionUserEntity>> getCurrentDriver() {
    return safeApiCall(() async {
      final response = await _dataSource.getCurrentDriver();
      final entity = response.toEntity();
      await _saveIdentity(entity);
      return entity;
    });
  }

  @override
  Future<ApiResult<AuthSessionUserEntity>> updateCurrentDriver(
    UpdateCurrentDriverRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _dataSource.updateCurrentDriver(request.toDto());
      final entity = response.toEntity();
      await _saveIdentity(
        entity,
        lastIdentifier: entity.email.isNotEmpty ? entity.email : entity.phone,
      );
      return entity;
    });
  }

  @override
  Future<ApiResult<RefreshTokenResponseEntity>> refreshToken(
    RefreshTokenRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _dataSource.refreshToken(request.toDto());
      final entity = response.toEntity();

      if (entity.accessToken.isNotEmpty) {
        await _tokenService.saveAccessToken(entity.accessToken);
      }
      if (entity.refreshToken.isNotEmpty) {
        await _tokenService.saveRefreshToken(entity.refreshToken);
      }

      return entity;
    });
  }

  @override
  Future<ApiResult<void>> logout() {
    return safeApiCall(() async {
      final refreshToken = await _tokenService.getRefreshToken();

      if (refreshToken != null && refreshToken.trim().isNotEmpty) {
        try {
          await _dataSource.logout(refreshToken.trim());
        } catch (_) {
          // Best effort server logout. Local cleanup still runs.
        }
      }

      await _tokenService.deleteToken();
      await _tokenService.deleteRefreshToken();
      await _identityService.clearIdentity();
      await _draftService.clearDraft();
    });
  }

  Future<void> _saveIdentity(
    AuthSessionUserEntity user, {
    String? lastIdentifier,
  }) async {
    final currentIdentity = _identityService.identity;
    final resolvedLastIdentifier =
        (lastIdentifier != null && lastIdentifier.isNotEmpty)
        ? lastIdentifier
        : (currentIdentity.lastIdentifier.isNotEmpty
              ? currentIdentity.lastIdentifier
              : (user.email.isNotEmpty ? user.email : user.phone));

    await _identityService.saveIdentity(
      DriverIdentity(
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        role: user.role,
        lastIdentifier: resolvedLastIdentifier,
      ),
    );
  }
}
