class UpdateCurrentDriverRequestModelDto {
  const UpdateCurrentDriverRequestModelDto({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  final String fullName;
  final String email;
  final String phone;

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
  };
}
