class UpdateDriverDocumentsRequestEntity {
  const UpdateDriverDocumentsRequestEntity({
    required this.personalPhotoUrl,
    required this.nationalIdFrontImageUrl,
    required this.nationalIdBackImageUrl,
    required this.licenseImageUrl,
    required this.vehicleImageUrl,
  });

  final String personalPhotoUrl;
  final String nationalIdFrontImageUrl;
  final String nationalIdBackImageUrl;
  final String licenseImageUrl;
  final String vehicleImageUrl;
}
