import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/services/driver_notification_router_service.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/screens/completed_orders_screen.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_screen.dart';
import 'package:zadana_delivery/features/driver_tracking/presentation/manager/driver_tracking_cubit.dart';
import 'package:zadana_delivery/features/driver_tracking/presentation/manager/driver_tracking_event.dart';
import 'package:zadana_delivery/features/profile/presentation/screens/profile_screen.dart';
import 'package:zadana_delivery/features/wallet/presentation/screens/wallet_screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  static AppShellTabScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppShellTabScope>();
  }

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  late final PersistentTabController _controller;
  late final DriverTrackingCubit _driverTrackingCubit;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.initialIndex);
    _driverTrackingCubit = getIt<DriverTrackingCubit>()
      ..doIntent(const DriverTrackingBootstrapEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(getIt<DriverNotificationRouterService>().unlockNavigation());
    });
  }

  @override
  void dispose() {
    _driverTrackingCubit.close();
    super.dispose();
  }

  void _switchToTab(int index) {
    _controller.jumpToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final activeColor = color.secondary;
    final inactiveColor = color.onSurfaceVariant;
    final tabs = [
      PersistentTabConfig(
        screen: const DriverHomeScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.home_rounded),
          inactiveIcon: const Icon(Icons.home_outlined),
          title: locale.nav_home,
          activeForegroundColor: activeColor,
          inactiveForegroundColor: inactiveColor,
        ),
      ),
      PersistentTabConfig(
        screen: const CompletedOrdersScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.receipt_long_rounded),
          inactiveIcon: const Icon(Icons.receipt_long_outlined),
          title: locale.nav_orders,
          activeForegroundColor: activeColor,
          inactiveForegroundColor: inactiveColor,
        ),
      ),
      PersistentTabConfig(
        screen: const WalletScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.account_balance_wallet_rounded),
          inactiveIcon: const Icon(Icons.account_balance_wallet_outlined),
          title: locale.nav_wallet,
          activeForegroundColor: activeColor,
          inactiveForegroundColor: inactiveColor,
        ),
      ),
      PersistentTabConfig(
        screen: const ProfileScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.person_rounded),
          inactiveIcon: const Icon(Icons.person_outline_rounded),
          title: locale.nav_profile,
          activeForegroundColor: activeColor,
          inactiveForegroundColor: inactiveColor,
        ),
      ),
    ];

    return AppShellTabScope(
      switchToTab: _switchToTab,
      child: PersistentTabView(
        controller: _controller,
        tabs: tabs,
        backgroundColor: color.surface,
        navBarBuilder: (navBarConfig) => SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          child: _AppShellNavBar(navBarConfig: navBarConfig),
        ),
      ),
    );
  }
}

class AppShellTabScope extends InheritedWidget {
  const AppShellTabScope({
    super.key,
    required this.switchToTab,
    required super.child,
  });

  final ValueChanged<int> switchToTab;

  @override
  bool updateShouldNotify(AppShellTabScope oldWidget) {
    return switchToTab != oldWidget.switchToTab;
  }
}

class _AppShellNavBar extends StatelessWidget {
  const _AppShellNavBar({required this.navBarConfig});

  final NavBarConfig navBarConfig;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundStart = isDark
        ? color.surfaceContainerHigh
        : color.surface.withValues(alpha: 0.97);
    final backgroundEnd = isDark
        ? color.surfaceContainer
        : color.surfaceContainerLowest.withValues(alpha: 0.94);
    final borderColor = isDark
        ? color.outlineVariant.withValues(alpha: 0.35)
        : Colors.white.withValues(alpha: 0.85);
    final shadowColor = color.shadow.withValues(alpha: isDark ? 0.24 : 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundStart, backgroundEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 28,
            offset: const Offset(0, 16),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        children: List.generate(navBarConfig.items.length, (index) {
          final item = navBarConfig.items[index];
          final isSelected = navBarConfig.selectedIndex == index;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => navBarConfig.onItemSelected(index),
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? item.activeForegroundColor
                            : color.surfaceContainerHighest.withValues(
                                alpha: isDark ? 0.65 : 0.45,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: item.activeForegroundColor.withValues(
                                    alpha: isDark ? 0.34 : 0.28,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                            : null,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          size: item.iconSize - 3,
                          color: isSelected
                              ? Colors.white
                              : item.inactiveForegroundColor,
                        ),
                        child: isSelected ? item.icon : item.inactiveIcon,
                      ),
                    ),
                    const SizedBox.shrink(),
                    Text(
                      item.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: item.textStyle.copyWith(
                        fontSize: 10.5,
                        color: isSelected
                            ? color.onSurface
                            : item.inactiveForegroundColor,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 0.5),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: isSelected ? 16 : 0,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: item.activeForegroundColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
