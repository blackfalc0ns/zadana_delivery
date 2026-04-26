import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';

class DriverZoneSelector extends StatelessWidget {
  const DriverZoneSelector({
    super.key,
    required this.zones,
    required this.isLoading,
    required this.selectedZoneId,
    required this.selectedZoneName,
    required this.selectedZoneCity,
    required this.onChanged,
    required this.onRetry,
    this.failure,
  });

  final List<DriverZoneEntity> zones;
  final bool isLoading;
  final String selectedZoneId;
  final String selectedZoneName;
  final String selectedZoneCity;
  final Failure? failure;
  final ValueChanged<DriverZoneEntity> onChanged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    DriverZoneEntity? selectedZone;

    for (final zone in zones) {
      if (zone.id == selectedZoneId) {
        selectedZone = zone;
        break;
      }
    }

    final selectedTitle = selectedZone?.name ?? selectedZoneName;
    final selectedSubtitle = selectedZone != null
        ? '${selectedZone.city} • ${selectedZone.radiusKm.toStringAsFixed(0)} km'
        : selectedZoneCity.trim().isNotEmpty
        ? selectedZoneCity
        : locale.driver_profile_zone_hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.driver_profile_zone_label,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        InkWell(
          onTap: isLoading ? null : () => _showZonePicker(context),
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  color.primary.withValues(alpha: 0.10),
                  color.tertiary.withValues(alpha: 0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: color.primary.withValues(alpha: 0.26)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.map_outlined, color: color.primary),
                ),
                const SizedBox(width: Spacing.base),
                Expanded(
                  child: isLoading
                      ? _ZoneLoadingState(
                          title: locale.driver_profile_zone_loading,
                        )
                      : _ZoneSummary(
                          title: selectedTitle.isEmpty
                              ? locale.driver_profile_zone_placeholder
                              : selectedTitle,
                          subtitle: selectedSubtitle,
                        ),
                ),
                const SizedBox(width: Spacing.sm),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: color.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (failure != null) ...[
          const SizedBox(height: Spacing.sm),
          InlineApiErrorWidget(failure: failure!, onRetry: onRetry),
        ],
      ],
    );
  }

  Future<void> _showZonePicker(BuildContext context) async {
    final selected = await showModalBottomSheet<DriverZoneEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _ZonePickerSheet(zones: zones, selectedZoneId: selectedZoneId),
    );

    if (selected != null) {
      onChanged(selected);
    }
  }
}

class _ZoneLoadingState extends StatelessWidget {
  const _ZoneLoadingState({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CustomProgressIndicator.compact(size: 18, tintColor: color.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ZoneSummary extends StatelessWidget {
  const _ZoneSummary({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size15,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ZonePickerSheet extends StatelessWidget {
  const _ZonePickerSheet({required this.zones, required this.selectedZoneId});

  final List<DriverZoneEntity> zones;
  final String selectedZoneId;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.78,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: color.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.driver_profile_zone_sheet_title,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size18,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          locale.driver_profile_zone_sheet_subtitle,
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
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: zones.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final zone = zones[index];
                  final isSelected = zone.id == selectedZoneId;

                  return InkWell(
                    onTap: () => Navigator.of(context).pop(zone),
                    borderRadius: BorderRadius.circular(24),
                    child: Ink(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.primary.withValues(alpha: 0.10)
                            : color.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? color.primary
                              : color.outlineVariant.withValues(alpha: 0.55),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.primary
                                  : color.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              Icons.place_outlined,
                              color: isSelected
                                  ? color.onPrimary
                                  : color.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  zone.name,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size15,
                                    color: color.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${zone.city} • ${locale.driver_profile_zone_radius(zone.radiusKm.toStringAsFixed(0))}',
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.cairo,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            color: isSelected ? color.primary : color.outline,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
