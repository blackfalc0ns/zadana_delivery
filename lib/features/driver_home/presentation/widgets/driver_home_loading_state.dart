import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';

class DriverHomeLoadingState extends StatelessWidget {
  const DriverHomeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: const Center(child: CustomProgressIndicator()),
    );
  }
}
