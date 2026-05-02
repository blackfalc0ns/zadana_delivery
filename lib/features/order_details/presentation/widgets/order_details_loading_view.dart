import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_scaffold.dart';

class OrderDetailsLoadingView extends StatelessWidget {
  const OrderDetailsLoadingView({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsScaffold(
      onBack: onBack,
      bottomActions: const _LoadingBottomAction(),
      child: const SkeletonStateWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(14, 8, 14, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LoadingStatusCard(),
                SizedBox(height: 10),
                _LoadingHeroCard(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _LoadingStatCard(
                        titleWidth: 56,
                        valueWidth: 82,
                        accent: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _LoadingStatCard(
                        titleWidth: 72,
                        valueWidth: 108,
                        accent: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _LoadingSectionCard(
                  titleWidthFactor: 0.40,
                  accent: AppColors.success,
                  child: _LoadingItemsPreview(),
                ),
                SizedBox(height: 10),
                _LoadingSectionCard(
                  titleWidthFactor: 0.34,
                  accent: AppColors.primary,
                  child: Column(
                    children: [
                      _LoadingInfoTile(),
                      SizedBox(height: 8),
                      _LoadingInfoTile(),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _LoadingSectionCard(
                  titleWidthFactor: 0.38,
                  accent: AppColors.secondary,
                  child: Column(
                    children: [
                      _LoadingInfoTile(),
                      SizedBox(height: 8),
                      _LoadingInfoTile(),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _LoadingMapCard(),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _LoadingRouteButton()),
                    SizedBox(width: 10),
                    Expanded(child: _LoadingRouteButton()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingStatusCard extends StatelessWidget {
  const _LoadingStatusCard();

  @override
  Widget build(BuildContext context) {
    return const _LoadingSurfaceCard(
      radius: 22,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            _LoadingStatusStep(),
            _LoadingStatusConnector(),
            _LoadingStatusStep(),
            _LoadingStatusConnector(),
            _LoadingStatusStep(),
            _LoadingStatusConnector(),
            _LoadingStatusStep(),
          ],
        ),
      ),
    );
  }
}

class _LoadingStatusStep extends StatelessWidget {
  const _LoadingStatusStep();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 64,
      child: Column(
        children: [
          _LoadingCircle(size: 40),
          SizedBox(height: 8),
          _LoadingLine(height: 10),
          SizedBox(height: 6),
          _LoadingLine(width: 44, height: 10),
        ],
      ),
    );
  }
}

class _LoadingStatusConnector extends StatelessWidget {
  const _LoadingStatusConnector();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 36),
        child: _LoadingLine(height: 4),
      ),
    );
  }
}

class _LoadingHeroCard extends StatelessWidget {
  const _LoadingHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.22),
            AppColors.primary.withValues(alpha: 0.12),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LoadingLine(width: 190, height: 22, isBright: true),
                    SizedBox(height: 10),
                    _LoadingLine(width: 132, height: 15, isBright: true),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _LoadingPill(width: 82, height: 42, radius: 999, isBright: true),
            ],
          ),
          SizedBox(height: 16),
          _LoadingPill(height: 54, radius: 18, isBright: true),
        ],
      ),
    );
  }
}

class _LoadingStatCard extends StatelessWidget {
  const _LoadingStatCard({
    required this.titleWidth,
    required this.valueWidth,
    required this.accent,
  });

