import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';

class SecurityDocumentsScreen extends StatefulWidget {
  const SecurityDocumentsScreen({super.key});

  @override
  State<SecurityDocumentsScreen> createState() => _SecurityDocumentsScreenState();
}

class _SecurityDocumentsScreenState extends State<SecurityDocumentsScreen> {
  final _service = DriverProfileService();
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final TextEditingController _nationalIdController;
  late final TextEditingController _licenseController;
  late Map<String, String> _images;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final draft = _service.profileDraft;
    _nationalIdController = TextEditingController(text: draft.nationalId);
    _licenseController = TextEditingController(text: draft.licenseNumber);
    _images = Map<String, String>.from(draft.images);
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String key) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 86,
    );
    if (image == null || !mounted) return;
    setState(() => _images[key] = image.path);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final draft = _service.profileDraft.copyWith(
      nationalId: _nationalIdController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      images: _images,
    );
    await _service.saveProfileDraft(draft);
    if (!mounted) return;
    setState(() => _isSaving = false);
    CustomSnackbar.showSuccess(context: context, message: 'تم حفظ الأمان والمستندات');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final uploadedCount = _images.values
        .where((value) => value.trim().isNotEmpty)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: CustomAppBar.modern(
        title: 'الأمان والمستندات',
        backgroundColor: const Color(0xFFF7FAFC),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            _SecurityHeader(uploadedCount: uploadedCount),
            const SizedBox(height: Spacing.base),
            _buildField(_nationalIdController, 'الرقم القومي', 'أدخل الرقم القومي', Icons.badge_outlined),
            const SizedBox(height: Spacing.md),
            _buildField(_licenseController, 'رقم الرخصة', 'أدخل رقم الرخصة', Icons.assignment_outlined),
            const SizedBox(height: Spacing.base),
            Text(
              'المستندات الحالية',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            _DocumentTile(title: 'الصورة الشخصية', path: _images['portrait'] ?? '', icon: Icons.person_rounded, onTap: () => _pickImage('portrait')),
            const SizedBox(height: Spacing.sm),
            _DocumentTile(title: 'صورة الهوية الأمامية', path: _images['idFront'] ?? '', icon: Icons.badge_outlined, onTap: () => _pickImage('idFront')),
            const SizedBox(height: Spacing.sm),
            _DocumentTile(title: 'صورة الرخصة', path: _images['license'] ?? '', icon: Icons.assignment_ind_outlined, onTap: () => _pickImage('license')),
            const SizedBox(height: Spacing.sm),
            _DocumentTile(title: 'صورة المركبة', path: _images['vehicle'] ?? '', icon: Icons.two_wheeler_rounded, onTap: () => _pickImage('vehicle')),
            const SizedBox(height: Spacing.sm),
            _DocumentTile(title: 'صورة اللوحة', path: _images['plate'] ?? '', icon: Icons.pin_outlined, onTap: () => _pickImage('plate')),
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

  Widget _buildField(TextEditingController controller, String label, String hint, IconData icon) {
    return AuthTextField(
      controller: controller,
      label: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
    );
  }
}

class _SecurityHeader extends StatelessWidget {
  const _SecurityHeader({required this.uploadedCount});

  final int uploadedCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.verified_user_outlined, color: AppColors.info),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المستندات المرفوعة: $uploadedCount/5',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'راجع بيانات الأمان الحالية وعدّل المستندات المحفوظة عند الحاجة.',
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

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.path,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String path;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasFile = path.trim().isNotEmpty;
    final fileName = hasFile
        ? path.split(RegExp(r'[/\\]')).last
        : 'لم يتم الرفع بعد';

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileName,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: hasFile ? AppColors.textSecondary : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onTap, child: Text(hasFile ? 'تغيير' : 'رفع')),
        ],
      ),
    );
  }
}

