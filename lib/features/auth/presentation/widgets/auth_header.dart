import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.caption,
  });

  final String title;
  final String subtitle;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final headerCaption = caption ?? 'منصة التوصيل';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.primary.withValues(alpha: 0.96),
            color.primary,
            color.secondary.withValues(alpha: 0.88),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: color.onPrimary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  headerCaption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: color.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 100,
                height: 50,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.onPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(Assets.logoDark, fit: BoxFit.contain),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: color.onPrimary,
            ).copyWith(height: 1.1),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: color.onPrimary.withValues(alpha: 0.88),
            ).copyWith(height: 1.2),
          ),
        ],
      ),
    );
  }
}

