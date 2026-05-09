import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_unified_profile_entity.dart';

class DriverProfileDraft {
  factory DriverProfileDraft.fromJson(Map<String, dynamic> json) {
    return DriverProfileDraft(
      vehicleType: _normalizeVehicleType(json['vehicleType']?.toString()),
      address: json['address']?.toString() ?? '',
      nationalId: json['nationalId']?.toString() ?? '',
      nationalIdExpiryDate: json['nationalIdExpiryDate']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
      driverLicenseExpiryDate:
          json['driverLicenseExpiryDate']?.toString() ?? '',
      vehicleLicenseNumber: json['vehicleLicenseNumber']?.toString() ?? '',
      vehicleLicenseExpiryDate:
          json['vehicleLicenseExpiryDate']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      vehicleBrand: json['vehicleBrand']?.toString() ?? '',
      vehicleModel: json['vehicleModel']?.toString() ?? '',
      plateNumber: json['plateNumber']?.toString() ?? '',
      images: Map<String, String>.from(
        (json['images'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
            ) ??
            const <String, String>{},
      ),
    );
  }
  const DriverProfileDraft({
    required this.vehicleType,
    required this.address,
    required this.nationalId,
    required this.nationalIdExpiryDate,
    required this.licenseNumber,
    required this.driverLicenseExpiryDate,
    required this.vehicleLicenseNumber,
    required this.vehicleLicenseExpiryDate,
    required this.region,
    required this.city,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
    required this.images,
  });

  final String vehicleType;
  final String address;
  final String nationalId;
  final String nationalIdExpiryDate;
  final String licenseNumber;
  final String driverLicenseExpiryDate;
  final String vehicleLicenseNumber;
  final String vehicleLicenseExpiryDate;
  final String region;
  final String city;
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
  final Map<String, String> images;

  bool get isComplete {
    final hasFields = [
      vehicleType,
      address,
      nationalId,
      nationalIdExpiryDate,
      licenseNumber,
      driverLicenseExpiryDate,
      vehicleLicenseNumber,
      vehicleLicenseExpiryDate,
      region,
      city,
    ].every((value) => value.trim().isNotEmpty);

    final requiredImages = [
      'portrait',
      'idFront',
      'idBack',
      'license',
      'vehicle',
    ];
    final hasImages = requiredImages.every(
      (key) => (images[key] ?? '').trim().isNotEmpty,
    );

    return hasFields && hasImages;
  }

  Map<String, dynamic> toJson() => {
    'vehicleType': vehicleType,
    'address': address,
    'nationalId': nationalId,
    'nationalIdExpiryDate': nationalIdExpiryDate,
    'licenseNumber': licenseNumber,
    'driverLicenseExpiryDate': driverLicenseExpiryDate,
    'vehicleLicenseNumber': vehicleLicenseNumber,
    'vehicleLicenseExpiryDate': vehicleLicenseExpiryDate,
    'region': region,
    'city': city,
    'vehicleBrand': vehicleBrand,
    'vehicleModel': vehicleModel,
    'plateNumber': plateNumber,
    'images': images,
  };

  DriverProfileDraft copyWith({
    String? vehicleType,
    String? address,
    String? nationalId,
    String? nationalIdExpiryDate,
    String? licenseNumber,
    String? driverLicenseExpiryDate,
    String? vehicleLicenseNumber,
    String? vehicleLicenseExpiryDate,
    String? region,
    String? city,
    String? vehicleBrand,
    String? vehicleModel,
    String? plateNumber,
    Map<String, String>? images,
  }) {
    return DriverProfileDraft(
      vehicleType: vehicleType ?? this.vehicleType,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      nationalIdExpiryDate: nationalIdExpiryDate ?? this.nationalIdExpiryDate,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      driverLicenseExpiryDate:
          driverLicenseExpiryDate ?? this.driverLicenseExpiryDate,
      vehicleLicenseNumber: vehicleLicenseNumber ?? this.vehicleLicenseNumber,
      vehicleLicenseExpiryDate:
          vehicleLicenseExpiryDate ?? this.vehicleLicenseExpiryDate,
      region: region ?? this.region,
      city: city ?? this.city,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      plateNumber: plateNumber ?? this.plateNumber,
      images: images ?? this.images,
    );
  }

  static const empty = DriverProfileDraft(
    vehicleType: DriverVehicleType.car,
    address: '',
    nationalId: '',
    nationalIdExpiryDate: '',
    licenseNumber: '',
    driverLicenseExpiryDate: '',
    vehicleLicenseNumber: '',
    vehicleLicenseExpiryDate: '',
    region: '',
    city: '',
    vehicleBrand: '',
    vehicleModel: '',
    plateNumber: '',
    images: <String, String>{},
  );

  static String _normalizeVehicleType(String? rawValue) {
    return DriverVehicleType.normalize(rawValue);
  }
}

class DriverIdentity {
  const DriverIdentity({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.role = 'driver',
    this.lastIdentifier = '',
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String lastIdentifier;

  DriverIdentity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? lastIdentifier,
  }) {
    return DriverIdentity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      lastIdentifier: lastIdentifier ?? this.lastIdentifier,
    );
  }
}

class DriverIdentityService {
  DriverIdentity _identity = const DriverIdentity();

  DriverIdentity get identity => _identity;

  Future<void> saveIdentity(DriverIdentity identity) async {
    _identity = identity;
  }

  Future<void> clearIdentity() async {
    _identity = const DriverIdentity();
  }
}

class DriverProfileDraftService {
  DriverProfileDraft _profileDraft = DriverProfileDraft.empty;

  bool get isProfileCompleted => _profileDraft.isComplete;

  DriverProfileDraft get profileDraft => _profileDraft;

  Future<void> saveProfileDraft(DriverProfileDraft draft) async {
    _profileDraft = draft;
  }

  Future<void> clearDraft() async {
    _profileDraft = DriverProfileDraft.empty;
  }
}

extension DriverUnifiedProfileDraftMapper on DriverUnifiedProfileEntity {
  DriverProfileDraft toLocalDraft() {
    return DriverProfileDraft(
      vehicleType: vehicleType,
      address: address,
      nationalId: nationalId,
      nationalIdExpiryDate: nationalIdExpiryDate,
      licenseNumber: licenseNumber,
      driverLicenseExpiryDate: driverLicenseExpiryDate,
      vehicleLicenseNumber: vehicleLicenseNumber,
      vehicleLicenseExpiryDate: vehicleLicenseExpiryDate,
      region: region,
      city: city,
      vehicleBrand: '',
      vehicleModel: '',
      plateNumber: '',
      images: {
        'portrait': personalPhotoUrl,
        'idFront': nationalIdFrontImageUrl,
        'idBack': nationalIdBackImageUrl,
        'license': licenseImageUrl,
        'vehicle': vehicleImageUrl,
      },
    );
  }
}
