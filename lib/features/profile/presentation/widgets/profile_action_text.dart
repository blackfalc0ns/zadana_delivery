import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class ProfileActionText extends StatelessWidget {
  const ProfileActionText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDestructive,
  });

  final String title;
  final String subtitle;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: isDestructive ? colorScheme.error : colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size11,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
