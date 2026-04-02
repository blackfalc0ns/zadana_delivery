import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverUploadTile extends StatelessWidget {
  const DriverUploadTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.imagePath,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? imagePath;

  bool get _hasImage => (imagePath ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _hasImage
              ? color.secondary.withValues(alpha: 0.06)
              : color.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hasImage
                ? color.secondary.withValues(alpha: 0.22)
                : color.outline.withValues(alpha: 0.16),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: _hasImage
                    ? color.secondary.withValues(alpha: 0.14)
                    : color.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _hasImage
                  ? Image.file(File(imagePath!), fit: BoxFit.cover)
                  : Icon(
                      icon,
                      color: _hasImage ? color.secondary : color.primary,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
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
                      color: color.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Column(
              children: [
                Icon(
                  _hasImage
                      ? Icons.check_circle_rounded
                      : Icons.file_upload_outlined,
                  color: _hasImage
                      ? color.secondary
                      : color.onSurface.withValues(alpha: 0.55),
                ),
                const SizedBox(height: 6),
                Text(
                  _hasImage
                      ? context.localization.driver_upload_status_done
                      : context.localization.driver_upload_status_upload,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: _hasImage
                        ? color.secondary
                        : color.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
