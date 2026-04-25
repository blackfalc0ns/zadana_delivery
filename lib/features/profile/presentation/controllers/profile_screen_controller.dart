import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/auth/session/domain/usecase/logout_usecase.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_view_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_identity.dart';

@injectable
class ProfileScreenController extends ChangeNotifier {
  ProfileScreenController(this._identityService, this._logoutUseCase);

  final DriverIdentityService _identityService;
  final LogoutUseCase _logoutUseCase;

  bool _isLoggingOut = false;
  bool _notificationsEnabled = true;

  late final List<ProfileSectionData> sections = const [
    ProfileSectionData(
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
    ProfileSectionData(
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
    ProfileSectionData(
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
    final identity = _identityService.identity;

    return ProfileHeaderData(
      fullName: identity.fullName,
      email: _resolveEmail(identity.email),
      phone: _resolvePhone(identity.phone),
    );
  }

  ProfileHeaderIdentity resolveHeaderIdentity(AppLocalizations locale) {
    final data = headerData;
    final fullName = _resolveValue(data.fullName, locale.profile_default_name);
    final email = _resolveValue(data.email, locale.profile_default_email);
    final phone = _resolveValue(data.phone, locale.profile_default_phone);

    return ProfileHeaderIdentity(
      fullName: fullName,
      email: email,
      phone: phone,
      avatarLetter: fullName.substring(0, 1).toUpperCase(),
    );
  }

  List<ProfileSectionViewData> buildSectionViewData({
    required AppLocalizations locale,
    required ColorScheme colorScheme,
  }) {
    return sections
        .map(
          (section) => ProfileSectionViewData(
            items: section.items.map((item) {
              final copy = item.type.localizedCopy(locale);
              return ProfileActionViewData(
                type: item.type,
                title: copy.$1,
                subtitle: copy.$2,
                icon: item.icon,
                iconColor: item.colorToken.resolveColor(colorScheme),
                isDestructive: item.isDestructive,
                isLoading:
                    item.type == ProfileActionType.logout && _isLoggingOut,
                isNotificationTile:
                    item.type == ProfileActionType.notifications,
                notificationsEnabled: _notificationsEnabled,
              );
            }).toList(),
          ),
        )
        .toList();
  }

  void updateNotifications(bool value) {
    if (_notificationsEnabled == value) return;
    _notificationsEnabled = value;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    final result = await _logoutUseCase.call();

    _isLoggingOut = false;
    notifyListeners();

    if (result case ApiErrorResult()) {
      throw Exception(result.failure.errorMessage);
    }
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

  static String _resolveValue(String value, String fallback) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return fallback;
    return trimmed;
  }
}
