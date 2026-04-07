import 'package:flutter/material.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';

class ProfileActionViewData {
  const ProfileActionViewData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isDestructive,
    required this.isLoading,
    required this.isNotificationTile,
    required this.notificationsEnabled,
  });

  final ProfileActionType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isDestructive;
  final bool isLoading;
  final bool isNotificationTile;
  final bool notificationsEnabled;
}

class ProfileSectionViewData {
  const ProfileSectionViewData({required this.items});

  final List<ProfileActionViewData> items;
}
