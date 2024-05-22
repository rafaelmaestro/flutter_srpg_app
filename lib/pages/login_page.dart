import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/cadastro_page_1.dart';
import 'package:flutter_srpg_app/pages/esqueceu_senha_page.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// cpf
// nome
// Email
// foto
// senha
class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                color: const Color(0xFF0A6D92),
                // image: DecorationImage(
                //     image: AssetImage('lib/assets/app/icon.png'))
              ),
              child: Center(
                child: Image(
                  image: AssetImage('lib/assets/app/icon.png'),
                  width: 100,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white, // Adicione uma cor ao Container
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(64)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Acesse sua conta",
                          style: TextStyle(fontSize: 28),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyInputField(
                              label: "Email ou CPF",
                              placeholder: "Insira seu e-mail ou cpf",
                              onChange: (value) {
                                this.emailController.text = value;
                              },
                              isEmailOrCpfField: true,
                            ),
                            SizedBox(height: 20),
                            MyInputField(
                              label: "Senha",
                              placeholder: "Insira sua senha",
                              onChange: (value) {
                                this.passwordController.text = value;
                              },
                              isPasswordField: true,
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                _handleLogin();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A6D92),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
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
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(text: 'Não tem uma conta? '),
                                  TextSpan(
                                    text: 'Cadastre-se',
                                    style: TextStyle(
                                        color: const Color(0xFF0A6D92)),
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Esqueceu sua senha?',
                                    style: TextStyle(
                                        color: const Color(0xFF0A6D92)),
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
    Get.to(() => CadastroPage1());
  }

  _handleEsqueceuSenha() {
    Get.to(() => EsqueceuSenhaPage());
  }
}
