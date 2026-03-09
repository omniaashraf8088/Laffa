/// Email, password, and form validators for authentication
class AuthValidators {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validates password strength and minimum length
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  /// Validates that two passwords match
  static String? validatePasswordMatch(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates name field
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    return null;
  }

  /// Validates phone number (basic international format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    // Remove all non-digit characters
    final phoneDigits = value.replaceAll(RegExp(r'\D'), '');

    if (phoneDigits.length < 10) {
      return 'Please enter a valid phone number';
    }

    if (phoneDigits.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  /// Check password strength
  static PasswordStrength checkPasswordStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength.none;
    }

    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int score = 0;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasDigits) score++;
    if (hasSpecialChar) score++;

    if (password.length >= 12 && score >= 3) {
      return PasswordStrength.strong;
    } else if (password.length >= 8 && score >= 2) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.weak;
    }
  }
}

/// Enum for password strength levels
enum PasswordStrength { none, weak, medium, strong }

extension PasswordStrengthExtension on PasswordStrength {
  String get label {
    switch (this) {
      case PasswordStrength.none:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  int get value {
    switch (this) {
      case PasswordStrength.none:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.medium:
        return 2;
      case PasswordStrength.strong:
        return 3;
    }
  }
}
