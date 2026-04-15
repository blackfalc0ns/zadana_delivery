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

class PersonalInfoController {
  PersonalInfoController({DriverProfileService? service})
    : _service = service ?? DriverProfileService();

  final DriverProfileService _service;

  PersonalInfoInitialData get initialData {
    final identity = _service.identity;
    final draft = _service.profileDraft;

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
    final identity = _service.identity.copyWith(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    final draft = _service.profileDraft.copyWith(address: address.trim());

    await _service.saveIdentity(identity);
    await _service.saveProfileDraft(draft);
  }
}
