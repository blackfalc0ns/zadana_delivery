class AuthSessionUserEntity {
  const AuthSessionUserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.profilePhotoUrl,
    required this.favoritesCount,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String profilePhotoUrl;
  final int favoritesCount;
}
