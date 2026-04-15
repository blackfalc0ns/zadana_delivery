import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/utils/constants.dart';

class DriverProfileDraft {
  factory DriverProfileDraft.fromJson(Map<String, dynamic> json) {
    return DriverProfileDraft(
      vehicleType: json['vehicleType']?.toString() ?? 'car',
      address: json['address']?.toString() ?? '',
      nationalId: json['nationalId']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
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
    required this.licenseNumber,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
    required this.images,
  });

  final String vehicleType;
  final String address;
  final String nationalId;
  final String licenseNumber;
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
  final Map<String, String> images;

  bool get isComplete {
    final hasFields = [
      address,
      nationalId,
      licenseNumber,
      vehicleBrand,
      vehicleModel,
      plateNumber,
    ].every((value) => value.trim().isNotEmpty);

    final requiredImages = [
      'portrait',
      'idFront',
      'license',
      'vehicle',
      'plate',
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
    'licenseNumber': licenseNumber,
    'vehicleBrand': vehicleBrand,
    'vehicleModel': vehicleModel,
    'plateNumber': plateNumber,
    'images': images,
  };

  DriverProfileDraft copyWith({
    String? vehicleType,
    String? address,
    String? nationalId,
    String? licenseNumber,
    String? vehicleBrand,
    String? vehicleModel,
    String? plateNumber,
    Map<String, String>? images,
  }) {
    return DriverProfileDraft(
      vehicleType: vehicleType ?? this.vehicleType,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      plateNumber: plateNumber ?? this.plateNumber,
      images: images ?? this.images,
    );
  }

  static const empty = DriverProfileDraft(
    vehicleType: 'car',
    address: '',
    nationalId: '',
    licenseNumber: '',
    vehicleBrand: '',
    vehicleModel: '',
    plateNumber: '',
    images: <String, String>{},
  );
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

class DriverProfileService {
  DriverProfileService({SharedPreferences? sharedPreferences})
    : _sharedPreferences =
          sharedPreferences ?? GetIt.instance<SharedPreferences>();

  final SharedPreferences _sharedPreferences;

  DriverIdentity get identity => DriverIdentity(
    id: _sharedPreferences.getString(AppConstants.driverId) ?? '',
    fullName: _sharedPreferences.getString(AppConstants.driverFullName) ?? '',
    email: _sharedPreferences.getString(AppConstants.driverEmail) ?? '',
    phone: _sharedPreferences.getString(AppConstants.driverPhone) ?? '',
    role: _sharedPreferences.getString(AppConstants.driverRole) ?? 'driver',
    lastIdentifier:
        _sharedPreferences.getString(AppConstants.driverLastIdentifier) ?? '',
  );

  bool get isProfileCompleted =>
      _sharedPreferences.getBool(AppConstants.isDriverProfileCompleted) ??
      false;

  DriverProfileDraft get profileDraft {
    final raw = _sharedPreferences.getString(AppConstants.driverProfileDraft);
    if (raw == null || raw.isEmpty) return DriverProfileDraft.empty;

    try {
      return DriverProfileDraft.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return DriverProfileDraft.empty;
    }
  }

  Future<void> saveIdentity(DriverIdentity identity) async {
    await _sharedPreferences.setString(AppConstants.driverId, identity.id);
    await _sharedPreferences.setString(
      AppConstants.driverFullName,
      identity.fullName,
    );
    await _sharedPreferences.setString(
      AppConstants.driverEmail,
      identity.email,
    );
    await _sharedPreferences.setString(
      AppConstants.driverPhone,
      identity.phone,
    );
    await _sharedPreferences.setString(AppConstants.driverRole, identity.role);
    await _sharedPreferences.setString(
      AppConstants.driverLastIdentifier,
      identity.lastIdentifier,
    );
  }

  Future<void> saveProfileDraft(DriverProfileDraft draft) async {
    await _sharedPreferences.setString(
      AppConstants.driverProfileDraft,
      jsonEncode(draft.toJson()),
    );
    await _sharedPreferences.setBool(
      AppConstants.isDriverProfileCompleted,
      draft.isComplete,
    );
  }

  Future<void> clearSession() async {
    await _sharedPreferences.remove(AppConstants.driverId);
    await _sharedPreferences.remove(AppConstants.driverFullName);
    await _sharedPreferences.remove(AppConstants.driverEmail);
    await _sharedPreferences.remove(AppConstants.driverPhone);
    await _sharedPreferences.remove(AppConstants.driverRole);
    await _sharedPreferences.remove(AppConstants.driverLastIdentifier);
    await _sharedPreferences.remove(AppConstants.driverProfileDraft);
    await _sharedPreferences.remove(AppConstants.isDriverProfileCompleted);
  }
}
