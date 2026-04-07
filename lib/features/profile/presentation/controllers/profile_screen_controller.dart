import 'package:flutter/material.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_data.dart';

class ProfileScreenController extends ChangeNotifier {
  ProfileScreenController({DriverProfileService? service})
    : _service = service ?? DriverProfileService();

  final DriverProfileService _service;

  bool _isLoggingOut = false;
  bool _notificationsEnabled = true;

  bool get isLoggingOut => _isLoggingOut;
  bool get notificationsEnabled => _notificationsEnabled;

  late final List<ProfileSectionData> sections = [
    const ProfileSectionData(
      items: [
        ProfileActionItemData(
          icon: Icons.person_outline_rounded,
          colorToken: ProfileColorToken.primary,
          type: ProfileActionType.editProfile,
        ),
        ProfileActionItemData(
          icon: Icons.receipt_long_outlined,
          colorToken: ProfileColorToken.tertiary,
          type: ProfileActionType.orders,
        ),
      ],
    ),
    const ProfileSectionData(
      items: [
        ProfileActionItemData(
          icon: Icons.language_rounded,
          colorToken: ProfileColorToken.tertiary,
          type: ProfileActionType.language,
        ),
        ProfileActionItemData(
          icon: Icons.notifications_none_rounded,
          colorToken: ProfileColorToken.primary,
          type: ProfileActionType.notifications,
        ),
        ProfileActionItemData(
          icon: Icons.lock_outline_rounded,
          colorToken: ProfileColorToken.secondary,
          type: ProfileActionType.security,
        ),
      ],
    ),
    const ProfileSectionData(
      items: [
        ProfileActionItemData(
          icon: Icons.support_agent_rounded,
          colorToken: ProfileColorToken.primary,
          type: ProfileActionType.support,
        ),
        ProfileActionItemData(
          icon: Icons.privacy_tip_outlined,
          colorToken: ProfileColorToken.tertiary,
          type: ProfileActionType.privacy,
        ),
      ],
    ),
    ProfileSectionData(
      items: [
        ProfileActionItemData(
          icon: Icons.logout_rounded,
          colorToken: ProfileColorToken.error,
          type: ProfileActionType.logout,
          isDestructive: true,
        ),
      ],
    ),
  ];

  ProfileHeaderData get headerData {
    final identity = _service.identity;

    return ProfileHeaderData(
      fullName: identity.fullName,
      email: _resolveEmail(identity.email),
      phone: _resolvePhone(identity.phone),
    );
  }

  void updateNotifications(bool value) {
    if (_notificationsEnabled == value) return;
    _notificationsEnabled = value;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    await _service.clearSession();
    await Future<void>.delayed(const Duration(milliseconds: 250));

    _isLoggingOut = false;
    notifyListeners();
  }
  static String _resolveEmail(String email) {
    final trimmed = email.trim();
    return trimmed;
  }

  static String _resolvePhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return '+20 100 000 0000';
    return trimmed;
  }
}
