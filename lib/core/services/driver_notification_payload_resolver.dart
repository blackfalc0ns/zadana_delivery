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
    payload['caseType'] = _firstNonEmptyString([
      payload['caseType'],
      payload['case_type'],
      payload['type'],
      nestedPayload?['caseType'],
      nestedPayload?['case_type'],
      nestedPayload?['type'],
      customPayload?['caseType'],
      customPayload?['case_type'],
      customPayload?['type'],
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
    payload['targetUrl'] = _firstNonEmptyString([
      payload['targetUrl'],
      payload['target_url'],
      nestedPayload?['targetUrl'],
      nestedPayload?['target_url'],
      customPayload?['targetUrl'],
      customPayload?['target_url'],
    ]);
    payload['category'] = _firstNonEmptyString([
      payload['category'],
      nestedPayload?['category'],
      customPayload?['category'],
    ]);
    payload['popupType'] = _firstNonEmptyString([
      payload['popupType'],
      payload['popup_type'],
      nestedPayload?['popupType'],
      nestedPayload?['popup_type'],
      customPayload?['popupType'],
      customPayload?['popup_type'],
    ]);
    payload['presentation'] = _firstNonEmptyString([
      payload['presentation'],
      nestedPayload?['presentation'],
      customPayload?['presentation'],
    ]);
    payload['showPopup'] = _firstNonEmptyString([
      payload['showPopup'],
      payload['show_popup'],
      nestedPayload?['showPopup'],
      nestedPayload?['show_popup'],
      customPayload?['showPopup'],
      customPayload?['show_popup'],
    ]);
    payload['eventName'] = _firstNonEmptyString([
      payload['eventName'],
      payload['event_name'],
      nestedPayload?['eventName'],
      nestedPayload?['event_name'],
      customPayload?['eventName'],
      customPayload?['event_name'],
    ]);
    payload['action'] = _firstNonEmptyString([
      payload['action'],
      nestedPayload?['action'],
      customPayload?['action'],
    ]);
    payload['status'] = _firstNonEmptyString([
      payload['status'],
      nestedPayload?['status'],
      customPayload?['status'],
    ]);
    payload['changedAtUtc'] = _firstNonEmptyString([
      payload['changedAtUtc'],
      payload['changed_at_utc'],
      nestedPayload?['changedAtUtc'],
      nestedPayload?['changed_at_utc'],
      customPayload?['changedAtUtc'],
      customPayload?['changed_at_utc'],
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
    final normalizedPayload = normalize(payload);
    final explicitScreen = _firstNonEmptyString([normalizedPayload['screen']]);
    if (explicitScreen != null) {
      return explicitScreen;
    }

    // Resolve screen from targetUrl (backend unified payload).
    final targetUrl = _firstNonEmptyString([normalizedPayload['targetUrl']]);
    if (targetUrl != null) {
      final resolvedScreen = _resolveScreenFromTargetUrl(targetUrl, normalizedPayload);
      if (resolvedScreen != null) {
        return resolvedScreen;
      }
    }

    // Resolve screen from category (backend unified payload).
    final category = _firstNonEmptyString([normalizedPayload['category']]);
    if (category != null) {
      final resolvedScreen = _resolveScreenFromCategory(category, normalizedPayload);
      if (resolvedScreen != null) {
        return resolvedScreen;
      }
    }

    if (resolveSupportCaseId(normalizedPayload) != null) {
      return 'support_case_detail';
    }

    return null;
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

  static String? resolveSupportCaseType(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    final explicitType = _firstNonEmptyString([
      normalizedPayload['caseType'],
      normalizedPayload['type'],
    ]);
    if (explicitType != null) {
      return explicitType;
    }

    final orderId = resolveOrderId(normalizedPayload);
    if (orderId == null || orderId.trim().isEmpty) {
      return 'driver_account';
    }
    return null;
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
    final eventName = _firstNonEmptyString([
      normalizedPayload['eventName'],
    ])?.toLowerCase() ?? '';
    if (_urgentEvents.any(event.contains) ||
        _urgentEvents.any(eventName.contains)) {
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
      'category=${resolveCategory(normalizedPayload) ?? '-'}',
      'popupType=${resolvePopupType(normalizedPayload) ?? '-'}',
      'eventName=${resolveEventName(normalizedPayload) ?? '-'}',
      'targetUrl=${resolveTargetUrl(normalizedPayload) ?? '-'}',
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

  static String? resolveCategory(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['category']]);
  }

  static String? resolvePopupType(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['popupType']]);
  }

  static String? resolveEventName(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    return _firstNonEmptyString([
      normalizedPayload['eventName'],
      normalizedPayload['event'],
    ]);
  }

  static String? resolveTargetUrl(Map<String, dynamic> payload) {
    return _firstNonEmptyString([normalize(payload)['targetUrl']]);
  }

  static bool shouldShowPopup(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    final presentation = _firstNonEmptyString([
      normalizedPayload['presentation'],
    ]);
    if (presentation == 'popup') return true;

    final showPopup = _firstNonEmptyString([normalizedPayload['showPopup']]);
    if (showPopup == 'true' || showPopup == '1') return true;

    return false;
  }

  static String? _resolveScreenFromTargetUrl(
    String targetUrl,
    Map<String, dynamic> payload,
  ) {
    final url = targetUrl.trim().toLowerCase();

    if (url == '/' || url == '/home') {
      return 'home';
    }

    // /assignments/{id} or /orders/{id}
    final assignmentMatch = RegExp(r'^/assignments/(.+)$').firstMatch(url);
    if (assignmentMatch != null) {
      final id = assignmentMatch.group(1) ?? '';
      if (id.isNotEmpty) {
        // Inject the resolved assignment ID into the payload for downstream use.
        payload['assignmentId'] = id;
      }
      return 'assignment_detail';
    }
    final orderMatch = RegExp(r'^/orders/(.+)$').firstMatch(url);
    if (orderMatch != null) {
      final id = orderMatch.group(1) ?? '';
      if (id.isNotEmpty) {
        payload['orderId'] = id;
      }
      return 'assignment_detail';
    }

    // /wallet
    if (url == '/wallet') {
      return 'wallet';
    }

    // /support/cases/{id}
    final supportMatch = RegExp(r'^/support/cases/(.+)$').firstMatch(url);
    if (supportMatch != null) {
      final id = supportMatch.group(1) ?? '';
      if (id.isNotEmpty) {
        payload['supportCaseId'] = id;
      }
      return 'support_case_detail';
    }

    // /account-status
    if (url == '/account-status') {
      return 'account_status';
    }

    return null;
  }

  static String? _resolveScreenFromCategory(
    String category,
    Map<String, dynamic> payload,
  ) {
    switch (category.toLowerCase()) {
      case 'dispatch':
        return 'home';
      case 'assignment':
        if (resolveAssignmentId(payload) != null) {
          return 'assignment_detail';
        }
        return 'home';
      case 'wallet':
        return 'wallet';
      case 'support':
        if (resolveSupportCaseId(payload) != null) {
          return 'support_case_detail';
        }
        return 'home';
      case 'account':
        return 'account_status';
      default:
        return null;
    }
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
    final eventName = _firstNonEmptyString([
      payload['eventName'],
    ])?.toLowerCase() ?? '';

    if (event.contains('dispatch.offer_new') ||
        eventName.contains('dispatch.offer_new') ||
        event.contains('support.request_evidence') ||
        event.contains('account.suspend') ||
        event.contains('assignment.active_order_cancelled')) {
      return 'New update';
    }

    if (event.contains('dispatch.offer_expired') ||
        eventName.contains('dispatch.offer_expired')) {
      return 'Offer expired';
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
    final eventName = _firstNonEmptyString([
      payload['eventName'],
    ])?.toLowerCase() ?? '';
    if (event.contains('dispatch.offer_new') ||
        eventName.contains('dispatch.offer_new')) {
      return 'A new delivery offer is waiting for you.';
    }
    if (event.contains('dispatch.offer_expired') ||
        eventName.contains('dispatch.offer_expired')) {
      return 'A delivery offer has expired.';
    }
    if (event.contains('support.request_evidence')) {
      return 'Support requested more details for your case.';
    }
    if (event.contains('wallet.withdrawal_paid') ||
        event.contains('wallet.withdrawal_submitted') ||
        eventName.contains('wallet.withdrawal_submitted')) {
      return 'Your wallet balance was updated.';
    }
    if (event.contains('wallet.admin_adjustment') ||
        eventName.contains('wallet.admin_adjustment')) {
      return 'Your wallet was adjusted by an administrator.';
    }
    if (event.contains('wallet.payout_completed') ||
        eventName.contains('wallet.payout_completed')) {
      return 'Your payout has been completed.';
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
    'caseType',
    'case_type',
    'targetUrl',
    'target_url',
    'category',
    'popupType',
    'popup_type',
    'presentation',
    'showPopup',
    'show_popup',
    'eventName',
    'event_name',
    'action',
    'status',
    'changedAtUtc',
    'changed_at_utc',
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
    'dispatch.offer_expired',
    'account.suspend',
    'assignment.active_order_cancelled',
    'support.request_evidence',
  ];
}
