import 'package:flutter/material.dart';

class DriverHomeMapOverlay extends StatelessWidget {
  const DriverHomeMapOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -50,
              child: _GlowBubble(
                size: 220,
                colors: [Color(0x3328B7C8), Color(0x0028B7C8)],
              ),
            ),
            Positioned(
              bottom: -120,
              right: -40,
              child: _GlowBubble(
                size: 260,
                colors: [Color(0x33F29D38), Color(0x00F29D38)],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x14161F29),
                    Colors.transparent,
                    Color(0x1E102A43),
                    Color(0x66202D3A),
                  ],
                  stops: [0.0, 0.32, 0.62, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
