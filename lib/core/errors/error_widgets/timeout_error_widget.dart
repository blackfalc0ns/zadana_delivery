import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

import 'base_error_widget.dart';

class TimeoutErrorWidget extends BaseErrorWidget {
  const TimeoutErrorWidget({
    super.key,
    required this.timeoutType,
    super.onRetry,
  }) : super(
         title: '',
         description: '',
         icon: Icons.access_time,
         primaryColor: Colors.amber,
       );

  final ApiErrorType timeoutType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    String title;
    String description;

    switch (timeoutType) {
      case ApiErrorType.connectionTimeout:
        title = l10n.error_connection_timeout;
        description = l10n.error_connection_timeout_desc;
        break;
      case ApiErrorType.receiveTimeout:
        title = l10n.error_receive_timeout;
        description = l10n.error_receive_timeout_desc;
        break;
      case ApiErrorType.sendTimeout:
        title = l10n.error_send_timeout;
        description = l10n.error_send_timeout_desc;
        break;
      case ApiErrorType.requestTimeout:
        title = l10n.error_request_timeout;
        description = l10n.error_request_timeout_desc;
        break;
      default:
        title = l10n.error_connection_timeout;
        description = l10n.error_connection_timeout_desc;
    }

    return BaseErrorWidget(
      title: title,
      description: description,
      icon: Icons.access_time,
      onRetry: onRetry,
      primaryColor: Colors.amber,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return context.localization.retry;
  }
}
