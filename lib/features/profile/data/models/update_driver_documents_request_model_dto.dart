class UpdateDriverDocumentsRequestModelDto {
  const UpdateDriverDocumentsRequestModelDto({
    required this.personalPhotoUrl,
    required this.nationalIdImageUrl,
    required this.licenseImageUrl,
    required this.vehicleImageUrl,
  });

  final String personalPhotoUrl;
  final String nationalIdImageUrl;
  final String licenseImageUrl;
  final String vehicleImageUrl;

  Map<String, dynamic> toJson() => {
    'personalPhotoUrl': personalPhotoUrl,
    'nationalIdImageUrl': nationalIdImageUrl,
    'licenseImageUrl': licenseImageUrl,
    'vehicleImageUrl': vehicleImageUrl,
  };
}
