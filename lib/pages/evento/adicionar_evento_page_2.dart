import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/aula.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdicionarEventoPage2 extends StatefulWidget {
  Evento aulaASerCriada;
  AdicionarEventoPage2({super.key, required this.aulaASerCriada});

  @override
  _EventoAlunoPageState createState() => _EventoAlunoPageState();
}

class _EventoAlunoPageState extends State<AdicionarEventoPage2> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> listController = [];
  TextEditingController inputEmailController = TextEditingController();
  double eventoLatitude = 0.0;
  double eventoLongitude = 0.0;

  Set<Marker> markers = <Marker>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    listController.forEach((element) {
      element.dispose();
    });

    inputEmailController.dispose();
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
                            const Center(
                              child: Text(
                                'Quem você deseja convidar? 🤔',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Container do InputField
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF0A6D92),
                                  ),
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
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Digite o e-mail do convidado';
                                      }
                                      return null;
                                    },
                                    controller: inputEmailController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person,
                                            color: const Color(0xFF0A6D92)),
                                        labelText: "Convidado",
                                        labelStyle: const TextStyle(
                                            color: Color(0xFF0A6D92)),
                                        hintText:
                                            "Digite o e-mail do convidado",
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding:
                                            const EdgeInsets.all(0)),
                                  ),
                                ],
                              ),
                            ),
                            // Fim do Container do InputField
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _handleAdicionar();
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
                              child: const Text('Adicionar',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                '${listController.length} convidados:',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Column(
                              children:
                                  List.generate(listController.length, (index) {
                                return Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Color(0xFF0A6D92),
                                    ),
                                    title: Text(listController[index].text),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        // Aqui você pode adicionar a lógica para remover o item da lista
                                        setState(() {
                                          listController.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Icon(
                                  Icons.looks_one_sharp,
                                  color: Color(0xFF0A6D92),
                                ),
                                Icon(
                                  Icons.looks_two_outlined,
                                  color: Color(0xFF0A6D92),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _handleCriarEvento();
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

  _handleAdicionar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      listController.insert(
          0, TextEditingController(text: inputEmailController.text));
      inputEmailController.clear();
    });
  }

  _handleCriarEvento() async {
    if (listController.length == 0) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Ops! Parece que você está planejando o evento mais exclusivo de todos! 😅',
              textAlign: TextAlign.center, // Centraliza o título
              style: TextStyle(
                  fontWeight: FontWeight.bold), // Torna o título em negrito
            ),
            content: const Text(
              'Vamos lá, adicione pelo menos um convidado. Afinal, até as plantas gostam de companhia! 🌱',
              textAlign: TextAlign.center, // Centraliza o conteúdo
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.green, // Cor do texto do botão Cancelar
                    side: const BorderSide(
                        color: Colors.green,
                        width: 2), // Borda do botão Cancela
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok, vou adicionar alguém!'),
                ),
              )
            ],
          );
        },
      );
    }

    listController.forEach((element) {
      widget.aulaASerCriada.adicionarConvidado(element.text);
    });

    // TODO: Requisição p/ backend criar evento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: CircularProgressIndicator(color: Color(0xFF0A6D92)),
          ),
        );
      },
    );

    print('Aula será criada com os seguintes parâmetros:');
    print('Nome: ${widget.aulaASerCriada.nome}');
    print('Descrição: ${widget.aulaASerCriada.descricao}');
    print('Data de início: ${widget.aulaASerCriada.dataInicio}');
    print('Data de fim: ${widget.aulaASerCriada.dataFim}');
    print('Local: ${widget.aulaASerCriada.local}');
    print('Latitude: ${widget.aulaASerCriada.latitude}');
    print('Longitude: ${widget.aulaASerCriada.longitude}');
    print('CPF do organizador: ${widget.aulaASerCriada.cpfOrganizador}');
    print('Convidados: ${widget.aulaASerCriada.convidados}');

    // Simulate a network request delay of 5 seconds.
    await Future.delayed(const Duration(seconds: 5));

    Fluttertoast.showToast(
        msg:
            "Evento criado com sucesso! 🎉 Agora é só esperar seus convidados no dia do evento! 📍",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
// After the delay, you can close the dialog.

    Get.offNamed('/home');
  }
}
