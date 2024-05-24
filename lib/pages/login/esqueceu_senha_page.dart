import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/helpers/is_numeric_helper.dart';
import 'package:flutter_srpg_app/helpers/is_valid_email_helper.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:get/get.dart';

class EsqueceuSenhaPage extends StatefulWidget {
  const EsqueceuSenhaPage({super.key});

  @override
  _EsqueceuSenhaPageState createState() => _EsqueceuSenhaPageState();
}

class _EsqueceuSenhaPageState extends State<EsqueceuSenhaPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isButtonPressed = false;
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
            const Center(
              child: Icon(Icons.check_circle, size: 100, color: Colors.green),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Caso haja uma conta associada a este e-mail, você receberá instruções para redefinir sua senha.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Get.back();
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
        const Text(
          "Esqueceu sua senha?",
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
                prefixIcon: const Icon(
                  Icons.person,
                  color: Color(0xFF0A6D92),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _handleProsseguir();
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
                child: const Text('Prosseguir',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        )
      ];
    }
  }

  _handleProsseguir() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // TODO: Seguir para página 2
    // TODO: Criar um controller para armazenar os dados do usuário
    setState(() {
      isButtonPressed = true;
    });
  }
}
