class ResetPasswordRequestModelDto {
  const ResetPasswordRequestModelDto({
    required this.identifier,
    required this.resetToken,
    required this.newPassword,
  });

  final String identifier;
  final String resetToken;
  final String newPassword;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'resetToken': resetToken,
    'newPassword': newPassword,
  };
}
