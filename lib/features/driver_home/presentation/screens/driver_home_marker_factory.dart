import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';

class DriverHomeMarkerFactory {
  const DriverHomeMarkerFactory._();

  static Future<BitmapDescriptor> buildPickupMarker({
    required String marketName,
  }) async {
    const width = 154.0;
    const height = 94.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const bubbleRect = Rect.fromLTWH(11, 0, width - 22, 42);
    const markerAccent = Color(0xFFE48215);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bubbleRect.shift(const Offset(0, 3)),
        const Radius.circular(16),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.12),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(16)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(16)),
      Paint()
        ..color = markerAccent.withValues(alpha: 0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.drawCircle(
      const Offset(29, 21),
      11,
      Paint()..color = markerAccent.withValues(alpha: 0.14),
    );
    canvas.drawCircle(const Offset(29, 21), 4.5, Paint()..color = markerAccent);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: marketName,
        style: const TextStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF212121),
        ),
      ),
      textDirection: TextDirection.rtl,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: 86);
    titlePainter.paint(canvas, const Offset(48, 12));

    final stemPaint = Paint()
      ..color = markerAccent.withValues(alpha: 0.78)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(width / 2, 42),
      const Offset(width / 2, 66),
      stemPaint,
    );
    canvas.drawCircle(
      const Offset(width / 2, 74),
      13,
      Paint()..color = markerAccent.withValues(alpha: 0.18),
    );
    canvas.drawCircle(
      const Offset(width / 2, 74),
      7.5,
      Paint()..color = markerAccent,
    );
    canvas.drawCircle(
      const Offset(width / 2, 74),
      3.2,
      Paint()..color = Colors.white,
    );

    final image = await recorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> buildDriverMarker() async {
    const width = 96.0;
    const height = 118.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(width / 2, 46);

    canvas.drawCircle(center, 34, Paint()..color = const Color(0x26007A92));
    canvas.drawCircle(center, 24, Paint()..color = const Color(0xFF007A92));
    canvas.drawCircle(center, 18, Paint()..color = Colors.white);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.person_rounded.codePoint),
        style: const TextStyle(
          fontFamily: 'MaterialIcons',
          fontSize: 22,
          color: Color(0xFF007A92),
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
      ..color = const Color(0xFF007A92)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(width / 2, 68),
      const Offset(width / 2, 94),
      stemPaint,
    );
    canvas.drawCircle(
      const Offset(width / 2, 101),
      7,
      Paint()..color = const Color(0xFF007A92),
    );
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
}
