import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/get_driver_notifications_unread_count_usecase.dart';

class AuthStatusNotificationButton extends StatefulWidget {
  const AuthStatusNotificationButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<AuthStatusNotificationButton> createState() =>
      _AuthStatusNotificationButtonState();
}

class _AuthStatusNotificationButtonState
    extends State<AuthStatusNotificationButton> {
  late final GetDriverNotificationsUnreadCountUseCase _getUnreadCountUseCase;
  late final StreamSubscription<Map<String, dynamic>> _notificationSubscription;
  late final StreamSubscription<Map<String, dynamic>>
  _supportCaseChangedSubscription;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _getUnreadCountUseCase = getIt<GetDriverNotificationsUnreadCountUseCase>();
    _notificationSubscription = getIt<DriverRealtimeService>().notifications
        .listen((_) {
          unawaited(_refreshUnreadCount());
        });
    _supportCaseChangedSubscription =
        getIt<DriverRealtimeService>().supportCaseChanged.listen((_) {
          unawaited(_refreshUnreadCount());
        });
    unawaited(_refreshUnreadCount());
  }

  @override
  void dispose() {
    unawaited(_notificationSubscription.cancel());
    unawaited(_supportCaseChangedSubscription.cancel());
    super.dispose();
  }

  Future<void> _refreshUnreadCount() async {
    final result = await _getUnreadCountUseCase.call();
    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult(data: final unreadCount):
        setState(() => _count = unreadCount.count);
      case ApiErrorResult():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final badgeText = _count > 99 ? '99+' : '$_count';
    final shouldShowBadge = _count > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onTap,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: color.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: color.onSurface,
              ),
            ),
          ),
        ),
        if (shouldShowBadge)
          PositionedDirectional(
            top: -4,
            end: -2,
            child: Container(
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                badgeText,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
