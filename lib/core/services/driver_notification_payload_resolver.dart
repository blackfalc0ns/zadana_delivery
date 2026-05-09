import 'dart:convert';

class DriverNotificationDisplayContent {
  const DriverNotificationDisplayContent({required this.title, this.body});

  final String title;
  final String? body;

  bool get hasVisibleContent =>
      title.trim().isNotEmpty || (body?.trim().isNotEmpty ?? false);
}

class DriverNotificationPayloadResolver {
  const DriverNotificationPayloadResolver._();

  static const String headsUpChannelId = 'zadana_heads_up_notifications';
  static const String generalChannelId = 'zadana_driver_general_notifications';

  static Map<String, dynamic> normalize(Map<String, dynamic> rawPayload) {
    final payload = Map<String, dynamic>.from(rawPayload);
    final nestedPayload = _extractNestedPayload(payload);
    final customPayload = _extractCustomPayload(payload);

    if (nestedPayload != null && nestedPayload.isNotEmpty) {
      payload['dataObject'] = nestedPayload;
    }
    if (customPayload != null && customPayload.isNotEmpty) {
      payload['customObject'] = customPayload;
    }

    for (final key in _stringKeys) {
      payload[key] = _firstNonEmptyString([
        payload[key],
        nestedPayload?[key],
        customPayload?[key],
      ]);
    }

    payload['screen'] = _firstNonEmptyString([
      payload['screen'],
      nestedPayload?['screen'],
    ]);
    payload['event'] = _firstNonEmptyString([
      payload['event'],
      nestedPayload?['event'],
    ]);
    payload['type'] = _firstNonEmptyString([
      payload['type'],
      nestedPayload?['type'],
    ]);
    payload['notificationId'] = _firstNonEmptyString([
      payload['notificationId'],
      payload['id'],
      nestedPayload?['notificationId'],
      nestedPayload?['id'],
      customPayload?['notificationId'],
      customPayload?['id'],
      customPayload?['i'],
    ]);
    payload['referenceId'] = _firstNonEmptyString([
      payload['referenceId'],
      nestedPayload?['referenceId'],
      customPayload?['referenceId'],
    ]);
    payload['assignmentId'] = _firstNonEmptyString([
      payload['assignmentId'],
      payload['assignment_id'],
      nestedPayload?['assignmentId'],
      nestedPayload?['assignment_id'],
      customPayload?['assignmentId'],
      customPayload?['assignment_id'],
    ]);
    payload['orderId'] = _firstNonEmptyString([
      payload['orderId'],
      payload['order_id'],
      nestedPayload?['orderId'],
      nestedPayload?['order_id'],
      customPayload?['orderId'],
      customPayload?['order_id'],
    ]);
    payload['supportCaseId'] = _firstNonEmptyString([
      payload['supportCaseId'],
      payload['support_case_id'],
      payload['caseId'],
      payload['case_id'],
      nestedPayload?['supportCaseId'],
      nestedPayload?['support_case_id'],
      nestedPayload?['caseId'],
      nestedPayload?['case_id'],
      customPayload?['supportCaseId'],
      customPayload?['support_case_id'],
      customPayload?['caseId'],
      customPayload?['case_id'],
    ]);
    payload['withdrawalId'] = _firstNonEmptyString([
      payload['withdrawalId'],
      payload['withdrawal_id'],
      nestedPayload?['withdrawalId'],
      nestedPayload?['withdrawal_id'],
      customPayload?['withdrawalId'],
      customPayload?['withdrawal_id'],
    ]);
    payload['documentType'] = _firstNonEmptyString([
      payload['documentType'],
      nestedPayload?['documentType'],
      customPayload?['documentType'],
    ]);
    payload['documentId'] = _firstNonEmptyString([
      payload['documentId'],
      nestedPayload?['documentId'],
      customPayload?['documentId'],
    ]);
    payload['reason'] = _firstNonEmptyString([
      payload['reason'],
      nestedPayload?['reason'],
      customPayload?['reason'],
      nestedPayload?['rejectionReason'],
      customPayload?['rejectionReason'],
    ]);
    payload['driverId'] = _firstNonEmptyString([
      payload['driverId'],
      nestedPayload?['driverId'],
      customPayload?['driverId'],
    ]);
    payload['verificationStatus'] = _firstNonEmptyString([
      payload['verificationStatus'],
      nestedPayload?['verificationStatus'],
      customPayload?['verificationStatus'],
    ]);
    payload['accountStatus'] = _firstNonEmptyString([
      payload['accountStatus'],
      nestedPayload?['accountStatus'],
      customPayload?['accountStatus'],
    ]);

    return payload;
  }

