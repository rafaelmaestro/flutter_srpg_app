import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

handleSessionExpired() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  Get.offAllNamed('/');

  Get.snackbar(
    'Sessão expirada! 😢',
    'Parece que sua sessão expirou, por favor, faça login novamente para continuar usando o SRPG!',
    backgroundColor: Colors.orange,
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 10),
    showProgressIndicator: true,
    progressIndicatorBackgroundColor: Colors.orange,
    progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
      Colors.white,
    ),
    isDismissible: true,
  );
}
