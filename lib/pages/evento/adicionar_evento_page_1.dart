import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/widgets/adicionar_evento.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';

class AdicionarEventoPage1 extends StatefulWidget {
  const AdicionarEventoPage1({super.key});

  @override
  _EventoAlunoPageState createState() => _EventoAlunoPageState();
}

class _EventoAlunoPageState extends State<AdicionarEventoPage1> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // nome do evento
  // descrição do evento
  // data e hora do evento
  // endereco do evento (cep, cidade, estado, rua, numero, complemento?)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'Criar Novo Evento',
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyInputField(
                              label: "Nome",
                              placeholder: "Insira o nome do seu evento",
                              onChange: (value) {
                                // emailController.text = value;
                              },
                              validateFunction: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Por favor, insira um nome para o evento';
                                // }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            MyInputField(
                              label: "Descrição",
                              placeholder: "Insira uma descrição para o evento",
                              onChange: (value) {
                                // emailController.text = value;
                              },
                              validateFunction: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Por favor, insira um nome para o evento';
                                // }
                                return null;
                              },
                              maxLen: 200,
                            ),
                            const SizedBox(height: 20),
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
                                Icon(
                                  Icons.looks_3_outlined,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFloatingActionButton(),
      bottomNavigationBar: const SRPGNavigationBar(),
    );
  }
}
