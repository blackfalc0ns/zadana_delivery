import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/constants/durations.dart';

/// ─────────────────────────────────────────────────────────────
/// Slide‑in animation wrapper.
///
/// [direction] controls where the widget slides from:
///   SlideDirection.left   → enters from left
///   SlideDirection.right  → enters from right
///   SlideDirection.top    → enters from top
///   SlideDirection.bottom → enters from bottom
/// ─────────────────────────────────────────────────────────────
enum SlideDirection { left, right, top, bottom }

class SlideIn extends StatefulWidget {
  const SlideIn({
    super.key,
    required this.child,
    this.direction = SlideDirection.bottom,
    this.duration = AppDurations.normal,
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.offset = 0.3,
  });
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double offset;

  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);

    final begin = switch (widget.direction) {
      SlideDirection.left => Offset(-widget.offset, 0),
      SlideDirection.right => Offset(widget.offset, 0),
      SlideDirection.top => Offset(0, -widget.offset),
      SlideDirection.bottom => Offset(0, widget.offset),
    };

    _slideAnimation = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(curved);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curved);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
