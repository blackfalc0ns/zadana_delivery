import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

import 'base_error_widget.dart';

class ServerErrorWidget extends BaseErrorWidget {
  const ServerErrorWidget({
    super.key,
    required this.serverErrorType,
    this.statusCode,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onContactSupport,
  }) : super(
         title: '',
         description: '',
         icon: Icons.error_outline,
         onSecondaryAction: onContactSupport,
         secondaryActionText: '',
         primaryColor: Colors.red,
       );

  final ApiErrorType serverErrorType;
  final int? statusCode;
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
    IconData iconData = Icons.error_outline;

    switch (serverErrorType) {
      case ApiErrorType.internalServerError:
        title = l10n.error_internal_server_error;
        description = l10n.error_internal_server_error_desc;
        iconData = Icons.dns;
        break;
      case ApiErrorType.badGateway:
        title = l10n.error_bad_gateway;
        description = l10n.error_bad_gateway_desc;
        iconData = Icons.router;
        break;
      case ApiErrorType.serviceUnavailable:
        title = l10n.error_service_unavailable;
        description = l10n.error_service_unavailable_desc;
        iconData = Icons.cloud_off;
        break;
      case ApiErrorType.gatewayTimeout:
        title = l10n.error_gateway_timeout;
        description = l10n.error_gateway_timeout_desc;
        iconData = Icons.access_time;
        break;
      default:
        title = l10n.error_server_error;
        description = l10n.error_server_error_desc;
        iconData = Icons.error_outline;
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
      secondaryActionText: l10n.contact_support,
      primaryColor: Colors.red,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return context.localization.retry;
  }
}
