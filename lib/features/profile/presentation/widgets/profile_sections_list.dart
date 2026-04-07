import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_section_card.dart';

class ProfileSectionsList extends StatelessWidget {
  const ProfileSectionsList({
    super.key,
    required this.sections,
    required this.itemBuilder,
  });

  final List<ProfileSectionData> sections;
  final Widget Function(ProfileActionItemData item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < sections.length; index++) ...[
          ProfileSectionCard(
            children: sections[index].items.map(itemBuilder).toList(),
          ),
          if (index < sections.length - 1) const SizedBox(height: Spacing.base),
        ],
      ],
    );
  }
}
