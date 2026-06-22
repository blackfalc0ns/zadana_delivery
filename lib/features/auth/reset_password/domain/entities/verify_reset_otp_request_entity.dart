class VerifyResetOtpRequestEntity {
  const VerifyResetOtpRequestEntity({
    required this.identifier,
    required this.otpCode,
  });

  final String identifier;
  final String otpCode;
}
