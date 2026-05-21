import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class ProfileHeaderAvatarBadge extends StatelessWidget {
  const ProfileHeaderAvatarBadge({
    super.key,
    required this.letter,
    this.photoUrl = '',
  });

  final String letter;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;
    final normalizedPhotoUrl = photoUrl.trim();
    return Container(
      width: 68,
      height: 68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPrimary.withValues(alpha: 0.14),
        border: Border.all(
          color: onPrimary.withValues(alpha: 0.18),
          width: 1.2,
        ),
      ),
      child: ClipOval(
        child: normalizedPhotoUrl.startsWith('http://') ||
                normalizedPhotoUrl.startsWith('https://')
            ? Image.network(
                normalizedPhotoUrl,
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _AvatarLetter(
                  letter: letter,
                  color: onPrimary,
                ),
              )
            : _AvatarLetter(letter: letter, color: onPrimary),
      ),
    );
  }
}

class _AvatarLetter extends StatelessWidget {
  const _AvatarLetter({required this.letter, required this.color});

  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        letter,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 24,
          color: color,
        ),
      ),
    );
  }
}
