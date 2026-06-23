import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_page_header_card.dart';

class ProfileFormScaffold extends StatelessWidget {
  const ProfileFormScaffold({
    super.key,
    required this.title,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.headerIcon,
    required this.headerColorToken,
    required this.formKey,
    required this.isSaving,
    required this.onSave,
    required this.children,
    this.actionText,
    this.isFormDirty = true,
    this.banner,
  });

  final String title;
  final String headerTitle;
  final String headerSubtitle;
  final IconData headerIcon;
  final ProfileColorToken headerColorToken;
  final GlobalKey<FormState> formKey;
  final bool isSaving;
  final VoidCallback onSave;
  final List<Widget> children;
  final String? actionText;
  final bool isFormDirty;
  final Widget? banner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar.modern(
        title: title,
        backgroundColor: context.colorScheme.surface,
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isSaving,
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(Spacing.base),
                children: [
                  ProfilePageHeaderCard(
                    title: headerTitle,
                    subtitle: headerSubtitle,
                    icon: headerIcon,
                    colorToken: headerColorToken,
                  ),
                  if (banner != null) ...[
                    const SizedBox(height: Spacing.sm),
                    banner!,
                  ],
                  const SizedBox(height: Spacing.base),
                  ...children,
                  const SizedBox(height: Spacing.lg),
                  AppButton.filled(
                    text:
                        actionText ??
                        context.localization.profile_update_action,
                    onPressed: isSaving || !isFormDirty ? null : onSave,
                    height: 52,
                    borderRadius: 18,
                  ),
                ],
              ),
            ),
          ),
          if (isSaving) ...[
            Positioned.fill(
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.08)),
            ),
            const Positioned.fill(child: CustomProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
