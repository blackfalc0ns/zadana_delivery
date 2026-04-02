import 'package:flutter/material.dart';
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
      height: 210,
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontSize: 26,
                    fontFamily: FontConstant.cairo,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.base),
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
      width: 124,
      height: 168,
      child: Stack(
        children: const [
          Positioned(
            top: 0,
            left: 18,
            child: _ProduceBox(
              assetPath: 'assets/images/Cabbage.png',
              size: 72,
            ),
          ),
          Positioned(
            top: 60,
            left: 45,
            child: _ProduceBox(assetPath: 'assets/images/Tomato.png', size: 72),
          ),
          Positioned(
            top: 99,
            right: 55,
            child: _ProduceBox(assetPath: 'assets/images/Chilli.png', size: 65),
          ),
        ],
      ),
    );
  }
}

class _ProduceBox extends StatelessWidget {
  const _ProduceBox({required this.assetPath, required this.size});

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.local_shipping_outlined,
            color: Colors.white.withValues(alpha: 0.92),
          );
        },
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
