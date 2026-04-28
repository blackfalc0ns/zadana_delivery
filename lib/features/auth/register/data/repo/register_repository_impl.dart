import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
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

  @override
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterRequestEntity request,
  ) {
    return safeApiCall(() async {
      final nationalIdFrontImageUrl = await _uploadService.uploadFile(
        request.nationalIdFrontImagePath,
      );
      final nationalIdBackImageUrl = await _uploadService.uploadFile(
        request.nationalIdBackImagePath,
      );
      final licenseImageUrl = await _uploadService.uploadFile(
        request.licenseImagePath,
      );
      final vehicleImageUrl = await _uploadService.uploadFile(
        request.vehicleImagePath,
      );
      final personalPhotoUrl = await _uploadService.uploadFile(
        request.personalPhotoPath,
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

      final accessToken = response.tokens?.accessToken?.trim() ?? '';
      final refreshToken = response.tokens?.refreshToken?.trim() ?? '';

      if (accessToken.isNotEmpty) {
        await _tokenService.saveAccessToken(accessToken);
      }
      if (refreshToken.isNotEmpty) {
        await _tokenService.saveRefreshToken(refreshToken);
      }

      final entity = response.toEntity();
      final user = entity.user;

      if (user != null) {
        await _identityService.saveIdentity(
          DriverIdentity(
            id: user.id,
            fullName: user.fullName,
            email: user.email,
            phone: user.phone,
            role: user.role,
            lastIdentifier: user.email.isNotEmpty ? user.email : user.phone,
          ),
        );
      }

      await _draftService.saveProfileDraft(
        DriverProfileDraft(
          vehicleType: request.vehicleType,
          address: request.address,
          nationalId: request.nationalId,
          licenseNumber: request.licenseNumber,
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

      return RegisterResponseEntity(
        message: entity.message,
        isVerified: entity.isVerified,
        user: entity.user,
      );
    });
  }
}
