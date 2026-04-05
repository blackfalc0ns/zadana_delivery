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

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final _service = DriverProfileService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _plateController;
  bool _isSaving = false;
  String _vehicleType = 'car';

  @override
  void initState() {
    super.initState();
    final draft = _service.profileDraft;
    _vehicleType = draft.vehicleType;
    _brandController = TextEditingController(text: draft.vehicleBrand);
    _modelController = TextEditingController(text: draft.vehicleModel);
    _plateController = TextEditingController(text: draft.plateNumber);
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final draft = _service.profileDraft.copyWith(
      vehicleType: _vehicleType,
      vehicleBrand: _brandController.text.trim(),
      vehicleModel: _modelController.text.trim(),
      plateNumber: _plateController.text.trim(),
    );
    await _service.saveProfileDraft(draft);
    if (!mounted) return;
    setState(() => _isSaving = false);
    CustomSnackbar.showSuccess(context: context, message: 'تم حفظ بيانات المركبة');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: CustomAppBar.modern(
        title: 'بيانات المركبة',
        backgroundColor: const Color(0xFFF7FAFC),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.base),
          children: [
            const _VehicleHeader(),
            const SizedBox(height: Spacing.base),
            Text(
              'نوع المركبة',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size11,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Expanded(
                  child: _VehicleTypeChip(
                    label: 'سيارة',
                    value: 'car',
                    groupValue: _vehicleType,
                    onChanged: _changeType,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: _VehicleTypeChip(
                    label: 'دراجة',
                    value: 'bike',
                    groupValue: _vehicleType,
                    onChanged: _changeType,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            _buildField(_brandController, 'الماركة', 'مثال: Yamaha أو Toyota', Icons.directions_car_outlined),
            const SizedBox(height: Spacing.md),
            _buildField(_modelController, 'الموديل', 'مثال: 2023 أو NMAX', Icons.tune_rounded),
            const SizedBox(height: Spacing.md),
            _buildField(_plateController, 'رقم اللوحة', 'اكتب رقم اللوحة', Icons.pin_outlined),
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

  void _changeType(String value) {
    setState(() => _vehicleType = value);
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

class _VehicleHeader extends StatelessWidget {
  const _VehicleHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.directions_bike_outlined, color: AppColors.secondary),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حدّث بيانات مركبتك',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'البيانات الحالية محمّلة من الملف المحفوظ ويمكنك تعديلها ثم حفظها.',
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

class _VehicleTypeChip extends StatelessWidget {
  const _VehicleTypeChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.10) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: selected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

