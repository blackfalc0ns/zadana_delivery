import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';

class PublicContentShimmer extends StatelessWidget {
  const PublicContentShimmer({super.key, this.rows = 4});
  final int rows;
  @override
  Widget build(BuildContext context) => SkeletonStateWidget(
    child: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: rows,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => Container(
        height: index == 0 ? 110 : 72,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
