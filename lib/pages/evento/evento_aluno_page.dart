import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventoAlunoPage extends StatefulWidget {
  const EventoAlunoPage({super.key});

  @override
  _EventoAlunoPageState createState() => _EventoAlunoPageState();
}

class _EventoAlunoPageState extends State<EventoAlunoPage> {
  Timer? _timer;
  int _start = 0;

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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 50),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
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
          ),
        ],
      ),
    );
  }

  _handleCheckout() async {
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
            'Você tem certeza que deseja realizar o check-out?',
            textAlign: TextAlign.center, // Centraliza o conteúdo
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Confirmar'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red, // Cor do texto do botão Cancelar
                  side: BorderSide(
                      color: Colors.red, width: 2), // Borda do botão Cancela
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  _callCheckout();
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                child: const Text('Quero ficar mais um pouco!'),
                style: TextButton.styleFrom(
                  foregroundColor:
                      Colors.green, // Cor do texto do botão Cancelar
                  side: BorderSide(
                      color: Colors.green, width: 2), // Borda do botão Cancela
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  _callCheckout() {
    // TODO: Implementar a lógica de checkout chamar o back-end para registrar a saída do aluno
    Get.offAllNamed('/');
  }
}
