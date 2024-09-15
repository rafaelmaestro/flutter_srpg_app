import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  Size? size;

  @override
  void initState() {
    super.initState();
    _loadCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller?.dispose();
    super.dispose();
  }

  _loadCamera() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {
      rethrow;
    }
  }

  _startCamera() {
    if (cameras.isEmpty) {
      Get.snackbar(
        'Não há câmeras disponíveis! 😢',
        'Erro desconhecido ao iniciar a câmera, tente novamente mais tarde ou entre em contato com o suporte em 4002-8922',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 10),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.red,
        progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        isDismissible: true,
      );
    } else {
      _previewCamera(cameras.first);
    }
  }

  _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
        camera, ResolutionPreset.max,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);

    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      rethrow;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Column(
            children: [
              Text(
                'Biometria Facial',
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
        body: Stack(
          children: [
            Container(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      'Dicas para uma boa foto:',
                      style: TextStyle(color: Color(0xFF0A6D92), fontSize: 12),
                    ),
                    const Text(
                      '1. Verifique se a imagem está nítida',
                      style: TextStyle(color: Color(0xFF0A6D92), fontSize: 12),
                    ),
                    const Text(
                      '2. Verifique se a imagem está bem iluminada',
                      style: TextStyle(color: Color(0xFF0A6D92), fontSize: 12),
                    ),
                    const Text(
                      '3. Verifique se a imagem está bem enquadrada',
                      style: TextStyle(color: Color(0xFF0A6D92), fontSize: 12),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: _arquivoWidget(),
                    ),
                    const SizedBox(height: 15)
                  ],
                ),
              ),
            ),
            if (imagem != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: _botaoInferior(),
              )
          ],
        ));
  }

  _botaoInferior() {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 16, bottom: 16),
              child: CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color.fromARGB(255, 1, 90, 32),
                  child: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => {Get.back(result: imagem)}
                      // Get.back(result: file),
                      ))),
          Padding(
              padding: const EdgeInsets.all(32),
              child: CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color.fromARGB(255, 110, 12, 1),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => {
                      setState(() {
                        imagem = null;
                      })
                    },
                  )))
        ],
      ),
    );
  }

  _arquivoWidget() {
    final CameraController? cameraController = controller;

    if (imagem != null) {
      return SizedBox(
          width: size!.width - 50,
          height: size!.height - (size!.height / 3),
          child: Image.file(
            File(imagem!.path),
            fit: BoxFit.contain,
          ));
    }

    if (imagem == null &&
        (cameraController == null || !cameraController.value.isInitialized)) {
      return const Padding(
          padding: EdgeInsets.only(top: 200),
          child: Center(
              child: CircularProgressIndicator(color: Color(0xFF0A6D92))));
    } else {
      return SizedBox(
          width: size!.width,
          height: size!.height - (size!.height / 4),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CameraPreview(controller!),
              _botaoCapturaWidget(),
            ],
          ));
    }
  }

  _botaoCapturaWidget() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF0A6D92),
            child: IconButton(
              onPressed: _tirarFoto,
              icon: const Icon(Icons.camera_alt),
              color: Colors.white,
              iconSize: 30,
            )));
  }

  _tirarFoto() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();
        if (mounted) {
          setState(() {
            imagem = file;
          });
        }
      } on CameraException catch (e) {
        rethrow;
      }
    }
  }
}
