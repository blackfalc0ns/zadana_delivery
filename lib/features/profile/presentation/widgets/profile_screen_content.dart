import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/controllers/profile_screen_controller.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_data.dart';
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
    final colorScheme = context.colorScheme;
    final headerHeight = 156 + MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surface),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _ProfileHeaderDelegate(
              extent: headerHeight,
              data: controller.headerData,
              onEditTap: () => onActionTap(ProfileActionType.editProfile),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.base,
              Spacing.md,
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
      ),
    );
  }
}

class _ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _ProfileHeaderDelegate({
    required this.extent,
    required this.data,
    required this.onEditTap,
  });

  final double extent;
  final ProfileHeaderData data;
  final VoidCallback onEditTap;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ProfileHeaderCard(data: data, onEditTap: onEditTap);
  }

  @override
  bool shouldRebuild(covariant _ProfileHeaderDelegate oldDelegate) {
    return extent != oldDelegate.extent ||
        data != oldDelegate.data ||
        onEditTap != oldDelegate.onEditTap;
  }
}
