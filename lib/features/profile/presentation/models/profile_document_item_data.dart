import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';

enum ProfileDocumentType { portrait, idFront, idBack, license, vehicle }

extension ProfileDocumentTypeX on ProfileDocumentType {
  String get storageKey {
    return switch (this) {
      ProfileDocumentType.portrait => 'portrait',
      ProfileDocumentType.idFront => 'idFront',
      ProfileDocumentType.idBack => 'idBack',
      ProfileDocumentType.license => 'license',
      ProfileDocumentType.vehicle => 'vehicle',
    };
  }

  String localizedTitle(AppLocalizations locale) {
    return switch (this) {
      ProfileDocumentType.portrait => locale.driver_profile_portrait_title,
      ProfileDocumentType.idFront => locale.driver_profile_id_front_title,
      ProfileDocumentType.idBack => locale.driver_profile_id_back_title,
      ProfileDocumentType.license => locale.driver_profile_license_title,
      ProfileDocumentType.vehicle =>
        locale.driver_profile_vehicle_license_title,
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
