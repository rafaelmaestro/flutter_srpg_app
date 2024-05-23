bool isValidPassword(String password) {
  final RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  return regex.hasMatch(password);
}
