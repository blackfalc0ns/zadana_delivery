class DriverAccountSupportAppealArgs {
  const DriverAccountSupportAppealArgs({
    this.identifier,
    this.initialReasonCode,
    this.buttonLabel,
    this.requiresAuthentication = true,
  });

  final String? identifier;
  final String? initialReasonCode;
  final String? buttonLabel;
  final bool requiresAuthentication;
}