  static bool isLikelyNotificationPayload(Map<String, dynamic> rawPayload) {
    final normalizedPayload = normalize(rawPayload);

    final clickAction = _firstNonEmptyString([
      normalizedPayload['click_action'],
    ]);
    if (clickAction == 'FLUTTER_NOTIFICATION_CLICK') {
      return true;
    }

    return _firstNonEmptyString([
          resolveNotificationId(normalizedPayload),
          resolveScreen(normalizedPayload),
          resolveEvent(normalizedPayload),
          resolveType(normalizedPayload),
          resolveReferenceId(normalizedPayload),
          resolveAssignmentId(normalizedPayload),
          resolveOrderId(normalizedPayload),
          resolveSupportCaseId(normalizedPayload),
          resolveWithdrawalId(normalizedPayload),
        ]) !=
        null;
  }

  static DriverNotificationDisplayContent resolveDisplayContent({
    required Map<String, dynamic> payload,
    String? title,
    String? body,
  }) {
    final normalizedPayload = normalize(payload);
    final resolvedTitle = _firstNonEmptyString([
      title,
      normalizedPayload['title'],
      normalizedPayload['heading'],
      _resolveLocalizedMapValue(normalizedPayload['headings']),
      normalizedPayload['titleAr'],
      normalizedPayload['titleEn'],
      _resolveFallbackTitle(normalizedPayload),
    ]);
    final resolvedBody = _firstNonEmptyString([
      body,
      normalizedPayload['body'],
      normalizedPayload['message'],
      normalizedPayload['content'],
      _resolveLocalizedMapValue(normalizedPayload['contents']),
      normalizedPayload['bodyAr'],
      normalizedPayload['bodyEn'],
      _resolveFallbackBody(normalizedPayload),
    ]);

    final displayTitle = resolvedTitle ?? resolvedBody ?? '';
    final displayBody = resolvedTitle == null ? null : resolvedBody;

    return DriverNotificationDisplayContent(
      title: displayTitle,
      body: displayBody,
    );
  }

