import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewPage extends StatelessWidget {
  File file;

  PreviewPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Column(
            children: [
              Text(
                'A foto ficou boa?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF0A6D92),
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          )),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Column(
              children: [
                const Text(
                  'Dicas para uma boa foto:',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Text(
                  '1. Verifique se a imagem está nítida',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Text(
                  '2. Verifique se a imagem está bem iluminada',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Text(
                  '3. Verifique se a imagem está bem enquadrada',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 500, // Largura máxima de 500
                  height: 470, // Altura máxima de 500
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Border radius
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit
                          .cover, // A imagem preenche todo o espaço disponível sem distorcer
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 32, right: 32, top: 16, bottom: 16),
                              child: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: const Color(0xFF0A6D92),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () => Get.back(result: file),
                                  )))),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: const Color(0xFF0A6D92),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () => Get.back(),
                                  ))))
                    ],
                  ),
                ),
              ],
            )));
  }
}
