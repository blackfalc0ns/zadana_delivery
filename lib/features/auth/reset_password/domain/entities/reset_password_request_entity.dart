class ResetPasswordRequestEntity {
  const ResetPasswordRequestEntity({
    required this.identifier,
    required this.otpCode,
    required this.newPassword,
  });

  final String identifier;
  final String otpCode;
  final String newPassword;
}
