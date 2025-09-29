class Validators {
  /// Non-empty validator
  static bool notEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Email validator
  static bool email(String? value) {
    if (value == null || value.trim().isEmpty) return false;

    final regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]+)+$",
    );
    return regExp.hasMatch(value.trim());
  }

  /// Strong password validator
  static bool password(String? value) {
    if (value == null || value.isEmpty) return false;

    final regExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
    );
    return regExp.hasMatch(value);
  }

  /// Confirm password validator
  static bool confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) return false;
    return password == confirmPassword;
  }
}
