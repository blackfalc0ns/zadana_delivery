import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsLauncher {
  const OrderDetailsLauncher._();

  static Future<bool> openRoute({
    required LatLng destination,
    String? destinationLabel,
  }) async {
    final destinationText = '${destination.latitude},${destination.longitude}';
    final queryText = destinationLabel?.trim().isNotEmpty == true
        ? destinationLabel!.trim()
        : destinationText;

    final candidates = <Uri>[
      Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$destinationText',
      ),
      Uri.parse('geo:$destinationText?q=$destinationText'),
      Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=$destinationText&travelmode=driving',
      ),
      Uri.parse('google.navigation:q=$destinationText&mode=d'),
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$queryText'),
      Uri.parse('geo:0,0?q=$queryText'),
    ];

    for (final uri in candidates) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  static Future<bool> callNumber(String number) async {
    try {
      return await launchUrl(
        Uri(scheme: 'tel', path: number),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  static void showFailure(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
