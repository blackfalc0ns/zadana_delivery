import 'package:zadana_delivery/features/profile/domain/entities/update_driver_personal_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_vehicle_request_entity.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';

sealed class ProfileFormEvent {
  const ProfileFormEvent();
}

class ProfileFormLoadEvent extends ProfileFormEvent {
  const ProfileFormLoadEvent({this.includeRegionCities = false});

  final bool includeRegionCities;
}

class ProfileFormRetryRegionCitiesEvent extends ProfileFormEvent {
  const ProfileFormRetryRegionCitiesEvent();
}

class ProfileFormSavePersonalEvent extends ProfileFormEvent {
  const ProfileFormSavePersonalEvent(this.request);

  final UpdateDriverPersonalRequestEntity request;
}

class ProfileFormSaveVehicleEvent extends ProfileFormEvent {
  const ProfileFormSaveVehicleEvent(this.request);

  final UpdateDriverVehicleRequestEntity request;
}

class ProfileFormPickDocumentEvent extends ProfileFormEvent {
  const ProfileFormPickDocumentEvent(this.type);

  final ProfileDocumentType type;
}

class ProfileFormUpdateProfilePhotoEvent extends ProfileFormEvent {
  const ProfileFormUpdateProfilePhotoEvent(this.photoPathOrUrl);

  final String photoPathOrUrl;
}

class ProfileFormDeleteProfilePhotoEvent extends ProfileFormEvent {
  const ProfileFormDeleteProfilePhotoEvent();
}

class ProfileFormSaveDocumentsEvent extends ProfileFormEvent {
  const ProfileFormSaveDocumentsEvent();
}

class ProfileFormClearErrorEvent extends ProfileFormEvent {
  const ProfileFormClearErrorEvent();
}
