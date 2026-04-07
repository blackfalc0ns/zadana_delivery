import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/controllers/profile_screen_controller.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_identity.dart';
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
    final locale = context.localization;
    final color = context.colorScheme;
    final headerIdentity = controller.resolveHeaderIdentity(locale);
    final headerHeight = 156 + MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: BoxDecoration(color: color.surface),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _ProfileHeaderDelegate(
              extent: headerHeight,
              identity: headerIdentity,
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
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) => ProfileSectionsList(
                  sections: controller.buildSectionViewData(
                    locale: locale,
                    colorScheme: color,
                  ),
                  itemBuilder: (item) => ProfileActionItemBuilder(
                    item: item,
                    onNotificationsChanged: controller.updateNotifications,
                    onActionTap: onActionTap,
                  ),
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
    required this.identity,
    required this.onEditTap,
  });

  final double extent;
  final ProfileHeaderIdentity identity;
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
    return ProfileHeaderCard(identity: identity, onEditTap: onEditTap);
  }

  @override
  bool shouldRebuild(covariant _ProfileHeaderDelegate oldDelegate) {
    return extent != oldDelegate.extent ||
        identity != oldDelegate.identity ||
        onEditTap != oldDelegate.onEditTap;
  }
}