  static String? resolveScreen(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['screen']]);
  }

  static String? resolveEvent(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['event']]);
  }

  static String? resolveType(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['type']]);
  }

  static String? resolveNotificationId(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['notificationId']]);
  }

  static String? resolveAssignmentId(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['assignmentId']]);
  }

  static String? resolveOrderId(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    return _firstNonEmptyString([
      normalizedPayload['orderId'],
      normalizedPayload['referenceId'],
    ]);
  }

  static String? resolveSupportCaseId(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['supportCaseId']]);
  }

  static String? resolveWithdrawalId(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['withdrawalId']]);
  }

  static String? resolveReferenceId(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['referenceId']]);
  }

  static String resolveAndroidChannelId(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    final explicitChannelId = _firstNonEmptyString([
      normalizedPayload['android_channel_id'],
      normalizedPayload['existing_android_channel_id'],
    ]);
    if (explicitChannelId != null && explicitChannelId.isNotEmpty) {
      return explicitChannelId;
    }

    final event = resolveEvent(normalizedPayload)?.toLowerCase() ?? '';
    if (_urgentEvents.any(event.contains)) {
      return headsUpChannelId;
    }

    return generalChannelId;
  }

  static String resolveBannerMessage(
    Map<String, dynamic> payload, {
    String? title,
    String? body,
  }) {
    final displayContent = resolveDisplayContent(
      payload: payload,
      title: title,
      body: body,
    );

    final resolvedTitle = displayContent.title.trim();
    final resolvedBody = displayContent.body?.trim() ?? '';
    if (resolvedTitle.isEmpty) {
      return resolvedBody;
    }
    if (resolvedBody.isEmpty) {
      return resolvedTitle;
    }
    return '$resolvedTitle\n$resolvedBody';
  }

  static String resolveDebugSummary(
    Map<String, dynamic> payload, {
    String? title,
    String? body,
  }) {
    final normalizedPayload = normalize(payload);
    final resolvedDisplayContent = resolveDisplayContent(
      payload: normalizedPayload,
      title: title,
      body: body,
    );
    final explicitChannelId = _firstNonEmptyString([
      normalizedPayload['android_channel_id'],
      normalizedPayload['existing_android_channel_id'],
    ]);

    return <String>[
      'screen=${resolveScreen(normalizedPayload) ?? '-'}',
      'event=${resolveEvent(normalizedPayload) ?? '-'}',
      'type=${resolveType(normalizedPayload) ?? '-'}',
      'notificationId=${resolveNotificationId(normalizedPayload) ?? '-'}',
      'assignmentId=${resolveAssignmentId(normalizedPayload) ?? '-'}',
      'orderId=${resolveOrderId(normalizedPayload) ?? '-'}',
      'supportCaseId=${resolveSupportCaseId(normalizedPayload) ?? '-'}',
      'withdrawalId=${resolveWithdrawalId(normalizedPayload) ?? '-'}',
      'title=${resolvedDisplayContent.title.trim().isEmpty ? '-' : resolvedDisplayContent.title.trim()}',
      'bodyExists=${(resolvedDisplayContent.body ?? '').trim().isNotEmpty}',
      'clickAction=${normalizedPayload['click_action'] ?? '-'}',
      'channel=${explicitChannelId ?? resolveAndroidChannelId(normalizedPayload)}',
    ].join(', ');
  }

  static Map<String, dynamic>? _extractNestedPayload(
    Map<String, dynamic> payload,
  ) {
    final directNotification = _mapValue(payload['notification']);
    final notificationAdditionalData = _mapValue(
      directNotification?['additionalData'],
    );
    if (notificationAdditionalData != null) {
      return notificationAdditionalData;
    }

    final directDataObject = _mapValue(payload['dataObject']);
    if (directDataObject != null) {
      return directDataObject;
    }

    final directAdditionalData = _mapValue(payload['additionalData']);
    if (directAdditionalData != null) {
      return directAdditionalData;
    }

    final directPayload = _mapValue(payload['payload']);
    if (directPayload != null) {
      return directPayload;
    }

    final oneSignalData = payload['onesignalData'];
    if (oneSignalData is String && oneSignalData.trim().isNotEmpty) {
      final decoded = _decodeMap(oneSignalData);
      if (decoded != null) {
        return decoded;
      }
    }
    if (oneSignalData is Map) {
      return Map<String, dynamic>.from(oneSignalData);
    }

    final rawData = payload['data'];
    if (rawData is String && rawData.trim().isNotEmpty) {
      return _decodeMap(rawData);
    }
    if (rawData is Map) {
      return Map<String, dynamic>.from(rawData);
    }

    return null;
  }

  static Map<String, dynamic>? _extractCustomPayload(
    Map<String, dynamic> payload,
  ) {
    final customValue = payload['custom'];
    Map<String, dynamic>? customMap;
    if (customValue is String && customValue.trim().isNotEmpty) {
      customMap = _decodeMap(customValue);
    } else {
      customMap = _mapValue(customValue);
    }

    if (customMap == null || customMap.isEmpty) {
      final oneSignalData = payload['onesignalData'];
      if (oneSignalData is String && oneSignalData.trim().isNotEmpty) {
        customMap = _decodeMap(oneSignalData);
      } else {
        customMap = _mapValue(oneSignalData);
      }
    }

    if (customMap == null || customMap.isEmpty) {
      final rawPayload = payload['rawPayload'];
      if (rawPayload is String && rawPayload.trim().isNotEmpty) {
        customMap = _decodeMap(rawPayload);
      }
    }

    if (customMap == null || customMap.isEmpty) {
      return null;
    }

    final additionalData = _mapValue(customMap['a']);
    if (additionalData == null || additionalData.isEmpty) {
      return customMap;
    }

    return <String, dynamic>{...customMap, ...additionalData};
  }

  static Map<String, dynamic>? _decodeMap(String rawValue) {
    try {
      final decoded = jsonDecode(rawValue);
      return _mapValue(decoded);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return value.map(
        (key, nestedValue) => MapEntry(key.toString(), nestedValue),
      );
    }
    return null;
  }

  static String? _resolveLocalizedMapValue(dynamic value) {
    final mapValue = _mapValue(value);
    if (mapValue == null || mapValue.isEmpty) {
      return null;
    }
    return _firstNonEmptyString(mapValue.values);
  }

  static String? _resolveFallbackTitle(Map<String, dynamic> payload) {
    final screen = resolveScreen(payload) ?? '';
    final event = resolveEvent(payload)?.toLowerCase() ?? '';

    if (event.contains('dispatch.offer_new') ||
        event.contains('support.request_evidence') ||
        event.contains('account.suspend') ||
        event.contains('assignment.active_order_cancelled')) {
      return 'New update';
    }

    switch (screen) {
      case 'assignment_detail':
        return 'Assignment update';
      case 'support_case_detail':
        return 'Support update';
      case 'wallet':
        return 'Wallet update';
      case 'account_status':
        return 'Account update';
      case 'notifications_center':
        return 'Notification center';
      default:
        return null;
    }
  }

  static String? _resolveFallbackBody(Map<String, dynamic> payload) {
    final event = resolveEvent(payload)?.toLowerCase() ?? '';
    if (event.contains('dispatch.offer_new')) {
      return 'A new delivery offer is waiting for you.';
    }
    if (event.contains('support.request_evidence')) {
      return 'Support requested more details for your case.';
    }
    if (event.contains('wallet.withdrawal_paid')) {
      return 'Your wallet balance was updated.';
    }
    if (event.contains('account.suspend')) {
      return 'Your account status needs attention.';
    }
    return null;
  }

  static String? _firstNonEmptyString(Iterable<dynamic> values) {
    for (final value in values) {
      final normalizedValue = _stringValue(value);
      if (normalizedValue != null) {
        return normalizedValue;
      }
    }
    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final trimmedValue = value.trim();
      return trimmedValue.isEmpty ? null : trimmedValue;
    }

    if (value is num || value is bool) {
      return value.toString();
    }

    final mapValue = _mapValue(value);
    if (mapValue != null) {
      return _firstNonEmptyString(mapValue.values);
    }

    return null;
  }

  static const List<String> _stringKeys = <String>[
    'screen',
    'event',
    'type',
    'id',
    'notificationId',
    'click_action',
    'title',
    'heading',
    'titleAr',
    'titleEn',
    'body',
    'message',
    'content',
    'bodyAr',
    'bodyEn',
    'referenceId',
    'orderId',
    'order_id',
    'assignmentId',
    'assignment_id',
    'supportCaseId',
    'support_case_id',
    'caseId',
    'case_id',
    'withdrawalId',
    'withdrawal_id',
    'documentType',
    'documentId',
    'reason',
    'driverId',
    'verificationStatus',
    'accountStatus',
    'android_channel_id',
    'existing_android_channel_id',
    'i',
  ];

  static const List<String> _urgentEvents = <String>[
    'dispatch.offer_new',
    'account.suspend',
    'assignment.active_order_cancelled',
    'support.request_evidence',
  ];
}
