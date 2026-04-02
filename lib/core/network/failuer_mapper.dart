import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

String mapFailureMessage(BuildContext context, String message) {
  final locale = context.localization;

  switch (message) {
    case 'error_connection_timeout':
      return locale.error_connection_timeout;
    case 'error_send_timeout':
      return locale.error_send_timeout;
    case 'error_receive_timeout':
      return locale.error_receive_timeout;
    case 'error_bad_certificate':
      return locale.error_bad_certificate;
    case 'error_request_cancelled':
      return locale.error_request_cancelled;
    case 'error_no_internet':
      return locale.error_no_internet;
    case 'error_unknown':
      return locale.error_unknown;
    case 'error_no_response':
      return locale.error_no_response;
    case 'error_bad_request':
      return locale.error_bad_request;
    case 'error_unauthorized':
      return locale.error_unauthorized;
    case 'error_forbidden':
      return locale.error_forbidden;
    case 'error_not_found':
      return locale.error_not_found;
    case 'error_conflict':
      return locale.error_conflict;
    case 'error_validation':
      return locale.error_validation;
    case 'error_server':
      return locale.error_server;
    default:
      return message;
  }
}
