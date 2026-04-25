import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';

class BaseErrorWidget extends StatelessWidget {
  const BaseErrorWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onRetry,
    this.onSecondaryAction,
    this.secondaryActionText,
    this.primaryColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionText;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final hasPrimaryAction = onRetry != null;
    final hasSecondaryAction =
        onSecondaryAction != null &&
        secondaryActionText != null &&
        secondaryActionText!.isNotEmpty;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (primaryColor ?? colorScheme.error).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: primaryColor ?? colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (hasPrimaryAction) ...[
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: onRetry,
                    text: getRetryButtonText(context),
                  ),
                ),
              ],
              if (hasSecondaryAction) ...[
                SizedBox(height: hasPrimaryAction ? 12 : 0),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: onSecondaryAction,
                    text: secondaryActionText!,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String getRetryButtonText(BuildContext context) {
    return context.localization.retry;
  }
}
