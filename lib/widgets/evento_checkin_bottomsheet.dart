import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/camera/camera_page.dart';
import 'package:flutter_srpg_app/pages/evento/evento_aluno_page.dart';
import 'package:flutter_srpg_app/services/data_service.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventoCheckInBottomSheet extends StatefulWidget {
  Evento aula;

  EventoCheckInBottomSheet({super.key, required this.aula});

  @override
  _EventoCheckInBottomSheetState createState() =>
      _EventoCheckInBottomSheetState();
}

class _EventoCheckInBottomSheetState extends State<EventoCheckInBottomSheet> {
  XFile arquivo = XFile('');
  LocalizacaoService service = LocalizacaoService();
  bool isButtonClicked = false;

  getBiometria() async {
    var fotoBiometria = await Get.to(() => const CameraPage());

    if (fotoBiometria != null) {
      // Adicione a lógica de envio da foto para o servidor
      print(fotoBiometria);
      await Future.delayed(const Duration(seconds: 10));

      // se retornar erro, retornar false
      // se retornar sucesso, retornar true

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<PosicaoController>();
    local.getPosicao();
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                widget.aula.nome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(widget.aula.descricao),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text('Local: ${widget.aula.local}'),
            ),
            Text(DataService().calcularDuracaoEventoEmHoras(
                widget.aula.dtInicio ?? DateTime.now(), DateTime.now())),
            Text(DataService().calcularTerminoEventoEmHoras(
                widget.aula.dtFim ?? DateTime.now(), DateTime.now())),
            Text('Você está a ${LocalizacaoService().calcularDistancia(
              {'latitude': local.lat, 'longitude': local.long, 'elevacao': 0},
              {
                'latitude': widget.aula.latitude!,
                'longitude': widget.aula.longitude!,
                'elevacao': 0
              },
            )}km de distância desse evento.'), // Novo texto adicionado
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              // child: CircularProgressIndicator()
              child: ElevatedButton(
                onPressed: () {
                  handleCheckIn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A6D92),
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

      Get.to(() => const EventoAlunoPage());
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
