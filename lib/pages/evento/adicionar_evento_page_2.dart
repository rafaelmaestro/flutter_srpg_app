import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdicionarEventoPage2 extends StatefulWidget {
  Evento eventoASerCriado;
  AdicionarEventoPage2({super.key, required this.eventoASerCriado});

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
    for (var element in listController) {
      element.dispose();
    }

    inputEmailController.dispose();
  }

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
                                'Quem você deseja convidar?',
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
                                    color: Colors.grey.withOpacity(.1),
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
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person,
                                            color: Color(0xFF0A6D92)),
                                        labelText: "Convidado",
                                        labelStyle:
                                            TextStyle(color: Color(0xFF0A6D92)),
                                        hintText:
                                            "Digite o e-mail do convidado",
                                        border: InputBorder.none,
                                        errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(0)),
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
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children:
                                  List.generate(listController.length, (index) {
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.person,
                                      color: Color(0xFF0A6D92),
                                    ),
                                    title: Text(listController[index].text),
                                    trailing: IconButton(
                                      icon: const Icon(
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
                                  Icons.check_box,
                                  color: Colors.green,
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
    if (listController.isEmpty) {
      return showDialog(
        context: Get.context!,
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
                    Get.back();
                  },
                  child: const Text('Ok, vou adicionar alguém!'),
                ),
              )
            ],
          );
        },
      );
    }

    for (var element in listController) {
      widget.eventoASerCriado.adicionarConvidado(element.text);
    }

    try {
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
      final eventoCriado = await EventoRepository().criarEvento(
          criarEventoParams: CriarEventoParams(
        cpfOrganizador: widget.eventoASerCriado.cpfOrganizador,
        convidados: widget.eventoASerCriado.convidados.emails.toSet().toList(),
        descricao: widget.eventoASerCriado.descricao,
        dtFimPrevista: widget.eventoASerCriado.dtFimPrevista.toIso8601String(),
        dtInicioPrevista:
            widget.eventoASerCriado.dtInicioPrevista.toIso8601String(),
        local: widget.eventoASerCriado.local,
        nome: widget.eventoASerCriado.nome,
      ));

      Get.snackbar(
        'Evento criado com sucesso! 🎉',
        'Agora é só esperar seus convidados no dia combinado! 📍',
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

      Get.offNamed('/home');
    } catch (err) {
      Get.snackbar(
        'Falha ao criar o evento! 😢',
        'Por favor, tente novamente mais tarde.\nCaso o erro persista, entre em contato com o suporte em 📞 4002-8922 e informe o seguinte código: \n\n${err.toString()}',
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
  }
}
