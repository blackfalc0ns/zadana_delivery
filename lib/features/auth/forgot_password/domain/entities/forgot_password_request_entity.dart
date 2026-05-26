class ForgotPasswordRequestEntity {
  const ForgotPasswordRequestEntity({
    required this.identifier,
    this.botChallengeToken,
  });

  final String identifier;

  /// Cloudflare Turnstile token. May be null/empty if CAPTCHA is disabled.
  final String? botChallengeToken;
}
