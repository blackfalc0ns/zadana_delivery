import 'package:flutter/material.dart';

enum ProfileColorToken { primary, secondary, tertiary, error }

enum ProfileActionType {
  editProfile,
  orders,
  language,
  notifications,
  security,
  support,
  privacy,
  logout,
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
