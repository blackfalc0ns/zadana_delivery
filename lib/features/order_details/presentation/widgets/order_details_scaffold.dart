import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class OrderDetailsScaffold extends StatelessWidget {
  const OrderDetailsScaffold({
    super.key,
    required this.onBack,
    required this.bottomActions,
    required this.child,
    this.actions,
  });

  final VoidCallback onBack;
  final Widget bottomActions;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar.modern(
        title: locale.order_details_title,
        backgroundColor: color.surface,
        onBackPressed: onBack,
        actions: actions,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          decoration: BoxDecoration(
            color: color.surfaceContainerLow,
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: bottomActions,
        ),
      ),
      body: child,
    );
  }
}
