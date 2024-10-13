import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_srpg_app/helpers/is_numeric_helper.dart';
import 'package:flutter_srpg_app/helpers/is_valid_email_helper.dart';
import 'package:flutter_srpg_app/helpers/is_valid_password_helper.dart';
import 'package:flutter_srpg_app/pages/cadastro/cadastro_page_2.dart';
import 'package:flutter_srpg_app/repositories/login_repository.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:get/get.dart';

class CadastroPage1 extends StatefulWidget {
  const CadastroPage1({super.key});

  @override
  _CadastroPage1State createState() => _CadastroPage1State();
}

class _CadastroPage1State extends State<CadastroPage1> {
  final LoginRepository loginRepository = LoginRepository();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isBiometriaEnabled =
      FlutterConfig.get('BIOMETRIA_ON_BOOLEAN') == 'true' ? true : false;

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
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyInputField(
                                label: "Nome",
                                placeholder: "Insira seu nome completo",
                                onChange: (value) {
                                  nomeController.text = value;
                                },
                                validateFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu nome completo';
                                  }
                                  return null;
                                },
                                prefixIcon: const Icon(
                                  Icons.abc,
                                  color: Color(0xFF0A6D92),
                                ),
                              ),
                              const SizedBox(height: 20),
                              MyInputField(
                                label: "E-mail",
                                placeholder: "Insira seu melhor e-mail",
                                onChange: (value) {
                                  emailController.text = value;
                                },
                                isEmailOrCpfField: true,
                                validateFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu e-mail';
                                  }

                                  if (isValidEmail(value) == false) {
                                    return 'Por favor insira um e-mail válido';
                                  }
                                  return null;
                                },
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Color(0xFF0A6D92),
                                ),
                              ),
                              const SizedBox(height: 20),
                              MyInputField(
                                label: "CPF",
                                placeholder: "Insira seu CPF",
                                onChange: (value) {
                                  cpfController.text = value;
                                },
                                validateFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu CPF';
                                  }

                                  if (isNumeric(value) == false) {
                                    return 'Por favor insira um CPF válido';
                                  }

                                  if (value.length != 11) {
                                    return 'Por favor insira um CPF válido';
                                  }
                                  return null;
                                },
                                prefixIcon: const Icon(
                                  Icons.perm_identity,
                                  color: Color(0xFF0A6D92),
                                ),
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
                                    return 'Por favor, insira sua senha';
                                  }

                                  if (isValidPassword(value) == false) {
                                    return 'A senha deve conter no mínimo 8 caracteres, uma letra maiúscula, uma letra minúscula, um caractere especial e um número';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              MyInputField(
                                label: "Confirme sua senha",
                                placeholder: "Insira sua senha novamente",
                                onChange: (value) {
                                  confirmPasswordController.text = value;
                                },
                                validateFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira sua senha novamente';
                                  }

                                  if (isValidPassword(value) == false) {
                                    return 'A senha deve conter no mínimo 8 caracteres, uma letra maiúscula, uma letra minúscula, um caractere especial e um número';
                                  }

                                  if (passwordController.text != value) {
                                    return 'As senhas não conferem';
                                  }
                                  return null;
                                },
                                isPasswordField: true,
                              ),
                              const SizedBox(height: 20),
                              if (isBiometriaEnabled)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.looks_one_outlined,
                                      color: Color(0xFF0A6D92),
                                    ),
                                    Icon(
                                      Icons.looks_two_outlined,
                                      color: Colors.grey,
                                    ),
                                  ],
                                )
                              else
                                const SizedBox.shrink(),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: () {
                                  _handleProsseguir();
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
                                child: const Text('Prosseguir',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
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

  _handleProsseguir() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = {
      'nome': nomeController.text,
      'email': emailController.text,
      'cpf': cpfController.text,
      'senha': passwordController.text,
    };

    if (isBiometriaEnabled) {
      Get.to(() => CadastroPage2(usuario: usuario));
    }

    final response = await loginRepository.signUp(
      usuario['cpf']!,
      usuario['nome']!,
      usuario['email']!,
      usuario['senha']!,
      '', // TODO: Ao implementar o fluxo de biometria de forma funcional, essa propriedade deve ser preenchida na página 2
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
