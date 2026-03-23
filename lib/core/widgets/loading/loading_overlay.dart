import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// Full‑screen semi‑transparent loading overlay.
///
/// Usage:
///   LoadingOverlay.show(context);
///   await doWork();
///   LoadingOverlay.hide(context);
///
/// Or wrap a widget:
///   LoadingOverlay.wrap(isLoading: state.isLoading, child: …)
/// ─────────────────────────────────────────────────────────────
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? barrierColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: barrierColor ?? Colors.black38,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/car_loading.gif',
                    width: 120,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Show overlay via [OverlayEntry] — imperative API.
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    _entry?.remove();
    _entry = OverlayEntry(
      builder: (_) => ColoredBox(
        color: Colors.black38,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/car_loading.gif', width: 120),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  static void hide(BuildContext context) {
    _entry?.remove();
    _entry = null;
  }
}
