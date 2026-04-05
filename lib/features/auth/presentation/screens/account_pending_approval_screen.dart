import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';

class AccountPendingApprovalScreen extends StatelessWidget {
  const AccountPendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xl,
            vertical: Spacing.base,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  _NotificationButton(
                    count: 1,
                    onTap: () => context.pushNamed(AppRoutes.notifications),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Lottie.asset(
                            'assets/animation/blue_loading.json',
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        SizedBox(
                          height: 155,
                          child: SvgPicture.asset(
                            'assets/images/fast_delivery.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Text(
                          'حسابك قيد المراجعة',
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          'تم استلام بياناتك بنجاح. سيقوم فريقنا بمراجعة الحساب وتفعيله قبل بدء استلام الطلبات.',
                          textAlign: TextAlign.center,
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.10),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.notifications_active_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'سيصلك إشعار جديد فور الموافقة على الحساب، ويمكنك متابعة كل التنبيهات من زر الإشعارات بالأعلى.',
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.base),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.secondary.withValues(alpha: 0.12),
                                AppColors.secondary.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled_rounded,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'عادةً تتم مراجعة الحساب خلال وقت قصير بعد التأكد من اكتمال البيانات.',
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.xl),
                        AppButton.filled(
                          text: 'العودة إلى تسجيل الدخول',
                          onPressed: () => context.pushNamedAndRemoveUntil(
                            AppRoutes.login,
                            predicate: (route) => false,
                          ),
                          height: 54,
                          borderRadius: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            top: -4,
            right: -2,
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
