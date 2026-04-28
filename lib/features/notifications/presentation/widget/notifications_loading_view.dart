import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';

class NotificationsLoadingView extends StatelessWidget {
  const NotificationsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mutedColor = scheme.outlineVariant.withValues(alpha: 0.18);

    return SkeletonStateWidget(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          Spacing.base,
          Spacing.base,
          Spacing.base,
          Spacing.xl,
        ),
        children: [
          _LoadingCard(
            height: 92,
            radius: 24,
            child: Row(
              children: [
                _SkeletonBox(
                  width: 52,
                  height: 52,
                  radius: 16,
                  color: mutedColor,
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SkeletonBox(width: 160, height: 16, color: mutedColor),
                      const SizedBox(height: Spacing.sm),
                      _SkeletonBox(
                        width: double.infinity,
                        height: 12,
                        color: mutedColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          ...List.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: _LoadingCard(
                height: 152,
                radius: 22,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(
                      width: 52,
                      height: 52,
                      radius: 18,
                      color: mutedColor,
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _SkeletonBox(
                                  width: double.infinity,
                                  height: 16,
                                  color: mutedColor,
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              _SkeletonBox(
                                width: 10,
                                height: 10,
                                radius: 999,
                                color: mutedColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.sm),
                          _SkeletonBox(
                            width: double.infinity,
                            height: 12,
                            color: mutedColor,
                          ),
                          const SizedBox(height: Spacing.xs),
                          _SkeletonBox(
                            width: 220,
                            height: 12,
                            color: mutedColor,
                          ),
                          const SizedBox(height: Spacing.base),
                          _SkeletonBox(
                            width: 110,
                            height: 12,
                            color: mutedColor,
                          ),
                          const SizedBox(height: Spacing.sm),
                          _SkeletonBox(
                            width: 130,
                            height: 32,
                            radius: 999,
                            color: mutedColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({
    required this.height,
    required this.radius,
    required this.child,
  });

  final double height;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
    this.radius = 12,
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
