class ResetPasswordRequestModelDto {
  const ResetPasswordRequestModelDto({
    required this.identifier,
    required this.otpCode,
    required this.newPassword,
  });

  final String identifier;
  final String otpCode;
  final String newPassword;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'otpCode': otpCode,
    'newPassword': newPassword,
  };
}
