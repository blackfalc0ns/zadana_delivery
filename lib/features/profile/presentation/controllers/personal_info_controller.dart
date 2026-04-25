import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

class PersonalInfoInitialData {
  const PersonalInfoInitialData({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  final String fullName;
  final String email;
  final String phone;
  final String address;
}

@injectable
class PersonalInfoController {
  PersonalInfoController(this._identityService, this._draftService);

  final DriverIdentityService _identityService;
  final DriverProfileDraftService _draftService;

  PersonalInfoInitialData get initialData {
    final identity = _identityService.identity;
    final draft = _draftService.profileDraft;

    return PersonalInfoInitialData(
      fullName: identity.fullName,
      email: identity.email,
      phone: identity.phone,
      address: draft.address,
    );
  }

  Future<void> save({
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    final identity = _identityService.identity.copyWith(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    final draft = _draftService.profileDraft.copyWith(address: address.trim());

    await _identityService.saveIdentity(identity);
    await _draftService.saveProfileDraft(draft);
  }
}
