import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';

/// Displays the reason dropdown or appropriate loading/error states.
class OrderSupportReasonField extends StatelessWidget {
  const OrderSupportReasonField({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.reasons,
    required this.selectedReasonCode,
    required this.isSubmitting,
    required this.reasonLabelBuilder,
    required this.onChanged,
    required this.onRetry,
  });

  final bool isLoading;
  final String? errorMessage;
  final List<DriverSupportReasonEntity> reasons;
  final String? selectedReasonCode;
  final bool isSubmitting;
  final String Function(DriverSupportReasonEntity reason) reasonLabelBuilder;
  final ValueChanged<String?> onChanged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = context.localization;

    if (isLoading) {
      return Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        child: const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
      );
    }

    if ((errorMessage ?? '').trim().isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            errorMessage!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.error),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: isSubmitting ? null : onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(locale.retry),
            ),
          ),
        ],
      );
    }

    if (reasons.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        child: Text(
          locale.order_support_reasons_empty,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: selectedReasonCode,
      borderRadius: BorderRadius.circular(12),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: scheme.onSurfaceVariant,
        size: 18,
      ),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        labelText: locale.order_support_reason_label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: locale.order_support_reason_label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: reasons
          .map(
            (option) => DropdownMenuItem<String>(
              value: option.code,
              child: Text(
                reasonLabelBuilder(option),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(growable: false),
      onChanged: isSubmitting || reasons.isEmpty ? null : onChanged,
    );
  }
}
