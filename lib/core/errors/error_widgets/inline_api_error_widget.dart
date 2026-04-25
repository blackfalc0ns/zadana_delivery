import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/text_styles.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/failures.dart';

class InlineApiErrorWidget extends StatelessWidget {
  const InlineApiErrorWidget({super.key, required this.failure, this.onRetry});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = _resolveScheme(context, failure.code);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: scheme.softColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(scheme.icon, color: scheme.accentColor, size: 20),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    scheme.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (onRetry != null)
                OutlinedButton.icon(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 34),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    side: BorderSide(color: scheme.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: scheme.accentColor,
                  ),
                  label: Text(
                    context.localization.retry,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            failure.errorMessage,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  _InlineErrorScheme _resolveScheme(BuildContext context, String code) {
    final l10n = context.localization;

    switch (code.trim().toLowerCase()) {
      case 'error_no_internet':
      case 'connection_error':
        return _InlineErrorScheme(
          title: l10n.error_no_internet_connection,
          icon: Icons.wifi_off_rounded,
          accentColor: const Color(0xFFE68A00),
          softColor: const Color(0xFFFFF7EB),
          borderColor: const Color(0xFFFFE1B5),
        );
      case 'error_connection_timeout':
      case 'error_send_timeout':
      case 'error_receive_timeout':
      case 'connection_timeout':
      case 'send_timeout':
      case 'receive_timeout':
        return _InlineErrorScheme(
          title: l10n.error_connection_timeout,
          icon: Icons.schedule_rounded,
          accentColor: const Color(0xFFE68A00),
          softColor: const Color(0xFFFFF7EB),
          borderColor: const Color(0xFFFFE1B5),
        );
      default:
        return _InlineErrorScheme(
          title: l10n.error_unknown,
          icon: Icons.error_outline_rounded,
          accentColor: AppColors.error,
          softColor: AppColors.errorLight,
          borderColor: const Color(0xFFF1D0D5),
        );
    }
  }
}

class _InlineErrorScheme {
  const _InlineErrorScheme({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.softColor,
    required this.borderColor,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final Color softColor;
  final Color borderColor;
}
