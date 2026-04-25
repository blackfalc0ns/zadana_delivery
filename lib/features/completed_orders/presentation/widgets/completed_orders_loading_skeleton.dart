import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';

class CompletedOrdersLoadingSkeleton extends StatelessWidget {
  const CompletedOrdersLoadingSkeleton({super.key, this.cardCount = 4});

  final int cardCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SkeletonStateWidget(
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(child: _SummarySkeletonCard()),
              SizedBox(width: 8),
              Expanded(child: _SummarySkeletonCard()),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cardCount,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _OrderCardSkeleton(
                borderColor: scheme.outlineVariant.withValues(alpha: 0.35),
                fillColor: scheme.surface,
                mutedColor: scheme.outlineVariant.withValues(alpha: 0.18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummarySkeletonCard extends StatelessWidget {
  const _SummarySkeletonCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: .5,
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SkeletonBox(
              width: 56,
              height: 18,
              color: scheme.outlineVariant.withValues(alpha: 0.22),
            ),
            const SizedBox(height: 8),
            _SkeletonBox(
              width: 72,
              height: 12,
              color: scheme.outlineVariant.withValues(alpha: 0.18),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCardSkeleton extends StatelessWidget {
  const _OrderCardSkeleton({
    required this.borderColor,
    required this.fillColor,
    required this.mutedColor,
  });

  final Color borderColor;
  final Color fillColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: .5, color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _SkeletonBox(
                width: 48,
                height: 48,
                radius: 15,
                color: mutedColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(
                      width: double.infinity,
                      height: 16,
                      color: mutedColor,
                    ),
                    const SizedBox(height: 8),
                    _SkeletonBox(width: 90, height: 12, color: mutedColor),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _SkeletonBox(
                width: 74,
                height: 28,
                radius: 14,
                color: mutedColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: mutedColor),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: index == 2 ? 0 : 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(width: 56, height: 10, color: mutedColor),
                      const SizedBox(height: 8),
                      _SkeletonBox(
                        width: index == 1 ? 78 : double.infinity,
                        height: 13,
                        color: mutedColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: _SkeletonBox(width: 110, height: 10, color: mutedColor),
          ),
        ],
      ),
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
