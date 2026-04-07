import 'package:flutter/widgets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_data.dart';

class ProfileHeaderIdentity {
  const ProfileHeaderIdentity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatarLetter,
  });

  final String fullName;
  final String email;
  final String phone;
  final String avatarLetter;

  factory ProfileHeaderIdentity.fromData(
    BuildContext context,
    ProfileHeaderData data,
  ) {
    final locale = context.localization;
    final fullName = data.fullName.trim().isEmpty
        ? locale.profile_default_name
        : data.fullName.trim();
    final email = data.email.trim().isEmpty
        ? locale.profile_default_email
        : data.email.trim();
    final phone = data.phone.trim().isEmpty
        ? locale.profile_default_phone
        : data.phone.trim();
    return ProfileHeaderIdentity(
      fullName: fullName,
      email: email,
      phone: phone,
      avatarLetter: fullName.substring(0, 1).toUpperCase(),
    );
  }
}
