bool isNumeric(String str) {
  final RegExp regex = RegExp(r'^[0-9]+$');
  return regex.hasMatch(str);
}
