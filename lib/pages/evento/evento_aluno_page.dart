import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
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
  int _start = 0;
  late Future<void> _futurePosicao;
  late PosicaoController local;
  String? distancia;
  List<String> eventos = [];
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          _start++;
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
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
    int seconds = _start % 60;
    int minutes = _start ~/ 60;
    int hours = _start ~/ (60 * 60);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          children: [
            Text(
              'Evento em Andamento',
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

            return Column(
              children: [
                // Seção Superior
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Tempo de permanência:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                            height: 8), // Espaçamento entre os textos
                        Text(
                          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
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
                              color: distanceInMeters <= 10
                                  ? Colors.green
                                  : distanceInMeters >= 10 &&
                                          distanceInMeters <= 20
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
      context: context,
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

  _callCheckout() {
    // TODO: Implementar a lógica de checkout chamar o back-end para registrar a saída do aluno
    Navigator.of(context).pop();
    Navigator.of(context).pop(); // Fecha a página atual
    Navigator.of(context).pop(); // Fecha a página atual
  }
}
