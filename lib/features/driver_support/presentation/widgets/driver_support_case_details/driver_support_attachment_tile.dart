import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverSupportAttachmentTile extends StatelessWidget {
  const DriverSupportAttachmentTile({
    super.key,
    required this.fileName,
    required this.onTap,
  });

  final String fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.insert_drive_file_outlined, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  fileName.trim().isEmpty
                      ? locale.driver_support_attachment
                      : fileName.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.open_in_new_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
