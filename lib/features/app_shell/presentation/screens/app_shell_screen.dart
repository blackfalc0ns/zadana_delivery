import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/driver_account_screen.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/screens/completed_orders_screen.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_screen.dart';
import 'package:zadana_delivery/features/wallet/presentation/screens/wallet_screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final tabs = [
      PersistentTabConfig(
        screen: const DriverHomeScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.home_rounded),
          inactiveIcon: const Icon(Icons.home_outlined),
          title: locale.nav_home,
          activeForegroundColor: AppColors.secondary,
          inactiveForegroundColor: const Color(0xFF7D8793),
        ),
      ),
      PersistentTabConfig(
        screen: const CompletedOrdersScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.receipt_long_rounded),
          inactiveIcon: const Icon(Icons.receipt_long_outlined),
          title: locale.nav_orders,
          activeForegroundColor: AppColors.secondary,
          inactiveForegroundColor: const Color(0xFF7D8793),
        ),
      ),
      PersistentTabConfig(
        screen: const WalletScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.account_balance_wallet_rounded),
          inactiveIcon: const Icon(Icons.account_balance_wallet_outlined),
          title: locale.nav_wallet,
          activeForegroundColor: AppColors.secondary,
          inactiveForegroundColor: const Color(0xFF7D8793),
        ),
      ),
      PersistentTabConfig(
        screen: const DriverAccountScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.person_rounded),
          inactiveIcon: const Icon(Icons.person_outline_rounded),
          title: locale.nav_profile,
          activeForegroundColor: AppColors.secondary,
          inactiveForegroundColor: const Color(0xFF7D8793),
        ),
      ),
    ];

    return PersistentTabView(
      controller: _controller,
      tabs: tabs,
      backgroundColor: color.surface,
      navBarBuilder: (navBarConfig) => SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: _AppShellNavBar(navBarConfig: navBarConfig),
      ),
    );
  }
}

class _AppShellNavBar extends StatelessWidget {
  const _AppShellNavBar({required this.navBarConfig});

  final NavBarConfig navBarConfig;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.97),
            const Color(0xFFF7F9FC).withValues(alpha: 0.94),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F102033),
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
                                alpha: 0.45,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: item.activeForegroundColor.withValues(
                                    alpha: 0.28,
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

