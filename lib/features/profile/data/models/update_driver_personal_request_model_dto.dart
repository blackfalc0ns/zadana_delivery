class UpdateDriverPersonalRequestModelDto {
  const UpdateDriverPersonalRequestModelDto({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  final String fullName;
  final String email;
  final String phone;
  final String address;

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'address': address,
  };
}
