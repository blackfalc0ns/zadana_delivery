import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DeliveryStatusCard extends StatelessWidget {
  const DeliveryStatusCard({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final steps = [
      (locale.order_details_status_accepted, Icons.check_circle_rounded),
      (
        locale.order_details_arrived_at_vendor,
        Icons.store_mall_directory_rounded,
      ),
      (locale.order_details_status_picked_up, Icons.storefront_rounded),
      (locale.order_details_status_on_the_way, Icons.delivery_dining_rounded),
      (locale.order_details_status_delivered, Icons.home_rounded),
    ];
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.16),
          width: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: 104,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              return _StatusConnector(isComplete: activeIndex > index ~/ 2);
            }
            final stepIndex = index ~/ 2;
            return _StatusStep(
              step: steps[stepIndex],
              isDone: stepIndex <= activeIndex,
              isCurrent: stepIndex == activeIndex,
            );
          }),
        ),
      ),
    );
  }
}

class _StatusConnector extends StatelessWidget {
  const _StatusConnector({required this.isComplete});

  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Container(
          height: 3,
          decoration: BoxDecoration(
            color: isComplete
                ? AppColors.secondary
                : colorScheme.outlineVariant.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  const _StatusStep({
    required this.step,
    required this.isDone,
    required this.isCurrent,
  });

  final (String, IconData) step;
  final bool isDone;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final stepColor = isCurrent || isDone
        ? AppColors.secondary
        : colorScheme.outlineVariant;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDone
                  ? stepColor
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone ? Colors.transparent : stepColor,
              ),
            ),
            child: Icon(
              step.$2,
              color: isDone ? Colors.white : colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Center(
              child: Text(
                step.$1,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: isDone
                      ? AppColors.secondary
                      : colorScheme.onSurfaceVariant,
                ).copyWith(height: 1.25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
