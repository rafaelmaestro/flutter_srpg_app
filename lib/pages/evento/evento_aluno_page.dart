import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/constants/constants.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventoAlunoPage extends StatefulWidget {
  final Evento evento;
  final List<Registro> registros;
  const EventoAlunoPage(
      {super.key, required this.evento, required this.registros});

  @override
  _EventoAlunoPageState createState() => _EventoAlunoPageState();
}

class _EventoAlunoPageState extends State<EventoAlunoPage>
    with WidgetsBindingObserver {
  Timer? _timer;
  Timer? _httpTimer;
  Timer? _checkDistanceTimer;
  int _start = 0;
  late Future<void> _futurePosicao;
  late PosicaoController local;
  String? distancia;
  List<String> eventos = [];
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  String? statusEventoAtual;
  DateTime? dtFimEvento;
  int _httpErrorCount = 0;
  ValueNotifier<int> countdownNotifier = ValueNotifier<int>(0);
  bool _isPaused = false; // Variável para indicar se o timer está pausado
  bool _isModalVisible =
      false; // Variável para controlar se o modal está visível

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _startDistanceCheckTimer();
    } else {
      print('VOLTEI PARA O APP!');
      _checkDistanceTimer?.cancel();
      // _checkNovosRegistros();
    }
  }

  void startHttpTimer() {
    _httpTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer timer) => _makeHttpRequest(),
    );
  }

  void _startDistanceCheckTimer() {
    _checkDistanceTimer?.cancel(); // Cancel any existing timer
    _checkDistanceTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      print('Verificando distância...');
      _checkDistance();
    });
  }

  void _checkDistance() async {
    final double eventLat = widget.evento.latitude!;
    final double eventLong = widget.evento.longitude!;

    final posicaoController =
        Provider.of<PosicaoController>(context, listen: false);
    double distanceInMeters = Geolocator.distanceBetween(
      posicaoController.lat,
      posicaoController.long,
      eventLat,
      eventLong,
    );

    if (distanceInMeters > MAX_DISTANCE_FROM_EVENT &&
        statusEventoAtual == 'EM_ANDAMENTO' &&
        !_isModalVisible) {
      setState(() {
        _isModalVisible = true;
      });
      Future.delayed(Duration.zero, () {
        _showDistanceWarningModal();
      });
    } else if (distanceInMeters <= MAX_DISTANCE_FROM_EVENT && _isModalVisible) {
      Get.back();
      setState(() {
        _isModalVisible = false;
      });
    }
  }

  @override
  void initState() {
    startTimer();
    startHttpTimer();
    super.initState();
    local = PosicaoController(loadEventosBool: false);
    _futurePosicao = local.getPosicao().then((_) {
      setState(() {
        distancia = LocalizacaoService().calcularDistancia(
          {'latitude': local.lat, 'longitude': local.long, 'elevacao': 0},
          {
            'latitude': widget.evento.latitude!,
            'longitude': widget.evento.longitude!,
            'elevacao': 0
          },
        ).toString();
        statusEventoAtual = widget.evento.status;
      });
      adicionarEventos();

      Get.snackbar(
        'Check-in realizado com sucesso! 🎉',
        'Por favor, permaneça no local do evento para que sua presença seja contabilizada! ✅',
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

      WidgetsBinding.instance!.addObserver(this);
    });
  }

  void adicionarEventos() {
    for (var registro in widget.registros) {
      eventos.add(
          '[${formatter.format(registro.dtHoraCheckIn!)}] - Check-in realizado 🧑‍🎓');
      if (registro.dtHoraCheckOut != null) {
        eventos.add(
            '[${formatter.format(registro.dtHoraCheckOut!)}] - Check-out realizado 🚪');
      }
    }

    if (widget.registros.isNotEmpty) {
      var ultimoRegistro = widget.registros.last;
      if (ultimoRegistro.dtHoraCheckOut != null) {
        // Se o último registro tiver check-in e check-out, o check-out automático já foi feito
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _httpTimer?.cancel();
    _checkDistanceTimer?.cancel();
    countdownNotifier.dispose();
    WidgetsBinding.instance!.removeObserver(this);
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
      body: ChangeNotifierProvider<PosicaoController>(
        create: (context) => PosicaoController(),
        child: Consumer<PosicaoController>(
          builder: (context, local, child) {
            final double eventLat =
                widget.evento.latitude!; // Latitude do evento
            final double eventLong =
                widget.evento.longitude!; // Longitude do evento

            double distanceInMeters = Geolocator.distanceBetween(
              local.lat,
              local.long,
              eventLat,
              eventLong,
            );

            final distanceText = distanceInMeters >= 1000
                ? '${(distanceInMeters / 1000).toStringAsFixed(2)}km'
                : '${distanceInMeters.toStringAsFixed(0)}m';

            if (distanceInMeters > MAX_DISTANCE_FROM_EVENT &&
                statusEventoAtual == 'EM_ANDAMENTO' &&
                !_isModalVisible) {
              _isModalVisible = true;
              Future.delayed(Duration.zero, () {
                _showDistanceWarningModal();
              });
            } else if (distanceInMeters <= MAX_DISTANCE_FROM_EVENT &&
                _isModalVisible) {
              Get.back();
              _isModalVisible = false;
            }

            return Column(
              children: [
                // Seção Superior
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Adicionar um texto com fundo circular para indicar o status do evento
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: _getStatusColor(statusEventoAtual ??
                                'Em andamento'), // Cor de fundo baseada no status
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            _formatStatus(statusEventoAtual ?? 'Em andamento'),
                            style: const TextStyle(
                              color: Colors.white, // Cor do texto
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 8), // Espaçamento entre os textos
                        const Text(
                          'Tempo de permanência:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                            height: 8), // Espaçamento entre os textos
                        Text(
                          '${(_start ~/ 3600).toString().padLeft(2, '0')}:${((_start % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 50),
                        ),
                        const SizedBox(
                            height:
                                16), // Espaçamento entre o cronômetro e o texto de distância
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Você está a $distanceText de distância desse evento.',
                            style: TextStyle(
                              fontSize: 16,
                              color: distanceInMeters <=
                                      (MAX_DISTANCE_FROM_EVENT / 2)
                                  ? Colors.green
                                  : distanceInMeters >=
                                              (MAX_DISTANCE_FROM_EVENT / 2) &&
                                          distanceInMeters <=
                                              MAX_DISTANCE_FROM_EVENT
                                      ? Colors.yellow
                                      : Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Seção do Meio
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView.builder(
                      itemCount: eventos.length,
                      itemBuilder: (context, index) {
                        return Text(eventos[index]); // Exibe cada evento
                      },
                    ),
                  ),
                ),
                // Seção Inferior
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _handleCheckout();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Realizar check-out',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _handleCheckout() async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Mas já? 😢',
            textAlign: TextAlign.center, // Centraliza o título
            style: TextStyle(
                fontWeight: FontWeight.bold), // Torna o título em negrito
          ),
          content: const Text(
            'Fazer check-out antes do evento acabar é como sair do cinema no meio do filme. Você não quer perder o final emocionante, né? 🍿',
            textAlign: TextAlign.center, // Centraliza o conteúdo
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red, // Cor do texto do botão Cancelar
                  side: const BorderSide(
                      color: Colors.red, width: 2), // Borda do botão Cancela
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  _callCheckout();
                },
                child: const Text('Sim, quero sair!'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Colors.green, // Cor do texto do botão Cancelar
                  side: const BorderSide(
                      color: Colors.green, width: 2), // Borda do botão Cancela
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text('Quero ficar mais um pouco!'),
              ),
            )
          ],
        );
      },
    );
  }

  _callCheckout() async {
    try {
      print('Realizando check-out...');
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.get('email').toString();

      await EventoRepository()
          .realizarCheckOut(idEvento: widget.evento.id, emailConvidado: email);

      Get.snackbar(
        'Check-out realizado! 🚪',
        'Seu check-out foi realizado com sucesso. Obrigado por participar! 🎉',
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

      Get.off(() =>
          const HomePage()); // Isso remove a página atual e navega para a HomePage
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

  Future<void> _makeHttpRequest() async {
    try {
      final response = await EventoRepository()
          .getEvento(widget.evento.id); // Faz a requisição HTTP

      if (response.evento.status == 'FINALIZADO') {
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

      setState(() {
        statusEventoAtual = response.evento.status;
        dtFimEvento = response.evento.dtFim;
      });
    } catch (err) {
      setState(() {
        _httpErrorCount++;
      });

      if (_httpErrorCount >= MAX_HTTP_ERROR_COUNT) {
        _handleErroConexao();
      }
      print('Erro ao fazer requisição HTTP: $err');
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
    _callCheckout();
  }

  _handleEventoFinalizado() {
    Get.snackbar(
      'O evento foi finalizado! 🏁',
      'O organizador encerrou o evento e o seu check-out foi realizado de forma automática. \n\nObrigado por participar! 🎉',
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
    _callCheckout();
  }

  _handleEventoPausado() {
    pauseTimer();
    Get.snackbar(
      'O evento foi pausado! ⏸️',
      'O organizador pausou o evento. Você pode relaxar um pouco e aproveitar o tempo para descansar. 😴',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 10),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.orange,
      progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
        Colors.white,
      ),
      isDismissible: true,
    );
    setState(() {
      eventos.add(
          '[${formatter.format(DateTime.now())}] - Evento pausado pelo organizador 🛑');
    });
  }

  _handleEventoEmAndamento() {
    resumeTimer();
    Get.snackbar(
      'O evento foi retomado! ▶️',
      'O organizador retomou o evento. \n Você deve continuar no local para que sua presença seja contabilizada. ✅',
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
      eventos.add(
          '[${formatter.format(DateTime.now())}] - Evento retomado pelo organizador ▶️');
    });
  }

  String _formatStatus(String status) {
    String formattedStatus = status.replaceAll('_', ' ').toLowerCase();
    return formattedStatus[0].toUpperCase() + formattedStatus.substring(1);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PAUSADO':
        return Colors.orange;
      case 'FINALIZADO':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  void _showDistanceWarningModal() {
    int countdown =
        MAX_MINUTES_TIME_TOLERANCE_FROM_EVENT * 60; // 10 minutos em segundos
    Timer? countdownTimer;
    bool isModalOpen = false;
    bool hasCheckedOut = false;

    print('LONGE DEMAIS DO EVENTO!');

    countdownNotifier.value = countdown;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownNotifier.value > 0) {
        countdownNotifier.value--;
        print(
            '${DateTime.now()} Contagem regressiva: ${countdownNotifier.value}');
      } else {
        timer.cancel();
        if (!hasCheckedOut) {
          hasCheckedOut = true;
          _callCheckout();
        }
      }
    });

    String _formatCountdown(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$remainingSeconds';
    }

    if (!isModalOpen) {
      eventos.add(
          '[${formatter.format(DateTime.now())}] - Aviso de distância: Você está longe demais do evento! 🚨');
      isModalOpen = true;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Aviso de distância 🚨',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: ValueListenableBuilder<int>(
              valueListenable: countdownNotifier,
              builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Você está longe demais do evento! 😢\n\nVocê será desconectado automaticamente em:',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatCountdown(value),
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 2),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    countdownTimer?.cancel();
                    if (!hasCheckedOut) {
                      hasCheckedOut = true;
                      _callCheckout();
                    }
                  },
                  child: const Text(
                    'Quero sair!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ).then((_) {
        // Cancelar o timer quando o diálogo for fechado
        countdownTimer?.cancel();
        isModalOpen = false;
      });
    }
  }
}
