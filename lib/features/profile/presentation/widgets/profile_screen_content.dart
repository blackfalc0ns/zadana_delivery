import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_state.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_view_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_identity.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_item_builder.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_document_status_banner.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_rejection_policy_card.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_sections_list.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({
    super.key,
    required this.state,
    required this.onActionTap,
    required this.onNotificationsChanged,
    required this.onOverlayChanged,
    required this.overlayEnabled,
    this.onRefresh,
  });

  final ProfileState state;
  final ValueChanged<ProfileActionType> onActionTap;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onOverlayChanged;
  final bool overlayEnabled;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final headerIdentity = _resolveHeaderIdentity(locale);
    final headerHeight = 140 + MediaQuery.paddingOf(context).top;
    final profile = state.profile;

    return DecoratedBox(
      decoration: BoxDecoration(color: color.surface),
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        edgeOffset: headerHeight,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _ProfileHeaderDelegate(
                extent: headerHeight,
                identity: headerIdentity,
                onEditTap: () => onActionTap(ProfileActionType.personalInfo),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.base,
                Spacing.sm,
                Spacing.base,
                Spacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (profile != null) ...[
                      const SizedBox(height: 1),
                      ProfileDocumentStatusBanner(
                        documents: profile.documents,
                        onTap: () => onActionTap(ProfileActionType.documents),
                      ),
                      const SizedBox(height: Spacing.sm),
                      ProfileRejectionPolicyCard(
                        policy: profile.rejectionPolicy,
                      ),
                      const SizedBox(height: Spacing.base),
                    ],
                    ProfileSectionsList(
                      sections: _buildSections(locale, color),
                      itemBuilder: (item) => ProfileActionItemBuilder(
                        item: item,
                        onNotificationsChanged: onNotificationsChanged,
                        onOverlayChanged: onOverlayChanged,
                        onActionTap: onActionTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ProfileHeaderIdentity _resolveHeaderIdentity(AppLocalizations locale) {
    final profile = state.profile;
    final fullName = _resolveValue(
      profile?.fullName ?? '',
      locale.profile_default_name,
    );
    final email = _resolveValue(
      profile?.email ?? '',
      locale.profile_default_email,
    );
    final phone = _resolveValue(
      profile?.phone ?? '',
      locale.profile_default_phone,
    );

    return ProfileHeaderIdentity(
      fullName: fullName,
      email: email,
      phone: phone,
      avatarLetter: fullName.substring(0, 1).toUpperCase(),
      photoUrl: profile?.personalPhotoUrl.trim() ?? '',
    );
  }

  List<ProfileSectionViewData> _buildSections(
    AppLocalizations locale,
    ColorScheme colorScheme,
  ) {
    final sections = [
      const ProfileSectionData(
        items: [
          ProfileActionItemData(
            icon: Icons.person_outline_rounded,
            colorToken: ProfileColorToken.primary,
            type: ProfileActionType.personalInfo,
          ),
          ProfileActionItemData(
            icon: Icons.two_wheeler_outlined,
            colorToken: ProfileColorToken.secondary,
            type: ProfileActionType.vehicleInfo,
          ),
          ProfileActionItemData(
            icon: Icons.verified_user_outlined,
            colorToken: ProfileColorToken.tertiary,
            type: ProfileActionType.documents,
          ),
          ProfileActionItemData(
            icon: Icons.receipt_long_outlined,
            colorToken: ProfileColorToken.tertiary,
            type: ProfileActionType.orders,
          ),
        ],
      ),
      const ProfileSectionData(
        items: [
          ProfileActionItemData(
            icon: Icons.language_rounded,
            colorToken: ProfileColorToken.tertiary,
            type: ProfileActionType.language,
          ),
          ProfileActionItemData(
            icon: Icons.notifications_none_rounded,
            colorToken: ProfileColorToken.primary,
            type: ProfileActionType.notifications,
          ),
          ProfileActionItemData(
            icon: Icons.layers_outlined,
            colorToken: ProfileColorToken.secondary,
            type: ProfileActionType.overlayPermission,
          ),
          ProfileActionItemData(
            icon: Icons.lock_outline_rounded,
            colorToken: ProfileColorToken.secondary,
            type: ProfileActionType.security,
          ),
        ],
      ),
      const ProfileSectionData(
        items: [
          ProfileActionItemData(
            icon: Icons.support_agent_rounded,
            colorToken: ProfileColorToken.primary,
            type: ProfileActionType.support,
          ),
          ProfileActionItemData(
            icon: Icons.privacy_tip_outlined,
            colorToken: ProfileColorToken.tertiary,
            type: ProfileActionType.privacy,
          ),
        ],
      ),
      const ProfileSectionData(
        items: [
          ProfileActionItemData(
            icon: Icons.logout_rounded,
            colorToken: ProfileColorToken.error,
            type: ProfileActionType.logout,
            isDestructive: true,
          ),
        ],
      ),
    ];

    return sections
        .map(
          (section) => ProfileSectionViewData(
            items: section.items.map((item) {
              final copy = item.type.localizedCopy(locale);
              return ProfileActionViewData(
                type: item.type,
                title: copy.$1,
                subtitle: copy.$2,
                icon: item.icon,
                iconColor: item.colorToken.resolveColor(colorScheme),
                isDestructive: item.isDestructive,
                isLoading: false,
                isNotificationTile:
                    item.type == ProfileActionType.notifications,
                notificationsEnabled: state.notificationsEnabled,
                isOverlayTile:
                    item.type == ProfileActionType.overlayPermission,
                overlayEnabled: overlayEnabled,
              );
            }).toList(),
          ),
        )
        .toList();
  }

  static String _resolveValue(String value, String fallback) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return fallback;
    return trimmed;
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
