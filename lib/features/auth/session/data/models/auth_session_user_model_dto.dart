class AuthSessionUserModelDto {
  const AuthSessionUserModelDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.favoritesCount,
  });

  factory AuthSessionUserModelDto.fromJson(Map<String, dynamic> json) {
    return AuthSessionUserModelDto(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? 'driver',
      favoritesCount: json['favoritesCount'] is int
          ? json['favoritesCount'] as int
          : 0,
    );
  }

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final int favoritesCount;
}
