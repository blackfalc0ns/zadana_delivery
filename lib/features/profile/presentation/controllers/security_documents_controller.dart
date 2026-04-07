import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';

class SecurityDocumentsInitialData {
  const SecurityDocumentsInitialData({
    required this.nationalId,
    required this.licenseNumber,
  });

  final String nationalId;
  final String licenseNumber;
}

class SecurityDocumentsController extends ChangeNotifier {
  SecurityDocumentsController({
    DriverProfileService? service,
    ImagePicker? picker,
  }) : _service = service ?? DriverProfileService(),
       _picker = picker ?? ImagePicker();

  final DriverProfileService _service;
  final ImagePicker _picker;

  Map<String, String> _images = const <String, String>{};

  SecurityDocumentsInitialData loadInitialData() {
    final draft = _service.profileDraft;
    _images = Map<String, String>.from(draft.images);

    return SecurityDocumentsInitialData(
      nationalId: draft.nationalId,
      licenseNumber: draft.licenseNumber,
    );
  }

  List<ProfileDocumentItemData> get documents => [
    ProfileDocumentItemData(
      type: ProfileDocumentType.portrait,
      icon: Icons.person_rounded,
      path: _images['portrait'] ?? '',
    ),
    ProfileDocumentItemData(
      type: ProfileDocumentType.idFront,
      icon: Icons.badge_outlined,
      path: _images['idFront'] ?? '',
    ),
    ProfileDocumentItemData(
      type: ProfileDocumentType.license,
      icon: Icons.assignment_ind_outlined,
      path: _images['license'] ?? '',
    ),
    ProfileDocumentItemData(
      type: ProfileDocumentType.vehicle,
      icon: Icons.two_wheeler_rounded,
      path: _images['vehicle'] ?? '',
    ),
    ProfileDocumentItemData(
      type: ProfileDocumentType.plate,
      icon: Icons.pin_outlined,
      path: _images['plate'] ?? '',
    ),
  ];

  int get uploadedCount =>
      _images.values.where((value) => value.trim().isNotEmpty).length;

  Future<void> pickImage(String key) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 86,
    );
    if (image == null) return;

    _images = Map<String, String>.from(_images)..[key] = image.path;
    notifyListeners();
  }

  Future<void> save({
    required String nationalId,
    required String licenseNumber,
  }) async {
    final draft = _service.profileDraft.copyWith(
      nationalId: nationalId.trim(),
      licenseNumber: licenseNumber.trim(),
      images: Map<String, String>.from(_images),
    );

    await _service.saveProfileDraft(draft);
  }
}
