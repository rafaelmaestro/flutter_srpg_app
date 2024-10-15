import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/helpers/is_numeric_helper.dart';
import 'package:flutter_srpg_app/helpers/is_valid_email_helper.dart';
import 'package:flutter_srpg_app/pages/cadastro/cadastro_page_1.dart';
import 'package:flutter_srpg_app/pages/login/esqueceu_senha_page.dart';
import 'package:flutter_srpg_app/repositories/login_repository.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController tokenEmailController = TextEditingController();
  final LoginRepository loginRepository = LoginRepository();
  final _formKey = GlobalKey<FormState>();
  final _formTokenEmailKey = GlobalKey<FormState>();
  ValueNotifier<int> countdownNotifier = ValueNotifier<int>(0);
  bool hasVerifiedToken = false;

  @override
  void initState() {
    _handleSession();
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
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                color: Color(0xFF0A6D92),
              ),
              child: const Center(
                child: Image(
                  image: AssetImage('lib/assets/app/icon.png'),
                  width: 100,
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
                          "Acesse sua conta",
                          style: TextStyle(fontSize: 28),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyInputField(
                                label: "E-mail ou CPF",
                                placeholder: "Insira seu e-mail ou CPF",
                                onChange: (value) {
                                  emailController.text = value;
                                },
                                isEmailOrCpfField: true,
                                validateFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu e-mail ou CPF';
                                  }

                                  if (isNumeric(value)) {
                                    if (value.length != 11) {
                                      return 'CPF inválido';
                                    } else {
                                      return null;
                                    }
                                  }

                                  if (value.contains('@') == true ||
                                      isNumeric(value) == false) {
                                    if (!isValidEmail(value)) {
                                      return 'E-mail inválido';
                                    } else {
                                      return null;
                                    }
                                  }

                                  return null;
                                },
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF0A6D92)),
                              ),
                              const SizedBox(height: 20),
                              MyInputField(
                                label: "Senha",
                                placeholder: "Insira sua senha",
                                onChange: (value) {
                                  passwordController.text = value;
                                },
                                isPasswordField: true,
                                validateFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Senha não pode ser vazia';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: () {
                                  _handleLogin();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A6D92),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)),
                                    )),
                                child: const Text('Entrar',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Não tem uma conta? '),
                                  TextSpan(
                                    text: 'Cadastre-se',
                                    style: const TextStyle(
                                        color: Color(0xFF0A6D92)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        handleCadastrar();
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Esqueceu sua senha?',
                                    style: const TextStyle(
                                        color: Color(0xFF0A6D92)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        handleEsqueceuSenha();
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cpf = emailController.text;
    final senha = passwordController.text;

    final response = await loginRepository.login(cpf, senha);

    if (response.code == 200) {
      final accessToken = response.accessToken;

      if (accessToken == null) {
        Get.snackbar(
          'Falha no login! 😢',
          response.error ??
              'Erro desconhecido ao realizar login! \n Por favor, verifique suas credenciais e tente novamente, ou entre em contato com o suporte em 📞 4002-8922',
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
        return;
      }

      _showTokenModal(accessToken);
    } else {
      Get.snackbar(
        'Falha no login! 😢',
        response.error ??
            'Erro desconhecido ao realizar login! \n Por favor, verifique suas credenciais e tente novamente, ou entre em contato com o suporte em 📞 4002-8922',
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

  handleCadastrar() {
    Get.to(() => const CadastroPage1());
  }

  handleEsqueceuSenha() {
    Get.to(() => const EsqueceuSenhaPage());
  }

  void _showTokenModal(String accessToken) {
    int countdown = 10 * 60; // 10 minutos em segundos
    Timer? countdownTimer;
    bool isModalOpen = false;

    countdownNotifier.value = countdown;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownNotifier.value > 0) {
        countdownNotifier.value--;
      } else {
        timer.cancel();
        if (!hasVerifiedToken) {
          Navigator.of(Get.context!).pop();
          Get.snackbar(
            'Token expirado! 😢',
            'Parece que o token de segurança expirou! \n Por favor, tente novamente, ou entre em contato com o suporte em 📞 4002-8922',
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
    });

    String formatCountdown(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$remainingSeconds';
    }

    if (!isModalOpen) {
      isModalOpen = true;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Token de segurança enviado para o seu e-mail! 📧',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ValueListenableBuilder<int>(
                    valueListenable: countdownNotifier,
                    builder: (context, value, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatCountdown(value),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: _formTokenEmailKey,
                            child: MyInputField(
                              label: "Insira o token",
                              maxLen: 8,
                              placeholder: "Ex: 1f3h56jq",
                              onChange: (value) {
                                tokenEmailController.text = value;
                              },
                              isEmailOrCpfField: true,
                              validateFunction: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira o token de segurança';
                                }

                                if (value.length != 8) {
                                  return 'Insira um token válido';
                                }

                                return null;
                              },
                              prefixIcon: const Icon(Icons.key,
                                  color: Color(0xFF0A6D92)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0A6D92),
                  side: const BorderSide(color: Color(0xFF0A6D92), width: 2),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (!hasVerifiedToken) {
                    _callCompareToken(tokenEmailController.text, accessToken);
                  }
                },
                child: const Text(
                  'Validar token',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ).then((_) {
        // Cancelar o timer quando o diálogo for fechado
        countdownTimer?.cancel();
        isModalOpen = false;
      });
    }
  }

  _callCompareToken(String tokenEmail, String accessToken) async {
    if (!_formTokenEmailKey.currentState!.validate()) {
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();

      final response =
          await loginRepository.compareToken(tokenEmail, accessToken);

      if (response.code == 401) {
        Get.snackbar(
          'Token inválido! 😢',
          'O token inserido é inválido! \nPor favor, verifique o token e tente novamente, ou entre em contato com o suporte em 📞 4002-8922',
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

        setState(() {
          hasVerifiedToken = false;
        });

        return;
      }

      setState(() {
        hasVerifiedToken = true;
      });

      await _showLoginMessage();

      Get.offNamed('/home');

      await prefs.setString('access_token', accessToken);
    } catch (err) {
      Get.snackbar(
        'Falha ao validar token! 😢',
        'Erro desconhecido ao validar token! \nPor favor, verifique o token e tente novamente, ou entre em contato com o suporte em 📞 4002-8922',
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

  _handleSession() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      final response = await LoginRepository().getMe(accessToken);

      if (response.code == 200) {
        await _showLoginMessage();
        Get.offNamed('/home');
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();

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
    }
  }

  _showLoginMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final nomeCompleto = prefs.getString('nome');
    final nomeUsuario = nomeCompleto?.split(' ')[0] ?? nomeCompleto;

    Get.snackbar(
      'Bem vindo de volta, $nomeUsuario! 🎉',
      'Você está logado e pronto para usar o SRPG!',
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
  }
}
