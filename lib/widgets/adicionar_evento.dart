import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Coloque aqui o código que deve ser executado quando o botão é pressionado
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
