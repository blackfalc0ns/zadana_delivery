import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class ProfileScreenLoadingSkeleton extends StatelessWidget {
  const ProfileScreenLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: color.surface,
      body: SkeletonStateWidget(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 156 + topPadding,
                padding: EdgeInsets.fromLTRB(
                  Spacing.base,
                  topPadding + 20,
                  Spacing.base,
                  Spacing.base,
                ),
                decoration: BoxDecoration(
                  color: color.outlineVariant.withValues(alpha: 0.22),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Row(
                  children: [
                    _ShimmerBox(
                      width: 72,
                      height: 72,
                      borderRadius: 36,
                      color: color.surface,
                    ),
                    const SizedBox(width: Spacing.base),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBox(
                            width: double.infinity,
                            height: 18,
                            color: color.surface,
                          ),
                          const SizedBox(height: Spacing.sm),
                          _ShimmerBox(
                            width: 220,
                            height: 14,
                            color: color.surface,
                          ),
                          const SizedBox(height: 10),
                          _ShimmerBox(
                            width: 160,
                            height: 14,
                            color: color.surface,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(Spacing.base),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _ProfileCardSkeleton(height: 144),
                    SizedBox(height: Spacing.md),
                    _ProfileCardSkeleton(height: 132),
                    SizedBox(height: Spacing.md),
                    _ProfileActionSectionSkeleton(itemCount: 4),
                    SizedBox(height: Spacing.md),
                    _ProfileActionSectionSkeleton(itemCount: 3),
                    SizedBox(height: Spacing.md),
                    _ProfileActionSectionSkeleton(itemCount: 2),
                    SizedBox(height: Spacing.md),
                    _ProfileActionSectionSkeleton(itemCount: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFormLoadingSkeleton extends StatelessWidget {
  const ProfileFormLoadingSkeleton({
    super.key,
    required this.title,
    this.fieldCount = 4,
    this.includeSelector = false,
    this.includeDocumentGrid = false,
  });

  final String title;
  final int fieldCount;
  final bool includeSelector;
  final bool includeDocumentGrid;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar.modern(title: title, backgroundColor: color.surface),
      body: SkeletonStateWidget(
        child: ListView(
          padding: const EdgeInsets.all(Spacing.base),
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.base),
              decoration: BoxDecoration(
                color: color.outlineVariant.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _ShimmerBox(
                    width: 52,
                    height: 52,
                    borderRadius: 18,
                    color: color.surface,
                  ),
                  const SizedBox(width: Spacing.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(
                          width: double.infinity,
                          height: 16,
                          color: color.surface,
                        ),
                        const SizedBox(height: Spacing.sm),
                        _ShimmerBox(
                          width: 220,
                          height: 12,
                          color: color.surface,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.base),
            if (includeSelector) ...[
              const _ProfileCardSkeleton(height: 84),
              const SizedBox(height: Spacing.md),
            ],
            if (includeDocumentGrid) ...[
              Wrap(
                spacing: Spacing.sm,
                runSpacing: Spacing.sm,
                children: List.generate(
                  4,
                  (_) => _ShimmerBox(
                    width: (MediaQuery.sizeOf(context).width - 48) / 2,
                    height: 126,
                    borderRadius: 22,
                    color: color.outlineVariant.withValues(alpha: 0.2),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.base),
            ] else ...[
              for (var i = 0; i < fieldCount; i++) ...[
                const _FieldSkeleton(),
                if (i != fieldCount - 1) const SizedBox(height: Spacing.md),
              ],
            ],
            const SizedBox(height: Spacing.lg),
            _ShimmerBox(
              width: double.infinity,
              height: 52,
              borderRadius: 18,
              color: color.outlineVariant.withValues(alpha: 0.24),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCardSkeleton extends StatelessWidget {
  const _ProfileCardSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color.outlineVariant.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class _ProfileActionSectionSkeleton extends StatelessWidget {
  const _ProfileActionSectionSkeleton({required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.outlineVariant.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 10),
            child: Row(
              children: [
                _ShimmerBox(
                  width: 44,
                  height: 44,
                  borderRadius: 16,
                  color: color.surface,
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(
                        width: double.infinity,
                        height: 14,
                        color: color.surface,
                      ),
                      const SizedBox(height: 8),
                      _ShimmerBox(width: 180, height: 12, color: color.surface),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _FieldSkeleton extends StatelessWidget {
  const _FieldSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShimmerBox(width: 120, height: 12, color: color.outlineVariant),
        const SizedBox(height: Spacing.sm),
        _ShimmerBox(
          width: double.infinity,
          height: 56,
          borderRadius: 18,
          color: color.outlineVariant.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = 14,
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
