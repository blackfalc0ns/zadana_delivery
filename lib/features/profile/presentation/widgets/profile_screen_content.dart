import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/features/profile/presentation/controllers/profile_screen_controller.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_item_builder.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_sections_list.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({
    super.key,
    required this.controller,
    required this.onActionTap,
  });

  final ProfileScreenController controller;
  final ValueChanged<ProfileActionType> onActionTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: ProfileHeaderCard(
            data: controller.headerData,
            onEditTap: () => onActionTap(ProfileActionType.editProfile),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.base,
            Spacing.base,
            Spacing.base,
            Spacing.xl,
          ),
          sliver: SliverToBoxAdapter(
            child: ProfileSectionsList(
              sections: controller.sections,
              itemBuilder: (item) => ProfileActionItemBuilder(
                item: item,
                notificationsEnabled: controller.notificationsEnabled,
                isLoggingOut: controller.isLoggingOut,
                onNotificationsChanged: controller.updateNotifications,
                onActionTap: onActionTap,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
