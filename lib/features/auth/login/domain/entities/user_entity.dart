class UserEntity {
  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePhotoUrl = '',
    this.favoritesCount = 0,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String profilePhotoUrl;
  final int favoritesCount;
}
