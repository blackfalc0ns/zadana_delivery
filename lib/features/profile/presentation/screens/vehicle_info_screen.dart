import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/profile/presentation/controllers/vehicle_info_controller.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_scaffold.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/vehicle_info_fields.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  late final VehicleInfoController _controller;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _plateController;
  bool _isSaving = false;
  String _vehicleType = 'car';

  @override
  void initState() {
    super.initState();
    _controller = VehicleInfoController();
    final data = _controller.initialData;
    _vehicleType = data.vehicleType;
    _brandController = TextEditingController(text: data.vehicleBrand);
    _modelController = TextEditingController(text: data.vehicleModel);
    _plateController = TextEditingController(text: data.plateNumber);
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return ProfileFormScaffold(
      title: locale.driver_profile_vehicle_card_title,
      headerTitle: locale.driver_profile_vehicle_card_title,
      headerSubtitle: locale.driver_profile_vehicle_card_subtitle,
      headerIcon: Icons.directions_bike_outlined,
      headerColorToken: ProfileColorToken.secondary,
      formKey: _formKey,
      isSaving: _isSaving,
      onSave: _save,
      children: [
        VehicleInfoFields(
          groupValue: _vehicleType,
          onTypeChanged: _selectType,
          brandController: _brandController,
          modelController: _modelController,
          plateController: _plateController,
        ),
      ],
    );
  }

  void _selectType(String value) => setState(() => _vehicleType = value);

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await _controller.save(
      vehicleType: _vehicleType,
      vehicleBrand: _brandController.text,
      vehicleModel: _modelController.text,
      plateNumber: _plateController.text,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.profile_vehicle_info_saved,
    );
    Navigator.of(context).pop();
  }
}
