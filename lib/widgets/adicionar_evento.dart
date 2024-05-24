import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/evento/adicionar_evento_page_1.dart';
import 'package:get/get.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.to(() => const AdicionarEventoPage1());
      },
      backgroundColor: const Color(0xFF0A6D92),
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
