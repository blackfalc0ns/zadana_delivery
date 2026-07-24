import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'terms_and_conditions_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => LegalScreen(
    title: context.localization.privacy_policy,
    type: 'DriverPrivacy',
  );
}
