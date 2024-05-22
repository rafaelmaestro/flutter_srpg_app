import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/cadastro_page_2.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:get/get.dart';

// cpf
// nome
// Email
// foto
// senha
class CadastroPage1 extends StatefulWidget {
  @override
  _CadastroPage1State createState() => _CadastroPage1State();
}

class _CadastroPage1State extends State<CadastroPage1> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

// TODO: validar os forms e criar um controller para armazenar os dados do usuário
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0A6D92),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: const Color(0xFF0A6D92),
              ),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Container(
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
                          "Cadastre-se",
                          style: TextStyle(fontSize: 28),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyInputField(
                              label: "Nome",
                              placeholder: "Insira seu nome completo",
                              onChange: (value) {
                                // this.emailController.text = value;
                              },
                            ),
                            SizedBox(height: 20),
                            MyInputField(
                              label: "E-mail",
                              placeholder: "Insira seu melhor e-mail",
                              onChange: (value) {
                                this.emailController.text = value;
                              },
                              isEmailOrCpfField: true,
                            ),
                            SizedBox(height: 20),
                            MyInputField(
                              label: "CPF",
                              placeholder: "Insira seu cpf",
                              onChange: (value) {
                                this.emailController.text = value;
                              },
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
                            SizedBox(height: 20),
                            MyInputField(
                              label: "Confirme sua senha",
                              placeholder: "Insira sua senha novamente",
                              onChange: (value) {
                                this.passwordController.text = value;
                              },
                              isPasswordField: true,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.looks_one_outlined,
                                  color: const Color(0xFF0A6D92),
                                ),
                                Icon(
                                  Icons.looks_two_outlined,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                _handleProsseguir();
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
                              child: const Text('Prosseguir',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
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

  _handleProsseguir() {
    // TODO: Seguir para página 2
    // TODO: Criar um controller para armazenar os dados do usuário
    Get.to(() => CadastroPage2());
  }
}
