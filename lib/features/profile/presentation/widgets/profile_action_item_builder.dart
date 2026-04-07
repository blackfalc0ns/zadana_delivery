import 'package:flutter/material.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_view_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_tile.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_notification_tile.dart';

class ProfileActionItemBuilder extends StatelessWidget {
  const ProfileActionItemBuilder({
    super.key,
    required this.item,
    required this.onNotificationsChanged,
    required this.onActionTap,
  });

  final ProfileActionViewData item;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<ProfileActionType> onActionTap;

  @override
  Widget build(BuildContext context) {
    if (item.isNotificationTile) {
      return ProfileNotificationTile(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon,
        iconColor: item.iconColor,
        value: item.notificationsEnabled,
        onChanged: onNotificationsChanged,
        onTap: () => onActionTap(item.type),
      );
    }

    return ProfileActionTile(
      title: item.title,
      subtitle: item.subtitle,
      icon: item.icon,
      iconColor: item.iconColor,
      isDestructive: item.isDestructive,
      trailing: item.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          : null,
      onTap: item.isLoading ? null : () => onActionTap(item.type),
    );
  }
}
