import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverSupportCasesLoadingView extends StatelessWidget {
  const DriverSupportCasesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return SkeletonStateWidget(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SkeletonBox(
            height: 118,
            borderRadius: 28,
            color: scheme.outlineVariant.withValues(alpha: 0.16),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < 4; i++) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: scheme.outlineVariant.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SkeletonBox(
                          height: 20,
                          borderRadius: 12,
                          color: scheme.surface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _SkeletonBox(
                        width: 84,
                        height: 30,
                        borderRadius: 999,
                        color: scheme.surface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _SkeletonBox(
                    height: 72,
                    borderRadius: 20,
                    color: scheme.surface,
                  ),
                  const SizedBox(height: 12),
                  _SkeletonBox(
                    width: 170,
                    height: 14,
                    borderRadius: 10,
                    color: scheme.surface,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.width = double.infinity,
    required this.height,
    required this.borderRadius,
    required this.color,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
