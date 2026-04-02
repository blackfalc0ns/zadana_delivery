import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverProfileReviewList extends StatelessWidget {
  const DriverProfileReviewList({super.key, required this.items});

  final List<({String label, String value})> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.35),
                    ),
                  ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.value.trim().isEmpty
                      ? context.localization.driver_profile_incomplete
                      : item.value,
                  textAlign: TextAlign.end,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