  final double titleWidth;
  final double valueWidth;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return _LoadingSurfaceCard(
      radius: 20,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _LoadingPill(
            width: 42,
            height: 42,
            radius: 14,
            color: accent.withValues(alpha: 0.14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LoadingLine(width: titleWidth, height: 11),
                const SizedBox(height: 8),
                _LoadingLine(width: valueWidth, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingSectionCard extends StatelessWidget {
  const _LoadingSectionCard({
    required this.titleWidthFactor,
    required this.accent,
    required this.child,
  });

  final double titleWidthFactor;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _LoadingSurfaceCard(
      radius: 22,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LoadingCircle(size: 10, color: accent.withValues(alpha: 0.22)),
              const SizedBox(width: 8),
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: titleWidthFactor,
                  alignment: Alignment.centerLeft,
                  child: const _LoadingLine(height: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _LoadingItemsPreview extends StatelessWidget {
  const _LoadingItemsPreview();

  @override
  Widget build(BuildContext context) {
    return const _LoadingItemContainer(
      child: Row(
        children: [
          _LoadingPill(width: 44, height: 44, radius: 14),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _LoadingLine(height: 16)),
                    SizedBox(width: 10),
                    _LoadingLine(width: 96, height: 16),
                  ],
                ),
                SizedBox(height: 10),
                _LoadingLine(width: 132, height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingInfoTile extends StatelessWidget {
  const _LoadingInfoTile();

  @override
  Widget build(BuildContext context) {
    return const _LoadingItemContainer(
      height: 78,
      child: Row(
        children: [
          _LoadingPill(width: 40, height: 40, radius: 14),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LoadingLine(width: 72, height: 11),
                SizedBox(height: 8),
                _LoadingLine(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingMapCard extends StatelessWidget {
  const _LoadingMapCard();

  @override
  Widget build(BuildContext context) {
    return _LoadingSurfaceCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LoadingPill(
                width: 40,
                height: 40,
                radius: 14,
                color: AppColors.primary.withValues(alpha: 0.14),
              ),
              const SizedBox(width: 10),
              const _LoadingLine(width: 120, height: 16),
            ],
          ),
          const SizedBox(height: 14),
          const Stack(
            children: [
              _LoadingPill(height: 250, radius: 18),
              Positioned(
                top: 12,
                right: 12,
                child: _LoadingPill(width: 92, height: 28, radius: 999),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingRouteButton extends StatelessWidget {
  const _LoadingRouteButton();

  @override
  Widget build(BuildContext context) {
    return const _LoadingSurfaceCard(
      height: 54,
      radius: 22,
      borderAlpha: 0.12,
      shadowAlpha: 0.012,
    );
  }
}

class _LoadingBottomAction extends StatelessWidget {
  const _LoadingBottomAction();

  @override
  Widget build(BuildContext context) {
    return _LoadingSurfaceCard(
      height: 58,
      radius: 22,
      borderAlpha: 0.10,
      shadowAlpha: 0.01,
      color: AppColors.secondary.withValues(alpha: 0.12),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(child: _LoadingLine(height: 18, isBright: true)),
            SizedBox(width: 12),
            _LoadingCircle(size: 24, isBright: true),
          ],
        ),
      ),
    );
  }
}

class _LoadingItemContainer extends StatelessWidget {
  const _LoadingItemContainer({this.height = 84, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _LoadingSurfaceCard(
      height: height,
      radius: 16,
      borderAlpha: 0.10,
      shadowAlpha: 0,
      color: context.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: child,
    );
  }
}

class _LoadingSurfaceCard extends StatelessWidget {
  const _LoadingSurfaceCard({
    this.height,
    required this.radius,
    this.padding,
    this.child,
    this.color,
    this.borderAlpha = 0.14,
    this.shadowAlpha = 0.018,
  });

  final double? height;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color? color;
  final double borderAlpha;
  final double shadowAlpha;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? colorScheme.surfaceContainerLow.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: borderAlpha),
          width: 0.6,
        ),
        boxShadow: [
          if (shadowAlpha > 0)
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: shadowAlpha),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: child,
    );
  }
}

class _LoadingLine extends StatelessWidget {
  const _LoadingLine({this.width, this.height = 14, this.isBright = false});

  final double? width;
  final double height;
  final bool isBright;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isBright
            ? Colors.white.withValues(alpha: 0.34)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill({
    this.width,
    required this.height,
    required this.radius,
    this.color,
    this.isBright = false,
  });

  final double? width;
  final double height;
  final double radius;
  final Color? color;
  final bool isBright;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            color ??
            (isBright
                ? Colors.white.withValues(alpha: 0.24)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _LoadingCircle extends StatelessWidget {
  const _LoadingCircle({required this.size, this.color, this.isBright = false});

  final double size;
  final Color? color;
  final bool isBright;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color:
            color ??
            (isBright
                ? Colors.white.withValues(alpha: 0.28)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.22)),
        shape: BoxShape.circle,
      ),
    );
  }
}
