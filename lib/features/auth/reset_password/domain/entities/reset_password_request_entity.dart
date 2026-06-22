class ResetPasswordRequestEntity {
  const ResetPasswordRequestEntity({
    required this.identifier,
    required this.resetToken,
    required this.newPassword,
  });

  final String identifier;
  final String resetToken;
  final String newPassword;
}
