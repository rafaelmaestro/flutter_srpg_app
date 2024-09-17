import 'dart:async';
import 'dart:math';
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

class EventoAlunoPage extends StatefulWidget {
  final Evento evento;
  const EventoAlunoPage({super.key, required this.evento});

  @override
  _EventoAlunoPageState createState() => _EventoAlunoPageState();
}

class _EventoAlunoPageState extends State<EventoAlunoPage> {
  Timer? _timer;
  Timer? _httpTimer;
  int _start = 0;
  late Future<void> _futurePosicao;
  late PosicaoController local;
  String? distancia;
  List<String> eventos = [];
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  String? statusEventoAtual;
  int _httpErrorCount = 0;
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

  void startHttpTimer() {
    _httpTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer timer) => _makeHttpRequest(),
    );
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
    });
    eventos.add('[${formatter.format(DateTime.now())}] - Check-in realizado');
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                _showDistanceWarningModal(appKey.currentState!.context);
              });
            } else if (distanceInMeters <= MAX_DISTANCE_FROM_EVENT &&
                _isModalVisible) {
              Navigator.of(context, rootNavigator: true).pop();
              _isModalVisible = false;
            }
            // TODO: ABRIR UM MODAL PARA AVISAR QUE O USUÁRIO ESTÁ LONGE DEMAIS DO EVENTO E EXIBIR UM CONTADOR DE TEMPO PARA O CHECK-OUT AUTOMÁTICO QUE É DEFINIDO EM MAX_TIME_TOLERANCE_FROM_EVENT, ALÉM DE UM BOTÃO PARA REALIZAR O CHECK-OUT MANUALMENTE

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
                            color: _getStatusColor(widget.evento
                                .status), // Cor de fundo baseada no status
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            _formatStatus(widget.evento.status),
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
    setState(() {
      eventos
          .add('[${formatter.format(DateTime.now())}] - Check-out realizado');
    });
    return showDialog(
      context: appKey.currentState!.context,
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
                  _callCheckout(appKey.currentState!.context);
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
                  Navigator.of(context).pop();
                },
                child: const Text('Quero ficar mais um pouco!'),
              ),
            )
          ],
        );
      },
    );
  }

  _callCheckout(BuildContext context) {
    Get.offAll(() => const HomePage());
  }

  Future<void> _makeHttpRequest() async {
    try {
      final response = await EventoRepository()
          .getEvento(widget.evento.id); // Faz a requisição HTTP

      if (response.evento.status == 'FINALIZADO') {
        // _handleEventoFinalizado();
      }

      if (response.evento.status == 'EM_ANDAMENTO' &&
          statusEventoAtual != 'EM_ANDAMENTO') {
        // _handleEventoEmAndamento();
      }

      if (response.evento.status == 'PAUSADO' &&
          statusEventoAtual != 'PAUSADO') {
        // _handleEventoPausado();
      }

      setState(() {
        statusEventoAtual = response.evento.status;
      });
    } catch (err) {
      setState(() {
        _httpErrorCount++;
      });

      if (_httpErrorCount >= MAX_HTTP_ERROR_COUNT) {
        // TODO: Se o número de erros HTTP for maior ou igual ao limite, exibe um diálogo de erro
        // TODO: Realizar checkout e fecha a página
      }
      print('Erro ao fazer requisição HTTP: $err');
    }
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

  void _showDistanceWarningModal(BuildContext context) {
    int countdown =
        MAX_MINUTES_TIME_TOLERANCE_FROM_EVENT * 60; // 10 minutos em segundos
    Timer? countdownTimer;
    bool isModalOpen = false;
    bool hasCheckedOut = false;

    void startCountdown(StateSetter setState) {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (countdown > 0) {
              countdown--;
              print('${DateTime.now()} Contagem regressiva: $countdown');
            } else {
              timer.cancel();
              if (!hasCheckedOut) {
                hasCheckedOut = true;
                print('------------------');
                print('Usuário desconectado');
                print('------------------');
                _callCheckout(appKey.currentState!.context);
              }
            }
          });
        } else {
          timer.cancel();
        }
      });
    }

    String _formatCountdown(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$remainingSeconds';
    }

    if (!isModalOpen) {
      isModalOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              if (countdownTimer == null || !countdownTimer!.isActive) {
                startCountdown(
                    setState); // Iniciar o countdown quando o diálogo for exibido
              }
              return AlertDialog(
                title: const Text(
                  'Aviso de distância 🚨',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Você está longe demais do evento! 😢\n\nVocê será desconectado automaticamente em:',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatCountdown(countdown),
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                          _callCheckout(appKey.currentState!.context);
                        }
                        Navigator.of(context).pop();
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
