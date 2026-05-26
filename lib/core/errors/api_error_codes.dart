/// Known API error codes returned by the server.
/// Used for specific error handling in the UI layer.
abstract class ApiErrorCodes {
  // Registration Upload Token errors
  static const String tokenMissing = 'TOKEN_MISSING';
  static const String tokenMalformed = 'TOKEN_MALFORMED';
  static const String tokenInvalidSignature = 'TOKEN_INVALID_SIGNATURE';
  static const String tokenExpired = 'TOKEN_EXPIRED';
  static const String invalidUploadDirectory = 'INVALID_UPLOAD_DIRECTORY';

  // CAPTCHA errors
  static const String botChallengeFailed = 'BOT_CHALLENGE_FAILED';

  // JWT Revocation errors
  static const String tokenRevoked = 'TOKEN_REVOKED';
  static const String userTokensRevoked = 'USER_TOKENS_REVOKED';

  // OTP errors
  static const String otpAccountLocked = 'OTP_ACCOUNT_LOCKED';

  // Rate limiting
  static const String tooManyRequests = 'TOO_MANY_REQUESTS';
}
