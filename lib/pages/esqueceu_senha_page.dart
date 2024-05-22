import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:get/get.dart';

// cpf
// nome
// Email
// foto
// senha
class EsqueceuSenhaPage extends StatefulWidget {
  @override
  _EsqueceuSenhaPageState createState() => _EsqueceuSenhaPageState();
}

class _EsqueceuSenhaPageState extends State<EsqueceuSenhaPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isButtonPressed = false;

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
                        ..._buildPageContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _buildPageContent() {
    if (isButtonPressed) {
      return [
        Column(
          children: [
            Center(
              child: Icon(Icons.check_circle, size: 100, color: Colors.green),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Caso haja uma conta associada a este e-mail, você receberá instruções para redefinir sua senha.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Get.back();
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
              child: const Text('Retornar',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        )
      ];
    } else {
      return [
        Text(
          "Esqueceu sua senha?",
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
        )
      ];
    }
  }

  _handleProsseguir() {
    // TODO: Seguir para página 2
    // TODO: Criar um controller para armazenar os dados do usuário
    setState(() {
      isButtonPressed = true;
    });
  }
}
