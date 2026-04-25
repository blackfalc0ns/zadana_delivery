class UpdateCurrentDriverRequestEntity {
  const UpdateCurrentDriverRequestEntity({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  final String fullName;
  final String email;
  final String phone;
}
