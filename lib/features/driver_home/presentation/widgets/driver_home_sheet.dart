import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverHomeSheet extends StatelessWidget {
  const DriverHomeSheet({
    super.key,
    required this.child,
    required this.initiallyExpanded,
  });

  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initiallyExpanded ? 0.34 : 0.28,
      minChildSize: 0.18,
      maxChildSize: 0.80,
      builder: (context, scrollController) {
        final color = context.colorScheme;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.surface, color.surfaceContainerLowest],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 28,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              Spacing.base,
              Spacing.sm,
              Spacing.base,
              Spacing.base,
            ),
            children: [
              Center(
                child: Container(
                  width: 52,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: Spacing.base),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.primary.withValues(alpha: 0.18),
                        color.primary.withValues(alpha: 0.34),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}
