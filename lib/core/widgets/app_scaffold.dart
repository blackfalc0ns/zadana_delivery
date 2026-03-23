import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// Base scaffold with optional AppBar, FAB, and common defaults.
/// ─────────────────────────────────────────────────────────────
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showAppBar;
  final bool centerTitle;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.actions,
    this.leading,
    this.showAppBar = true,
    this.centerTitle = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar:
          appBar ??
          (showAppBar
              ? AppBar(
                  title: title != null ? Text(title!) : null,
                  centerTitle: centerTitle,
                  leading: leading,
                  actions: actions,
                )
              : null),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
    );
  }
}
