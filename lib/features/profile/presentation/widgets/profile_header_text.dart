import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_header_identity.dart';

class ProfileHeaderText extends StatelessWidget {
  const ProfileHeaderText({
    super.key,
    required this.identity,
    required this.onEditTap,
  });

  final ProfileHeaderIdentity identity;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                identity.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: onEditTap,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: onPrimary.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit_outlined, color: onPrimary, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        _HeaderMetaText(value: identity.email, alpha: 0.92),
        const SizedBox(height: 2),
        _HeaderMetaText(value: identity.phone, alpha: 0.78),
      ],
    );
  }
}

class _HeaderMetaText extends StatelessWidget {
  const _HeaderMetaText({required this.value, required this.alpha});

  final String value;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: getRegularStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size10,
        color: context.colorScheme.onPrimary.withValues(alpha: alpha),
      ),
    );
  }
}
