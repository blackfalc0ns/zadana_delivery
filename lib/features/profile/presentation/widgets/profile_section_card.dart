import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(width: .5,
          color: colorScheme.outlineVariant),
        // boxShadow: [
        //   BoxShadow(
        //     color: colorScheme.shadow.withValues(alpha: 0.03),
        //     blurRadius: 16,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),
      child: Column(children: children),
    );
  }
}
