import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_body.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_bottom_actions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_scaffold.dart';

class OrderDetailsScreenView extends StatefulWidget {
  const OrderDetailsScreenView({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onAcceptOrder,
    required this.onRejectOrder,
    required this.onArrivedAtVendor,
    required this.onShowPickupOtp,
    required this.onArrivedAtCustomer,
    required this.onShowCustomerOtp,
    required this.onStartDelivery,
    required this.onShowItems,
    required this.onCallStore,
    required this.onCallCustomer,
    required this.onOpenStoreRoute,
    required this.onOpenCustomerRoute,
    required this.onFinish,
    required this.onRefresh,
    required this.onOpenSupportComposer,
    required this.onResendPickupOtp,
    this.isActionLoading = false,
  });

  final OrderDetailsController controller;
  final VoidCallback onBack;
  final VoidCallback onAcceptOrder;
  final VoidCallback onRejectOrder;
  final VoidCallback onArrivedAtVendor;
  final VoidCallback onShowPickupOtp;
  final VoidCallback onArrivedAtCustomer;
  final VoidCallback onStartDelivery;
  final VoidCallback onShowCustomerOtp;
  final VoidCallback onShowItems;
  final VoidCallback onCallStore;
  final VoidCallback onCallCustomer;
  final VoidCallback onOpenStoreRoute;
  final VoidCallback onOpenCustomerRoute;
  final VoidCallback onFinish;
  final Future<void> Function() onRefresh;
  final VoidCallback onOpenSupportComposer;
  final Future<bool> Function() onResendPickupOtp;
  final bool isActionLoading;

  @override
  State<OrderDetailsScreenView> createState() => _OrderDetailsScreenViewState();
}

class _OrderDetailsScreenViewState extends State<OrderDetailsScreenView> {
  static const Duration _refreshAnimationDuration = Duration(milliseconds: 700);

  bool _isRefreshing = false;
  double _refreshTurns = 0;

  Future<void> _handleRefresh() async {
    if (widget.isActionLoading || _isRefreshing) return;

    HapticFeedback.selectionClick();
    setState(() {
      _isRefreshing = true;
      _refreshTurns += 1;
    });

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        await Future<void>.delayed(const Duration(milliseconds: 220));
      }
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Widget _buildRefreshAction(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsetsDirectional.only(end: 4),
      decoration: BoxDecoration(
        color: _isRefreshing
            ? scheme.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: _isRefreshing
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.18),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : const [],
      ),
      child: IconButton(
        onPressed: widget.isActionLoading ? null : _handleRefresh,
        icon: AnimatedRotation(
          turns: _refreshTurns,
          duration: _refreshAnimationDuration,
          curve: Curves.easeInOutCubic,
          child: Icon(
            Icons.refresh_rounded,
            color: _isRefreshing ? scheme.primary : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return OrderDetailsScaffold(
      onBack: widget.onBack,
      actions: [
        IconButton(
          onPressed: widget.isActionLoading
              ? null
              : widget.onOpenSupportComposer,
          icon: const Icon(Icons.support_agent_rounded),
        ),
        _buildRefreshAction(context),
      ],
      bottomActions: AnimatedBuilder(
        animation: widget.controller,
        builder: (_, _) => OrderDetailsBottomActions(
          controller: widget.controller,
          onAcceptOrder: widget.onAcceptOrder,
          onRejectOrder: widget.onRejectOrder,
          onArrivedAtVendor: widget.onArrivedAtVendor,
          onShowPickupOtp: widget.onShowPickupOtp,
          onArrivedAtCustomer: widget.onArrivedAtCustomer,
          onStartDelivery: widget.onStartDelivery,
          onShowCustomerOtp: widget.onShowCustomerOtp,
          onFinish: widget.onFinish,
        ),
      ),
      child: Stack(
        children: [
          OrderDetailsBody(
            controller: widget.controller,
            onCallStore: widget.onCallStore,
            onCallCustomer: widget.onCallCustomer,
            onShowItems: widget.onShowItems,
            onOpenCustomerRoute: widget.onOpenCustomerRoute,
            onOpenStoreRoute: widget.onOpenStoreRoute,
            onRefresh: _handleRefresh,
            onResendPickupOtp: widget.onResendPickupOtp,
          ),
          Positioned(
            top: 0,
            left: 14,
            right: 14,
            child: SafeArea(
              bottom: false,
              child: IgnorePointer(
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  offset: _isRefreshing ? Offset.zero : const Offset(0, -0.55),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: _isRefreshing ? 1 : 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 4,
                            backgroundColor: scheme.primary.withValues(
                              alpha: 0.12,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              scheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.isActionLoading) ...[
            const ModalBarrier(dismissible: false, color: Colors.black26),
            const Center(child: CustomProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
