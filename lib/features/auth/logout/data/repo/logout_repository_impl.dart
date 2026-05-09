import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_notification_session_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/auth/logout/data/data_source/logout_remote_data_source.dart';
import 'package:zadana_delivery/features/auth/logout/domain/repo/logout_repository.dart';

@Injectable(as: LogoutRepository)
class LogoutRepositoryImpl implements LogoutRepository {
  const LogoutRepositoryImpl(
    this._remoteDataSource,
    this._tokenService,
    this._identityService,
    this._draftService,
  );

  final LogoutRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final DriverIdentityService _identityService;
  final DriverProfileDraftService _draftService;

  @override
  Future<ApiResult<void>> logout() {
    return safeApiCall(() async {
      final refreshToken = await _tokenService.getRefreshToken();

      if (refreshToken != null && refreshToken.trim().isNotEmpty) {
        try {
          await _remoteDataSource.logout(refreshToken.trim());
        } catch (_) {
          // Best effort server logout. Local cleanup still runs.
        }
      }

      await getIt<DriverNotificationSessionService>().handleLogout();
      await _tokenService.deleteToken();
      await _tokenService.deleteRefreshToken();
      await _identityService.clearIdentity();
      await _draftService.clearDraft();
    });
  }
}
