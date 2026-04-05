import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class AuthExperienceShell extends StatelessWidget {
  const AuthExperienceShell({
    super.key,
    required this.heroBadge,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.sectionTitle,
    required this.sectionDescription,
    required this.body,
    this.sectionBadge,
    this.sectionIcon = Icons.lock_outline_rounded,
    this.footer,
    this.showBackButton = false,
  });

  final String heroBadge;
  final String heroTitle;
  final String heroSubtitle;
  final String sectionTitle;
  final String sectionDescription;
  final String? sectionBadge;
  final IconData sectionIcon;
  final Widget body;
  final Widget? footer;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final resolvedSectionBadge =
        sectionBadge ?? context.localization.auth_section_badge_default;

    return Scaffold(
      body: Stack(
        children: [
          const _AuthBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                Spacing.base,
                Spacing.base,
                Spacing.base,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroHeader(
                    badge: heroBadge,
                    title: heroTitle,
                    subtitle: heroSubtitle,
                  ),
                  const SizedBox(height: Spacing.lg),
                  _FormCard(
                    badge: resolvedSectionBadge,
                    title: sectionTitle,
                    description: sectionDescription,
                    icon: sectionIcon,
                    child: body,
                  ),
                  if (footer != null) ...[
                    const SizedBox(height: Spacing.base),
                    Center(child: footer),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPromptText extends StatelessWidget {
  const AuthPromptText({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onTap,
  });

  final String text;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            text,
            style: getRegularStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: AppColors.textSecondary,
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                actionLabel,
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  final String badge;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
            AppColors.primarySurface,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontSize: FontSize.size20,
                    fontFamily: FontConstant.cairo,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const _HeroProduceArtwork(),
        ],
      ),
    );
  }
}

class _HeroProduceArtwork extends StatelessWidget {
  const _HeroProduceArtwork();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 126,
      height: 150,
      child: SvgPicture.asset(
        'assets/images/fast_delivery.svg',
        fit: BoxFit.contain,
        placeholderBuilder: (context) => Center(
          child: Icon(
            Icons.local_shipping_outlined,
            size: 40,
            color: Colors.white.withValues(alpha: 0.92),
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.badge,
    required this.title,
    required this.description,
    required this.icon,
    required this.child,
  });

  final String badge;
  final String title;
  final String description;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo_dark.png', width: 100, height: 100),
          child,
        ],
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF1F5F5), Color(0xFFF7F8F8)],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0x220A8597),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: -20,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0x14FFFFFF),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ],
    );
  }
}
