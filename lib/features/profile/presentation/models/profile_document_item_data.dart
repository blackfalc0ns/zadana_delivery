import 'package:flutter/material.dart';

enum ProfileDocumentType { portrait, idFront, license, vehicle, plate }

class ProfileDocumentItemData {
  const ProfileDocumentItemData({
    required this.type,
    required this.icon,
    required this.path,
  });

  final ProfileDocumentType type;
  final IconData icon;
  final String path;

  bool get hasFile => path.trim().isNotEmpty;
}
