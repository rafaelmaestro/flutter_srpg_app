import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/camera/camera_page.dart';
import 'package:flutter_srpg_app/repositories/login_repository.dart';
import 'package:get/get.dart';

// cpf
// nome
// Email
// foto
// senha
class CadastroPage2 extends StatefulWidget {
  final Map<String, String> usuario;

  const CadastroPage2({super.key, required this.usuario});

  @override
  _CadastroPage2State createState() => _CadastroPage2State();
}

class _CadastroPage2State extends State<CadastroPage2> {
  XFile arquivo = XFile('');
  final LoginRepository loginRepository = LoginRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0A6D92),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFF0A6D92),
              ),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                      child: Image(
                        image: AssetImage('lib/assets/app/icon.png'),
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: const BoxDecoration(
                  color: Colors.white, // Adicione uma cor ao Container
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(64)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Cadastre-se",
                          style: TextStyle(fontSize: 28),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 100,
                              child: Image(
                                image: AssetImage('lib/assets/app/user_m.png'),
                                width: 100,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                'Vamos precisar de uma foto sua para continuar, ok?',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                            const Center(
                              child: Text("📸", style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(height: 70),
                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '*Não se preocupe, ela servirá apenas para ',
                                        style: TextStyle(fontSize: 16)),
                                    TextSpan(
                                        text: 'identificação',
                                        style: TextStyle(fontSize: 16)),
                                    TextSpan(
                                        text: ' e não será divulgada. 😉',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ),
                                Icon(
                                  Icons.looks_two_outlined,
                                  color: Color(0xFF0A6D92),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            _botaoBottom()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _botaoBottom() {
    return ElevatedButton(
      onPressed: () {
        _handleCadastroBiometria();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A6D92),
          minimumSize: const Size(double.infinity, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16)),
          )),
      child: const Text('Vamos lá!',
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }

  _handleCadastroBiometria() async {
    var fotoBiometria = await Get.to(const CameraPage());

    if (fotoBiometria != null) {
      setState(() {
        arquivo = fotoBiometria;
      });

      final bytes = await File(arquivo.path).readAsBytes();

      // Converta os bytes para uma string base64
      final base64Image = base64Encode(bytes);

      print('Cpf ${widget.usuario['cpf']}');
      print('Nome ${widget.usuario['nome']}');
      print('Email ${widget.usuario['email']}');
      print('Senha ${widget.usuario['senha']}');

      // TODO: chamar o backend para cadastrar o usuário
      final response = await loginRepository.signUp(
        widget.usuario['cpf'] ?? '',
        widget.usuario['nome'] ?? '',
        widget.usuario['email'] ?? '',
        widget.usuario['senha'] ?? '',
        '', // TODO: alterar para base64Image para enviar foto de biometria capturada
      );

      if (response.code == 201) {
        Get.snackbar(
          'Deu tudo certo! 😁',
          'Você está cadastrado e já pode acessar o sistema!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 10),
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: Colors.green,
          progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
          isDismissible: true,
        );
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Erro ao realizar cadastro! 😢',
          response.error ??
              'Erro desconhecido ao cadastrar usuário, tente novamente mais tarde ou entre em contato com o suporte em 4002-8922',
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
      }
    }
  }
}
