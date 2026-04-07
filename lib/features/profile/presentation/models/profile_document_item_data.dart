import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';

enum ProfileDocumentType { portrait, idFront, license, vehicle, plate }

extension ProfileDocumentTypeX on ProfileDocumentType {
  String get storageKey {
    return switch (this) {
      ProfileDocumentType.portrait => 'portrait',
      ProfileDocumentType.idFront => 'idFront',
      ProfileDocumentType.license => 'license',
      ProfileDocumentType.vehicle => 'vehicle',
      ProfileDocumentType.plate => 'plate',
    };
  }

  String localizedTitle(AppLocalizations locale) {
    return switch (this) {
      ProfileDocumentType.portrait => locale.driver_profile_portrait_title,
      ProfileDocumentType.idFront => locale.driver_profile_id_front_title,
      ProfileDocumentType.license => locale.driver_profile_license_title,
      ProfileDocumentType.vehicle =>
        locale.driver_profile_vehicle_photo_title,
      ProfileDocumentType.plate => locale.driver_profile_plate_photo_title,
    };
  }
}

class ProfileDocumentItemData {
  const ProfileDocumentItemData({
    required this.type,
    required this.icon,
    required this.path,
  });

  final ProfileDocumentType type;
  final IconData icon;
  final String path;

  bool get hasFile => path.trim().isNotEmpty;
}
