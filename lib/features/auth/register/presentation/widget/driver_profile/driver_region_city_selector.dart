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
    this.regionCities = const [],
    required this.isLoading,
    this.isCitiesLoading = false,
    this.selectedCityId = '',
    required this.selectedRegionCode,
    this.selectedCityName = '',
    required this.selectedRegionName,
    required this.regions,
    required this.onRegionSelected,
    this.onCitySelected,
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
  final ValueChanged<DriverRegionCityEntity>? onCitySelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final selectedRegion = selectedRegionName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.driver_profile_zone_region_label,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        if (isLoading)
          const _LoadingTile(icon: Icons.map_outlined)
        else
          _SelectorTile(
            title: locale.driver_profile_zone_region_label,
            value: selectedRegion,
            placeholder: locale.driver_profile_zone_region_placeholder,
            icon: Icons.map_outlined,
            onTap: () => _showRegionPicker(context),
          ),
        if (failure != null) ...[
          const SizedBox(height: Spacing.sm),
          InlineApiErrorWidget(failure: failure!, onRetry: onRetry),
        ],
        if (citiesFailure != null) ...[
          const SizedBox(height: Spacing.sm),
          InlineApiErrorWidget(failure: citiesFailure!, onRetry: onRetry),
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
        emptyMessage: locale.driver_profile_zone_empty,
        itemTitle: (region) => region.name,
        itemSubtitle: (_) => '',
        itemIcon: Icons.map_outlined,
        itemEnabled: (region) => region.isOperational,
        itemBadge: (region) =>
            !region.isOperational
                ? locale.driver_profile_region_coming_soon
                : null,
        onSelected: (region) => region,
        selectedMatcher: (region, selected) => region.code == selected,
      ),
    );

    if (selected == null) return;

    onRegionSelected(selected.code, selected.name);
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
    required this.emptyMessage,
    required this.itemTitle,
    required this.itemSubtitle,
    required this.itemIcon,
    required this.onSelected,
    this.itemEnabled,
    this.itemBadge,
    this.selectedMatcher,
  });

  final String title;
  final String subtitle;
  final List<T> items;
  final String selectedValue;
  final String emptyMessage;
  final String Function(T item) itemTitle;
  final String Function(T item) itemSubtitle;
  final IconData itemIcon;
  final Object Function(T item) onSelected;
  final bool Function(T item)? itemEnabled;
  final String? Function(T item)? itemBadge;
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
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          emptyMessage,
                          textAlign: TextAlign.center,
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isEnabled = itemEnabled?.call(item) ?? true;
                        final badge = itemBadge?.call(item);
                        final isSelected =
                            isEnabled &&
                            (selectedMatcher?.call(item, selectedValue) ??
                                itemTitle(item) == selectedValue);

                        return Opacity(
                          opacity: isEnabled ? 1.0 : 0.55,
                          child: InkWell(
                            onTap: isEnabled
                                ? () => Navigator.of(
                                    context,
                                  ).pop(onSelected(item))
                                : null,
                            borderRadius: BorderRadius.circular(22),
                            child: Ink(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.primary.withValues(alpha: 0.10)
                                    : isEnabled
                                        ? color.surfaceContainerLow
                                        : color.surfaceContainerHighest
                                            .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? color.primary
                                      : color.outlineVariant.withValues(
                                          alpha: 0.55,
                                        ),
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
                                          : isEnabled
                                              ? color.primary.withValues(
                                                  alpha: 0.10,
                                                )
                                              : color.outlineVariant
                                                  .withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      itemIcon,
                                      color: isSelected
                                          ? color.onPrimary
                                          : isEnabled
                                              ? color.primary
                                              : color.onSurfaceVariant
                                                  .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                itemTitle(item),
                                                style: getBoldStyle(
                                                  fontFamily:
                                                      FontConstant.cairo,
                                                  fontSize: FontSize.size15,
                                                  color: isEnabled
                                                      ? color.onSurface
                                                      : color.onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                            if (badge != null)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: color.surfaceContainerHighest,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: color.outlineVariant,
                                                  ),
                                                ),
                                                child: Text(
                                                  badge,
                                                  style: getMediumStyle(
                                                    fontFamily:
                                                        FontConstant.cairo,
                                                    fontSize: FontSize.size11,
                                                    color: color.onSurfaceVariant,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        if (itemSubtitle(item).trim().isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            itemSubtitle(item),
                                            style: getRegularStyle(
                                              fontFamily: FontConstant.cairo,
                                              color: color.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (isEnabled)
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.circle_outlined,
                                      color: isSelected
                                          ? color.primary
                                          : color.outline,
                                    ),
                                ],
                              ),
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
