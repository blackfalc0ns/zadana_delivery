import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key, required this.markers, required this.target});

  final Set<Marker> markers;
  final LatLng target;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MapCardHeader(),
          Stack(
            children: [
              SizedBox(
                height: 280,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: target,
                    zoom: 12.5,
                  ),
                  markers: markers,
                  gestureRecognizers: const {
                    Factory<OneSequenceGestureRecognizer>(
                      EagerGestureRecognizer.new,
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
              const _MapHintBadge(),
            ],
          ),
        ],
      ),
    );
  }
}

class MapCardHeader extends StatelessWidget {
  const MapCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.map_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              locale.order_details_route_map_title,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size15,
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapHintBadge extends StatelessWidget {
  const _MapHintBadge();

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    return Positioned(
      right: 12,
      top: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          locale.order_details_map_hint,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size10,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
