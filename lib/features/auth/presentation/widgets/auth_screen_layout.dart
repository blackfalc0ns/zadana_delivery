import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_header.dart';

class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    required this.caption,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.child,
    this.footer,
    this.leading,
  });

  final String caption;
  final String title;
  final String subtitle;
  final String description;
  final Widget child;
  final Widget? footer;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final leadingWidgets = leading == null
        ? const <Widget>[]
        : <Widget>[leading!];
    final footerWidgets = footer == null
        ? const <Widget>[]
        : <Widget>[const SizedBox(height: Spacing.xs), footer!];

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...leadingWidgets,
              const SizedBox(height: Spacing.xs),
              AuthHeader(caption: caption, title: title, subtitle: subtitle),
              const SizedBox(height: Spacing.xs),
              Text(
                description,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: color.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: Spacing.md),
              child,
              ...footerWidgets,
              const SizedBox(height: Spacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
