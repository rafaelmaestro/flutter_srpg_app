import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/cadastro/cadastro_page_1.dart';
import 'package:flutter_srpg_app/pages/login/esqueceu_senha_page.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                                label: "Email ou CPF",
                                placeholder: "Insira seu e-mail ou CPF",
                                onChange: (value) {
                                  emailController.text = value;
                                },
                                isEmailOrCpfField: true,
                                validateFunction: (value) {
                                  // TODO: descomentar as validações
                                  // if (value == null || value.isEmpty) {
                                  //   return 'Por favor, insira seu e-mail ou CPF';
                                  // }

                                  // if (isNumeric(value)) {
                                  //   if (value.length != 11) {
                                  //     return 'CPF inválido';
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // }

                                  // if (value.contains('@') == true ||
                                  //     isNumeric(value) == false) {
                                  //   if (!isValidEmail(value)) {
                                  //     return 'E-mail inválido';
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // }

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
                                  // TODO: descomentar as validações
                                  // if (value == null || value.isEmpty) {
                                  //   return 'Senha não pode ser vazia';
                                  // }
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
                                        _handleCadastrar();
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
                                        _handleEsqueceuSenha();
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

  _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // TODO: Implementar a lógica de login
    print("Email: ${emailController.text}");
    print("Senha: ${passwordController.text}");
    // TODO: substituir o nome do usuário
    Fluttertoast.showToast(
        msg: 'Bem vindo de volta, Rafael! 🎉',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Get.toNamed('/home');
  }

  _handleCadastrar() {
    Get.to(() => const CadastroPage1());
  }

  _handleEsqueceuSenha() {
    Get.to(() => const EsqueceuSenhaPage());
  }
}
