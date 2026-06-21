import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/loading/loading_overlay.dart';

class OrderDetailsResendOtpAction extends StatefulWidget {
  const OrderDetailsResendOtpAction({
    super.key,
    required this.onResend,
    this.cooldown = const Duration(seconds: 60),
  });

  final Future<bool> Function() onResend;
  final Duration cooldown;

  @override
  State<OrderDetailsResendOtpAction> createState() =>
      _OrderDetailsResendOtpActionState();
}

class _OrderDetailsResendOtpActionState
    extends State<OrderDetailsResendOtpAction> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isSubmitting = false;

  bool get _isCoolingDown => _secondsRemaining > 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleResend() async {
    if (_isSubmitting || _isCoolingDown) return;

    setState(() => _isSubmitting = true);
    
    LoadingOverlay.show(context);
    final success = await widget.onResend();
    
    if (!mounted) {
      LoadingOverlay.hide();
      return;
    }
    
    LoadingOverlay.hide(context);

    if (success) {
      _startCooldown();
    }

    setState(() => _isSubmitting = false);
  }

  void _startCooldown() {
    _timer?.cancel();
    _secondsRemaining = widget.cooldown.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        return;
      }

      setState(() => _secondsRemaining -= 1);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final text = _isCoolingDown
        ? context.localization.order_details_resend_otp_in(_secondsRemaining)
        : context.localization.order_details_resend_otp;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: _isSubmitting || _isCoolingDown ? null : _handleResend,
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: Text(text),
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          disabledForegroundColor: scheme.onSurfaceVariant.withValues(
            alpha: 0.72,
          ),
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
