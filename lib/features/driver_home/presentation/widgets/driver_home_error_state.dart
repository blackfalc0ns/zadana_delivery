import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverHomeErrorState extends StatelessWidget {
  const DriverHomeErrorState({
    super.key,
    required this.exception,
    required this.onRetry,
    required this.onGoBack,
  });

  final ApiException exception;
  final VoidCallback onRetry;
  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: ApiErrorWidget(
          exception: exception,
          onRetry: onRetry,
          onGoBack: onGoBack,
        ),
      ),
    );
  }
}
