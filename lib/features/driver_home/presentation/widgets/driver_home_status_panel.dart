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
                  isMissionMode
                      ? Icons.local_shipping_rounded
                      : isOnline
                      ? Icons.bolt_rounded
                      : Icons.pause_circle_filled,
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
                      _title(context, isMissionMode),
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size18,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(context, isMissionMode),
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
            statusColor: statusColor,
            leadingText: _statusStripLeadingText(
              context,
              isMissionMode: isMissionMode,
              assignment: assignment,
            ),
            trailingText: _statusStripTrailingText(
              context,
              isMissionMode: isMissionMode,
            ),
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

  String _title(BuildContext context, bool isMissionMode) {
    if (isMissionMode) {
      return home.currentAssignment?.orderNumber ?? context.localization.order_details_title;
    }

    switch (home.homeState) {
      case 'Idle':
        return context.localization.driver_home_connection_online_title;
      case 'HasOffer':
        return home.currentOffer?.orderNumber ?? context.localization.driver_home_connection_online_title;
      default:
        return isOnline
            ? context.localization.driver_home_connection_online_title
            : context.localization.driver_home_connection_offline_title;
    }
  }

  String _subtitle(BuildContext context, bool isMissionMode) {
    if (isMissionMode) {
      return _localizedText(
        context,
        ar: 'لديك طلب جارٍ توصيله الآن. افتح التفاصيل لمتابعة المهمة وإكمالها.',
        en: 'You have an active delivery in progress. Open the details to continue the mission.',
      );
    }

    if (isOnline) {
      return _localizedText(
        context,
        ar: 'أنت جاهز الآن لاستقبال العروض الجديدة فور وصولها.',
        en: 'You are ready to receive new offers as soon as they arrive.',
      );
    }

    return _localizedText(
      context,
      ar: 'فعّل حالتك من الأعلى لتبدأ استقبال الطلبات.',
      en: 'Go online from the top switch to receive new orders.',
    );
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

  String _statusStripLeadingText(
    BuildContext context, {
    required bool isMissionMode,
    required DriverHomeAssignmentEntity? assignment,
  }) {
    if (isMissionMode && assignment != null) {
      return _assignmentStatusLabel(context, assignment.status);
    }

    if (isOnline) {
      return _localizedText(context, ar: 'متصل الآن', en: 'Online now');
    }

    return _localizedText(context, ar: 'متوقف مؤقتًا', en: 'Paused');
  }

  String _statusStripTrailingText(
    BuildContext context, {
    required bool isMissionMode,
  }) {
    if (isMissionMode) {
      return _localizedText(context, ar: 'مهمة جارية', en: 'Active mission');
    }

    if (isOnline) {
      return _localizedText(context, ar: 'جاهز للعروض', en: 'Ready for offers');
    }

    return _localizedText(context, ar: 'غير متصل', en: 'Offline mode');
  }

  String _assignmentStatusLabel(BuildContext context, String status) {
    final normalized = status.trim().toLowerCase().replaceAll('_', '');
    final locale = context.localization;

    switch (normalized) {
      case 'accepted':
      case 'orderaccepted':
        return locale.order_details_status_accepted;
      case 'arrivedatvendor':
        return locale.order_details_arrived_at_vendor;
      case 'pickedup':
      case 'pickedupfromstore':
        return locale.order_details_status_picked_up;
      case 'ontheway':
      case 'onthewaytocustomer':
      case 'startdelivery':
        return locale.order_details_status_on_the_way;
      case 'arrivedatcustomer':
        return locale.order_details_arrived_at_customer;
      case 'delivered':
      case 'completed':
        return locale.order_details_status_delivered;
      default:
        return status;
    }
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MissionHeader(
            title: assignment.vendorName,
            subtitle: assignment.deliveryAddress,
          ),
          const SizedBox(height: 12),
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
    required this.statusColor,
    required this.leadingText,
    required this.trailingText,
  });

  final Color statusColor;
  final String leadingText;
  final String trailingText;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leadingText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
                fontSize: FontSize.size14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  trailingText,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: statusColor,
                    fontSize: FontSize.size11,
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

class _MissionHeader extends StatelessWidget {
  const _MissionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: scheme.onSurface,
                  fontSize: FontSize.size17,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.storefront_rounded,
            color: scheme.primary,
            size: 22,
          ),
        ),
      ],
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
