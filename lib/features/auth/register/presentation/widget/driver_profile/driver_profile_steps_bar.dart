import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverProfileStepsBar extends StatelessWidget {
  const DriverProfileStepsBar({
    super.key,
    required this.titles,
    required this.currentStep,
  });

  final List<String> titles;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / titles.length;
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                context.localization.driver_profile_steps_progress,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.primary.withValues(alpha: 0.10),
            valueColor: AlwaysStoppedAnimation(color.primary),
            borderRadius: BorderRadius.circular(99),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(titles.length, (index) {
              final isActive = index == currentStep;
              final isDone = index < currentStep;

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isDone || isActive
                            ? color.primary
                            : color.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: isDone || isActive
                            ? null
                            : Border.all(
                                color: color.outlineVariant.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                      ),
                      child: Center(
                        child: isDone
                            ? Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: color.onPrimary,
                              )
                            : Text(
                                '${index + 1}',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  color: isActive || isDone
                                      ? color.onPrimary
                                      : color.onSurfaceVariant,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: isActive || isDone
                            ? color.onSurface
                            : color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
