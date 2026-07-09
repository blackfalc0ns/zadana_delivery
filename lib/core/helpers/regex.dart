abstract class AppRegExp {
  static bool isNameValid(String name) {
    return RegExp(
      r"^[A-Za-z\u0600-\u06FF]{2,}(?:\s+[A-Za-z\u0600-\u06FF]{2,})*$",
    ).hasMatch(name);
  }

  static bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    return RegExp(r"^01[0125][0-9]{8}$").hasMatch(phoneNumber);
  }

  static bool isOTPValid(String otp) {
    return RegExp(r"^[0-9]{6}$").hasMatch(otp);
  }

  static bool isPasswordValid(String password) {
    // Server requirement: 8+ characters, at least one lowercase letter, at least one digit.
    return RegExp(r'^(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(password);
  }
}
