import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
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
    final color = context.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          const _AuthBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.base,
                      Spacing.base,
                      Spacing.base,
                      0,
                    ),
                    child: Column(
                      children: [
                        if (showBackButton) ...[
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: color.surfaceContainerLow,
                                foregroundColor: color.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                        ],
                        _HeroHeader(
                          badge: heroBadge,
                          title: heroTitle,
                          subtitle: heroSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.base),
                    child: Column(
                      children: [
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
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow.withValues(alpha: 0.92),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.45)),
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
              color: color.onSurfaceVariant,
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
                  color: color.primary,
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
    final color = context.colorScheme;

    return Container(
      height: 120,
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
            color: color.shadow.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
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
        Assets.fastDelivery,
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
    final color = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(30),

        //   border: Border.all(color: color.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Column(
        children: [
          Image.asset(Assets.logoDark, width: 100, height: 100),
          const SizedBox(height: 8),
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
    final color = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.surface, color.surfaceContainerLowest],
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
              color: color.primary.withValues(alpha: isDark ? 0.12 : 0.14),
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
              color: color.secondary.withValues(alpha: isDark ? 0.10 : 0.08),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ],
    );
  }
}
