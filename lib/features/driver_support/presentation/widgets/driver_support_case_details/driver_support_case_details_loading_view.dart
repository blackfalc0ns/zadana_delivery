import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverSupportCaseDetailsLoadingView extends StatelessWidget {
  const DriverSupportCaseDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return SkeletonStateWidget(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
        children: [
          _SkeletonBox(
            height: 158,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.16),
          ),
          const SizedBox(height: 10),
          _SkeletonBox(
            height: 104,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 10),
          _SkeletonBox(
            height: 128,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 10),
          _SkeletonBox(
            height: 198,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.12),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.borderRadius,
    required this.color,
  });

  final double height;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
