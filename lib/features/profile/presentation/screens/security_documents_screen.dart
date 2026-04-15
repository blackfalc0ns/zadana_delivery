import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/profile/presentation/controllers/security_documents_controller.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_scaffold.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/security_documents_fields.dart';

class SecurityDocumentsScreen extends StatefulWidget {
  const SecurityDocumentsScreen({super.key});

  @override
  State<SecurityDocumentsScreen> createState() =>
      _SecurityDocumentsScreenState();
}

class _SecurityDocumentsScreenState extends State<SecurityDocumentsScreen> {
  late final SecurityDocumentsController _controller;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nationalIdController;
  late final TextEditingController _licenseController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = SecurityDocumentsController()..addListener(_refresh);
    final data = _controller.loadInitialData();
    _nationalIdController = TextEditingController(text: data.nationalId);
    _licenseController = TextEditingController(text: data.licenseNumber);
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    _nationalIdController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return ProfileFormScaffold(
      title: locale.profile_security_documents_title,
      headerTitle: locale.profile_documents_uploaded_count(
        _controller.uploadedCount,
      ),
      headerSubtitle: locale.driver_profile_uploads_card_subtitle,
      headerIcon: Icons.verified_user_outlined,
      headerColorToken: ProfileColorToken.tertiary,
      formKey: _formKey,
      isSaving: _isSaving,
      onSave: _save,
      children: [
        SecurityDocumentsFields(
          nationalIdController: _nationalIdController,
          licenseController: _licenseController,
          documents: _controller.documents,
          onSelect: _pickDocument,
        ),
      ],
    );
  }

  void _pickDocument(ProfileDocumentType type) {
    _controller.pickImage(type.storageKey);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await _controller.save(
      nationalId: _nationalIdController.text,
      licenseNumber: _licenseController.text,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.profile_security_documents_saved,
    );
    Navigator.of(context).pop();
  }
}
