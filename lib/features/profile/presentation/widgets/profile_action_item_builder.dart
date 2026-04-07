import 'package:flutter/material.dart';
import 'package:zadana_delivery/features/profile/presentation/extensions/profile_action_type_extension.dart';
import 'package:zadana_delivery/features/profile/presentation/extensions/profile_color_token_extension.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_tile.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_notification_tile.dart';

class ProfileActionItemBuilder extends StatelessWidget {
  const ProfileActionItemBuilder({
    super.key,
    required this.item,
    required this.notificationsEnabled,
    required this.isLoggingOut,
    required this.onNotificationsChanged,
    required this.onActionTap,
  });

  final ProfileActionItemData item;
  final bool notificationsEnabled;
  final bool isLoggingOut;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<ProfileActionType> onActionTap;

  @override
  Widget build(BuildContext context) {
    final copy = item.type.copyOf(context);
    final color = item.colorToken.resolve(Theme.of(context).colorScheme);
    if (item.type == ProfileActionType.notifications) {
      return ProfileNotificationTile(
        title: copy.$1,
        subtitle: copy.$2,
        icon: item.icon,
        iconColor: color,
        value: notificationsEnabled,
        onChanged: onNotificationsChanged,
        onTap: () => onActionTap(item.type),
      );
    }

    return ProfileActionTile(
      title: copy.$1,
      subtitle: copy.$2,
      icon: item.icon,
      iconColor: color,
      isDestructive: item.isDestructive,
      trailing: item.type == ProfileActionType.logout && isLoggingOut
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          : null,
      onTap: item.type == ProfileActionType.logout && isLoggingOut
          ? null
          : () => onActionTap(item.type),
    );
  }
}
