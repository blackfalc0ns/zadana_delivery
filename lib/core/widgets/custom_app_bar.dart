import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.backgroundColor,
    this.titleColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.showBackButton = true,
    this.onBackPressed,
    this.useGradient = false,
    this.gradientColors,
    this.showShadow = true,
    this.backIcon,
    this.backIconWidget,
    this.titleFontSize,
    this.subtitle,
    this.subtitleColor,
    this.systemOverlayStyle,
  });

  // Factory constructors for common use cases
  factory CustomAppBar.simple({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      onBackPressed: onBackPressed,
      showShadow: false,
    );
  }

  factory CustomAppBar.withSubtitle({
    required String title,
    required String subtitle,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }

  factory CustomAppBar.gradient({
    required String title,
    List<Color>? gradientColors,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      useGradient: true,
      gradientColors: gradientColors,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }

  factory CustomAppBar.transparent({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      backgroundColor: Colors.transparent,
      elevation: 0,
      showShadow: false,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }

  factory CustomAppBar.search({
    required String title,
    VoidCallback? onSearchPressed,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 16,
              color: AppColors.primary,
            ),
            onPressed: onSearchPressed,
          ),
        ),
      ],
      onBackPressed: onBackPressed,
    );
  }

  factory CustomAppBar.modern({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      backgroundColor: backgroundColor,
      showShadow: false,
      titleFontSize: FontSize.size18,
      actions: actions,
      onBackPressed: onBackPressed,
      backIconWidget: const Icon(Icons.arrow_back_ios_new),
    );
  }

  factory CustomAppBar.premium({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      useGradient: true,
      gradientColors: [
        AppColors.primary.withValues(alpha: 0.15),
        AppColors.primary.withValues(alpha: 0.05),
      ],
      titleColor: AppColors.primary,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool useGradient;
  final List<Color>? gradientColors;
  final bool showShadow;
  final IconData? backIcon;
  final Widget? backIconWidget;
  final double? titleFontSize;
  final String? subtitle;
  final Color? subtitleColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final resolvedBackgroundColor =
        backgroundColor ??
        (useGradient ? Colors.transparent : colorScheme.surface);
    final resolvedTitleColor = titleColor ?? colorScheme.onSurface;
    final resolvedSubtitleColor = subtitleColor ?? colorScheme.primary;
    final overlayStyle =
        systemOverlayStyle ??
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        );

    return Container(
      decoration: useGradient
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    gradientColors ??
                    [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
              ),
            )
          : null,
      child: AppBar(
        systemOverlayStyle: overlayStyle,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: resolvedTitleColor),
        actionsIconTheme: IconThemeData(color: resolvedTitleColor),
        leading: _buildLeading(context, canPop, resolvedTitleColor),
        title: _buildTitle(context, resolvedTitleColor, resolvedSubtitleColor),
        centerTitle: centerTitle,
        actions: _buildActions(context, canPop),
        backgroundColor: resolvedBackgroundColor,
        elevation: elevation ?? 0,
        scrolledUnderElevation: 0,
        shadowColor: showShadow
            ? colorScheme.shadow.withValues(alpha: isDark ? 0.24 : 0.1)
            : null,
        surfaceTintColor: Colors.transparent,
        bottom: bottom,
        titleSpacing: leading != null ? 0 : null,
        toolbarHeight: subtitle != null ? 70 : kToolbarHeight,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, bool canPop, Color iconColor) {
    if (leading != null) return leading;

    if (!showBackButton || !automaticallyImplyLeading || !canPop) {
      return null;
    }

    return IconButton(
      icon:
          backIconWidget ??
          Icon(backIcon ?? Icons.arrow_back_ios, color: iconColor),
      onPressed: onBackPressed ?? () => Navigator.pop(context),
      splashRadius: 20,
    );
  }

  Widget? _buildTitle(
    BuildContext context,
    Color resolvedTitleColor,
    Color resolvedSubtitleColor,
  ) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title!,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: titleFontSize ?? FontSize.size18,
            color: resolvedTitleColor,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: resolvedSubtitleColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_alt, size: 12, color: resolvedSubtitleColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    subtitle!,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      color: resolvedSubtitleColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<Widget>? _buildActions(BuildContext context, bool canPop) {
    final List<Widget> actionsList = [];

    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return actionsList.isEmpty ? null : actionsList;
  }

  @override
  Size get preferredSize => Size.fromHeight(
    (subtitle != null ? 70 : kToolbarHeight) +
        (bottom?.preferredSize.height ?? 0),
  );
}
