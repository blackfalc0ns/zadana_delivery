import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/core/widgets/image_source_picker_sheet.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_personal_request_entity.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_cubit.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_form_event.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_state.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/personal_info_form.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_scaffold.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_loading_skeleton.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final ProfileCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  bool _didSeedControllers = false;
  bool _isFormDirty = false;

  // Original values to compare against
  String _originalName = '';
  String _originalEmail = '';
  String _originalPhone = '';
  String _originalAddress = '';

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>()..doIntent(const ProfileFormLoadEvent());
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    _cubit.clearError();
    final dirty = _nameController.text != _originalName ||
        _emailController.text != _originalEmail ||
        _phoneController.text != _originalPhone ||
        _addressController.text != _originalAddress;
    if (dirty != _isFormDirty) {
      setState(() => _isFormDirty = dirty);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          final profile = state.profile;
          if (!_didSeedControllers && profile != null) {
            _didSeedControllers = true;
            _originalName = profile.fullName;
            _originalEmail = profile.email;
            _originalPhone = profile.phone;
            _originalAddress = profile.address;
            _nameController.text = profile.fullName;
            _emailController.text = profile.email;
            _phoneController.text = profile.phone;
            _addressController.text = profile.address;
          }

          if (state.isSuccess) {
            CustomSnackbar.showInfo(
              context: context,
              message: context.localization.profile_change_pending_approval,
            );
            Navigator.of(context).pop(true);
            return;
          }

          if (state.failure != null && state.profile != null) {
            if (state.failure!.isConnectivityIssue) return;
            CustomSnackbar.showError(
              context: context,
              message: state.failure!.errorMessage,
            );
            _cubit.clearError();
          }
        },
        builder: (context, state) {
          final showGlobalError =
              !state.isLoading &&
              state.profile == null &&
              state.failure != null;

          if (state.profile == null && state.isLoading) {
            return ProfileFormLoadingSkeleton(title: locale.personal_info);
          }

          if (showGlobalError) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: state.failure!.asException,
                  onRetry: () => _cubit.doIntent(const ProfileFormLoadEvent()),
                  onGoBack: () =>
                      _cubit.doIntent(const ProfileFormClearErrorEvent()),
                ),
              ),
            );
          }

          return ProfileFormScaffold(
            title: locale.personal_info,
            headerTitle: locale.driver_profile_identity_card_title,
            headerSubtitle: locale.driver_profile_identity_card_subtitle,
            headerIcon: Icons.person_outline_rounded,
            headerColorToken: ProfileColorToken.primary,
            formKey: _formKey,
            isSaving: state.isSaving || state.isLoading,
            onSave: _save,
            children: [
              PersonalInfoForm(
                profilePhotoUrl: state.profile?.personalPhotoUrl ?? '',
                isBusy: state.isSaving || state.isLoading,
                onChangePhoto: _changePhoto,
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                addressController: _addressController,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _cubit.doIntent(
      ProfileFormSavePersonalEvent(
        UpdateDriverPersonalRequestEntity(
          fullName: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
        ),
      ),
    );
  }

  Future<void> _changePhoto() async {
    final source = await ImageSourcePickerSheet.show(context);
    if (!mounted || source == null) return;
    try {
      final picker = getIt<ImagePicker>();
      final image = await picker.pickImage(source: source, imageQuality: 86);
      if (!mounted || image == null) return;
      await _cubit.doIntent(ProfileFormUpdateProfilePhotoEvent(image.path));
      if (!mounted) return;
      CustomSnackbar.showSuccess(
        context: context,
        message: Localizations.localeOf(context).languageCode == 'ar'
            ? 'تم تحديث صورة البروفايل'
            : 'Profile photo updated',
      );
    } catch (_) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context: context,
        message: context.localization.driver_profile_picker_error,
      );
    }
  }

}
