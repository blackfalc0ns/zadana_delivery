class ProfileHeaderIdentity {
  const ProfileHeaderIdentity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatarLetter,
    this.photoUrl = '',
  });

  final String fullName;
  final String email;
  final String phone;
  final String avatarLetter;
  final String photoUrl;
}
