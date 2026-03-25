import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_screen_layout.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_profile_form.dart';

class DriverProfileCompletionScreen extends StatefulWidget {
  const DriverProfileCompletionScreen({super.key});

  @override
  State<DriverProfileCompletionScreen> createState() => _DriverProfileCompletionScreenState();
}

class _DriverProfileCompletionScreenState extends State<DriverProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleBrandController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _imagePicker = ImagePicker();
  final Map<String, XFile?> _images = {
    'portrait': null,
    'idFront': null,
    'idBack': null,
    'license': null,
    'vehicle': null,
    'plate': null,
  };

  bool _isSubmitting = false;
  String _vehicleType = 'car';

  @override
  void dispose() {
    _vehicleBrandController.dispose();
    _vehicleModelController.dispose();
    _plateNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String key) async {
    final locale = context.localization;
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null || !mounted) return;
      setState(() => _images[key] = image);
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().contains('channel-error')
          ? locale.driver_profile_picker_restart_required
          : locale.driver_profile_picker_error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _submit() async {
    final locale = context.localization;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(locale.driver_profile_save_success)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AuthScreenLayout(
        leading: Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            style: IconButton.styleFrom(
              foregroundColor: context.colorScheme.onSurface,
              minimumSize: const Size(40, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        caption: locale.driver_profile_caption,
        title: locale.driver_profile_title,
        subtitle: locale.driver_profile_subtitle,
        description: locale.driver_profile_description,
        child: DriverProfileForm(
          formKey: _formKey,
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
      ),
    );
  }
}
