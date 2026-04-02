import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';

class DriverAccountScreen extends StatefulWidget {
  const DriverAccountScreen({super.key});

  @override
  State<DriverAccountScreen> createState() => _DriverAccountScreenState();
}

class _DriverAccountScreenState extends State<DriverAccountScreen> {
  bool _isLoggingOut = false;

  String _copy(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() => _isLoggingOut = false);
    CustomSnackbar.showInfo(
      context: context,
      message: _copy(context, 'تم تسجيل الخروج.', 'Signed out successfully.'),
    );
    context.pushNamedAndRemoveUntil(
      AppRoutes.login,
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007A92), Color(0xFFE48215)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Image.asset(Assets.logoDark, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _copy(context, 'حساب المندوب', 'Driver account'),
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _copy(
                            context,
                            'وضع تجريبي للتنقل بين الشاشات',
                            'Dummy navigation flow',
                          ),
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size12,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.base),
            _InfoCard(
              title: _copy(context, 'حالة الملف', 'Profile status'),
              value: _copy(context, 'وضع تجريبي', 'Dummy mode'),
              icon: Icons.pending_actions_rounded,
              accent: color.secondary,
            ),
            const SizedBox(height: Spacing.sm),
            _InfoCard(
              title: _copy(context, 'نوع الحساب', 'Account type'),
              value: _copy(context, 'مندوب توصيل', 'Delivery driver'),
              icon: Icons.badge_outlined,
              accent: color.primary,
            ),
            const SizedBox(height: Spacing.base),
            AppButton.outlined(
              text: _copy(
                context,
                'استكمال بيانات المركبة',
                'Complete vehicle profile',
              ),
              onPressed: () =>
                  context.pushNamed(AppRoutes.driverProfileCompletion),
              height: 50,
              borderRadius: 18,
            ),
            const SizedBox(height: Spacing.sm),
            AppButton.filled(
              text: _copy(context, 'تسجيل الخروج', 'Sign out'),
              onPressed: _isLoggingOut ? null : _logout,
              isLoading: _isLoggingOut,
              color: color.error,
              height: 50,
              borderRadius: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
