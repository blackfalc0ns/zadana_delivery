import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';

enum ProfileColorToken { primary, secondary, tertiary, error }

enum ProfileActionType {
  personalInfo,
  vehicleInfo,
  documents,
  orders,
  language,
  notifications,
  security,
  support,
  privacy,
  logout;

  (String, String) localizedCopy(AppLocalizations locale) {
    return switch (this) {
      ProfileActionType.personalInfo => (
        locale.personal_info,
        locale.driver_profile_identity_card_subtitle,
      ),
      ProfileActionType.vehicleInfo => (
        locale.driver_profile_vehicle_card_title,
        locale.driver_profile_vehicle_card_subtitle,
      ),
      ProfileActionType.documents => (
        locale.profile_security_documents_title,
        locale.driver_profile_uploads_card_subtitle,
      ),
      ProfileActionType.orders => (
        locale.my_orders_title,
        locale.my_orders_subtitle,
      ),
      ProfileActionType.language => (
        locale.language,
        locale.localeName.startsWith('ar') ? locale.arabic : locale.english,
      ),
      ProfileActionType.notifications => (
        locale.notifications,
        locale.profile_notifications_subtitle,
      ),
      ProfileActionType.security => (
        locale.change_password,
        locale.profile_change_password_subtitle,
      ),
      ProfileActionType.support => (
        locale.help_support,
        locale.profile_support_subtitle,
      ),
      ProfileActionType.privacy => (
        locale.privacy_policy,
        locale.profile_privacy_subtitle,
      ),
      ProfileActionType.logout => (
        locale.logout,
        locale.profile_logout_subtitle,
      ),
    };
  }
}

extension ProfileColorTokenX on ProfileColorToken {
  Color resolveColor(ColorScheme colorScheme) {
    return switch (this) {
      ProfileColorToken.primary => colorScheme.primary,
      ProfileColorToken.secondary => colorScheme.secondary,
      ProfileColorToken.tertiary => colorScheme.tertiary,
      ProfileColorToken.error => colorScheme.error,
    };
  }
}

class ProfileActionItemData {
  const ProfileActionItemData({
    required this.icon,
    required this.colorToken,
    required this.type,
    this.isDestructive = false,
  });

  final IconData icon;
  final ProfileColorToken colorToken;
  final ProfileActionType type;
  final bool isDestructive;
}

class ProfileSectionData {
  const ProfileSectionData({required this.items});

  final List<ProfileActionItemData> items;
}
