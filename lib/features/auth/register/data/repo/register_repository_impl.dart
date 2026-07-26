import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/device_id_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_session_service.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
import 'package:zadana_delivery/core/services/registration_upload_token_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

import '../../domain/entities/register_request_entity.dart';
import '../../domain/entities/register_response_entity.dart';
import '../../domain/repo/register_repository.dart';
import '../data_source/register_remote_data_source.dart';
import '../mapper/mapper_register.dart';

@Injectable(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  const RegisterRepositoryImpl(
    this._remoteDataSource,
    this._tokenService,
    this._uploadService,
    this._identityService,
    this._draftService,
  );

  final RegisterRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final FileUploadService _uploadService;
  final DriverIdentityService _identityService;
  final DriverProfileDraftService _draftService;

  DeviceIdService get _deviceIdService => getIt<DeviceIdService>();
  RegistrationUploadTokenService get _registrationUploadTokenService =>
      getIt<RegistrationUploadTokenService>();

  @override
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterRequestEntity request,
  ) {
    return safeApiCall(() async {
      final deviceId = await _deviceIdService.getOrCreateDeviceId();

      final nationalIdFrontImageUrl = await _uploadService
          .uploadRegistrationFile(
            request.nationalIdFrontImagePath,
            directory: DriverUploadDirectory.nationalId,
            deviceId: deviceId,
            tokenService: _registrationUploadTokenService,
          );
      final nationalIdBackImageUrl = await _uploadService
          .uploadRegistrationFile(
            request.nationalIdBackImagePath,
            directory: DriverUploadDirectory.nationalId,
            deviceId: deviceId,
            tokenService: _registrationUploadTokenService,
          );
      final licenseImageUrl = await _uploadService.uploadRegistrationFile(
        request.licenseImagePath,
        directory: DriverUploadDirectory.license,
        deviceId: deviceId,
        tokenService: _registrationUploadTokenService,
      );
      final vehicleImageUrl = await _uploadService.uploadRegistrationFile(
        request.vehicleImagePath,
        directory: DriverUploadDirectory.vehicle,
        deviceId: deviceId,
        tokenService: _registrationUploadTokenService,
      );
      final personalPhotoUrl = await _uploadService.uploadRegistrationFile(
        request.personalPhotoPath,
        directory: DriverUploadDirectory.profile,
        deviceId: deviceId,
        tokenService: _registrationUploadTokenService,
      );

      final response = await _remoteDataSource.register(
        request.toDto(
          nationalIdFrontImageUrl: nationalIdFrontImageUrl,
          nationalIdBackImageUrl: nationalIdBackImageUrl,
          licenseImageUrl: licenseImageUrl,
          vehicleImageUrl: vehicleImageUrl,
          personalPhotoUrl: personalPhotoUrl,
        ),
      );

      final entity = response.toEntity();
      final user = entity.user;
      final accessToken = entity.tokens?.accessToken.trim() ?? '';
      final refreshToken = entity.tokens?.refreshToken.trim() ?? '';
      final requiresOtpVerification =
          !entity.isVerified ||
          accessToken.isEmpty ||
          refreshToken.isEmpty ||
          _messageRequiresOtpVerification(entity.message);

      // Before OTP verification, `user.id` may point to the temporary
      // PendingRegistrations record. Never persist that value as an
      // authenticated driver identity. The real user and its tokens are
      // persisted by the OTP verification repository after verification.
      if (user != null && !requiresOtpVerification) {
        await _identityService.saveIdentity(
          DriverIdentity(
            id: user.id,
            fullName: user.fullName,
            email: user.email,
            phone: user.phone,
            role: user.role,
            profilePhotoUrl: user.profilePhotoUrl,
            lastIdentifier: user.email.isNotEmpty ? user.email : user.phone,
          ),
        );
        await _tokenService.saveAccessToken(accessToken);
        await _tokenService.saveRefreshToken(refreshToken);
        await _tokenService.saveCurrentUserId(user.id);
        try {
          await getIt<DriverNotificationSessionService>()
              .handleSuccessfulAuthentication(user.id);
        } catch (_) {
          // Non-critical: notification/realtime setup can fail without blocking registration.
        }
      }

      await _draftService.saveProfileDraft(
        DriverProfileDraft(
          vehicleType: request.vehicleType,
          address: request.address,
          nationalId: request.nationalId,
          nationalIdExpiryDate: request.nationalIdExpiryDate,
          licenseNumber: request.licenseNumber,
          driverLicenseExpiryDate: request.driverLicenseExpiryDate,
          vehicleLicenseNumber: request.vehicleLicenseNumber,
          vehicleLicenseExpiryDate: request.vehicleLicenseExpiryDate,
          region: request.region,
          city: request.city,
          vehicleBrand: '',
          vehicleModel: '',
          plateNumber: '',
          images: {
            'portrait': request.personalPhotoPath,
            'idFront': request.nationalIdFrontImagePath,
            'idBack': request.nationalIdBackImagePath,
            'license': request.licenseImagePath,
            'vehicle': request.vehicleImagePath,
          },
        ),
      );

      // Registration upload token is no longer needed after registration.
      _registrationUploadTokenService.clear();

      return RegisterResponseEntity(
        message: entity.message,
        isVerified: entity.isVerified && !requiresOtpVerification,
        user: entity.user,
        tokens: entity.tokens,
        driverStatus: entity.driverStatus,
      );
    });
  }

  bool _messageRequiresOtpVerification(String message) {
    final normalized = message.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    return normalized.contains('not verified') ||
        normalized.contains('email address is not verified') ||
        normalized.contains('email is not verified') ||
        normalized.contains('unverified email') ||
        normalized.contains('غير مفعل') ||
        normalized.contains('غير مفعّل') ||
        normalized.contains('لم يتم تفعيل');
  }
}
