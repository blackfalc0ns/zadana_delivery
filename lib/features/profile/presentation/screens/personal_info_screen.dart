import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/profile/presentation/controllers/personal_info_controller.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/personal_info_form.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_scaffold.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final PersonalInfoController _controller;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = getIt<PersonalInfoController>();
    final data = _controller.initialData;
    _nameController = TextEditingController(text: data.fullName);
    _emailController = TextEditingController(text: data.email);
    _phoneController = TextEditingController(text: data.phone);
    _addressController = TextEditingController(text: data.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return ProfileFormScaffold(
      title: locale.personal_info,
      headerTitle: locale.driver_profile_identity_card_title,
      headerSubtitle: locale.driver_profile_identity_card_subtitle,
      headerIcon: Icons.person_outline_rounded,
      headerColorToken: ProfileColorToken.primary,
      formKey: _formKey,
      isSaving: _isSaving,
      onSave: _save,
      children: [
        PersonalInfoForm(
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
          addressController: _addressController,
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await _controller.save(
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.profile_personal_info_saved,
    );
    Navigator.of(context).pop();
  }
}
