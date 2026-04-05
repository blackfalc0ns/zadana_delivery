import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverOrderPreview {
  const DriverOrderPreview({
    required this.id,
    required this.title,
    required this.vendorName,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.customerName,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.distance,
    required this.eta,
    required this.payout,
    required this.vendorInitials,
    required this.customerInitials,
    this.orderItems = const [],
    this.packageNote,
    this.countdownSeconds = 60,
  });

  final String id;
  final String title;
  final String vendorName;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String customerName;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String distance;
  final String eta;
  final String payout;
  final String vendorInitials;
  final String customerInitials;
  final List<DriverOrderItemPreview> orderItems;
  final String? packageNote;
  final int countdownSeconds;
}

class DriverOrderItemPreview {
  const DriverOrderItemPreview({
    required this.name,
    required this.quantity,
    this.note,
  });

  final String name;
  final int quantity;
  final String? note;
}

class IncomingOrderCard extends StatefulWidget {
  const IncomingOrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
    required this.onExpired,
    this.onLocationTap,
  });

  final DriverOrderPreview order;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onExpired;
  final VoidCallback? onLocationTap;

  @override
  State<IncomingOrderCard> createState() => _IncomingOrderCardState();
}

class _IncomingOrderCardState extends State<IncomingOrderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _expiredNotified = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: Duration(seconds: widget.order.countdownSeconds),
          )
          ..addListener(_handleProgress)
          ..forward();
  }

  void _handleProgress() {
    if (_expiredNotified || _controller.status != AnimationStatus.completed) {
      return;
    }
    _expiredNotified = true;
    widget.onExpired();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleProgress)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final payoutValue = widget.order.payout
        .replaceAll(RegExp(r'[^\d.]'), '')
        .trim();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (1 - _controller.value).clamp(0.0, 1.0);

        return CustomPaint(
          painter: _CardCountdownPainter(
            progress: progress,
            accentColor: color.secondary,
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CompactOrderMeta(
                        payout: payoutValue.isEmpty
                            ? widget.order.payout
                            : payoutValue,
                        distance: widget.order.distance,
                        eta: widget.order.eta,
                      ),
                      if (widget.onLocationTap != null) ...[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: _LocationActionButton(
                            onTap: widget.onLocationTap!,
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _MiniRow(
                              icon: Icons.storefront_rounded,
                              label: 'الاستلام',
                              value: widget.order.vendorName,
                              color: color.primary,
                            ),
                            const SizedBox(height: 4),
                            _MiniRow(
                              icon: Icons.location_on_rounded,
                              label: 'التوصيل',
                              value: widget.order.deliveryAddress,
                              color: color.secondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'قبول',
                          foreground: Colors.white,
                          background: color.primary,
                          borderColor: color.primary,
                          onTap: widget.onAccept,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: _ActionButton(
                          label: 'رفض',
                          foreground: color.error,
                          background: color.error.withValues(alpha: 0.08),
                          borderColor: color.error.withValues(alpha: 0.16),
                          onTap: widget.onReject,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactOrderMeta extends StatelessWidget {
  const _CompactOrderMeta({
    required this.payout,
    required this.distance,
    required this.eta,
  });

  final String payout;
  final String distance;
  final String eta;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 76, maxWidth: 92),
      child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: payout,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: color.primary,
                  ),
                ),
                TextSpan(
                  text: ' ريال',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            distance,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: color.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.foreground,
    required this.background,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Ink(
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationActionButton extends StatelessWidget {
  const _LocationActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Material(
      color: color.primary.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.primary.withValues(alpha: 0.15)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.my_location_rounded, size: 14, color: color.primary),
              const SizedBox(width: 4),
              Text(
                'عرض الموقع',
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: color.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniRow extends StatelessWidget {
  const _MiniRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$label:',
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardCountdownPainter extends CustomPainter {
  _CardCountdownPainter({required this.progress, required this.accentColor});

  final double progress;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final borderRect = rect.deflate(2.4);
    const radius = 16.5;
    final rrect = RRect.fromRectAndRadius(
      borderRect,
      const Radius.circular(radius),
    );

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = accentColor.withValues(alpha: 0.16);
    canvas.drawRRect(rrect, basePaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [accentColor.withValues(alpha: 0.55), accentColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final path = _buildTopStartPath(borderRect, radius);
    final metric = path.computeMetrics().first;
    final visibleLength = metric.length * progress;
    final extracted = metric.extractPath(
      0,
      visibleLength.clamp(0.0, metric.length),
    );
    canvas.drawPath(extracted, progressPaint);
  }

  Path _buildTopStartPath(Rect rect, double radius) {
    final path = Path();
    final left = rect.left;
    final top = rect.top;
    final right = rect.right;
    final bottom = rect.bottom;
    final centerX = rect.center.dx;

    path.moveTo(centerX, top);
    path.lineTo(right - radius, top);
    path.arcToPoint(
      Offset(right, top + radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(right, bottom - radius);
    path.arcToPoint(
      Offset(right - radius, bottom),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(left + radius, bottom);
    path.arcToPoint(
      Offset(left, bottom - radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(left, top + radius);
    path.arcToPoint(
      Offset(left + radius, top),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(centerX, top);

    return path;
  }

  @override
  bool shouldRepaint(covariant _CardCountdownPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor;
  }
}
