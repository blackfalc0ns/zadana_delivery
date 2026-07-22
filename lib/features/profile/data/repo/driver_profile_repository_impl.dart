import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/profile/data/data_source/driver_profile_remote_data_source.dart';
import 'package:zadana_delivery/features/profile/data/mapper/driver_unified_profile_mapper.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_unified_profile_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_documents_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_personal_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_vehicle_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/repo/driver_profile_repository.dart';

@Injectable(as: DriverProfileRepository)
class DriverProfileRepositoryImpl implements DriverProfileRepository {
  const DriverProfileRepositoryImpl(
    this._remoteDataSource,
    this._uploadService,
    this._identityService,
    this._draftService,
  );

  final DriverProfileRemoteDataSource _remoteDataSource;
  final FileUploadService _uploadService;
  final DriverIdentityService _identityService;
  final DriverProfileDraftService _draftService;

  @override
  Future<ApiResult<DriverUnifiedProfileEntity>> getProfile() {
    return safeApiCall(() async {
      final profile = (await _remoteDataSource.getProfile()).toEntity();
      await _syncLocalServices(profile);
      return profile;
    });
  }

  @override
  Future<ApiResult<DriverUnifiedProfileEntity>> updateDocuments(
    UpdateDriverDocumentsRequestEntity request,
  ) {
    return safeApiCall(() async {
      final dto = request
          .copyWithResolvedUrls(
            personalPhotoUrl: await _resolveUrl(
              request.personalPhotoUrl,
              directory: DriverUploadDirectory.profile,
            ),
            nationalIdFrontImageUrl: await _resolveUrl(
              request.nationalIdFrontImageUrl,
              directory: DriverUploadDirectory.nationalId,
            ),
            nationalIdBackImageUrl: await _resolveUrl(
              request.nationalIdBackImageUrl,
              directory: DriverUploadDirectory.nationalId,
            ),
            licenseImageUrl: await _resolveUrl(
              request.licenseImageUrl,
              directory: DriverUploadDirectory.license,
            ),
            vehicleImageUrl: await _resolveUrl(
              request.vehicleImageUrl,
              directory: DriverUploadDirectory.vehicle,
            ),
          )
          .toDto();
      final profile = (await _remoteDataSource.updateDocuments(dto)).toEntity();
      await _syncLocalServices(profile);
      return profile;
    });
  }

  @override
  Future<ApiResult<DriverUnifiedProfileEntity>> updatePersonal(
    UpdateDriverPersonalRequestEntity request,
  ) {
    return safeApiCall(() async {
      final profile = (await _remoteDataSource.updatePersonal(
        request.toDto(),
      )).toEntity();
      await _syncLocalServices(profile);
      return profile;
    });
  }

  @override
  Future<ApiResult<DriverUnifiedProfileEntity>> updateVehicle(
    UpdateDriverVehicleRequestEntity request,
  ) {
    return safeApiCall(() async {
      final profile = (await _remoteDataSource.updateVehicle(
        request.toDto(),
      )).toEntity();
      await _syncLocalServices(profile);
      return profile;
    });
  }

  @override
  Future<ApiResult<DriverUnifiedProfileEntity>> updateProfilePhoto(
    String photoPathOrUrl,
  ) {
    return safeApiCall(() async {
      final resolvedUrl = await _resolveUrl(
        photoPathOrUrl,
        directory: DriverUploadDirectory.profile,
      );
      await _remoteDataSource.updateProfilePhoto(resolvedUrl);
      final profile = (await _remoteDataSource.getProfile()).toEntity();
      await _syncLocalServices(profile);
      return profile;
    });
  }

  @override
  Future<ApiResult<DriverUnifiedProfileEntity>> deleteProfilePhoto() {
    return safeApiCall(() async {
      await _remoteDataSource.deleteProfilePhoto();
      final profile = (await _remoteDataSource.getProfile()).toEntity();
      await _syncLocalServices(profile);
      return profile;
    });
  }

  @override
  Future<ApiResult<void>> closeAccount({
    required String password,
    String? reason,
  }) {
    return safeApiCall(
      () => _remoteDataSource.closeAccount(password: password, reason: reason),
    );
  }

  Future<String> _resolveUrl(
    String value, {
    required DriverUploadDirectory directory,
  }) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (File(trimmed).existsSync()) {
      return _uploadService.uploadFile(trimmed, directory: directory);
    }
    return trimmed;
  }

  Future<void> _syncLocalServices(DriverUnifiedProfileEntity profile) async {
    final identity = _identityService.identity;
    await _identityService.saveIdentity(
      identity.copyWith(
        fullName: profile.fullName,
        email: profile.email,
        phone: profile.phone,
        profilePhotoUrl: profile.personalPhotoUrl,
        lastIdentifier: profile.email.isNotEmpty
            ? profile.email
            : profile.phone,
      ),
    );

    await _draftService.saveProfileDraft(profile.toLocalDraft());
  }
}

extension on UpdateDriverDocumentsRequestEntity {
  UpdateDriverDocumentsRequestEntity copyWithResolvedUrls({
    required String personalPhotoUrl,
    required String nationalIdFrontImageUrl,
    required String nationalIdBackImageUrl,
    required String licenseImageUrl,
    required String vehicleImageUrl,
  }) {
    return UpdateDriverDocumentsRequestEntity(
      personalPhotoUrl: personalPhotoUrl,
      nationalIdFrontImageUrl: nationalIdFrontImageUrl,
      nationalIdBackImageUrl: nationalIdBackImageUrl,
      licenseImageUrl: licenseImageUrl,
      vehicleImageUrl: vehicleImageUrl,
    );
  }
}
