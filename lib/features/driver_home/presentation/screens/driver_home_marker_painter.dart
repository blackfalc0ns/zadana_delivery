import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';

class DriverHomeMarkerPainter {
  const DriverHomeMarkerPainter._();

  static const IconData storeIcon = Icons.storefront_rounded;
  static const IconData customerIcon = Icons.person_pin_circle_rounded;

  static Future<BitmapDescriptor> buildCompactMarker({
    required String markerLabel,
    required Color accent,
    required IconData iconData,
  }) async {
    const width = 108.0;
    const height = 136.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const labelRect = Rect.fromLTWH(14, 0, width - 28, 30);

    _paintLabelShell(canvas, labelRect, accent);
    _paintLabelText(canvas, labelRect, markerLabel, accent);

    const badgeCenter = Offset(width / 2, 56);
    _paintBadge(canvas, badgeCenter, accent, iconData);
    _paintStem(canvas, width, accent);

    final image = await recorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> buildDriverMarker({
    required Color accent,
  }) async {
    const width = 96.0;
    const height = 118.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(width / 2, 46);

    canvas.drawCircle(
      center,
      34,
      Paint()..color = accent.withValues(alpha: 0.15),
    );
    canvas.drawCircle(center, 24, Paint()..color = accent);
    canvas.drawCircle(center, 18, Paint()..color = Colors.white);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.person_rounded.codePoint),
        style: const TextStyle(
          fontFamily: 'MaterialIcons',
          fontSize: 22,
          color: Colors.black54,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );

    final stemPaint = Paint()
      ..color = accent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(width / 2, 68),
      const Offset(width / 2, 94),
      stemPaint,
    );
    canvas.drawCircle(const Offset(width / 2, 101), 7, Paint()..color = accent);
    canvas.drawCircle(
      const Offset(width / 2, 101),
      3,
      Paint()..color = Colors.white,
    );

    final image = await recorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  static void _paintLabelShell(Canvas canvas, Rect labelRect, Color accent) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        labelRect.shift(const Offset(0, 2)),
        const Radius.circular(999),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.08),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(999)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(999)),
      Paint()
        ..color = accent.withValues(alpha: 0.20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  static void _paintLabelText(
    Canvas canvas,
    Rect labelRect,
    String markerLabel,
    Color accent,
  ) {
    final labelPainter = TextPainter(
      text: TextSpan(
        text: markerLabel,
        style: TextStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
      textDirection: TextDirection.rtl,
      maxLines: 1,
    )..layout(maxWidth: labelRect.width - 14);
    labelPainter.paint(
      canvas,
      Offset(
        labelRect.center.dx - labelPainter.width / 2,
        labelRect.center.dy - labelPainter.height / 2,
      ),
    );
  }

  static void _paintBadge(
    Canvas canvas,
    Offset badgeCenter,
    Color accent,
    IconData iconData,
  ) {
    canvas.drawCircle(
      badgeCenter,
      24,
      Paint()..color = accent.withValues(alpha: 0.14),
    );
    canvas.drawCircle(badgeCenter, 18, Paint()..color = Colors.white);
    canvas.drawCircle(
      badgeCenter,
      18,
      Paint()
        ..color = accent.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          fontSize: 20,
          color: accent,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - iconPainter.width / 2,
        badgeCenter.dy - iconPainter.height / 2,
      ),
    );
  }

  static void _paintStem(Canvas canvas, double width, Color accent) {
    final stemPaint = Paint()
      ..color = accent.withValues(alpha: 0.86)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final stemStart = Offset(width / 2, 75);
    final stemEnd = Offset(width / 2, 106);
    final markerCenter = Offset(width / 2, 116);
    canvas.drawLine(stemStart, stemEnd, stemPaint);
    canvas.drawCircle(
      markerCenter,
      14,
      Paint()..color = accent.withValues(alpha: 0.18),
    );
    canvas.drawCircle(markerCenter, 8, Paint()..color = accent);
    canvas.drawCircle(markerCenter, 3.4, Paint()..color = Colors.white);
  }
}
