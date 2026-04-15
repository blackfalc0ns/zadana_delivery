import 'package:flutter/material.dart';

class IncomingOrderCardCountdownPainter extends CustomPainter {
  IncomingOrderCardCountdownPainter({
    required this.progress,
    required this.accentColor,
  });

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
    final extracted = metric.extractPath(
      0,
      (metric.length * progress).clamp(0.0, metric.length),
    );
    canvas.drawPath(extracted, progressPaint);
  }

  Path _buildTopStartPath(Rect rect, double radius) {
    final path = Path();
    final centerX = rect.center.dx;
    path.moveTo(centerX, rect.top);
    path.lineTo(rect.right - radius, rect.top);
    path.arcToPoint(
      Offset(rect.right, rect.top + radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(rect.right, rect.bottom - radius);
    path.arcToPoint(
      Offset(rect.right - radius, rect.bottom),
      radius: Radius.circular(radius),
    );
    path.lineTo(rect.left + radius, rect.bottom);
    path.arcToPoint(
      Offset(rect.left, rect.bottom - radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(rect.left, rect.top + radius);
    path.arcToPoint(
      Offset(rect.left + radius, rect.top),
      radius: Radius.circular(radius),
    );
    path.lineTo(centerX, rect.top);
    return path;
  }

  @override
  bool shouldRepaint(covariant IncomingOrderCardCountdownPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor;
  }
}
