import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/posto.dart';
import 'package:flutter_srpg_app/pages/camera/camera_page.dart';
import 'package:flutter_srpg_app/pages/evento/evento_aluno_page.dart';
import 'package:flutter_srpg_app/services/data_service.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AulaBottomSheet extends StatefulWidget {
  Aula aula;

  AulaBottomSheet({super.key, required this.aula});

  @override
  _AulaBottomSheetState createState() => _AulaBottomSheetState();
}

class _AulaBottomSheetState extends State<AulaBottomSheet> {
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
            Text(DataService().calcularDuracaoEventoEmHoras(
                widget.aula.dataInicio, DateTime.now())),
            Text('Você está a ${LocalizacaoService().calcularDistancia(
              {'latitude': local.lat, 'longitude': local.long, 'elevacao': 0},
              {
                'latitude': widget.aula.latitude,
                'longitude': widget.aula.longitude,
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
      Fluttertoast.showToast(
          msg:
              "Check-in realizado com sucesso! 🎉 \n Por favor, permaneça no local do evento para que sua presença seja contabilizada! ✅",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Get.to(() => const EventoAlunoPage());
    } else {
      // TODO: exibir mensagens de erro diferentes para cada tipo de erro
      Fluttertoast.showToast(
          msg:
              "Erro ao realizar check-in! 😢 \n Por favor, tente novamente! 🔄",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        isButtonClicked = false;
      });
    }
  }
}
