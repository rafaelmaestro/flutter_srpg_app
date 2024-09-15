import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/camera/camera_page.dart';
import 'package:flutter_srpg_app/pages/evento/evento_aluno_page.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/services/data_service.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventoCheckInBottomSheet extends StatefulWidget {
  Evento evento;

  EventoCheckInBottomSheet({super.key, required this.evento});

  @override
  _EventoCheckInBottomSheetState createState() =>
      _EventoCheckInBottomSheetState();
}

class _EventoCheckInBottomSheetState extends State<EventoCheckInBottomSheet> {
  XFile arquivo = XFile('');
  LocalizacaoService service = LocalizacaoService();
  bool isButtonClicked = false;
  late Future<void> _futurePosicao;
  late PosicaoController local;
  String? distancia;
  bool isCheckInEnabled = false;

  @override
  void initState() {
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

        isCheckInEnabled = (double.tryParse(distancia ?? '0') ?? 0) <=
            0.02; // 20 metros = 0.02 km
      });
    });
  }

  getBiometria() async {
    var fotoBiometria = await Get.to(() => const CameraPage());

    if (fotoBiometria != null) {
      // Adicione a lógica de envio da foto para o servidor
      await Future.delayed(const Duration(seconds: 10));

      // se retornar erro, retornar false
      // se retornar sucesso, retornar true

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                widget.evento.nome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(widget.evento.descricao),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text('Local: ${widget.evento.local}'),
            ),
            Text(DataService().calcularDuracaoEventoEmHoras(
                widget.evento.dtInicio ?? DateTime.now(), DateTime.now())),
            Text(DataService().calcularTerminoEventoEmHoras(
                widget.evento.dtFimPrevista ?? DateTime.now(), DateTime.now())),
            FutureBuilder<void>(
              future: _futurePosicao,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Erro ao obter localização');
                } else {
                  final distanciaKm = double.tryParse(distancia ?? '0') ?? 0.0;
                  final distanciaTexto = distanciaKm >= 1
                      ? '${distanciaKm.toStringAsFixed(2)}km'
                      : '${(distanciaKm * 1000).toStringAsFixed(0)}m';
                  return Text(
                    'Você está a $distanciaTexto de distância desse evento.',
                  );
                }
              },
            ),
            isCheckInEnabled
                ? const SizedBox.shrink()
                : const Center(
                    child: Text(
                      'Você está muito longe para realizar o check-in! 😢',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              // child: CircularProgressIndicator()
              child: ElevatedButton(
                onPressed: () {
                  isCheckInEnabled ? handleCheckIn() : null;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCheckInEnabled ? const Color(0xFF0A6D92) : Colors.grey,
                ),
                child: const Text('Realizar check-in',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleCheckIn() async {
    setState(() {
      isButtonClicked = true;
    });

    showDialog(
      context: appKey.currentState!.context,
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

    var biometria = await getBiometria();

    Navigator.pop(context); // fecha o Dialog

    if (biometria == true) {
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

      Get.to(() => EventoAlunoPage(
            evento: widget.evento,
          ));
    } else {
      // TODO: exibir mensagens de erro diferentes para cada tipo de erro
      Get.snackbar(
        'Erro ao realizar check-in! 😢',
        'Erro desconhecido ao realizar check-in! \n Por favor, tente novamente mais tarde ou entre em contato com o suporte em 📞 4002-8922',
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

      setState(() {
        isButtonClicked = false;
      });
    }
  }
}
