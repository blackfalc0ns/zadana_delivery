import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_avatar_badge.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_glow_circle.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_identity.dart';
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
          top: -26,
          right: -10,
          child: ProfileHeaderGlowCircle(
            size: 88,
            color: onPrimary.withValues(alpha: 0.08),
          ),
        ),
        Positioned(
          bottom: -28,
          left: -8,
          child: ProfileHeaderGlowCircle(
            size: 100,
            color: onPrimary.withValues(alpha: 0.05),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: onPrimary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: onPrimary.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              ProfileHeaderAvatarBadge(letter: identity.avatarLetter),
              const SizedBox(width: Spacing.md),
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
