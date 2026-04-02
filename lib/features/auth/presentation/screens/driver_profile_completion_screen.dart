import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_profile_form.dart';

class DriverProfileCompletionScreen extends StatefulWidget {
  const DriverProfileCompletionScreen({super.key});

  @override
  State<DriverProfileCompletionScreen> createState() =>
      _DriverProfileCompletionScreenState();
}

class _DriverProfileCompletionScreenState
    extends State<DriverProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _vehicleBrandController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _imagePicker = ImagePicker();

  final Map<String, String> _images = {
    'portrait': '',
    'idFront': '',
    'license': '',
    'vehicle': '',
    'plate': '',
  };

  bool _isSubmitting = false;
  String _vehicleType = 'car';

  @override
  void dispose() {
    _addressController.dispose();
    _nationalIdController.dispose();
    _licenseNumberController.dispose();
    _vehicleBrandController.dispose();
    _vehicleModelController.dispose();
    _plateNumberController.dispose();
    super.dispose();
  }

  String _copy(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  Future<void> _pickImage(String key) async {
    final locale = context.localization;
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 86,
      );
      if (image == null || !mounted) return;
      setState(() => _images[key] = image.path);
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().contains('channel-error')
          ? locale.driver_profile_picker_restart_required
          : locale.driver_profile_picker_error;
      CustomSnackbar.showError(context: context, message: message);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_images.values.any((value) => value.trim().isEmpty)) {
      CustomSnackbar.showError(
        context: context,
        message: _copy(
          context,
          'من فضلك ارفع كل الصور المطلوبة قبل المتابعة.',
          'Please upload all required images before continuing.',
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    context.pushNamedAndRemoveUntil(
      AppRoutes.mainShell,
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      heroBadge: _copy(context, 'خطوة التفعيل', 'Activation step'),
      heroTitle: locale.driver_profile_title,
      heroSubtitle: _copy(
        context,
        'رتّب بياناتك وصور مركبتك مرة واحدة فقط، وبعدها يصبح الحساب جاهزًا للعرض والتنقل داخل التطبيق.',
        'Set up your account and vehicle visuals once, then continue smoothly into the app.',
      ),
      sectionBadge: _copy(context, 'استكمال الملف', 'Complete profile'),
      sectionTitle: locale.driver_profile_title,
      sectionDescription: locale.driver_profile_description,
      sectionIcon: Icons.assignment_ind_rounded,
      body: DriverProfileForm(
        formKey: _formKey,
        addressController: _addressController,
        nationalIdController: _nationalIdController,
        licenseNumberController: _licenseNumberController,
        vehicleBrandController: _vehicleBrandController,
        vehicleModelController: _vehicleModelController,
        plateNumberController: _plateNumberController,
        vehicleType: _vehicleType,
        images: _images,
        isSubmitting: _isSubmitting,
        onVehicleTypeChanged: (value) => setState(() => _vehicleType = value),
        onPickImage: _pickImage,
        onSubmit: _submit,
      ),
    );
  }
}
