import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/evento/adicionar_evento_page_3.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdicionarEventoPage2 extends StatefulWidget {
  Evento eventoASerCriado;
  AdicionarEventoPage2({super.key, required this.eventoASerCriado});

  @override
  _EventoAlunoPageState createState() => _EventoAlunoPageState();
}

class _EventoAlunoPageState extends State<AdicionarEventoPage2> {
  var pergunta = 1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController distanciaMaximaController = TextEditingController();
  TextEditingController minutosToleranciaController = TextEditingController();

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
              'Criar Novo Evento 2/3',
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
                                'Qual a distância máxima EM METROS que os convidados podem estar do evento?',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            MyInputField(
                              label: "Distância máxima (metros)",
                              inputType: TextInputType.number,
                              placeholder:
                                  "Insira a distância máxima permitida",
                              onChange: (value) {
                                distanciaMaximaController.text = value;
                              },
                              validateFunction: (value) {
                                // Verifica se o valor é um número válido
                                final parsedValue = int.tryParse(value!);

                                if (parsedValue == null) {
                                  return 'Por favor, insira um número válido';
                                }

                                if (parsedValue < 0) {
                                  return 'O tempo de tolerância não pode ser negativo';
                                }

                                if (parsedValue > 60) {
                                  return 'O tempo de tolerância não pode ser maior que 60 minutos';
                                }

                                return null;
                              },
                              prefixIcon: const Icon(
                                Icons.social_distance,
                                color: Color(0xFF0A6D92),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                'Qual o tempo de tolerância EM MINUTOS ao se distanciar do evento?',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            MyInputField(
                              label: "Tempo de tolerância (minutos)",
                              inputType: TextInputType.number,
                              placeholder:
                                  "Insira o tempo de tolerância ao se distanciar do evento",
                              onChange: (value) {
                                minutosToleranciaController.text = value;
                              },
                              validateFunction: (value) {
                                final parsedValue = int.tryParse(value!);

                                if (parsedValue == null) {
                                  return 'Por favor, insira um número válido';
                                }

                                if (parsedValue <= 0) {
                                  return 'O tempo de tolerância não pode ser negativo';
                                }

                                if (parsedValue > 60) {
                                  return 'O tempo de tolerância não pode ser maior que 60 minutos';
                                }

                                return null;
                              },
                              prefixIcon: const Icon(
                                Icons.timer,
                                color: Color(0xFF0A6D92),
                              ),
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
                                Icon(
                                  Icons.looks_3_outlined,
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

  _handleMensagem(bool distanciaMenorQue10, bool minutosMenorQue5) {
    if (distanciaMenorQue10) {
      return const Text(
        'Recomendamos que a distância máxima permitida não seja menor que 10 metros, pois podem haver variações na precisão do GPS.',
        textAlign: TextAlign.center, // Centraliza o conteúdo
      );
    }
    if (minutosMenorQue5) {
      return const Text(
        'Recomendamos que o tempo de tolerância não seja menor que 5 minutos, pois os convidados podem se distanciar do evento por um curto período de tempo devido a variações na precisão do GPS.',
        textAlign: TextAlign.center, // Centraliza o conteúdo
      );
    }
  }

  _callProsseguir(int distanciaMaxima, int minutosTolerancia) {
    Evento eventoASerCriado = Evento(
      nome: widget.eventoASerCriado.nome,
      descricao: widget.eventoASerCriado.descricao,
      checkOuts: CheckOuts(total: 0, emails: []),
      convidados: Convidados(total: 0, emails: []),
      dtInicio: DateTime.now(),
      dtFim: DateTime.now(),
      checkIns: CheckIns(total: 0, emails: []),
      id: '',
      distanciaMaximaPermitida: distanciaMaxima,
      minutosTolerancia: minutosTolerancia,
      dtInicioPrevista: widget.eventoASerCriado.dtInicioPrevista,
      dtFimPrevista: widget.eventoASerCriado.dtFimPrevista,
      local: widget.eventoASerCriado.local,
      cpfOrganizador: '',
      status: 'PENDENTE',
    );

    Get.to(() => AdicionarEventoPage3(
          eventoASerCriado: eventoASerCriado,
        ));
  }

  _handleProsseguir() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final distanciaMenorQue10 = int.parse(distanciaMaximaController.text) < 10;
    final minutosMenorQue5 = int.parse(minutosToleranciaController.text) < 5;

    if (distanciaMenorQue10 || minutosMenorQue5) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Atenção! 🚨',
              textAlign: TextAlign.center, // Centraliza o título
              style: TextStyle(
                  fontWeight: FontWeight.bold), // Torna o título em negrito
            ),
            content: _handleMensagem(distanciaMenorQue10, minutosMenorQue5),
            actions: <Widget>[
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor:
                        Colors.white, // Cor do texto do botão Cancelar
                    side: const BorderSide(
                        color: Colors.green,
                        width: 2), // Borda do botão Cancela
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Vou corrigir!'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor:
                        Colors.white, // Cor do texto do botão Cancelar
                    side: const BorderSide(
                        color: Colors.red, width: 2), // Borda do botão Cancela
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _callProsseguir(int.parse(distanciaMaximaController.text),
                        int.parse(minutosToleranciaController.text));
                  },
                  child: const Text('Entendo, e quero continuar!'),
                ),
              )
            ],
          );
        },
      );
    } else {
      _callProsseguir(int.parse(distanciaMaximaController.text),
          int.parse(minutosToleranciaController.text));
    }
  }
}
