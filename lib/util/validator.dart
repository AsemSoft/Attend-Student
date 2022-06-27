class Validator {
  static final _usernamePattern = RegExp(r'(^[\w_\.]{4,}$)');
  static final _emailPattern = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool isValidUsername(String username) {
    return _usernamePattern.hasMatch(username);
  }

  static bool isValidEmail(String email) {
    return _emailPattern.hasMatch(email);
  }

  static String? validateUsername(String? username) {
    if (username!.isEmpty) {
      return 'Username is required';
    }

    return !Validator.isValidUsername(username) ? 'Invalid username' : null;
  }

  static String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Email is required';
    }

    return !Validator.isValidEmail(email) ? 'Invalid email' : null;
  }

  static String? validateNotEmpty(String? value, String field) {
    if (value == null || value.isEmpty) {
      return '$field is required';
    }

    return null;
  }
}
