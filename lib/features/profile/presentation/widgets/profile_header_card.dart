import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_identity.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_surface.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.data,
    required this.onEditTap,
  });

  final ProfileHeaderData data;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final identity = ProfileHeaderIdentity.fromData(context, data);
    final topInset = MediaQuery.paddingOf(context).top;
    return Container(
      height: 156 + topInset,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Spacing.base,
        topInset + 14,
        Spacing.base,
        20,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.10),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ProfileHeaderSurface(identity: identity, onEditTap: onEditTap),
    );
  }
}
