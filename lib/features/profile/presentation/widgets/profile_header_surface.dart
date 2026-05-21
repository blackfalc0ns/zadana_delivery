import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_identity.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_avatar_badge.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_glow_circle.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_text.dart';

class ProfileHeaderSurface extends StatelessWidget {
  const ProfileHeaderSurface({
    super.key,
    required this.identity,
    required this.onEditTap,
  });

  final ProfileHeaderIdentity identity;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;
    return Stack(
      children: [
        Positioned(
          top: -28,
          right: -18,
          child: ProfileHeaderGlowCircle(
            size: 96,
            color: onPrimary.withValues(alpha: 0.07),
          ),
        ),
        Positioned(
          bottom: -34,
          left: -14,
          child: ProfileHeaderGlowCircle(
            size: 108,
            color: onPrimary.withValues(alpha: 0.04),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: onPrimary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: onPrimary.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              ProfileHeaderAvatarBadge(
                letter: identity.avatarLetter,
                photoUrl: identity.photoUrl,
              ),
              const SizedBox(width: Spacing.base),
              Expanded(
                child: ProfileHeaderText(
                  identity: identity,
                  onEditTap: onEditTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
