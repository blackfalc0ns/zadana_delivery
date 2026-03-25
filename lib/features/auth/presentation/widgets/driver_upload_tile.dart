import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    this.image,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final XFile? image;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(Spacing.sm + 2),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.outline.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: image != null
                    ? color.secondary.withValues(alpha: 0.12)
                    : color.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: image != null ? color.secondary : color.primary,
              ),
            ),
            const SizedBox(width: 10),
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
            Icon(
              image != null
                  ? Icons.check_circle_rounded
                  : Icons.file_upload_outlined,
              color: image != null
                  ? color.secondary
                  : color.onSurface.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }
}
