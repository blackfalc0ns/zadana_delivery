import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _service = DriverProfileService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final identity = _service.identity;
    final draft = _service.profileDraft;
    _nameController = TextEditingController(text: identity.fullName);
    _emailController = TextEditingController(text: identity.email);
    _phoneController = TextEditingController(text: identity.phone);
    _addressController = TextEditingController(text: draft.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    final identity = _service.identity.copyWith(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    final draft = _service.profileDraft.copyWith(
      address: _addressController.text.trim(),
    );
    await _service.saveIdentity(identity);
    await _service.saveProfileDraft(draft);
    if (!mounted) return;
    setState(() => _isSaving = false);
    CustomSnackbar.showSuccess(context: context, message: 'تم حفظ البيانات الشخصية');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: CustomAppBar.modern(
        title: 'البيانات الشخصية',
        backgroundColor: const Color(0xFFF7FAFC),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.base),
          children: [
            const _ProfilePageHeader(
              title: 'راجع بياناتك الأساسية',
              subtitle: 'يمكنك تعديل الاسم والبريد والهاتف والعنوان وحفظ التغييرات مباشرة.',
              icon: Icons.person_outline_rounded,
              accent: AppColors.primary,
            ),
            const SizedBox(height: Spacing.base),
            _buildField(_nameController, 'الاسم الكامل', 'اكتب الاسم الكامل', Icons.badge_outlined),
            const SizedBox(height: Spacing.md),
            _buildField(
              _emailController,
              'البريد الإلكتروني',
              'اكتب البريد الإلكتروني',
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: Spacing.md),
            _buildField(
              _phoneController,
              'رقم الهاتف',
              'اكتب رقم الهاتف',
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: Spacing.md),
            _buildField(_addressController, 'العنوان', 'اكتب العنوان الحالي', Icons.home_work_outlined),
            const SizedBox(height: Spacing.lg),
            AppButton.filled(
              text: 'حفظ التغييرات',
              onPressed: _isSaving ? null : _save,
              isLoading: _isSaving,
              height: 52,
              borderRadius: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return AuthTextField(
      controller: controller,
      label: label,
      hintText: hint,
      keyboardType: keyboardType,
      prefixIcon: Icon(icon),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
    );
  }
}

class _ProfilePageHeader extends StatelessWidget {
  const _ProfilePageHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.textSecondary,
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

