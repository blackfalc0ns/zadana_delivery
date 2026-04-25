class UpdateDriverPersonalRequestEntity {
  const UpdateDriverPersonalRequestEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  final String fullName;
  final String email;
  final String phone;
  final String address;
}
