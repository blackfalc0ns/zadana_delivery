import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

import 'base_error_widget.dart';

class NoInternetErrorWidget extends BaseErrorWidget {
  const NoInternetErrorWidget({super.key, super.onRetry})
    : super(
        title: '',
        description: '',
        icon: Icons.wifi_off,
        primaryColor: Colors.orange,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return BaseErrorWidget(
      title: l10n.error_no_internet_connection,
      description: l10n.error_no_internet_connection_desc,
      icon: Icons.wifi_off,
      onRetry: onRetry,
      primaryColor: Colors.orange,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return context.localization.retry;
  }
}
