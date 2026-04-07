import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class ProfileHeaderAvatarBadge extends StatelessWidget {
  const ProfileHeaderAvatarBadge({super.key, required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;
    return Container(
      width: 62,
      height: 62,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPrimary.withValues(alpha: 0.14),
        border: Border.all(color: onPrimary.withValues(alpha: 0.18)),
      ),
      child: Text(
        letter,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 22,
          color: onPrimary,
        ),
      ),
    );
  }
}
