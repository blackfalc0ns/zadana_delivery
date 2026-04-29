import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';

class DriverHomeStatusPanel extends StatelessWidget {
  const DriverHomeStatusPanel({
    super.key,
    required this.home,
    required this.isOnline,
    required this.canReceiveOffers,
    required this.onOpenMission,
    required this.onToggleAvailability,
    this.onDisabledToggleTap,
    this.isToggleEnabled = true,
    this.isToggleLoading = false,
  });

  final DriverHomeEntity home;
  final bool isOnline;
  final bool canReceiveOffers;
  final VoidCallback onOpenMission;
  final VoidCallback onToggleAvailability;
  final VoidCallback? onDisabledToggleTap;
  final bool isToggleEnabled;
  final bool isToggleLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final assignment = home.currentAssignment;
    final isMissionMode = home.homeState == 'OnMission' && assignment != null;
    final statusHint = _statusHint(context, isMissionMode);
    final statusColor = isOnline ? color.primary : AppColors.secondary;
    final title = _title(context);
    final subtitle = isOnline
        ? _localizedText(
            context,
            ar: 'أنت جاهز الآن لاستقبال العروض الجديدة فور وصولها.',
            en: 'You are ready to receive new offers as soon as they arrive.',
          )
        : _localizedText(
            context,
            ar: 'فعّل حالتك من الأعلى لتبدأ استقبال الطلبات.',
            en: 'Go online from the top switch to receive new orders.',
          );

    return Container(
      margin: const EdgeInsets.fromLTRB(
        Spacing.base,
        0,
        Spacing.base,
        Spacing.base,
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isOnline ? Icons.bolt_rounded : Icons.pause_circle_filled,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size18,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StatusStrip(
            isOnline: isOnline,
            statusColor: statusColor,
            text: isOnline ? 'Live' : 'Paused',
          ),
          if (statusHint != null) ...[
            const SizedBox(height: 12),
            _SoftMessage(
              icon: Icons.auto_awesome_rounded,
              text: statusHint,
              color: statusColor,
            ),
          ],
          if (home.operationalStatus.zoneName.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _SoftMessage(
              icon: Icons.place_outlined,
              text: home.operationalStatus.zoneName,
              color: color.primary,
            ),
          ],
          if ((home.operationalStatus.restrictionMessage ?? '')
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 10),
            _SoftMessage(
              icon: Icons.info_outline_rounded,
              text: home.operationalStatus.restrictionMessage!,
              color: color.error,
            ),
          ],
          const SizedBox(height: 8),
          if (isMissionMode) ...[
            _MissionSummary(assignment: assignment),
            const SizedBox(height: Spacing.base),
            AppButton.filled(
              text: context.localization.order_details_title,
              onPressed: onOpenMission,
              height: 50,
              borderRadius: 18,
            ),
          ] else ...[
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }

  String _title(BuildContext context) {
    switch (home.homeState) {
      case 'WaitingForOffer':
        return context.localization.driver_home_connection_online_title;
      case 'Offline':
        return context.localization.driver_home_connection_offline_title;
      case 'OnMission':
        return home.currentAssignment?.orderNumber ?? home.homeState;
      default:
        return home.homeState;
    }
  }

  String? _statusHint(BuildContext context, bool isMissionMode) {
    if (isMissionMode) return null;
    if (!isOnline) {
      return _localizedText(
        context,
        ar: 'فعّل زر التواجد من الأعلى لبدء استقبال الطلبات.',
        en: 'Go online to start receiving new orders.',
      );
    }
    if (!canReceiveOffers) {
      return _localizedText(
        context,
        ar: 'راجع سبب التقييد الظاهر بالأسفل أو انتظر حتى تصبح متاحًا.',
        en: 'Check the restriction shown below or wait until offers become available again.',
      );
    }
    return _localizedText(
      context,
      ar: 'تابع الخريطة وكارت الطلبات عند وصول أي عرض جديد.',
      en: 'Keep an eye on the map and incoming offers for new assignments.',
    );
  }

  String _localizedText(
    BuildContext context, {
    required String ar,
    required String en,
  }) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return languageCode.toLowerCase() == 'ar' ? ar : en;
  }
}

class _MissionSummary extends StatelessWidget {
  const _MissionSummary({required this.assignment});

  final DriverHomeAssignmentEntity assignment;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assignment.vendorName,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            assignment.deliveryAddress,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _InfoChip(icon: Icons.flag_outlined, text: assignment.status),
              const SizedBox(width: Spacing.sm),
              _InfoChip(
                icon: Icons.payments_outlined,
                text:
                    '${assignment.codAmount.toStringAsFixed(2)} ${context.localization.currency}',
              ),
            ],
          ),
          if ((assignment.pickupOtpCode ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.secondary.withValues(alpha: 0.18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _pickupOtpHint(context),
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assignment.pickupOtpCode!,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size24,
                      color: color.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _pickupOtpHint(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode.toLowerCase() == 'ar') {
      return 'أظهر هذا الرمز للتاجر';
    }
    return 'Show this code to the merchant';
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({
    required this.isOnline,
    required this.statusColor,
    required this.text,
  });

  final bool isOnline;
  final Color statusColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            isOnline ? 'Ready for offers' : 'Offline mode',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftMessage extends StatelessWidget {
  const _SoftMessage({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                color: scheme.onSurfaceVariant,
              ).copyWith(height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final resolvedColor = scheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: resolvedColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: resolvedColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                color: resolvedColor,
                fontSize: FontSize.size11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
