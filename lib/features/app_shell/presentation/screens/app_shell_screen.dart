import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/driver_account_screen.dart';
import 'package:zadana_delivery/features/driver_home/presentation/screens/driver_home_screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 1,
  );

  late final List<PersistentTabConfig> _tabs = [
    PersistentTabConfig(
      screen: const _AppShellPlaceholderScreen(
        title: 'طلباتي',
        subtitle: 'مساحة الطلبات الجارية والقادمة ستظهر هنا قريبًا.',
        icon: Icons.receipt_long_rounded,
      ),
      item: ItemConfig(
        icon: const Icon(Icons.receipt_long_rounded),
        inactiveIcon: const Icon(Icons.receipt_long_outlined),
        title: 'الطلبات',
        activeForegroundColor: AppColors.primary,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: const DriverHomeScreen(),
      item: ItemConfig(
        icon: const Icon(Icons.home_rounded),
        inactiveIcon: const Icon(Icons.home_outlined),
        title: 'الرئيسية',
        activeForegroundColor: AppColors.secondary,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: const DriverAccountScreen(),
      item: ItemConfig(
        icon: const Icon(Icons.person_rounded),
        inactiveIcon: const Icon(Icons.person_outline_rounded),
        title: 'الحساب',
        activeForegroundColor: AppColors.primary,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return PersistentTabView(
      controller: _controller,
      tabs: _tabs,
      backgroundColor: color.surface,
      navBarBuilder: (navBarConfig) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(navBarConfig.items.length, (index) {
          final item = navBarConfig.items[index];
          final isSelected = navBarConfig.selectedIndex == index;
          final isCenterItem = index == 1;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => navBarConfig.onItemSelected(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCenterItem)
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? item.activeForegroundColor
                              : item.activeForegroundColor.withValues(
                                  alpha: 0.16,
                                ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: item.activeForegroundColor
                                        .withValues(alpha: 0.30),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: IconTheme(
                          data: IconThemeData(
                            size: item.iconSize,
                            color: isSelected
                                ? Colors.white
                                : item.activeForegroundColor,
                          ),
                          child: isSelected ? item.icon : item.inactiveIcon,
                        ),
                      )
                    else
                      IconTheme(
                        data: IconThemeData(
                          size: item.iconSize - 4,
                          color: isSelected
                              ? item.activeForegroundColor
                              : item.inactiveForegroundColor,
                        ),
                        child: isSelected ? item.icon : item.inactiveIcon,
                      ),
                    const SizedBox(height: 1),
                    Text(
                      item.title ?? '',
                      style: item.textStyle.copyWith(
                        fontSize: 10,
                        color: isSelected
                            ? item.activeForegroundColor
                            : item.inactiveForegroundColor,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
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

class _AppShellPlaceholderScreen extends StatelessWidget {
  const _AppShellPlaceholderScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SafeArea(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(icon, color: color.primary),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size20,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: color.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
