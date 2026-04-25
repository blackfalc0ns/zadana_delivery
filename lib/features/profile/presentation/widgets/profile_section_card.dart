import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          width: 0.6,
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: _withDividers(context)),
    );
  }

  List<Widget> _withDividers(BuildContext context) {
    final color = context.colorScheme.outlineVariant.withValues(alpha: 0.55);
    final items = <Widget>[];

    for (var index = 0; index < children.length; index++) {
      items.add(children[index]);
      if (index < children.length - 1) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
            child: Divider(height: 1, thickness: 1, color: color),
          ),
        );
      }
    }

    return items;
  }
}
