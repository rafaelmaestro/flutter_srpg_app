import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/evento/adicionar_evento_page_2.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdicionarEventoPage1 extends StatefulWidget {
  const AdicionarEventoPage1({super.key});

  @override
  _EventoAlunoPageState createState() => _EventoAlunoPageState();
}

class _EventoAlunoPageState extends State<AdicionarEventoPage1> {
  var pergunta = 1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController localController = TextEditingController();

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
        automaticallyImplyLeading: false,
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
                            const Center(
                              child: Text(
                                'O que você quer organizar? 🏫',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20),
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
                              prefixIcon: const Icon(
                                Icons.abc,
                                color: Color(0xFF0A6D92),
                              ),
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
                              prefixIcon: const Icon(
                                Icons.event_note,
                                color: Color(0xFF0A6D92),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                'Quando vai acontecer? 📅',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // ! Cópia do style dos inputs textuais
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16)),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 32,
                                      color: Colors.black.withOpacity(.1),
                                    )
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DateTimeField(
                                    decoration: const InputDecoration(
                                        labelText: 'Data do Evento',
                                        labelStyle:
                                            TextStyle(color: Color(0xFF0A6D92)),
                                        hintText: 'Selecione a data do evento',
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFF0A6D92),
                                        ),
                                        errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(8.0)),
                                    format: DateFormat("yyyy-MM-dd"),
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                      return date;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // ! Cópia do style dos inputs textuais
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16)),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 32,
                                      color: Colors.black.withOpacity(.1),
                                    )
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DateTimeField(
                                    decoration: const InputDecoration(
                                        labelText: 'Hora de início do evento',
                                        labelStyle:
                                            TextStyle(color: Color(0xFF0A6D92)),
                                        hintText:
                                            'Selecione a hora de início do evento',
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.access_time,
                                          color: Color(0xFF0A6D92),
                                        ),
                                        errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(8.0)),
                                    format: DateFormat("HH:mm"),
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.convert(time);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // ! Cópia do style dos inputs textuais
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16)),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 32,
                                      color: Colors.black.withOpacity(.1),
                                    )
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DateTimeField(
                                    decoration: const InputDecoration(
                                        labelText: 'Hora de término do evento',
                                        labelStyle:
                                            TextStyle(color: Color(0xFF0A6D92)),
                                        hintText:
                                            'Selecione a hora de término do evento',
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.access_time_filled,
                                          color: Color(0xFF0A6D92),
                                        ),
                                        errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(8.0)),
                                    format: DateFormat("HH:mm"),
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.convert(time);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                'Onde será o evento? 📍',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20),
                            MyInputField(
                              label: "Local do evento",
                              maxLen: 200,
                              placeholder: "Digite o local do evento",
                              onChange: (value) {
                                localController.text = value;
                              },
                              validateFunction: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Por favor, insira um nome para o evento';
                                // }
                                return null;
                              },
                              prefixIcon: const Icon(
                                Icons.location_pin,
                                color: Color(0xFF0A6D92),
                              ),
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
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SRPGNavigationBar(),
    );
  }

  _handleProsseguir() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // TODO: Seguir p/ pagina 2 de cadastro de evento
    Get.to(() => const AdicionarEventoPage2());
  }
}
