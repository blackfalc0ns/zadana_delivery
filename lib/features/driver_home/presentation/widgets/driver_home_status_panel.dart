import 'package:flutter/material.dart';
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
    this.isToggleEnabled = true,
    this.isToggleLoading = false,
  });

  final DriverHomeEntity home;
  final bool isOnline;
  final bool canReceiveOffers;
  final VoidCallback onOpenMission;
  final VoidCallback onToggleAvailability;
  final bool isToggleEnabled;
  final bool isToggleLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final assignment = home.currentAssignment;
    final earnings = home.earningsSummaryToday;
    final isMissionMode = home.homeState == 'OnMission' && assignment != null;
    final statusMessage = _statusMessage(context);
    final statusHint = _statusHint(context, isMissionMode);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        Spacing.base,
        0,
        Spacing.base,
        Spacing.base,
      ),
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _title(context),
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            statusMessage,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
          if (statusHint != null) ...[
            const SizedBox(height: Spacing.sm),
            _CalloutBanner(
              icon: isOnline ? Icons.bolt_rounded : Icons.toggle_off_rounded,
              text: statusHint,
              color: isOnline ? color.primary : color.outline,
            ),
          ],
          if (home.operationalStatus.zoneName.trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            _InfoChip(
              icon: Icons.place_outlined,
              text: home.operationalStatus.zoneName,
            ),
          ],
          if ((home.operationalStatus.restrictionMessage ?? '')
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            _InfoChip(
              icon: Icons.info_outline_rounded,
              text: home.operationalStatus.restrictionMessage!,
              color: color.error,
            ),
          ],
          const SizedBox(height: Spacing.base),
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
            AppButton.filled(
              text: isOnline
                  ? context.localization.driver_home_connection_offline_title
                  : context.localization.driver_home_connection_online_title,
              icon: isOnline
                  ? Icons.toggle_off_rounded
                  : Icons.toggle_on_rounded,
              onPressed: isToggleEnabled ? onToggleAvailability : null,
              isLoading: isToggleLoading,
              height: 50,
              borderRadius: 18,
              color: isOnline ? color.outline : color.primary,
              textColor: isOnline ? color.onSurface : color.onPrimary,
            ),
            const SizedBox(height: Spacing.base),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.payments_outlined,
                    value: earnings == null
                        ? '--'
                        : '${earnings.earningsAmount.toStringAsFixed(2)} ${context.localization.currency}',
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.local_shipping_outlined,
                    value: earnings == null
                        ? '--'
                        : '${earnings.completedTrips}',
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.notifications_none_rounded,
                    value: '${home.unreadAlerts}',
                  ),
                ),
              ],
            ),
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

  String _statusMessage(BuildContext context) {
    final apiMessage = home.operationalStatus.message.trim();
    if (apiMessage.isNotEmpty) return apiMessage;
    if (!isOnline) return 'أنت الآن غير متصل، لذلك لن تظهر لك طلبات جديدة.';
    if (!canReceiveOffers) {
      return 'التواجد مفعّل، لكن استقبال الطلبات غير متاح حاليًا.';
    }
    return 'أنت متصل الآن، وسيتم عرض الطلبات الجديدة فور وصولها.';
  }

  String? _statusHint(BuildContext context, bool isMissionMode) {
    if (isMissionMode) return null;
    if (!isOnline) return 'فعّل زر التواجد من الأعلى لبدء استقبال الطلبات.';
    if (!canReceiveOffers) {
      return 'راجع سبب التقييد الظاهر بالأسفل أو انتظر حتى تصبح متاحًا.';
    }
    return 'تابع الخريطة وكارت الطلبات عند وصول أي عرض جديد.';
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
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: color.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalloutBanner extends StatelessWidget {
  const _CalloutBanner({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final resolvedColor = color ?? scheme.primary;
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
