import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_region_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';

class DriverRegionCitySelector extends StatelessWidget {
  const DriverRegionCitySelector({
    super.key,
    required this.regionCities,
    required this.isLoading,
    required this.isCitiesLoading,
    required this.selectedCityId,
    required this.selectedRegionCode,
    required this.selectedCityName,
    required this.selectedRegionName,
    required this.regions,
    required this.onRegionSelected,
    required this.onCitySelected,
    required this.onRetry,
    this.failure,
    this.citiesFailure,
  });

  final List<DriverRegionCityEntity> regionCities;
  final bool isLoading;
  final bool isCitiesLoading;
  final String selectedCityId;
  final String selectedRegionCode;
  final String selectedCityName;
  final String selectedRegionName;
  final List<DriverRegionEntity> regions;
  final Failure? failure;
  final Failure? citiesFailure;
  final void Function(String regionCode, String regionName) onRegionSelected;
  final ValueChanged<DriverRegionCityEntity> onCitySelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final selectedRegion = selectedRegionName;
    final selectedCity = selectedCityName;
    final showEmptyCitiesMessage =
        !isLoading &&
        !isCitiesLoading &&
        citiesFailure == null &&
        selectedRegionCode.trim().isNotEmpty &&
        regionCities.isEmpty;

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
                  onTap: () => _showRegionPicker(context),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: isCitiesLoading
                    ? const _LoadingTile(icon: Icons.location_city_outlined)
                    : _SelectorTile(
                        title: locale.driver_profile_zone_city_label,
                        value: selectedCity,
                        placeholder:
                            locale.driver_profile_zone_city_placeholder,
                        icon: Icons.location_city_outlined,
                        onTap:
                            regionCities.isEmpty || selectedRegionCode.isEmpty
                            ? null
                            : () => _showCityPicker(context),
                      ),
              ),
            ],
          ),
        if (failure != null) ...[
          const SizedBox(height: Spacing.sm),
          InlineApiErrorWidget(failure: failure!, onRetry: onRetry),
        ],
        if (citiesFailure != null) ...[
          const SizedBox(height: Spacing.sm),
          InlineApiErrorWidget(failure: citiesFailure!, onRetry: onRetry),
        ],
        if (showEmptyCitiesMessage) ...[
          const SizedBox(height: Spacing.sm),
          _EmptyCitiesMessage(regionName: selectedRegionName),
        ],
      ],
    );
  }

  Future<void> _showRegionPicker(BuildContext context) async {
    final locale = context.localization;

    final selected = await showModalBottomSheet<DriverRegionEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SelectionSheet<DriverRegionEntity>(
        title: locale.driver_profile_zone_region_sheet_title,
        subtitle: locale.driver_profile_zone_region_sheet_subtitle,
        items: regions,
        selectedValue: selectedRegionCode,
        itemTitle: (region) => region.name,
        itemSubtitle: (_) => '',
        itemIcon: Icons.map_outlined,
        onSelected: (region) => region,
        selectedMatcher: (region, selected) => region.code == selected,
      ),
    );

    if (selected == null) return;

    onRegionSelected(selected.code, selected.name);
  }

  Future<void> _showCityPicker(BuildContext context) async {
    final locale = context.localization;
    if (regionCities.isEmpty) return;

    final selectedCity = await showModalBottomSheet<DriverRegionCityEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SelectionSheet<DriverRegionCityEntity>(
        title: locale.driver_profile_zone_city_sheet_title,
        subtitle: locale.driver_profile_zone_city_sheet_subtitle,
        items: regionCities,
        selectedValue: selectedCityId,
        itemTitle: (city) => city.cityName,
        itemSubtitle: (_) => selectedRegionName,
        itemIcon: Icons.location_city_outlined,
        onSelected: (city) => city,
        selectedMatcher: (city, selected) => city.id == selected,
      ),
    );

    if (selectedCity != null) {
      onCitySelected(selectedCity);
    }
  }
}

class _EmptyCitiesMessage extends StatelessWidget {
  const _EmptyCitiesMessage({required this.regionName});

  final String regionName;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final normalizedRegionName = regionName.trim();
    final message = normalizedRegionName.isEmpty
        ? locale.driver_profile_zone_no_cities
        : locale.driver_profile_zone_no_cities_for_region(normalizedRegionName);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.error.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: color.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
                fontSize: FontSize.size13,
              ),
            ),
          ),
        ],
      ),
    );
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
