import 'package:flutter/widgets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';

typedef ProfileActionCopy = (String title, String subtitle);

extension ProfileActionTypeExtension on ProfileActionType {
  ProfileActionCopy copyOf(BuildContext context) {
    final locale = context.localization;
    return switch (this) {
      ProfileActionType.editProfile => (
        locale.profile_edit_profile_title,
        locale.profile_edit_profile_subtitle,
      ),
      ProfileActionType.orders => (
        locale.my_orders_title,
        locale.my_orders_subtitle,
      ),
      ProfileActionType.language => (
        locale.language,
        locale.profile_language_subtitle,
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
