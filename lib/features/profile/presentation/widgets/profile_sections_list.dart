import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_view_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_section_card.dart';

class ProfileSectionsList extends StatelessWidget {
  const ProfileSectionsList({
    super.key,
    required this.sections,
    required this.itemBuilder,
  });

  final List<ProfileSectionViewData> sections;
  final Widget Function(ProfileActionViewData item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < sections.length; index++) ...[
          ProfileSectionCard(
            children: _buildSectionItems(sections[index]),
          ),
          if (index < sections.length - 1)
            const SizedBox(height: Spacing.md + 2),
        ],
      ],
    );
  }

  List<Widget> _buildSectionItems(ProfileSectionViewData section) {
    return [for (final item in section.items) itemBuilder(item)];
  }
}
