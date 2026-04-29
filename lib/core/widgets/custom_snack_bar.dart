import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/network/failuer_mapper.dart';

enum CustomSnackbarPosition { top, bottom }

class CustomSnackbar {
  static final Map<CustomSnackbarPosition, OverlayEntry> _currentEntries =
      <CustomSnackbarPosition, OverlayEntry>{};
  static final Map<CustomSnackbarPosition, AnimationController>
  _animationControllers = <CustomSnackbarPosition, AnimationController>{};
  static final Map<CustomSnackbarPosition, Timer> _dismissTimers =
      <CustomSnackbarPosition, Timer>{};
  static const Duration _defaultDuration = Duration(milliseconds: 1800);

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFF49C98B),
      icon: Icons.check_circle_outline,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFC85A54),
      icon: Icons.error_outline,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFD08A2E),
      icon: Icons.warning_amber_outlined,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }

  static void showTopBanner({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    Color backgroundColor = AppColors.primary,
    IconData icon = Icons.notifications_active_outlined,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: duration,
      onTap: onTap,
      position: CustomSnackbarPosition.top,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    final localizedMessage = mapFailureMessage(context, message);
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    _removeCurrent(position: position, immediate: true);
    HapticFeedback.lightImpact();

    final controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 260),
    );
    _animationControllers[position] = controller;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (entryContext) {
        final mediaQuery = MediaQuery.of(entryContext);
        final opacityAnimation = CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );
        final isTop = position == CustomSnackbarPosition.top;
        final slideAnimation =
            Tween<Offset>(
              begin: Offset(0, isTop ? -1.05 : 1.05),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: controller,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );
        final scaleAnimation = Tween<double>(begin: 0.98, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

        return Positioned(
          left: 16,
          right: 16,
          top: isTop ? mediaQuery.padding.top + 12 : null,
          bottom: isTop ? null : mediaQuery.padding.bottom + 12,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              top: isTop,
              bottom: !isTop,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: _SnackbarCard(
                          message: localizedMessage,
                          backgroundColor: backgroundColor,
                          icon: icon,
                          duration: duration,
                          onClose: () => _removeCurrent(position: position),
                          onTap: onTap,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    _currentEntries[position] = entry;
    overlay.insert(entry);

    controller.forward();
    _dismissTimers.remove(position)?.cancel();
    _dismissTimers[position] = Timer(
      duration,
      () => _removeCurrent(position: position),
    );
  }

  static void _removeCurrent({
    required CustomSnackbarPosition position,
    bool immediate = false,
  }) {
    final entry = _currentEntries[position];
    final controller = _animationControllers[position];

    _dismissTimers.remove(position)?.cancel();

    if (entry == null) {
      return;
    }

    _currentEntries.remove(position);
    _animationControllers.remove(position);

    if (controller == null || immediate) {
      entry.remove();
      controller?.dispose();
      return;
    }

    if (controller.status == AnimationStatus.dismissed) {
      entry.remove();
      controller.dispose();
      return;
    }

    controller.reverse().whenCompleteOrCancel(() {
      entry.remove();
      controller.dispose();
    });
  }
}

class _SnackbarCard extends StatelessWidget {
  const _SnackbarCard({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.duration,
    required this.onClose,
    this.onTap,
  });

  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progressColor = Colors.white.withValues(alpha: 0.9);
    final surfaceColor = Color.lerp(backgroundColor, Colors.black, 0.12)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                onClose();
                onTap!.call();
              },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                backgroundColor.withValues(alpha: 0.96),
                surfaceColor.withValues(alpha: 0.98),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.18),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: FontConstant.cairo,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                        padding: EdgeInsets.zero,
                        splashRadius: 16,
                      ),
                    ],
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1, end: 0),
                  duration: duration,
                  builder: (context, value, child) {
                    return Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FractionallySizedBox(
                        widthFactor: value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(height: 2.5, color: progressColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
