import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_profile_section_entity.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_cubit.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_state.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_tile.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_page_header_card.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_section_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final ProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>()..loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final profile = state.profile;
          final personalSection = profile?.personalSection;
          final vehicleSection = profile?.vehicleSection;
          final documentsSection = profile?.documentsSection;

          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(title: locale.profile_edit_profile_title),
            body: ListView(
              padding: const EdgeInsets.all(Spacing.base),
              children: [
                ProfilePageHeaderCard(
                  title: locale.profile_edit_profile_title,
                  subtitle: locale.profile_edit_profile_subtitle,
                  icon: Icons.edit_note_rounded,
                  colorToken: ProfileColorToken.primary,
                ),
                const SizedBox(height: Spacing.base),
                ProfileSectionCard(
                  children: [
                    ProfileActionTile(
                      title: locale.personal_info,
                      subtitle: locale.driver_profile_identity_card_subtitle,
                      icon: Icons.person_outline_rounded,
                      iconColor: color.primary,
                      onTap: () =>
                          context.pushNamed(AppRoutes.profilePersonalInfo),
                      trailing: _buildSectionBadge(personalSection),
                    ),
                    ProfileActionTile(
                      title: locale.driver_profile_vehicle_card_title,
                      subtitle: locale.driver_profile_vehicle_card_subtitle,
                      icon: Icons.two_wheeler_outlined,
                      iconColor: color.secondary,
                      onTap: () =>
                          context.pushNamed(AppRoutes.profileVehicleInfo),
                      trailing: _buildSectionBadge(vehicleSection),
                    ),
                    ProfileActionTile(
                      title: locale.profile_security_documents_title,
                      subtitle: locale.driver_profile_uploads_card_subtitle,
                      icon: Icons.verified_user_outlined,
                      iconColor: color.tertiary,
                      onTap: () =>
                          context.pushNamed(AppRoutes.profileSecurityDocuments),
                      trailing: _buildSectionBadge(documentsSection),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget? _buildSectionBadge(DriverProfileSectionEntity? section) {
    if (section == null || section.isValid) return null;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (section.isUnderReview) {
      return _SectionStatusBadge(
        label: isArabic ? 'تحت المراجعة' : 'Under Review',
        backgroundColor: AppColors.primary.withValues(alpha: 0.10),
        textColor: AppColors.primary,
        icon: Icons.hourglass_top_rounded,
      );
    }

    if (section.isRejected) {
      return _SectionStatusBadge(
        label: isArabic ? 'مرفوض' : 'Rejected',
        backgroundColor: Colors.red.shade50,
        textColor: Colors.red.shade700,
        icon: Icons.error_outline_rounded,
      );
    }

    return null;
  }
}

class _SectionStatusBadge extends StatelessWidget {
  const _SectionStatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
