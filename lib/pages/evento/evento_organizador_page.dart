import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/constants/constants.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// TODO: tratar cenários onde o usuário feche o app, ao retornar deve voltar para a tela
class EventoOrganizadorPage extends StatefulWidget {
  final Evento evento;
  bool? atualizarStatus = false;
  EventoOrganizadorPage(
      {super.key, required this.evento, this.atualizarStatus});

  @override
  _EventoOrganizadorPageState createState() => _EventoOrganizadorPageState();
}

class _EventoOrganizadorPageState extends State<EventoOrganizadorPage>
    with WidgetsBindingObserver {
  Timer? _timer;
  Timer? _httpTimer;
  int _start = 0;
  List<String> eventos = [];
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  String? statusEventoAtual;
  int? checkInsRealizados;
  int? checkOutsRealizados;
  List<String> emailsCheckIn = [];
  List<String> emailsCheckOut = [];
  int _httpErrorCount = 0;
  bool _isExpanded = true;
  // Crie uma lista para controlar a expansão de cada painel, caso tenha mais de um
  List<bool> _isExpandedList1 = [false]; // Ajustar conforme o número de painéis
  List<bool> _isExpandedList2 = [false]; // Ajustar conforme o número de painéis
  List<bool> _isExpandedList3 = [false]; // Ajustar conforme o número de painéis
  bool _isPaused = false; // Variável para indicar se o timer está pausado

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (!_isPaused) {
            _start++;
          }
        },
      ),
    );
  }

  void pauseTimer() {
    setState(() {
      _isPaused = true;
    });
  }

  void resumeTimer() {
    setState(() {
      _isPaused = false;
    });
  }

  void startHttpTimer() {
    _httpTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer timer) => _makeHttpRequest(),
    );
  }

  @override
  void initState() {
    final emailsCheckInRealizados = _getEmailsCheckInRealizados(
        widget.evento.checkIns.emails, widget.evento.checkOuts.emails);
    setState(() {
      statusEventoAtual = widget.evento.status;
      checkInsRealizados = widget.evento.checkIns.total;
      checkOutsRealizados = widget.evento.checkOuts.total;
      emailsCheckIn = emailsCheckInRealizados;
      emailsCheckOut = widget.evento.checkOuts.emails;
    });
    startTimer();
    startHttpTimer();
    super.initState();

    if (widget.atualizarStatus! && statusEventoAtual != 'EM_ANDAMENTO') {
      _retomarEvento();
    }

    if (!widget.atualizarStatus!) {
      Get.snackbar(
        'Evento iniciado! 🎉',
        'O evento foi iniciado e os convidados foram notificados. ✅ \n\nTodos devem permanecer no local para que a presença seja contabilizada.',
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
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _httpTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(
              widget.evento.nome,
              style: const TextStyle(
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
          // Seção Superior
          const SizedBox(height: 20),
          Expanded(
            flex: -1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Tempo decorrido:',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${(_start ~/ 3600).toString().padLeft(2, '0')}:${((_start % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'O evento está: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildEventoStatusText(),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.grey.withOpacity(.3),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
          // Seção Central
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    color: const Color(0xFF0A6D92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // Ajuste este valor para o que você está usando nos seus ElevatedButtons
                    ),
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isExpandedList1[index] = !_isExpandedList1[index];
                        });
                      },
                      children: [
                        ExpansionPanel(
                          canTapOnHeader: true,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return const ListTile(
                              title: Text('Informações do evento',
                                  style: TextStyle(fontSize: 16)),
                            );
                          },
                          body: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly, // Adicione esta linha,
                              children: [
                                Text(
                                  widget.evento.nome,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.evento.descricao,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('📍 ${widget.evento.local}'),
                                const SizedBox(height: 10),
                                Text(
                                    '⚙️ Distância máxima permitida: ${widget.evento.distanciaMaximaPermitida}m'),
                                Text(
                                    '⚙️ Tempo tolerância: ${widget.evento.minutosTolerancia} minutos'),
                                const SizedBox(height: 10),
                                Text(
                                    '📅 Iniciou em: ${formatter.format(widget.evento.dtInicio ?? DateTime.now())}'),
                                Text(
                                    '📅 Fim previsto: ${formatter.format(widget.evento.dtFimPrevista)}'),
                                const SizedBox(height: 10),
                                Text(
                                    '🧑‍🎓 Convidados: ${widget.evento.convidados.total}'),
                              ],
                            ),
                          ),
                          isExpanded: _isExpandedList1[0],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Check-ins: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${checkInsRealizados ?? 0}',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Check-outs: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${checkOutsRealizados ?? 0}',
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    color: const Color(0xFF0A6D92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // Ajuste este valor para o que você está usando nos seus ElevatedButtons
                    ),
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isExpandedList2[index] = !_isExpandedList2[index];
                        });
                      },
                      children: [
                        ExpansionPanel(
                          canTapOnHeader: true,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return const ListTile(
                              title: Text('Check-ins',
                                  style: TextStyle(fontSize: 16)),
                            );
                          },
                          body: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Column(
                                  children: List.generate(emailsCheckIn.length,
                                      (index) {
                                    return Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      shadowColor: Colors.grey.withOpacity(.3),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.person,
                                          color: Colors.green,
                                        ),
                                        title: Text(emailsCheckIn[index]),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _callCheckout(emailsCheckIn[index]);
                                            setState(() {
                                              emailsCheckIn.removeAt(index);
                                              checkOutsRealizados =
                                                  checkOutsRealizados! + 1;
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                          isExpanded: _isExpandedList2[0],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    color: const Color(0xFF0A6D92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // Ajuste este valor para o que você está usando nos seus ElevatedButtons
                    ),
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isExpandedList3[index] = !_isExpandedList3[index];
                        });
                      },
                      children: [
                        ExpansionPanel(
                          canTapOnHeader: true,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return const ListTile(
                              title: Text('Check-outs',
                                  style: TextStyle(fontSize: 16)),
                            );
                          },
                          body: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Column(
                                  children: List.generate(emailsCheckOut.length,
                                      (index) {
                                    return Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      shadowColor: Colors.grey.withOpacity(.3),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.person,
                                          color: Colors.red,
                                        ),
                                        title: Text(emailsCheckOut[index]),
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                          isExpanded: _isExpandedList3[0],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Seção Inferior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildElevatedButton(),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    _encerrarEvento();
                  },
                  icon: const Icon(Icons.stop, color: Colors.white),
                  label: const Text('Encerrar evento',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const ui.Size(double.infinity, 50)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventoStatusText() {
    if (statusEventoAtual == 'EM_ANDAMENTO') {
      return Text(
        statusEventoAtual ?? 'INDEFINIDO',
        style:
            const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    } else if (statusEventoAtual == 'PAUSADO') {
      return Text(
        statusEventoAtual ?? 'INDEFINIDO',
        style:
            const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        statusEventoAtual ?? 'INDEFINIDO',
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _buildElevatedButton() {
    if (statusEventoAtual == 'EM_ANDAMENTO') {
      return ElevatedButton.icon(
        onPressed: () {
          _pausarEvento();
        },
        icon: const Icon(Icons.pause, color: Colors.white),
        label: const Text('Pausar evento',
            style: TextStyle(
              color: Colors.white,
            )),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const ui.Size(double.infinity, 50)),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {
          // Sua lógica aqui
          _retomarEvento();
        },
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        label: const Text('Retomar evento',
            style: TextStyle(
              color: Colors.white,
            )),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const ui.Size(double.infinity, 50)),
      );
    }
  }

  Future<void> _encerrarEvento() async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Encerrar evento? 🏁',
            textAlign: TextAlign.center, // Centraliza o título
            style: TextStyle(
                fontWeight: FontWeight.bold), // Torna o título em negrito
          ),
          content: const Text(
            'Tem certeza que deseja encerrar o evento? Essa ação é irreversível e todos os convidados serão notificados.',
            textAlign: TextAlign.center, // Centraliza o conteúdo
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor:
                      Colors.white, // Cor do texto do botão Cancelar
                  side: const BorderSide(
                      color: Colors.green, width: 2), // Borda do botão Cancela
                  minimumSize: const ui.Size(double.infinity, 50),
                ),
                onPressed: () {
                  _callEncerrarEvento();
                },
                child: const Text('Sim, quero encerrar!'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Colors.white, // Cor do texto do botão Cancelar
                  backgroundColor: Colors.red,
                  side: const BorderSide(
                      color: Colors.red, width: 2), // Borda do botão Cancela
                  minimumSize: const ui.Size(double.infinity, 50),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text('Não, ainda vou continuar!'),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _pausarEvento() async {
    try {
      final response = await EventoRepository()
          .atualizarStatusEvento(widget.evento.id, 'PAUSADO');

      if (response.evento.status == 'PAUSADO') {
        _handleEventoPausado();
      }
    } catch (err) {
      Get.snackbar(
        'Erro ao pausar o evento! 😢',
        err.toString(),
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
    }
  }

  Future<void> _retomarEvento() async {
    try {
      final response = await EventoRepository()
          .atualizarStatusEvento(widget.evento.id, 'EM_ANDAMENTO');

      if (response.evento.status == 'EM_ANDAMENTO') {
        _handleEventoEmAndamento();
      }
    } catch (err) {
      Get.snackbar(
        'Erro ao retomar o evento! 😢',
        err.toString(),
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
    }
  }

  Future<void> _makeHttpRequest() async {
    try {
      final response = await EventoRepository()
          .getEvento(widget.evento.id); // Faz a requisição HTTP

      if (response.evento.status == 'FINALIZADO' &&
          statusEventoAtual != 'FINALIZADO') {
        _handleEventoFinalizado();
      }

      if (response.evento.status == 'EM_ANDAMENTO' &&
          statusEventoAtual != 'EM_ANDAMENTO') {
        _handleEventoEmAndamento();
      }

      if (response.evento.status == 'PAUSADO' &&
          statusEventoAtual != 'PAUSADO') {
        _handleEventoPausado();
      }

      final emailsCheckInRealizados = _getEmailsCheckInRealizados(
          response.evento.checkIns.emails, response.evento.checkOuts.emails);

      setState(() {
        statusEventoAtual = response.evento.status;
        checkInsRealizados = response.evento.checkIns.total;
        checkOutsRealizados = response.evento.checkOuts.total;
        emailsCheckIn = emailsCheckInRealizados;
        emailsCheckOut = response.evento.checkOuts.emails;
      });
    } catch (err) {
      setState(() {
        _httpErrorCount++;
      });

      if (_httpErrorCount >= MAX_HTTP_ERROR_COUNT) {
        _handleErroConexao();
      }
    }
  }

  List<String> _getEmailsCheckInRealizados(emailsCheckIn, emailsCheckOut) {
    final Map<String, int> checkInCounts = {};
    final Map<String, int> checkOutCounts = {};

    for (var email in emailsCheckIn) {
      checkInCounts[email] = (checkInCounts[email] ?? 0) + 1;
    }

    for (var email in emailsCheckOut) {
      checkOutCounts[email] = (checkOutCounts[email] ?? 0) + 1;
    }

    return checkInCounts.keys.where((email) {
      final checkInCount = checkInCounts[email] ?? 0;
      final checkOutCount = checkOutCounts[email] ?? 0;
      return checkInCount > checkOutCount;
    }).toList();
  }

  _callCheckout(String email) async {
    try {
      await EventoRepository()
          .realizarCheckOut(idEvento: widget.evento.id, emailConvidado: email);

      Get.snackbar(
        'Check-out realizado! 🚪',
        'O check-out do convidado $email foi realizado com sucesso. ✅\n\nNós o avisaremos que ele pode ir embora.',
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
    } catch (err) {
      Get.snackbar(
        'Erro ao realizar check-out! 😢',
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
    }
  }

  _handleErroConexao() {
    Get.snackbar(
      'Erro de conexão! 😢',
      'Parece que você está sem conexão com a internet. Fizemos o check-out automaticamente para você. \n\n Caso tenha algum problema, peça ao organizador para verificar a sua presença.',
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
  }

  _handleEventoFinalizado() {
    Get.off(() =>
        const HomePage()); // Isso remove a página atual e navega para a HomePage
    Get.snackbar(
      'O evento foi finalizado! 🏁',
      'O organizador já encerrou o evento e todos os convidados foram notificados. Obrigado por participar! 🎉',
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
  }

  _handleEventoPausado() {
    pauseTimer();
    Get.snackbar(
      'Evento pausado! ⏸️',
      'O evento foi pausado e os convidados podem relaxar um pouco. 😴\n\nQuando estiver pronto para retornar é só avisar!',
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
    setState(() {
      statusEventoAtual = 'PAUSADO';
    });
  }

  _handleEventoEmAndamento() {
    resumeTimer();
    Get.snackbar(
      'Evento retomado! ▶️',
      'O evento foi retomado e os convidados notificados. ✅ \n\nTodos devem permanecer no local para que a presença seja contabilizada.',
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
    setState(() {
      statusEventoAtual = 'EM_ANDAMENTO';
    });
  }

  _callEncerrarEvento() async {
    try {
      final response = await EventoRepository()
          .atualizarStatusEvento(widget.evento.id, 'FINALIZADO');

      if (response.evento.status == 'FINALIZADO') {
        _handleEventoFinalizado();
      }
    } catch (err) {
      Get.snackbar(
        'Erro ao encerrar o evento! 😢',
        err.toString(),
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
    }
  }
}
