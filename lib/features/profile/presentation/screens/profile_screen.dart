import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DriverProfileService _service = DriverProfileService();
  bool _isLoggingOut = false;
  bool _notificationsEnabled = true;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await _service.clearSession();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() => _isLoggingOut = false);
    CustomSnackbar.showInfo(context: context, message: 'تم تسجيل الخروج بنجاح');
    context.pushNamedAndRemoveUntil(
      AppRoutes.login,
      predicate: (route) => false,
    );
  }

  Future<void> _open(String route) async {
    await context.pushNamed(route);
    if (!mounted) return;
    setState(() {});
  }

  void _openOrdersTab() {
    final shellScope = AppShellScreen.maybeOf(context);
    if (shellScope != null) {
      shellScope.switchToTab(1);
      return;
    }

    context.pushNamedAndRemoveUntil(
      AppRoutes.completedOrders,
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final identity = _service.identity;
    final draft = _service.profileDraft;
    final profileCompleted = _service.isProfileCompleted || draft.isComplete;
    final avatarLetter = _resolveAvatarLetter(identity.fullName);
    final displayName = identity.fullName.trim().isEmpty
        ? 'اسم المستخدم'
        : identity.fullName.trim();
    final email = identity.email.trim().isEmpty
        ? 'example@zadana.com'
        : identity.email.trim();
    final phone = identity.phone.trim().isEmpty
        ? '+20 100 000 0000'
        : identity.phone.trim();
    final completionCount = _profileCompletionCount(identity, draft);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CustomAppBar(
        title: 'حسابي',
        backgroundColor: const Color(0xFFF6F7FB),
        showBackButton: false,
        showShadow: false,
        titleFontSize: FontSize.size18,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeaderCard(
              avatarLetter: avatarLetter,
              displayName: displayName,
              email: email,
              phone: phone,
              onEditTap: () => _open(AppRoutes.driverProfileCompletion),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.base,
              Spacing.base,
              Spacing.base,
              Spacing.xl,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _ProfileSectionCard(
                    children: [
                      _ProfileActionTile(
                        title: 'تعديل الملف الشخصي',
                        subtitle: 'عدّل بياناتك الشخصية والمركبة والمرفقات',
                        icon: Icons.person_outline_rounded,
                        iconColor: AppColors.primary,
                        onTap: () => _open(AppRoutes.driverProfileCompletion),
                      ),
                      _ProfileActionTile(
                        title: 'طلباتي',
                        subtitle: 'راجع الطلبات الحالية والطلبات المكتملة',
                        icon: Icons.receipt_long_outlined,
                        iconColor: AppColors.info,
                        onTap: _openOrdersTab,
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.base),
                  _ProfileSectionCard(
                    children: [
                      _ProfileActionTile(
                        title: 'اللغة',
                        subtitle: 'العربية',
                        icon: Icons.language_rounded,
                        iconColor: AppColors.info,
                        onTap: () {
                          CustomSnackbar.showInfo(
                            context: context,
                            message: 'إعدادات اللغة متاحة حالياً بالعربية',
                          );
                        },
                      ),
                      _ProfileNotificationTile(
                        title: 'الإشعارات',
                        subtitle: 'فتح صفحة الإشعارات والتحكم في تنبيهاتها',
                        icon: Icons.notifications_none_rounded,
                        iconColor: AppColors.primary,
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() => _notificationsEnabled = value);
                        },
                        onTap: () => _open(AppRoutes.notifications),
                      ),
                      _ProfileActionTile(
                        title: 'تغيير كلمة المرور',
                        subtitle: 'افتح شاشة الأمان لإدارة كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        iconColor: AppColors.secondary,
                        onTap: () => _open(AppRoutes.security),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.base),
                  _ProfileSectionCard(
                    children: [
                      _ProfileActionTile(
                        title: 'الدعم والمساعدة',
                        subtitle: 'تواصل معنا أو اطلع على المساعدة',
                        icon: Icons.support_agent_rounded,
                        iconColor: AppColors.primary,
                        onTap: () => _open(AppRoutes.supportHelp),
                      ),
                      _ProfileActionTile(
                        title: 'سياسة الخصوصية',
                        subtitle: 'المعرفة بالتجميع والتخزين والاستخدام',
                        icon: Icons.privacy_tip_outlined,
                        iconColor: AppColors.info,
                        onTap: () => _open(AppRoutes.privacy),
                      ),
                      _ProfileActionTile(
                        title: 'الأمان والمستندات',
                        subtitle: 'راجع الهوية والرخصة والمرفقات الحالية',
                        icon: Icons.verified_user_outlined,
                        iconColor: AppColors.success,
                        onTap: () => _open(AppRoutes.profileSecurityDocuments),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.base),
                  _ProfileSectionCard(
                    children: [
                      _ProfileActionTile(
                        title: 'استكمال الملف',
                        subtitle: profileCompleted
                            ? 'الملف مكتمل ويمكنك تحديثه في أي وقت'
                            : 'أكمل بياناتك ومستنداتك لتفعيل الحساب بالكامل ($completionCount عنصر محفوظ)',
                        icon: Icons.assignment_turned_in_outlined,
                        iconColor: profileCompleted
                            ? AppColors.success
                            : AppColors.secondary,
                        onTap: () => _open(AppRoutes.driverProfileCompletion),
                      ),
                      _ProfileActionTile(
                        title: 'تسجيل خروج',
                        subtitle: 'تسجيل الخروج من هذا الجهاز بأمان',
                        icon: Icons.logout_rounded,
                        iconColor: AppColors.error,
                        trailing: _isLoggingOut
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              )
                            : null,
                        onTap: _isLoggingOut ? null : _logout,
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _profileCompletionCount(
    DriverIdentity identity,
    DriverProfileDraft draft,
  ) {
    final values = [
      identity.fullName,
      identity.email,
      identity.phone,
      draft.address,
      draft.nationalId,
      draft.licenseNumber,
      draft.vehicleBrand,
      draft.vehicleModel,
      draft.plateNumber,
    ];

    final imageCount = draft.images.values
        .where((value) => value.trim().isNotEmpty)
        .length;

    return values.where((value) => value.trim().isNotEmpty).length + imageCount;
  }

  String _resolveAvatarLetter(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'م';
    return trimmed.substring(0, 1).toUpperCase();
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.avatarLetter,
    required this.displayName,
    required this.email,
    required this.phone,
    required this.onEditTap,
  });

  final String avatarLetter;
  final String displayName;
  final String email;
  final String phone;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(Spacing.base, 10, Spacing.base, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.94),
            const Color(0xFF0E8498),
            AppColors.secondary.withValues(alpha: 0.52),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14007A92),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -26,
            right: -10,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -28,
            left: -8,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    avatarLetter,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: onEditTap,
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
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

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08131A2A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: isDestructive
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              trailing ??
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 20,
                    color: isDestructive
                        ? AppColors.error.withValues(alpha: 0.75)
                        : const Color(0xFF9EA8B5),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileNotificationTile extends StatelessWidget {
  const _ProfileNotificationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              Switch.adaptive(
                value: value,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
