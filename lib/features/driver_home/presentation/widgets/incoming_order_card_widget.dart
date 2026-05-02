import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card_actions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card_content.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card_painter.dart';

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
  late AnimationController _controller;
  VoidCallback? _progressListener;
  bool _expiredNotified = false;

  @override
  void initState() {
    super.initState();
    _controller = _buildController();
  }

  @override
  void didUpdateWidget(covariant IncomingOrderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.id == widget.order.id &&
        oldWidget.order.countdownSeconds == widget.order.countdownSeconds) {
      return;
    }

    _detachControllerListener();
    _controller.dispose();
    _expiredNotified = false;
    _controller = _buildController();
  }

  AnimationController _buildController() {
    final controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.order.countdownSeconds),
    );
    final progressListener = _createProgressListener(controller);
    _progressListener = progressListener;
    controller.addListener(progressListener);

    if (widget.order.countdownSeconds <= 0) {
      controller.value = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _expiredNotified) return;
        _handleProgress(controller);
      });
    } else {
      controller.forward();
    }

    return controller;
  }

  VoidCallback _createProgressListener(AnimationController controller) {
    return () => _handleProgress(controller);
  }

  void _handleProgress(AnimationController controller) {
    if (_expiredNotified || controller.status != AnimationStatus.completed) {
      return;
    }
    _expiredNotified = true;
    widget.onExpired();
  }

  void _detachControllerListener() {
    final progressListener = _progressListener;
    if (progressListener == null) return;
    _controller.removeListener(progressListener);
    _progressListener = null;
  }

  @override
  void dispose() {
    _detachControllerListener();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final compact = MediaQuery.sizeOf(context).width < 360;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => CustomPaint(
        painter: IncomingOrderCardCountdownPainter(
          progress: (1 - _controller.value).clamp(0.0, 1.0),
          accentColor: color.secondary,
        ),
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap,
            child: Container(
              padding: EdgeInsets.all(compact ? 6 : 8),
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
                  _IncomingOrderHeader(
                    order: widget.order,
                    onLocationTap: widget.onLocationTap,
                    compact: compact,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: IncomingOrderActionButton(
                          label: locale.driver_home_accept,
                          foreground: Colors.white,
                          background: color.primary,
                          borderColor: color.primary,
                          onTap: widget.onAccept,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: IncomingOrderActionButton(
                          label: locale.driver_home_reject,
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

class _IncomingOrderHeader extends StatelessWidget {
  const _IncomingOrderHeader({
    required this.order,
    required this.onLocationTap,
    required this.compact,
  });

  final DriverOrderPreview order;
  final VoidCallback? onLocationTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Row(
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IncomingOrderCardMeta(
              codAmount: order.codAmount,
              paymentMethod: order.paymentMethod,
              distance: order.distance,
            ),
            if (onLocationTap != null) ...[
              const SizedBox(height: 8),
              IncomingOrderLocationButton(onTap: onLocationTap!),
            ],
          ],
        ),
        SizedBox(width: compact ? 4 : 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IncomingOrderMiniRow(
                icon: Icons.storefront_rounded,
                label: locale.driver_home_pickup_label,
                value: _pickupSummary,
                color: color.primary,
              ),
              const SizedBox(height: 4),
              IncomingOrderMiniRow(
                icon: Icons.location_on_rounded,
                label: locale.driver_home_delivery_label,
                value: _deliverySummary,
                color: color.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get _pickupSummary {
    final vendorName = order.vendorName.trim();
    final pickupAddress = order.pickupAddress.trim();
    if (vendorName.isEmpty) return pickupAddress;
    if (pickupAddress.isEmpty) return vendorName;
    return '$vendorName, $pickupAddress';
  }

  String get _deliverySummary {
    final customerName = order.customerName.trim();
    final deliveryAddress = order.deliveryAddress.trim();
    if (customerName.isEmpty) return deliveryAddress;
    if (deliveryAddress.isEmpty) return customerName;
    return '$customerName, $deliveryAddress';
  }
}
