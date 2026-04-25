import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

import 'base_error_widget.dart';

class GenericErrorWidget extends BaseErrorWidget {
  const GenericErrorWidget({
    super.key,
    required this.errorType,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onGoBack,
  }) : super(
         title: '',
         description: '',
         icon: Icons.error,
         onSecondaryAction: onGoBack,
         secondaryActionText: '',
       );

  final ApiErrorType errorType;
  final String? serverMessage;

  bool _isTechnicalMessage(String? message) {
    if (message == null || message.isEmpty) return true;

    final technicalPatterns = [
      'sql',
      'mysql',
      'database',
      'exception',
      'error:',
      'stack',
      'trace',
      'file:',
      '/tmp/',
      'errcode',
      'connection:',
      'select ',
      'insert ',
      'update ',
      'delete ',
      'from ',
      'where ',
      '.php',
      '.dart',
      'laravel',
      'eloquent',
      'null and',
      'is null',
      'sqlstate',
      'pdo',
      'query',
    ];

    final lowerMessage = message.toLowerCase();
    return technicalPatterns.any(lowerMessage.contains);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    String title;
    String description;
    IconData iconData = Icons.error;
    Color color = Colors.red;

    switch (errorType) {
      case ApiErrorType.locationServiceDisabled:
        title = l10n.location_service_disabled;
        description = l10n.location_service_disabled_message;
        iconData = Icons.location_off_rounded;
        break;
      case ApiErrorType.locationPermissionDenied:
        title = l10n.location_permission_denied;
        description = l10n.location_permission_denied_message;
        iconData = Icons.location_disabled_rounded;
        break;
      case ApiErrorType.locationPermissionDeniedForever:
        title = l10n.location_permission_denied_forever;
        description = l10n.location_permission_denied_forever_message;
        iconData = Icons.location_off_outlined;
        break;
      case ApiErrorType.cancelled:
        title = l10n.error_cancelled;
        description = l10n.error_cancelled_desc;
        iconData = Icons.cancel;
        color = Colors.grey;
        break;
      case ApiErrorType.unknown:
        title = l10n.error_unknown;
        description = l10n.error_unknown_desc;
        iconData = Icons.help_outline;
        color = Colors.grey;
        break;
      case ApiErrorType.other:
        title = l10n.error_other;
        description = l10n.error_other_desc;
        iconData = Icons.error_outline;
        break;
      default:
        title = l10n.error_unknown;
        description = l10n.error_unknown_desc;
        iconData = Icons.help_outline;
        color = Colors.grey;
    }

    final finalDescription =
        (serverMessage != null &&
            serverMessage!.isNotEmpty &&
            !_isTechnicalMessage(serverMessage) &&
            serverMessage!.length < 150)
        ? serverMessage!
        : description;

    return BaseErrorWidget(
      title: title,
      description: finalDescription,
      icon: iconData,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: onSecondaryAction == null ? null : l10n.go_back,
      primaryColor: color,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return context.localization.retry;
  }
}
