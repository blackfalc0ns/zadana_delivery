import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_tile.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_page_header_card.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_section_card.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(title: locale.profile_edit_profile_title),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.base),
        children: [
          ProfilePageHeaderCard(
            title: locale.profile_edit_profile_title,
            subtitle: locale.profile_edit_profile_subtitle,
            icon: Icons.edit_note_rounded,
            colorToken: ProfileColorToken.primary,
          ),
          const SizedBox(height: Spacing.base),
          ProfileSectionCard(
            children: [
              ProfileActionTile(
                title: locale.personal_info,
                subtitle: locale.driver_profile_identity_card_subtitle,
                icon: Icons.person_outline_rounded,
                iconColor: color.primary,
                onTap: () => context.pushNamed(AppRoutes.profilePersonalInfo),
              ),
              ProfileActionTile(
                title: locale.driver_profile_vehicle_card_title,
                subtitle: locale.driver_profile_vehicle_card_subtitle,
                icon: Icons.two_wheeler_outlined,
                iconColor: color.secondary,
                onTap: () => context.pushNamed(AppRoutes.profileVehicleInfo),
              ),
              ProfileActionTile(
                title: locale.profile_security_documents_title,
                subtitle: locale.driver_profile_uploads_card_subtitle,
                icon: Icons.verified_user_outlined,
                iconColor: color.tertiary,
                onTap: () =>
                    context.pushNamed(AppRoutes.profileSecurityDocuments),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
