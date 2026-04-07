import 'package:flutter/widgets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';

extension ProfileDocumentTypeExtension on ProfileDocumentType {
  String get storageKey => switch (this) {
    ProfileDocumentType.portrait => 'portrait',
    ProfileDocumentType.idFront => 'idFront',
    ProfileDocumentType.license => 'license',
    ProfileDocumentType.vehicle => 'vehicle',
    ProfileDocumentType.plate => 'plate',
  };

  String titleOf(BuildContext context) {
    final locale = context.localization;
    return switch (this) {
      ProfileDocumentType.portrait => locale.driver_profile_portrait_title,
      ProfileDocumentType.idFront => locale.driver_profile_id_front_title,
      ProfileDocumentType.license => locale.driver_profile_license_title,
      ProfileDocumentType.vehicle => locale.driver_profile_vehicle_photo_title,
      ProfileDocumentType.plate => locale.driver_profile_plate_photo_title,
    };
  }
}
