class VerifyDriverOtpRequestEntity {
  const VerifyDriverOtpRequestEntity({
    required this.identifier,
    required this.otpCode,
  });

  final String identifier;
  final String otpCode;
}
