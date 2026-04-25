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
      final dto = request.copyWithResolvedUrls(
        personalPhotoUrl: await _resolveUrl(request.personalPhotoUrl),
        nationalIdImageUrl: await _resolveUrl(request.nationalIdImageUrl),
        licenseImageUrl: await _resolveUrl(request.licenseImageUrl),
        vehicleImageUrl: await _resolveUrl(request.vehicleImageUrl),
      ).toDto();
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

  Future<String> _resolveUrl(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (File(trimmed).existsSync()) {
      return _uploadService.uploadFile(trimmed);
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
        lastIdentifier: profile.email.isNotEmpty ? profile.email : profile.phone,
      ),
    );

    await _draftService.saveProfileDraft(
      DriverProfileDraft(
        vehicleType: profile.vehicleType,
        address: profile.address,
        nationalId: profile.nationalId,
        licenseNumber: profile.licenseNumber,
        vehicleBrand: '',
        vehicleModel: '',
        plateNumber: '',
        images: {
          'portrait': profile.personalPhotoUrl,
          'idFront': profile.nationalIdImageUrl,
          'license': profile.licenseImageUrl,
          'vehicle': profile.vehicleImageUrl,
        },
      ),
    );
  }
}

extension on UpdateDriverDocumentsRequestEntity {
  UpdateDriverDocumentsRequestEntity copyWithResolvedUrls({
    required String personalPhotoUrl,
    required String nationalIdImageUrl,
    required String licenseImageUrl,
    required String vehicleImageUrl,
  }) {
    return UpdateDriverDocumentsRequestEntity(
      personalPhotoUrl: personalPhotoUrl,
      nationalIdImageUrl: nationalIdImageUrl,
      licenseImageUrl: licenseImageUrl,
      vehicleImageUrl: vehicleImageUrl,
    );
  }
}
