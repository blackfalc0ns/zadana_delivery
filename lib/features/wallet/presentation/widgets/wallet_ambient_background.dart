import 'package:flutter/material.dart';

class WalletAmbientBackground extends StatelessWidget {
  const WalletAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE6F5F7),
                    Color(0xFFF1F8F9),
                    Color(0xFFF7F9FA),
                  ],
                  stops: [0, 0.48, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 72,
            left: -40,
            child: Container(
              width: 108,
              height: 108,
              decoration: const BoxDecoration(
                color: Color(0x220E7C91),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: -20,
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0x14E48215),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
