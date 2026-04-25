class UpdateDriverDocumentsRequestEntity {
  const UpdateDriverDocumentsRequestEntity({
    required this.personalPhotoUrl,
    required this.nationalIdImageUrl,
    required this.licenseImageUrl,
    required this.vehicleImageUrl,
  });

  final String personalPhotoUrl;
  final String nationalIdImageUrl;
  final String licenseImageUrl;
  final String vehicleImageUrl;
}
