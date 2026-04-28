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
    required this.selectedRegionCode,
    required this.selectedZoneName,
    required this.selectedZoneCity,
    required this.onChanged,
    required this.onRetry,
    this.failure,
  });

  final List<DriverZoneEntity> zones;
  final bool isLoading;
  final String selectedZoneId;
  final String selectedRegionCode;
  final String selectedZoneName;
  final String selectedZoneCity;
  final Failure? failure;
  final ValueChanged<DriverZoneEntity> onChanged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final selectedZone = _findSelectedZone();
    final selectedRegion = selectedZone?.city ?? selectedZoneCity;
    final selectedCity = selectedZone?.name ?? selectedZoneName;

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
        if (isLoading)
          const _ZonesLoadingRow()
        else
          Row(
            children: [
              Expanded(
                child: _SelectorTile(
                  title: locale.driver_profile_zone_region_label,
                  value: selectedRegion,
                  placeholder: locale.driver_profile_zone_region_placeholder,
                  icon: Icons.map_outlined,
                  onTap: () => _showRegionPicker(context, selectedRegion),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _SelectorTile(
                  title: locale.driver_profile_zone_city_label,
                  value: selectedCity,
                  placeholder: locale.driver_profile_zone_city_placeholder,
                  icon: Icons.location_city_outlined,
                  onTap: _resolveCitiesForRegion(selectedRegion).isEmpty
                      ? null
                      : () => _showCityPicker(
                          context,
                          selectedRegion: selectedRegion,
                        ),
                ),
              ),
            ],
          ),
        if (failure != null) ...[
          const SizedBox(height: Spacing.sm),
          InlineApiErrorWidget(failure: failure!, onRetry: onRetry),
        ],
      ],
    );
  }

  DriverZoneEntity? _findSelectedZone() {
    for (final zone in zones) {
      if (zone.id == selectedZoneId) {
        return zone;
      }
    }
    return null;
  }

  List<_RegionGroup> _buildGroups() {
    final grouped = <String, List<DriverZoneEntity>>{};

    for (final zone in zones) {
      grouped.putIfAbsent(zone.city, () => <DriverZoneEntity>[]).add(zone);
    }

    final groups =
        grouped.entries
            .map(
              (entry) => _RegionGroup(
                code: entry.value.first.regionCode,
                name: entry.key,
                cities: List<DriverZoneEntity>.from(entry.value)
                  ..sort((first, second) => first.name.compareTo(second.name)),
              ),
            )
            .toList(growable: false)
          ..sort((first, second) => first.name.compareTo(second.name));

    return groups;
  }

  List<DriverZoneEntity> _resolveCitiesForRegion(String region) {
    for (final group in _buildGroups()) {
      if (group.name == region) {
        return group.cities;
      }
    }
    return const <DriverZoneEntity>[];
  }

  Future<void> _showRegionPicker(
    BuildContext context,
    String currentRegion,
  ) async {
    final locale = context.localization;
    final groups = _buildGroups();

    final selectedRegion = await showModalBottomSheet<_RegionGroup>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SelectionSheet<_RegionGroup>(
        title: locale.driver_profile_zone_region_sheet_title,
        subtitle: locale.driver_profile_zone_region_sheet_subtitle,
        items: groups,
        selectedValue: selectedRegionCode,
        itemTitle: (group) => group.name,
        itemSubtitle: (group) => locale.driver_profile_zone_cities_count(
          group.cities.length.toString(),
        ),
        itemIcon: Icons.map_outlined,
        onSelected: (group) => group,
        selectedMatcher: (group, selected) => group.code == selected,
      ),
    );

    if (selectedRegion == null) return;

    onChanged(
      DriverZoneEntity(
        id: '',
        regionCode: selectedRegion.code,
        city: selectedRegion.name,
        name: '',
        centerLat: 0,
        centerLng: 0,
        radiusKm: 0,
        isActive: true,
      ),
    );
  }

  Future<void> _showCityPicker(
    BuildContext context, {
    required String selectedRegion,
  }) async {
    final locale = context.localization;
    final cities = _resolveCitiesForRegion(selectedRegion);
    if (cities.isEmpty) return;

    final selectedCity = await showModalBottomSheet<DriverZoneEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SelectionSheet<DriverZoneEntity>(
        title: locale.driver_profile_zone_city_sheet_title,
        subtitle: locale.driver_profile_zone_city_sheet_subtitle,
        items: cities,
        selectedValue: selectedZoneId,
        itemTitle: (city) => city.name,
        itemSubtitle: (_) => selectedRegion,
        itemIcon: Icons.location_city_outlined,
        onSelected: (city) => city,
        selectedMatcher: (city, selected) => city.id == selected,
      ),
    );

    if (selectedCity != null) {
      onChanged(selectedCity);
    }
  }
}

class _ZonesLoadingRow extends StatelessWidget {
  const _ZonesLoadingRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _LoadingTile(icon: Icons.map_outlined)),
        SizedBox(width: Spacing.sm),
        Expanded(child: _LoadingTile(icon: Icons.location_city_outlined)),
      ],
    );
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                CustomProgressIndicator.compact(
                  size: 16,
                  tintColor: color.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.localization.driver_profile_zone_loading,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
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

class _SelectorTile extends StatelessWidget {
  const _SelectorTile({
    required this.title,
    required this.value,
    required this.placeholder,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String value;
  final String placeholder;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final hasValue = value.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: onTap == null ? color.surfaceContainerLow : color.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasValue
                ? color.primary.withValues(alpha: 0.55)
                : color.outlineVariant.withValues(alpha: 0.55),
          ),
          boxShadow: onTap == null
              ? null
              : [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasValue ? value : placeholder,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: hasValue
                        ? getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          )
                        : getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size13,
                            color: color.onSurfaceVariant,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: onTap == null
                  ? color.onSurfaceVariant.withValues(alpha: 0.45)
                  : color.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionSheet<T> extends StatelessWidget {
  const _SelectionSheet({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.selectedValue,
    required this.itemTitle,
    required this.itemSubtitle,
    required this.itemIcon,
    required this.onSelected,
    this.selectedMatcher,
  });

  final String title;
  final String subtitle;
  final List<T> items;
  final String selectedValue;
  final String Function(T item) itemTitle;
  final String Function(T item) itemSubtitle;
  final IconData itemIcon;
  final Object Function(T item) onSelected;
  final bool Function(T item, String selectedValue)? selectedMatcher;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
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
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
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
                  const SizedBox(height: 4),
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected =
                      selectedMatcher?.call(item, selectedValue) ??
                      itemTitle(item) == selectedValue;

                  return InkWell(
                    onTap: () => Navigator.of(context).pop(onSelected(item)),
                    borderRadius: BorderRadius.circular(22),
                    child: Ink(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.primary.withValues(alpha: 0.10)
                            : color.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isSelected
                              ? color.primary
                              : color.outlineVariant.withValues(alpha: 0.55),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.primary
                                  : color.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              itemIcon,
                              color: isSelected
                                  ? color.onPrimary
                                  : color.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemTitle(item),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size15,
                                    color: color.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  itemSubtitle(item),
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.cairo,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
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

class _RegionGroup {
  const _RegionGroup({
    required this.code,
    required this.name,
    required this.cities,
  });

  final String code;
  final String name;
  final List<DriverZoneEntity> cities;
}
