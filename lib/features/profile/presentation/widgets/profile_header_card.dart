import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_identity.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_surface.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.identity,
    required this.onEditTap,
  });

  final ProfileHeaderIdentity identity;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      height: 140 + topInset,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Spacing.base,
        topInset + 10,
        Spacing.base,
        16,
      ),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ProfileHeaderSurface(identity: identity, onEditTap: onEditTap),
    );
  }
}
